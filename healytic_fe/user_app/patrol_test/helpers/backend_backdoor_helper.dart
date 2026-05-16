import 'dart:developer';

import '../config/test_config.dart';
import '../openapi/test_backdoor_api.dart';
import '../services/backdoor_api_service.dart';

/// Prepares real backend data for Patrol scenarios.
///
/// Static/master data stays in backend migrations.
/// This helper owns the per-scenario payload and
/// sends it via the typed [TestBackdoorApi].
Future<void> prepareBackendScenario([
  String? scenario,
]) async {
  final config = TestConfig.instance;
  if (!config.backdoorEnabled) {
    return;
  }

  _configureServiceIfNeeded(config);

  final scenarioName =
      scenario ?? config.defaultScenario;
  final rawPayload =
      await config.loadScenarioPayload(scenarioName);
  final payload = SeedPayloadDto.fromJson(rawPayload);

  if (payload == null) {
    throw StateError(
      'Failed to parse scenario "$scenarioName" '
      'into SeedPayloadDto.',
    );
  }

  final api =
      BackdoorApiService.instance.backdoorApi;

  if (config.resetBeforeEachTest) {
    await _prepare(api, scenarioName, payload);
  } else {
    await _seed(api, scenarioName, payload);
  }
}

/// Resets the DB and seeds the full scenario.
Future<void> _prepare(
  TestBackdoorApi api,
  String scenario,
  SeedPayloadDto payload,
) async {
  final dto = BackdoorPrepareDto(
    scenario: scenario,
    payload: payload,
  );
  final response =
      await api.testBackdoorControllerPrepare(dto);
  _logResult('prepare', scenario, response);
}

/// Seeds data additively (no DB reset).
Future<void> _seed(
  TestBackdoorApi api,
  String scenario,
  SeedPayloadDto payload,
) async {
  final response =
      await api.testBackdoorControllerSeed(payload);
  _logResult('seed', scenario, response);
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
void _logResult(
  String action,
  String scenario,
  SeedResponseDto? response,
) {
  if (response == null) {
    log(
      'Backdoor $action "$scenario" returned null.',
      name: 'BackdoorHelper',
    );
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
