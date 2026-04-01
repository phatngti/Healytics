import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/network/logging_client.dart';
import 'package:admin_panel/core/utils/browser_storage.dart';
import 'package:admin_panel/core/utils/url_helper.dart';
import 'package:admin_panel/core/utils/user_agent.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:admin_openapi/api.dart';

/// Prefixes for different backend services behind
/// the API gateway (Kong).
///
/// **REST** entries produce an [ApiClient] in
/// [ApiService.setEndpoint].
/// **Real-time** entries (WS) are URL-only — used
/// to build full URIs without duplicating path
/// constants.
enum ServicePrefix {
  // ── REST (get an ApiClient) ───────────────────
  /// NestJS main backend: `/backend`
  backend('/backend'),

  /// AI / chatbot service: `/ai`
  ai('/ai'),

  // ── Real-time (URL-only, no ApiClient) ────────
  /// WebSocket partner-chat namespace:
  /// `/partner-chat`
  partnerChat('/partner-chat', isRest: false);

  const ServicePrefix(this.path, {this.isRest = true});

  /// The URL path segment for this service.
  final String path;

  /// Whether an [ApiClient] should be created for
  /// this prefix. `false` for WS entries.
  final bool isRest;

  /// All entries that need an [ApiClient].
  static List<ServicePrefix> get restValues =>
      values.where((v) => v.isRest).toList();
}

class ApiService implements Authentication {
  final _clients = <ServicePrefix, ApiClient>{};

  // ── Authentication & Account ──────────────────────
  late AuthenticationApi authenticateApi;
  late AccountApi accountApi;

  // ── Partners ──────────────────────────────────────
  late PartnersApi partnersApi;
  late AdminPartnersApi adminPartnersApi;
  late PartnerPartnersApi partnerPartnersApi;
  late PartnerEmployeesApi employeesApi;
  late PartnerHealthServicesApi partnerHealthServicesApi;
  late PartnerChatApi partnerChatApi;

  // ── Health Services & Categories ──────────────────
  late UserHealthServicesApi healthServicesApi;
  late CategoriesApi categoriesApi;
  late AdminCategoriesApi adminCategoriesApi;
  late PartnerServiceTagsApi serviceTagsApi;

  // ── Locations ─────────────────────────────────────
  late LocationsApi locationsApi;

  ApiService() {
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

  /// The raw API gateway URL **without** any service
  /// prefix (e.g. `https://api.healytics.vn`).
  ///
  /// Used by [WsService] to build WebSocket URLs.
  String get gatewayUrl => _gatewayUrl;
  String _gatewayUrl = '';

  /// The current access token, or `null` if not set.
  String? get accessToken => _accessToken;

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
    _gatewayUrl = endPoint;

    // Create one ApiClient per REST service prefix.
    for (final prefix in ServicePrefix.restValues) {
      _clients[prefix] = ApiClient(
        basePath: '$endPoint${prefix.path}',
        authentication: this,
      )..client = LoggingClient(Client());
    }

    _setUserAgentHeaders();

    if (_accessToken != null) {
      setAccessToken(_accessToken!);
    }

    final backend = clientFor(ServicePrefix.backend);

    // ── Backend APIs ────────────────────────────────
    authenticateApi = AuthenticationApi(backend);
    accountApi = AccountApi(backend);
    partnersApi = PartnersApi(backend);
    adminPartnersApi = AdminPartnersApi(backend);
    partnerPartnersApi = PartnerPartnersApi(backend);
    employeesApi = PartnerEmployeesApi(backend);
    partnerHealthServicesApi = PartnerHealthServicesApi(backend);
    healthServicesApi = UserHealthServicesApi(backend);
    categoriesApi = CategoriesApi(backend);
    adminCategoriesApi = AdminCategoriesApi(backend);
    serviceTagsApi = PartnerServiceTagsApi(backend);
    locationsApi = LocationsApi(backend);
    partnerChatApi = PartnerChatApi(backend);
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
    setBrowserItem('access_token', accessToken);
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
    var accessToken = Store.get(StoreKey.accessToken, "");
    if (accessToken.isEmpty) {
      accessToken = getBrowserItem('access_token') ?? "";
    }
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
