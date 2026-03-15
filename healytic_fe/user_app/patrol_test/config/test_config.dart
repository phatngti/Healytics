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
    config._fixtures = jsonDecode(fileString)
        as Map<String, dynamic>;
    _instance = config;
    return config;
  }

  // --- Auth ---

  /// Test account email for current env.
  String get testEmail =>
      (_fixtures['auth']
          as Map<String, dynamic>)['email'] as String;

  /// Test account password for current env.
  String get testPassword =>
      (_fixtures['auth']
          as Map<String, dynamic>)['password']
      as String;

  // --- Home Data ---

  /// Home categories for test assertions.
  List<dynamic> get homeCategories =>
      (_fixtures['home']
          as Map<String, dynamic>)['categories']
      as List<dynamic>;

  /// Home products for test assertions.
  List<dynamic> get homeProducts =>
      (_fixtures['home']
          as Map<String, dynamic>)['products']
      as List<dynamic>;

  // --- Chat Data ---

  /// Pre-seeded conversations for chat tests.
  List<dynamic> get conversations =>
      _fixtures['conversations'] as List<dynamic>;

  // --- Orders Data ---

  /// Pre-seeded appointments for order tests.
  List<dynamic> get appointments =>
      (_fixtures['orders']
          as Map<String, dynamic>)['appointments']
      as List<dynamic>;

  // --- Checkout Data ---

  /// Checkout data for checkout tests.
  Map<String, dynamic> get checkout =>
      _fixtures['checkout'] as Map<String, dynamic>;

  // --- Environment ---

  /// Whether current env uses mock data sources.
  bool get useMock =>
      AppEnvironment.fromDartDefine().useMock;

  /// Whether the app started in Patrol test mode.
  bool get isPatrol =>
      const bool.fromEnvironment('patrol');
}
