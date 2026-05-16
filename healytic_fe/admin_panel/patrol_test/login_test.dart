import 'package:admin_panel/core/keys/integration_test_keys.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/admin_dashboard_screen.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'common.dart';
import 'config/test_config.dart';
import 'helpers/auth_helper.dart';

void main() {
  patrolTest('sign in form renders on launch', ($) async {
    await pumpApp($);

    expect($(SignInScreen), findsOneWidget);
  });

  patrolTest('admin sign in navigates to dashboard', ($) async {
    await pumpApp($);
    await signIn($, role: 'admin');

    expect($(AdminDashboardScreen), findsOneWidget);
  });

  patrolTest('partner sign in navigates to '
      'partner dashboard', ($) async {
    await pumpApp($);
    await signIn($, role: 'health_partner');

    // Partner may land on dashboard, profile
    // completion, or verification depending on
    // fixture state, but should leave sign-in.
    expect($(SignInScreen), findsNothing);
  });

  patrolTest('invalid credentials show backend error '
      'when mock auth is disabled', ($) async {
    await pumpApp($);
    final config = TestConfig.instance;

    if (config.useMock) {
      expect($(SignInScreen), findsOneWidget);
      return;
    }

    await $(
      keys.signInPage.emailTextField,
    ).waitUntilVisible(timeout: const Duration(seconds: 10));

    await $(keys.signInPage.emailTextField).enterText('wrong@email.com');

    await $(keys.signInPage.passwordTextField).enterText('wrongpassword');

    await $(keys.signInPage.loginButton).tap();

    await $(
      find.byIcon(Icons.error_rounded),
    ).waitUntilVisible(timeout: const Duration(seconds: 10));
  });

  patrolTest('forgot password link is visible', ($) async {
    await pumpApp($);

    expect($(keys.signInPage.forgotPasswordButton), findsOneWidget);
  });

  patrolTest('join as provider link is visible', ($) async {
    await pumpApp($);

    expect($(keys.signInPage.joinProviderButton), findsOneWidget);
  });
}
