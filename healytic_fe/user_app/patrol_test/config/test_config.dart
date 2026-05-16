import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:user_app/core/config/app_environment.dart';

/// Loads environment-specific test fixtures from JSON.
///
/// Devs configure test data per environment by editing
/// `patrol_test/fixtures/<env>_fixtures.json`.
class TestConfig {
  TestConfig._();

  late final Map<String, dynamic> _fixtures;
  Map<String, dynamic>? _activeScenarioPayload;
  String? _activeScenarioName;

  /// Singleton instance.
  static TestConfig? _instance;

  /// Access the loaded config.
  static TestConfig get instance {
    if (_instance == null) {
      throw StateError(
        'TestConfig not loaded. '
        'Call TestConfig.load() first.',
      );
    }
    return _instance!;
  }

  /// Loads fixture file matching current ENV.
  static Future<TestConfig> load() async {
    final env = AppEnvironment.fromDartDefine();
    return loadFrom(
      'patrol_test/fixtures/'
      '${env.name}_fixtures.json',
    );
  }

  /// Loads fixtures from an explicit [assetPath].
  ///
  /// Use this when a test needs its own fixture file
  /// instead of the default ENV-based one.
  static Future<TestConfig> loadFrom(String assetPath) async {
    final config = TestConfig._();
    final fileString = await rootBundle.loadString(assetPath);
    config._fixtures = jsonDecode(fileString) as Map<String, dynamic>;
    _instance = config;
    if (config.backdoorEnabled) {
      await config.loadScenarioPayload(config.defaultScenario);
    }
    return config;
  }

  /// Loads a seed scenario payload from
  /// `patrol_test/fixtures/scenarios`.
  Future<Map<String, dynamic>> loadScenarioPayload(String scenario) async {
    final path = scenarioPath(scenario);
    final fileString = await rootBundle.loadString(path);
    final decoded = jsonDecode(fileString);
    if (decoded is! Map<String, dynamic>) {
      throw StateError(
        'Patrol seed scenario "$scenario" must be a JSON object.',
      );
    }
    _activeScenarioPayload = decoded;
    _activeScenarioName = scenario;
    return _activeScenarioPayload!;
  }

  // --- Auth ---

  /// Test account email for current env.
  String get testEmail {
    final auth = (_fixtures['auth'] as Map<String, dynamic>?) ?? {};
    final email = auth['email'] as String?;
    if (email != null && email.isNotEmpty) {
      return email;
    }
    return _defaultScenarioUser['email'] as String;
  }

  /// Test account password for current env.
  String get testPassword {
    final auth = (_fixtures['auth'] as Map<String, dynamic>?) ?? {};
    final password = auth['password'] as String?;
    if (password != null && password.isNotEmpty) {
      return password;
    }
    return _defaultScenarioUser['password'] as String;
  }

  // --- Home Data ---

  /// Home categories for test assertions.
  List<dynamic> get homeCategories =>
      ((_fixtures['home'] as Map<String, dynamic>?)?['categories']
          as List<dynamic>?) ??
      const [];

  /// Home products for test assertions.
  List<dynamic> get homeProducts =>
      ((_fixtures['home'] as Map<String, dynamic>?)?['products']
          as List<dynamic>?) ??
      const [];

  // --- Chat Data ---

  /// Pre-seeded conversations for chat tests.
  List<dynamic> get conversations =>
      (_fixtures['conversations'] as List<dynamic>?) ?? const [];

  // --- Orders Data ---

  /// Pre-seeded appointments for order tests.
  List<dynamic> get appointments =>
      ((_fixtures['orders'] as Map<String, dynamic>?)?['appointments']
          as List<dynamic>?) ??
      const [];

  // --- Checkout Data ---

  /// Checkout data for checkout tests.
  Map<String, dynamic> get checkout =>
      (_fixtures['checkout'] as Map<String, dynamic>?) ?? const {};

  // --- Backdoor seed config ---

  bool get backdoorEnabled {
    final backdoor = _fixtures['backdoor'] as Map<String, dynamic>?;
    return backdoor?['enabled'] == true;
  }

  String get backdoorBaseUrl {
    const override = String.fromEnvironment('BACKDOOR_BASE_URL');
    if (override.isNotEmpty) {
      return override;
    }
    final backdoor = _fixtures['backdoor'] as Map<String, dynamic>?;
    final url =
        (backdoor?['baseUrl'] as String?) ?? 'https://dev.healytics.me/backend';
    if (url.isEmpty) {
      throw StateError(
        'Backdoor is enabled but backdoor.baseUrl is empty. '
        'Set patrol_test/fixtures/<env>_fixtures.json or '
        'BACKDOOR_BASE_URL.',
      );
    }
    return url;
  }

  bool get resetBeforeEachTest {
    final backdoor = _fixtures['backdoor'] as Map<String, dynamic>?;
    return backdoor?['resetBeforeEachTest'] != false;
  }

  String get defaultScenario =>
      (_fixtures['defaultScenario'] as String?) ?? 'core';

  String get activeScenario => _activeScenarioName ?? defaultScenario;

  Map<String, dynamic> get activeScenarioPayload =>
      _activeScenarioPayload ?? const {};

  String scenarioPath(String scenario) {
    final scenarios = _fixtures['scenarios'] as Map<String, dynamic>?;
    final path = scenarios?[scenario] as String?;
    if (path == null || path.isEmpty) {
      final available = (scenarios?.keys.toList() ?? const <String>[])..sort();
      throw StateError(
        'Unknown Patrol seed scenario "$scenario". '
        'Available scenarios: ${available.join(', ')}.',
      );
    }
    return path;
  }

  Map<String, dynamic> get _defaultScenarioUser {
    final auth = (_fixtures['auth'] as Map<String, dynamic>?) ?? {};
    final defaultUserKey = auth['defaultUserKey'] as String?;
    final users =
        (_activeScenarioPayload?['users'] as List<dynamic>?) ?? const [];
    final user = users.cast<Map<String, dynamic>>().firstWhere(
      (candidate) => candidate['key'] == defaultUserKey,
      orElse: () => users.cast<Map<String, dynamic>>().isNotEmpty
          ? users.cast<Map<String, dynamic>>().first
          : <String, dynamic>{},
    );
    if (user.isEmpty) {
      throw StateError(
        'No auth email/password configured and active scenario '
        '"$activeScenario" does not contain users.',
      );
    }
    if ((user['email'] as String?)?.isNotEmpty != true ||
        (user['password'] as String?)?.isNotEmpty != true) {
      throw StateError(
        'Scenario "$activeScenario" user "${user['key'] ?? defaultUserKey}" '
        'must contain non-empty email and password.',
      );
    }
    return user;
  }

  // --- Environment ---

  /// Whether current env uses mock data sources.
  bool get useMock => AppEnvironment.fromDartDefine().useMock;

  /// Whether the app started in Patrol test mode.
  bool get isPatrol => const bool.fromEnvironment('patrol');
}
