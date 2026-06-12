import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';

import 'common.dart';
import 'config/test_config.dart';
import 'helpers/auth_helper.dart';

PatrolFinder _textField(PatrolIntegrationTester $, Key key) {
  return $(
    find.descendant(of: find.byKey(key), matching: find.byType(TextFormField)),
  );
}

void main() {
  patrolTest('password reset validates input and signs in with new password', (
    $,
  ) async {
    await pumpApp($, scenario: 'passwordReset');
    final config = TestConfig.instance;

    if (config.useMock) {
      await $.pump(const Duration(seconds: 1));
      return;
    }

    await signOut($);

    final signInNav = $(keys.onboardPage.signInButton);
    if (await signInNav
        .waitUntilVisible(timeout: const Duration(seconds: 5))
        .then((_) => true)
        .catchError((_) => false)) {
      await signInNav.tap();
      await $.pump(const Duration(seconds: 1));
    }

    await $(keys.signInPage.forgotPasswordButton).waitUntilVisible().tap();
    await $.pump(const Duration(seconds: 1));

    expect(
      _textField($, keys.forgotPasswordPage.emailTextField),
      findsOneWidget,
    );
    expect($(keys.forgotPasswordPage.sendResetCodeButton), findsOneWidget);

    await _textField(
      $,
      keys.forgotPasswordPage.emailTextField,
    ).enterText('not-an-email');
    await $.pump(const Duration(milliseconds: 300));

    await _textField(
      $,
      keys.forgotPasswordPage.emailTextField,
    ).enterText(config.testEmail);
    await $(keys.forgotPasswordPage.sendResetCodeButton).tap();
    await $.pump(const Duration(seconds: 2));

    await $(
      keys.passwordResetCodePage.pinput,
    ).waitUntilVisible().enterText(config.passwordResetCode);

    await _textField(
      $,
      keys.resetPasswordPage.passwordTextField,
    ).waitUntilVisible().enterText(config.passwordResetNewPassword);
    await _textField(
      $,
      keys.resetPasswordPage.confirmPasswordTextField,
    ).enterText(config.passwordResetNewPassword);
    await $(keys.resetPasswordPage.submitButton).scrollTo();
    await $(keys.resetPasswordPage.submitButton).tap();
    await $.pump(const Duration(seconds: 2));

    await $(keys.resetPasswordPage.submitButton).scrollTo();
    await $(keys.resetPasswordPage.submitButton).tap();
    await $.pump(const Duration(seconds: 1));

    await signIn($, password: config.passwordResetNewPassword);
    expect($(keys.bottomNav.homeTab), findsOneWidget);
  });
}
