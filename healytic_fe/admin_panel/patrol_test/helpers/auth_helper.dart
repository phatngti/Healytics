import 'package:admin_panel/core/entities/role.entity.dart';
import 'package:admin_panel/core/keys/integration_test_keys.dart';
import 'package:patrol/patrol.dart';

import '../config/test_config.dart';

/// Signs in using fixture credentials via
/// key-based finders.
///
/// [role] should be `admin`, `partner`, or
/// `health_partner`. Defaults to admin sign-in.
Future<void> signIn(PatrolIntegrationTester $, {String role = 'admin'}) async {
  final config = TestConfig.instance;
  final roleValue = _normalizeRole(role);
  final isPartner = roleValue == Role.health_partner.value;
  final email = roleValue == Role.admin.value
      ? config.adminEmail
      : config.partnerEmail;
  final password = roleValue == Role.admin.value
      ? config.adminPassword
      : config.partnerPassword;

  // Wait for sign-in form to appear.
  await $(
    keys.signInPage.emailTextField,
  ).waitUntilVisible(timeout: const Duration(seconds: 10));

  if (isPartner) {
    await $('Partner').tap();
    await $.pump(const Duration(milliseconds: 500));
  }

  await $(keys.signInPage.emailTextField).enterText(email);
  await $(keys.signInPage.passwordTextField).enterText(password);
  await $(keys.signInPage.loginButton).tap();

  // Allow time for navigation after login.
  await $.pump(const Duration(seconds: 3));
}

String _normalizeRole(String role) {
  if (role == Role.admin.value) {
    return Role.admin.value;
  }
  if (role == Role.health_partner.value || role == 'partner') {
    return Role.health_partner.value;
  }
  throw ArgumentError.value(
    role,
    'role',
    'Expected admin, partner, or health_partner',
  );
}
