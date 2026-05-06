import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:logging/logging.dart';
import '../entities/store.entity.dart';
import '../models/store.model.dart';
import '../utils/url_helper.dart';
import '../utils/user_agent.dart';
import 'package:user_openapi/api.dart';

import 'auth_http_client.dart';

/// Service prefixes behind the API gateway.
enum ServicePrefix {
  backend('/backend');

  const ServicePrefix(this.path);
  final String path;

  static List<ServicePrefix> get restValues => values;

  String httpUrl(String gatewayUrl) => '$gatewayUrl$path';
}

/// Centralised API client for the employee app.
///
/// Trimmed from user_app — only exposes APIs
/// relevant to employee workflows.
class ApiService implements Authentication {
  final _clients = <ServicePrefix, ApiClient>{};
  final AuthHttpClient? _authHttpClient;

  String get gatewayUrl => _gatewayUrl;
  String _gatewayUrl = '';

  String? get accessToken => _accessToken;

  // ── Authentication & Account ──────────────────
  late AuthenticationApi authenticateApi;
  late AccountApi accountApi;

  // ── Appointments ──────────────────────────────
  late UserAppointmentsApi userAppointmentsApi;

  ApiService({AuthHttpClient? httpClient}) : _authHttpClient = httpClient {
    setEndpoint('');
    final endpoint = Store.tryGet(StoreKey.serverEndpoint);
    if (endpoint != null && endpoint.isNotEmpty) {
      setEndpoint(endpoint);
    }
  }

  ApiClient get apiClient => _clients[ServicePrefix.backend]!;

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

  dynamic setEndpoint(String endPoint) {
    _gatewayUrl = endPoint;

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

    _authHttpClient?.backendBasePath = '$endPoint${ServicePrefix.backend.path}';

    _setUserAgentHeaders();

    if (_accessToken != null) {
      setAccessToken(_accessToken!);
    }

    final backend = clientFor(ServicePrefix.backend);

    // ── Backend APIs ────────────────────────────
    authenticateApi = AuthenticationApi(backend);
    accountApi = AccountApi(backend);
    userAppointmentsApi = UserAppointmentsApi(backend);
  }

  Future<void> _setUserAgentHeaders() async {
    final userAgent = await getUserAgentString();
    for (final client in _clients.values) {
      client.addDefaultHeader('User-Agent', userAgent);
    }
  }

  Future<String> resolveAndSetEndpoint(String serverUrl) async {
    final endpoint = await resolveEndpoint(serverUrl);
    setEndpoint(endpoint);
    Store.put(StoreKey.serverEndpoint, endpoint);
    return endpoint;
  }

  Future<String> resolveEndpoint(String serverUrl) async {
    String url = sanitizeUrl(serverUrl);

    if (!await _isEndpointAvailable(url)) {
      throw ApiException(503, 'Server is not reachable');
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
        'Error while checking server availability',
        error,
        stackTrace,
      );
      return false;
    }
    return true;
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
    final accessToken = Store.get(StoreKey.accessToken, '');
    final customHeadersStr = Store.get(StoreKey.customHeaders, '');
    final header = <String, String>{};
    if (accessToken.isNotEmpty) {
      header['Authorization'] = 'Bearer $accessToken';
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
