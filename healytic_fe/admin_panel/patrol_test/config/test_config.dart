import 'dart:convert';

import 'package:admin_panel/core/config/app_environment.dart';
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:flutter/services.dart';

/// Loads environment-specific test fixtures from JSON.
///
/// Devs configure test data per environment by editing
/// `patrol_test/fixtures/<env>_fixtures.json`.
class TestConfig {
  TestConfig._();

  late final Map<String, dynamic> _fixtures;

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
    final config = TestConfig._();
    final env = AppEnvironment.fromDartDefine();
    final fileString = await rootBundle.loadString(
      'patrol_test/fixtures/'
      '${env.name}_fixtures.json',
    );
    config._fixtures = jsonDecode(fileString) as Map<String, dynamic>;
    _instance = config;
    return config;
  }

  // --- Auth ---

  Map<String, dynamic> get _auth => _fixtures['auth'] as Map<String, dynamic>;

  Map<String, dynamic> get _dashboard =>
      _fixtures['dashboard'] as Map<String, dynamic>;

  /// Admin test account email.
  String get adminEmail =>
      (_auth['admin'] as Map<String, dynamic>)['email'] as String;

  /// Admin test account password.
  String get adminPassword =>
      (_auth['admin'] as Map<String, dynamic>)['password'] as String;

  /// Partner test account email.
  String get partnerEmail =>
      (_auth['partner'] as Map<String, dynamic>)['email'] as String;

  /// Partner test account password.
  String get partnerPassword =>
      (_auth['partner'] as Map<String, dynamic>)['password'] as String;

  // --- Dashboard Data ---

  /// Dashboard title expected after admin sign-in.
  String get dashboardExpectedTitle => _dashboard['expectedTitle'] as String;

  // --- Environment ---

  /// Current environment name.
  String get envName => AppEnvironment.fromDartDefine().name;

  /// Whether current env uses mock data sources.
  bool get useMock => Store.get(StoreKey.mockFlag, false);

  /// Whether the app started in Patrol test mode.
  bool get isPatrol => const bool.fromEnvironment('patrol');
}
