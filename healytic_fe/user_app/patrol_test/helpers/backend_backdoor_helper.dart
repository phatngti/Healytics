import 'dart:convert';
import 'dart:developer';

import '../config/test_config.dart';
import '../openapi/test_backdoor_api.dart';
import '../services/backdoor_api_service.dart';

/// Prepares real backend data for Patrol scenarios.
///
/// Static/master data stays in backend migrations.
/// This helper owns the per-scenario payload and
/// sends it to the test backdoor. Requests intentionally use raw JSON maps so
/// newly added backend-only seed fields are not dropped by a stale generated
/// Patrol OpenAPI client.
Future<void> prepareBackendScenario([String? scenario]) async {
  final config = TestConfig.instance;
  if (!config.backdoorEnabled) {
    return;
  }

  _configureServiceIfNeeded(config);

  final scenarioName = scenario ?? config.defaultScenario;
  final rawPayload = await config.loadScenarioPayload(scenarioName);

  final api = BackdoorApiService.instance.backdoorApi;

  if (config.resetBeforeEachTest) {
    await _prepare(api, scenarioName, rawPayload);
  } else {
    await _seed(api, scenarioName, rawPayload);
  }
}

/// Resets the DB and seeds the full scenario.
Future<void> _prepare(
  TestBackdoorApi api,
  String scenario,
  Map<String, dynamic> payload,
) async {
  final response = await _postSeedRequest(api, '/test-backdoor/prepare', {
    'scenario': scenario,
    'payload': payload,
  });
  _logResult('prepare', scenario, response);
}

/// Seeds data additively (no DB reset).
Future<void> _seed(
  TestBackdoorApi api,
  String scenario,
  Map<String, dynamic> payload,
) async {
  final response = await _postSeedRequest(api, '/test-backdoor/seed', payload);
  _logResult('seed', scenario, response);
}

Future<SeedResponseDto?> _postSeedRequest(
  TestBackdoorApi api,
  String path,
  Map<String, dynamic> body,
) async {
  final response = await api.apiClient.invokeAPI(
    path,
    'POST',
    <QueryParam>[],
    body,
    <String, String>{},
    <String, String>{},
    'application/json',
  );

  if (response.statusCode >= 400) {
    throw ApiException(response.statusCode, response.body);
  }
  if (response.body.isEmpty) {
    return null;
  }
  final decoded = jsonDecode(response.body);
  if (decoded is! Map<String, dynamic>) {
    throw StateError('Backdoor response from $path must be a JSON object.');
  }
  return SeedResponseDto.fromJson(decoded);
}

/// Lazily configures [BackdoorApiService] once.
void _configureServiceIfNeeded(TestConfig config) {
  final service = BackdoorApiService.instance;
  try {
    // Access triggers _assertConfigured internally.
    // ignore: unnecessary_statements
    service.backdoorApi;
  } on StateError {
    service.configure(config.backdoorBaseUrl);
  }
}

/// Logs the seed/prepare result for debugging.
void _logResult(String action, String scenario, SeedResponseDto? response) {
  if (response == null) {
    log('Backdoor $action "$scenario" returned null.', name: 'BackdoorHelper');
    return;
  }
  if (!response.ok) {
    throw StateError(
      'Backdoor $action "$scenario" failed: '
      '${response.toJson()}',
    );
  }
  log(
    'Backdoor $action "$scenario" OK – '
    'ids: ${response.ids.toJson()}',
    name: 'BackdoorHelper',
  );
}
