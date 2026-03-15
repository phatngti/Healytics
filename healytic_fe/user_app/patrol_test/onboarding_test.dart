import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/authenticate/presentation/screens/signin.screen.dart';
import 'package:user_app/features/onboarding/presentation/screens/lottie_splash.screen.dart';
import 'package:user_app/features/onboarding/presentation/screens/onboard.screen.dart';

import 'common.dart';
import 'config/test_config.dart';
import 'helpers/auth_helper.dart';

void main() {
  patrolTest(
    'splash screen appears on launch',
    ($) async {
      await pumpApp($);
      final config = TestConfig.instance;

      if (config.useMock) {
        // In mock mode the splash auto-navigates
        // out, so we just verify the app launched.
        await $.pump(const Duration(seconds: 1));
        return;
      }

      expect(
        $(LottieSplashScreen),
        findsOneWidget,
      );
    },
  );

  patrolTest(
    'onboarding shows Sign In and Create '
    'Account buttons',
    ($) async {
      await pumpApp($);
      final config = TestConfig.instance;

      if (config.useMock) {
        // Mock mode goes straight to home;
        // onboarding is never shown.
        await $.pump(const Duration(seconds: 1));
        return;
      }

      await $(OnboardScreen).waitUntilVisible();

      expect(
        $(keys.onboardPage.signInButton),
        findsOneWidget,
      );
      expect(
        $(keys.onboardPage.createAccountButton),
        findsOneWidget,
      );
    },
  );

  patrolTest(
    'tapping Sign In navigates to sign in '
    'screen',
    ($) async {
      await pumpApp($);
      final config = TestConfig.instance;

      if (config.useMock) {
        await $.pump(const Duration(seconds: 1));
        return;
      }

      await $(OnboardScreen).waitUntilVisible();
      await $(keys.onboardPage.signInButton).tap();
      await $.pumpAndSettle();

      expect($(SingInScreen), findsOneWidget);
    },
  );

  patrolTest(
    'sign in with valid credentials '
    'navigates to home',
    ($) async {
      await pumpApp($);
      final config = TestConfig.instance;

      if (config.useMock) {
        // In mock mode the app auto-lands on home.
        await $.pump(const Duration(seconds: 1));
        await $(keys.bottomNav.homeTab)
            .waitUntilVisible();
        return;
      }

      await $(SingInScreen).waitUntilVisible();
      await signIn($);

      await $(keys.bottomNav.homeTab)
          .waitUntilVisible();
    },
  );

  patrolTest(
    'sign in with invalid credentials '
    'shows error',
    ($) async {
      await pumpApp($);
      final config = TestConfig.instance;

      if (config.useMock) {
        // Mock mode auto-signs in; skip test.
        await $.pump(const Duration(seconds: 1));
        return;
      }

      await $(SingInScreen).waitUntilVisible();

      await $(keys.signInPage.emailTextField)
          .enterText('wrong@email.com');
      await $(keys.signInPage.passwordTextField)
          .enterText('wrongpassword');
      await $(keys.signInPage.signInButton).tap();
      await $.pumpAndSettle();

      expect($(SnackBar), findsOneWidget);
    },
  );

  patrolTest(
    'tapping Create Account navigates to '
    'email form',
    ($) async {
      await pumpApp($);
      final config = TestConfig.instance;

      if (config.useMock) {
        await $.pump(const Duration(seconds: 1));
        return;
      }

      await $(OnboardScreen).waitUntilVisible();

      await $(keys.onboardPage.createAccountButton)
          .tap();
      await $.pumpAndSettle();

      expect(
        $(keys.emailFormPage.emailTextField),
        findsOneWidget,
      );
    },
  );

  patrolTest(
    'email form submits and navigates to '
    'code confirmation',
    ($) async {
      await pumpApp($);
      final config = TestConfig.instance;

      if (config.useMock) {
        await $.pump(const Duration(seconds: 1));
        return;
      }

      await $(keys.emailFormPage.emailTextField)
          .waitUntilVisible();

      await $(keys.emailFormPage.emailTextField)
          .enterText(config.testEmail);
      await $(keys.emailFormPage.continueButton)
          .tap();
      await $.pumpAndSettle();

      expect(
        $(keys.codeConfirmationPage.pinput),
        findsOneWidget,
      );
    },
  );

  patrolTest(
    'code confirmation submits OTP',
    ($) async {
      await pumpApp($);
      final config = TestConfig.instance;

      if (config.useMock) {
        await $.pump(const Duration(seconds: 1));
        return;
      }

      await $(keys.codeConfirmationPage.pinput)
          .waitUntilVisible();

      await $(keys.codeConfirmationPage.pinput)
          .enterText('12345');
      await $(keys.codeConfirmationPage.submitButton)
          .tap();
      await $.pumpAndSettle();
    },
  );
}
