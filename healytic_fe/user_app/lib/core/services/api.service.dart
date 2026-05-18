import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:user_app/core/services/sse_client.dart';
import 'package:user_app/core/services/sse_event.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/utils/url_helper.dart';
import 'package:user_app/core/utils/user_agent.dart';
import 'package:user_openapi/api.dart';

import 'auth_http_client.dart';

/// Prefixes for different backend services behind
/// the API gateway (Kong).
///
/// **REST** entries produce an [ApiClient] in
/// [ApiService.setEndpoint].
/// **Real-time** entries (SSE / WS) are URL-only –
/// used to build full URIs without duplicating path
/// constants.
enum ServicePrefix {
  // ── REST (get an ApiClient) ───────────────────
  /// NestJS main backend: `/backend`
  backend('/backend'),

  /// AI / chatbot service: `/ai`
  ai('/ai'),

  // ── Real-time (URL-only, no ApiClient) ────────
  /// SSE streaming via the AI service: `/ai`
  aiSse('/ai', isRest: false),

  /// WebSocket user-chat namespace: `/user-chat`
  userChat('/user-chat', isRest: false),

  /// WebSocket partner-chat namespace:
  /// `/partner-chat`
  partnerChat('/partner-chat', isRest: false),

  /// WebSocket notifications namespace:
  /// `/notifications`
  notifications('/notifications', isRest: false),

  /// WebSocket chat notifications namespace:
  /// `/chat-notifications`
  chatNotifications('/chat-notifications', isRest: false);

  const ServicePrefix(this.path, {this.isRest = true});

  /// The URL path segment for this service.
  final String path;

  /// Whether an [ApiClient] should be created for
  /// this prefix. `false` for SSE / WS entries.
  final bool isRest;

  /// All entries that need an [ApiClient].
  static List<ServicePrefix> get restValues =>
      values.where((v) => v.isRest).toList();

  /// Builds a full HTTP URL from a gateway base.
  ///
  /// Example:
  /// ```dart
  /// ServicePrefix.backend.httpUrl(gateway)
  /// // → 'https://api.healytics.vn/backend'
  /// ```
  String httpUrl(String gatewayUrl) => '$gatewayUrl$path';

  /// Builds a WebSocket URL from a gateway base by
  /// replacing http(s) with ws(s).
  ///
  /// Example:
  /// ```dart
  /// ServicePrefix.userChat.wsUrl(gateway)
  /// // → 'wss://api.healytics.vn/user-chat'
  /// ```
  String wsUrl(String gatewayUrl) {
    final wsBase = gatewayUrl
        .replaceFirst('https://', 'wss://')
        .replaceFirst('http://', 'ws://');
    return '$wsBase$path';
  }
}

class ApiService implements Authentication {
  final _clients = <ServicePrefix, ApiClient>{};
  final AuthHttpClient? _authHttpClient;

  /// The raw API gateway URL **without** any service
  /// prefix (e.g. `https://api.healytics.vn`).
  ///
  /// Useful for WebSocket / Socket.IO connections
  /// that append their own namespace.
  String get gatewayUrl => _gatewayUrl;
  String _gatewayUrl = '';

  /// The current access token, or `null` if not set.
  String? get accessToken => _accessToken;

  // ── Authentication & Account ──────────────────────
  late AuthenticationApi authenticateApi;
  late AccountApi accountApi;

  // ── Home / Products ───────────────────────────────
  late CategoriesApi categoriesApi;
  late PartnerServiceTagsApi partnerServiceTagsApi;
  late UserHealthServicesApi userHealthServicesApi;

  // ── Booking / Slots ───────────────────────────────
  late UserBookingSearchApi userBookingSearchApi;
  late UserBookingsApi userBookingsApi;
  late UserSlotsApi userSlotsApi;

  // ── Appointments ──────────────────────────────────
  late UserAppointmentsApi userAppointmentsApi;

  // ── Reviews ───────────────────────────────────────
  late UserReviewsApi userReviewsApi;

  // ── Recommender (AI service) ──────────────────
  late RecommenderApi recommenderApi;

  // ── Notifications ─────────────────────────────────
  late UserNotificationsApi userNotificationsApi;

  // ── Devices ────────────────────────────────────────
  late UserDevicesApi userDevicesApi;

  // ── Chat ───────────────────────────────────────────
  late UserChatApi userChatApi;

  // ── Chatbot (AI service) ──────────────────────────
  late ChatbotApi chatbotApi;

  // ── Employees ─────────────────────────────────────
  late UserEmployeesApi userEmployeesApi;

  // ── User Categories ───────────────────────────────
  late UserCategoriesApi userCategoriesApi;

  // ── Payments ──────────────────────────────────────
  late UserPaymentsApi userPaymentsApi;

  // ── Clinics ───────────────────────────────────────
  late UserClinicsApi userClinicsApi;

  // ── Cart ────────────────────────────────────────
  late CartApi cartApi;

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
    _gatewayUrl = endPoint;

    // Create one ApiClient per service prefix.
    for (final prefix in ServicePrefix.restValues) {
      final client = ApiClient(
        basePath: '$endPoint${prefix.path}',
        authentication: this,
      );
      if (_authHttpClient != null) {
        client.client = _authHttpClient;
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
    userBookingSearchApi = UserBookingSearchApi(backend);
    userBookingsApi = UserBookingsApi(backend);
    userSlotsApi = UserSlotsApi(backend);
    userAppointmentsApi = UserAppointmentsApi(backend);
    userEmployeesApi = UserEmployeesApi(backend);
    userCategoriesApi = UserCategoriesApi(backend);
    userPaymentsApi = UserPaymentsApi(backend);
    userClinicsApi = UserClinicsApi(backend);
    cartApi = CartApi(backend);
    userHealthServicesApi = UserHealthServicesApi(backend);
    userReviewsApi = UserReviewsApi(backend);
    userNotificationsApi = UserNotificationsApi(backend);
    userDevicesApi = UserDevicesApi(backend);
    userChatApi = UserChatApi(backend);

    // ── AI APIs ─────────────────────────────────────
    chatbotApi = ChatbotApi(ai);
    recommenderApi = RecommenderApi(ai);
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

  // ── SSE convenience ─────────────────────────────

  /// Opens an SSE stream to [path] on [prefix] with
  /// the current auth headers injected automatically.
  ///
  /// [method] must be `'GET'` or `'POST'`.
  /// For POST requests, pass a JSON [body].
  Stream<SseEvent> openSseStream({
    required ServicePrefix prefix,
    required String method,
    required String path,
    Map<String, dynamic>? body,
  }) {
    final basePath = clientFor(prefix).basePath;
    final url = '$basePath$path';
    final headers = getRequestHeaders();

    return switch (method.toUpperCase()) {
      'POST' => SseClient.instance.post(
        url,
        headers: headers,
        body: body ?? {},
      ),
      _ => SseClient.instance.get(url, headers: headers),
    };
  }
}
