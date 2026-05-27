import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';

import '../config/test_config.dart';
import 'navigation_helper.dart';
import 'permission_helper.dart';

/// Signs out by navigating to the Profile tab,
/// tapping the Log Out button, and confirming.
///
/// Safe to call even when already signed out —
/// returns early if the bottom nav is not visible.
Future<void> signOut(PatrolIntegrationTester $) async {
  // If bottomNav is not present, we're already
  // logged out — nothing to do.
  final isLoggedIn = await $(keys.bottomNav.profileTab)
      .waitUntilVisible(timeout: const Duration(seconds: 5))
      .then((_) => true)
      .catchError((_) => false);

  if (!isLoggedIn) return;

  await navigateToTab($, TabKeys.profile);

  // Scroll to the logout button in case it's
  // below the fold.
  await $(keys.profilePage.logoutButton).scrollTo();
  await $(keys.profilePage.logoutButton).tap();

  // Confirm in the dialog.
  await $(keys.logoutDialog.confirmButton).waitUntilVisible().tap();

  // Wait for the router to redirect to onboarding.
  // Use a generous pump to ensure the session is
  // cleared and the redirect completes fully before
  // the sign-in flow begins.
  await $.pump(const Duration(seconds: 5));
  await grantAllPermissions($);
}

/// Signs in using fixture credentials via key finders.
///
/// Calls [signOut] first to ensure a clean session,
/// then proceeds through the onboarding → sign-in flow.
Future<void> signIn(
  PatrolIntegrationTester $, {
  String? email,
  String? password,
}) async {
  final config = TestConfig.instance;

  // In mock mode the user is already "logged in" and
  // the router redirects straight to home.
  if (config.useMock) {
    await $.pump(const Duration(seconds: 2));
    await grantAllPermissions($);
    return;
  }

  // Always start from a clean session.
  await signOut($);

  try {
    // If on OnboardScreen, tap the Sign In button.
    final signInNavBtn = $(keys.onboardPage.signInButton);
    if (await signInNavBtn
        .waitUntilVisible(timeout: const Duration(seconds: 8))
        .then((_) => true)
        .catchError((_) => false)) {
      await signInNavBtn.tap();
      await $.pump(const Duration(seconds: 1));
    }
  } catch (_) {}

  // Wait for the SignInScreen form.
  await $(keys.signInPage.emailTextField).waitUntilVisible();

  await $(keys.signInPage.emailTextField).enterText(email ?? config.testEmail);

  await $(
    keys.signInPage.passwordTextField,
  ).enterText(password ?? config.testPassword);

  await $(keys.signInPage.signInButton).tap();

  await $.pump(const Duration(seconds: 1));
  await grantAllPermissions($);
  await $.pump(const Duration(seconds: 2));
}
