import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/utils/url_helper.dart';
import 'package:user_app/core/utils/user_agent.dart';
import 'package:user_openapi/api.dart';

import 'auth_http_client.dart';

/// Prefixes for different backend services behind
/// the API gateway (Kong).
///
/// Each value maps to a path segment appended to the
/// base endpoint URL when creating its [ApiClient].
enum ServicePrefix {
  /// NestJS main backend: `/backend`
  backend('/backend'),

  /// AI / chatbot service: `/ai`
  ai('/ai');

  const ServicePrefix(this.path);

  /// The URL path segment for this service.
  final String path;
}

class ApiService implements Authentication {
  final _clients = <ServicePrefix, ApiClient>{};
  AuthHttpClient? _authHttpClient;

  // ── Authentication & Account ──────────────────────
  late AuthenticationApi authenticateApi;
  late AccountApi accountApi;

  // ── Home / Products ───────────────────────────────
  late CategoriesApi categoriesApi;
  late PartnerServiceTagsApi partnerServiceTagsApi;
  late UserHealthServicesApi userHealthServicesApi;

  // ── Booking / Slots ───────────────────────────────
  late UserBookingsApi userBookingsApi;
  late UserSlotsApi userSlotsApi;

  // ── Appointments ──────────────────────────────────
  late UserAppointmentsApi userAppointmentsApi;

  // ── Reviews ───────────────────────────────────────
  late UserReviewsApi userReviewsApi;

  // ── Chatbot (AI service) ──────────────────────────
  late ChatbotApi chatbotApi;

  // ── AI Recommendations ────────────────────────────
  late AIRecommendationsApi aiRecommendationsApi;

  // ── Employees ─────────────────────────────────────
  late UserEmployeesApi userEmployeesApi;

  // ── User Categories ───────────────────────────────
  late UserCategoriesApi userCategoriesApi;

  // ── Payments ──────────────────────────────────────
  late UserPaymentsApi userPaymentsApi;

  ApiService({AuthHttpClient? httpClient}) : _authHttpClient = httpClient {
    // Eagerly initialise so late fields are never
    // accessed before the endpoint is resolved.
    setEndpoint('');
    final endpoint = Store.tryGet(StoreKey.serverEndpoint);
    if (endpoint != null && endpoint.isNotEmpty) {
      setEndpoint(endpoint);
    }
  }

  /// Returns the **backend** [ApiClient].
  ///
  /// Prefer [clientFor] when you need a specific
  /// service prefix.
  ApiClient get apiClient => _clients[ServicePrefix.backend]!;

  /// Returns the [ApiClient] for [prefix].
  ApiClient clientFor(ServicePrefix prefix) => _clients[prefix]!;

  String? _accessToken;
  final _log = Logger('ApiService');

  @override
  Future<void> applyToParams(
    List<QueryParam> queryParams,
    Map<String, String> headerParams,
  ) {
    return Future<void>(() {
      final headers = ApiService.getRequestHeaders();
      headerParams.addAll(headers);
    });
  }

  // ── Endpoint management ───────────────────────────

  dynamic setEndpoint(String endPoint) {
    // Create one ApiClient per service prefix.
    for (final prefix in ServicePrefix.values) {
      final client = ApiClient(
        basePath: '$endPoint${prefix.path}',
        authentication: this,
      );
      if (_authHttpClient != null) {
        client.client = _authHttpClient!;
      }
      _clients[prefix] = client;
    }

    // Update backend base path for refresh calls.
    _authHttpClient?.backendBasePath = '$endPoint${ServicePrefix.backend.path}';

    _setUserAgentHeaders();

    if (_accessToken != null) {
      setAccessToken(_accessToken!);
    }

    final backend = clientFor(ServicePrefix.backend);
    final ai = clientFor(ServicePrefix.ai);

    // ── Backend APIs ────────────────────────────────
    authenticateApi = AuthenticationApi(backend);
    accountApi = AccountApi(backend);
    categoriesApi = CategoriesApi(backend);
    partnerServiceTagsApi = PartnerServiceTagsApi(backend);
    userBookingsApi = UserBookingsApi(backend);
    userSlotsApi = UserSlotsApi(backend);
    userAppointmentsApi = UserAppointmentsApi(backend);
    userEmployeesApi = UserEmployeesApi(backend);
    userCategoriesApi = UserCategoriesApi(backend);
    userPaymentsApi = UserPaymentsApi(backend);
    userHealthServicesApi = UserHealthServicesApi(backend);
    userReviewsApi = UserReviewsApi(backend);

    // ── AI APIs ─────────────────────────────────────
    chatbotApi = ChatbotApi(ai);
    aiRecommendationsApi = AIRecommendationsApi(ai);
  }

