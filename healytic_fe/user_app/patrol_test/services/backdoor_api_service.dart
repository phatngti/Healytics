import 'dart:developer';

import '../openapi/test_backdoor_api.dart';

/// Lightweight API service for the test-backdoor
/// endpoints.
///
/// Mirrors the app's [ApiService] pattern but targets
/// the standalone generated OpenAPI client under
/// `patrol_test/openapi/`.
class BackdoorApiService {
  BackdoorApiService._();

  static BackdoorApiService? _instance;

  /// Singleton accessor.
  static BackdoorApiService get instance {
    _instance ??= BackdoorApiService._();
    return _instance!;
  }

  late ApiClient _apiClient;
  late TestBackdoorApi _backdoorApi;

  /// Whether [configure] has been called.
  bool _configured = false;

  /// The typed API facade for test-backdoor calls.
  TestBackdoorApi get backdoorApi {
    _assertConfigured();
    return _backdoorApi;
  }

  /// Initialise the client with the backdoor base URL
  /// from [TestConfig].
  ///
  /// Must be called once after [TestConfig.load]
  /// before any API call.
  void configure(String baseUrl) {
    _apiClient = ApiClient(basePath: baseUrl);
    _backdoorApi = TestBackdoorApi(_apiClient);
    _configured = true;
    log(
      'BackdoorApiService configured → $baseUrl',
      name: 'BackdoorApiService',
    );
  }

  /// Resets the singleton (useful between test runs).
  static void reset() {
    _instance = null;
  }

  void _assertConfigured() {
    if (!_configured) {
      throw StateError(
        'BackdoorApiService not configured. '
        'Call configure(baseUrl) first.',
      );
    }
  }
}
