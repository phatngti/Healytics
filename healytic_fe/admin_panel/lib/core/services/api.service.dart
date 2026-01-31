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

class ApiService implements Authentication {
  late ApiClient _apiClient;
  late AuthenticationApi authenticateApi;
  late AccountApi accountApi;
  late EmployeesApi employeesApi;
  late ProductsApi productsApi;
  late CategoriesApi categoriesApi;
  late LocationsApi locationsApi;
  late PartnersApi partnersApi;
  late AdminPartnersApi adminPartnersApi;

  ApiService() {
    // The below line ensures that the api clients are initialized when the service is instantiated
    // This is required to avoid late initialization errors when the clients are access before the endpoint is resolved
    setEndpoint('');
    final endpoint = Store.tryGet(StoreKey.serverEndpoint);
    if (endpoint != null && endpoint.isNotEmpty) {
      setEndpoint(endpoint);
    }
  }

  ApiClient get apiClient => _apiClient;
  String? _accessToken;
  final _log = Logger('ApiService');

  @override
  Future<void> applyToParams(
    List<QueryParam> queryParams,
    Map<String, String> headerParams,
  ) {
    return Future<void>(() {
      var headers = ApiService.getRequestHeaders();
      headerParams.addAll(headers);
    });
  }

  dynamic setEndpoint(String endPoint) {
    _apiClient = ApiClient(basePath: endPoint, authentication: this)
      ..client = LoggingClient(Client());
    _setUserAgentHeader();

    if (_accessToken != null) {
      setAccessToken(_accessToken!);
    }
    authenticateApi = AuthenticationApi(_apiClient);
    accountApi = AccountApi(_apiClient);
    employeesApi = EmployeesApi(_apiClient);
    productsApi = ProductsApi(_apiClient);
    categoriesApi = CategoriesApi(_apiClient);
    locationsApi = LocationsApi(_apiClient);
    partnersApi = PartnersApi(_apiClient);
    adminPartnersApi = AdminPartnersApi(_apiClient);
  }

  Future<void> _setUserAgentHeader() async {
    final userAgent = await getUserAgentString();
    _apiClient.addDefaultHeader('User-Agent', userAgent);
  }

  Future<String> resolveAndSetEndpoint(String serverUrl) async {
    final endpoint = await resolveEndpoint(serverUrl);
    setEndpoint(endpoint);

    // Save in local database for next startup
    Store.put(StoreKey.serverEndpoint, endpoint);
    return endpoint;
  }

  /// Takes a server URL and attempts to resolve the API endpoint.
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

    // Otherwise, assume the URL provided is the api endpoint
    return url;
  }

  Future<bool> _isEndpointAvailable(String serverUrl) async {
    if (!serverUrl.endsWith('/api')) {
      serverUrl += '/api';
    }

    try {
      await setEndpoint(serverUrl);
      // await serverInfoApi.pingServer().timeout(const Duration(seconds: 5));
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
          // Full URL is relative to base
          return "$baseUrl$endpoint";
        }
        return endpoint;
      }
    } catch (e) {
      debugPrint("Could not locate /.well-known/immich at $baseUrl");
    }

    return "";
  }

  Future<void> setAccessToken(String accessToken) async {
    _accessToken = accessToken;
    await Store.put(StoreKey.accessToken, accessToken);
    setBrowserItem('access_token', accessToken);
  }

  Future<void> setDeviceInfoHeader() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      authenticateApi.apiClient.addDefaultHeader(
        'deviceModel',
        iosInfo.utsname.machine,
      );
      authenticateApi.apiClient.addDefaultHeader('deviceType', 'iOS');
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      authenticateApi.apiClient.addDefaultHeader(
        'deviceModel',
        androidInfo.model,
      );
      authenticateApi.apiClient.addDefaultHeader('deviceType', 'Android');
    } else {
      authenticateApi.apiClient.addDefaultHeader('deviceModel', 'Unknown');
      authenticateApi.apiClient.addDefaultHeader('deviceType', 'Unknown');
    }
  }

  static Map<String, String> getRequestHeaders() {
    var accessToken = Store.get(StoreKey.accessToken, "");
    if (accessToken.isEmpty) {
      accessToken = getBrowserItem('access_token') ?? "";
    }
    var customHeadersStr = Store.get(StoreKey.customHeaders, "");
    var header = <String, String>{};
    if (accessToken.isNotEmpty) {
      header['Authorization'] = "Bearer $accessToken";
    }

    if (customHeadersStr.isEmpty) {
      return header;
    }

    var customHeaders = jsonDecode(customHeadersStr) as Map;
    customHeaders.forEach((key, value) {
      header[key] = value;
    });

    return header;
  }
}