  /// Applies the User-Agent header to every client.
  Future<void> _setUserAgentHeaders() async {
    final userAgent = await getUserAgentString();
    for (final client in _clients.values) {
      client.addDefaultHeader('User-Agent', userAgent);
    }
  }

  Future<String> resolveAndSetEndpoint(String serverUrl) async {
    final endpoint = await resolveEndpoint(serverUrl);
    setEndpoint(endpoint);

    // Save in local database for next startup
    Store.put(StoreKey.serverEndpoint, endpoint);
    return endpoint;
  }

  /// Takes a server URL and resolves the API endpoint.
  ///
  /// Input: [schema://]host[:port][/path]
  ///  schema - optional (default: https)
  ///  host   - required
  ///  port   - optional (default: based on schema)
  ///  path   - optional
  Future<String> resolveEndpoint(String serverUrl) async {
    String url = sanitizeUrl(serverUrl);

    // Check for /.well-known/immich
    final wellKnownEndpoint = await _getWellKnownEndpoint(url);
    if (wellKnownEndpoint.isNotEmpty) {
      url = sanitizeUrl(wellKnownEndpoint);
    }

    if (!await _isEndpointAvailable(url)) {
      throw ApiException(503, "Server is not reachable");
    }

    return url;
  }

  Future<bool> _isEndpointAvailable(String serverUrl) async {
    try {
      await setEndpoint(serverUrl);
    } on TimeoutException catch (_) {
      return false;
    } on SocketException catch (_) {
      return false;
    } catch (error, stackTrace) {
      _log.severe(
        "Error while checking server availability",
        error,
        stackTrace,
      );
      return false;
    }
    return true;
  }

  Future<String> _getWellKnownEndpoint(String baseUrl) async {
    final Client client = Client();

    try {
      var headers = {"Accept": "application/json"};
      headers.addAll(getRequestHeaders());

      final res = await client
          .get(Uri.parse("$baseUrl/.well-known/immich"), headers: headers)
          .timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final endpoint = data['api']['endpoint'].toString();

        if (endpoint.startsWith('/')) {
          return "$baseUrl$endpoint";
        }
        return endpoint;
      }
    } catch (e) {
      debugPrint(
        "Could not locate /.well-known/immich "
        "at $baseUrl",
      );
    }

    return "";
  }

  Future<void> setAccessToken(String accessToken) async {
    _accessToken = accessToken;
    await Store.put(StoreKey.accessToken, accessToken);
    _log.info('Access token updated');
  }

  Future<void> setDeviceInfoHeader() async {
    final deviceInfo = DeviceInfoPlugin();
    final backend = clientFor(ServicePrefix.backend);

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      backend.addDefaultHeader('deviceModel', iosInfo.utsname.machine);
      backend.addDefaultHeader('deviceType', 'iOS');
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      backend.addDefaultHeader('deviceModel', androidInfo.model);
      backend.addDefaultHeader('deviceType', 'Android');
    } else {
      backend.addDefaultHeader('deviceModel', 'Unknown');
      backend.addDefaultHeader('deviceType', 'Unknown');
    }
  }

  static Map<String, String> getRequestHeaders() {
    final accessToken = Store.get(StoreKey.accessToken, "");
    final customHeadersStr = Store.get(StoreKey.customHeaders, "");
    final header = <String, String>{};
    if (accessToken.isNotEmpty) {
      header['Authorization'] = "Bearer $accessToken";
    }

    if (customHeadersStr.isEmpty) {
      return header;
    }

    final customHeaders = jsonDecode(customHeadersStr) as Map;
    customHeaders.forEach((key, value) {
      header[key] = value;
    });

    return header;
  }
}
