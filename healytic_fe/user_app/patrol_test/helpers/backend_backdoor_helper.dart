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
Future<SeedResponseDto?> prepareBackendScenario([String? scenario]) async {
  final config = TestConfig.instance;
  if (!config.backdoorEnabled) {
    return null;
  }

  _configureServiceIfNeeded(config);

  final scenarioName = scenario ?? config.defaultScenario;
  final rawPayload = _materializeScenarioPayload(
    scenarioName,
    await config.loadScenarioPayload(scenarioName),
  );

  final api = BackdoorApiService.instance.backdoorApi;

  return _seed(api, scenarioName, rawPayload);
}

/// Deletes only rows created by [prepareBackendScenario].
///
/// Cleanup is best-effort because a test may legitimately delete one of its own
/// seeded rows during the flow. Missing rows and cleanup conflicts should not
/// fail the Patrol run after assertions have already completed.
Future<void> cleanupBackendScenario(SeedResponseDto? seedResponse) async {
  final config = TestConfig.instance;
  if (!config.backdoorEnabled || seedResponse == null) {
    return;
  }

  _configureServiceIfNeeded(config);
  final api = BackdoorApiService.instance.backdoorApi;
  try {
    final response = await _postJsonRequest(api, '/test-backdoor/cleanup', {
      'ids': seedResponse.ids.toJson(),
    });
    log(
      'Backdoor cleanup "${seedResponse.scenario}" OK – '
      'deleted: ${response['deleted'] ?? {}}',
      name: 'BackdoorHelper',
    );
  } catch (error, stackTrace) {
    log(
      'Backdoor cleanup "${seedResponse.scenario}" ignored: $error',
      name: 'BackdoorHelper',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

Map<String, dynamic> _materializeScenarioPayload(
  String scenario,
  Map<String, dynamic> payload,
) {
  final copy = jsonDecode(jsonEncode(payload)) as Map<String, dynamic>;
  if (scenario == 'orders') {
    _materializeOrdersPayload(copy);
  }
  return copy;
}

void _materializeOrdersPayload(Map<String, dynamic> payload) {
  final bookings = payload['bookings'];
  if (bookings is! List) return;

  final now = DateTime.now().toUtc();
  for (final item in bookings) {
    if (item is! Map<String, dynamic>) continue;
    switch (item['key']) {
      case 'booking_pending':
        item['startsAt'] = now.add(const Duration(hours: 3)).toIso8601String();
        item['paymentExpiresAt'] = now
            .add(const Duration(minutes: 45))
            .toIso8601String();
      case 'booking_confirmed':
        item['startsAt'] = now.add(const Duration(days: 1)).toIso8601String();
      case 'booking_completed':
        item['startsAt'] = now
            .subtract(const Duration(days: 2))
            .toIso8601String();
    }
  }
}

/// Seeds data additively (no DB reset).
Future<SeedResponseDto?> _seed(
  TestBackdoorApi api,
  String scenario,
  Map<String, dynamic> payload,
) async {
  final response = await _postSeedRequest(api, '/test-backdoor/seed', payload);
  _logResult('seed', scenario, response);
  return response;
}

Future<SeedResponseDto?> _postSeedRequest(
  TestBackdoorApi api,
  String path,
  Map<String, dynamic> body,
) async {
  final decoded = await _postJsonRequest(api, path, body, ignoreConflict: true);
  return SeedResponseDto.fromJson(decoded);
}

Future<Map<String, dynamic>> _postJsonRequest(
  TestBackdoorApi api,
  String path,
  Map<String, dynamic> body, {
  bool ignoreConflict = false,
}) async {
  final response = await api.apiClient.invokeAPI(
    path,
    'POST',
    <QueryParam>[],
    body,
    <String, String>{},
    <String, String>{},
    'application/json',
  );

  if (ignoreConflict && response.statusCode == 409) {
    log(
      'Backdoor request $path ignored insert conflict: ${response.body}',
      name: 'BackdoorHelper',
    );
    return <String, dynamic>{};
  }

  if (response.statusCode >= 400) {
    throw ApiException(response.statusCode, response.body);
  }
  if (response.body.isEmpty) {
    return <String, dynamic>{};
  }
  final decoded = jsonDecode(response.body);
  if (decoded is! Map<String, dynamic>) {
    throw StateError('Backdoor response from $path must be a JSON object.');
  }
  return decoded;
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
