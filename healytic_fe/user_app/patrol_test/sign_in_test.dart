// Patrol smoke tests for the Google Sign-In entry point on
// `SingInScreen` (Task 7.8 in `.kiro/specs/google-signin/tasks.md`).
//
// Scope and known limitations
// ---------------------------
// Patrol drives a real, compiled app on a device or emulator. There is no
// in-test seam for overriding Riverpod providers because the app boots via
// the production `main()` path before the test body runs. That means a
// "stub `GoogleSignInService`" cannot be injected from this file alone.
// Properly stubbing the service requires one of the following follow-ups,
// neither of which is in scope for this task:
//
//   1. A test-only build flavor (e.g. `--dart-define=USE_FAKE_GOOGLE=true`)
//      that registers a fake `GoogleSignInService` in `bootstrap.dart`.
//   2. An override hook exposed by `bootstrap.dart` that the Patrol test
//      can flip before `pumpApp($)` runs (e.g. via a top-level
//      `Bootstrap.testOverrides` list passed into `ProviderScope`).
//
// Until one of those lands, this file delivers the minimal, deterministic
// smoke check Patrol can actually run on a device:
//
//   - Verify the "Continue with Google" button (`keys.signInPage.googleButton`)
//     is rendered on `SingInScreen` and is tappable.
//   - Tap the button to ensure no immediate widget-tree crash on press.
//     We deliberately do NOT assert navigation to `/home` (returning user)
//     or `/finish_google_sign_up` (first-time user): those branches depend
//     on a successful Google ID token exchange, which requires the native
//     Google account picker. Patrol cannot drive that picker through the
//     Flutter widget tree, so any further assertion would be flaky on real
//     devices.
//
// Mock mode (`config.useMock == true`) skips the assertions entirely — the
// app auto-lands on the home shell and never shows `SingInScreen`, matching
// the existing `onboarding_test.dart` convention.
//
// Deferred work
// -------------
// Once a `GoogleSignInService` override hook exists in `bootstrap.dart`,
// extend this file with two scenarios:
//   - Returning user (JWT carries `profileCompleted: true`): expect the
//     bottom nav (`keys.bottomNav.homeTab`) to become visible.
//   - First-time user (JWT carries `profileCompleted: false`): expect
//     `FinishGoogleSignUpScreen` to be the visible route.
// Both will require a fake `AuthenticateRemoteDatasource` (or a backdoor
// HTTP route) returning canned tokens with the chosen claim.

import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/authenticate/presentation/screens/signin.screen.dart';
import 'package:user_app/features/onboarding/presentation/screens/onboard.screen.dart';

import 'common.dart';
import 'config/test_config.dart';

void main() {
  patrolTest('sign in screen renders Google button', ($) async {
    await pumpApp($);
    final config = TestConfig.instance;

    if (config.useMock) {
      // Mock mode auto-lands on home; SingInScreen
      // never renders. Nothing to assert here.
      await $.pump(const Duration(seconds: 1));
      return;
    }

    // Navigate from onboarding to the sign-in screen.
    await $(OnboardScreen).waitUntilVisible();
    await $(keys.onboardPage.signInButton).tap();
    await $.pump(const Duration(seconds: 1));

    await $(SingInScreen).waitUntilVisible();

    expect($(keys.signInPage.googleButton), findsOneWidget);
  });

  patrolTest('tapping Google sign in button does not '
      'crash the sign in screen', ($) async {
    await pumpApp($);
    final config = TestConfig.instance;

    if (config.useMock) {
      // Mock mode skips this flow entirely — see
      // file header.
      await $.pump(const Duration(seconds: 1));
      return;
    }

    await $(OnboardScreen).waitUntilVisible();
    await $(keys.onboardPage.signInButton).tap();
    await $.pump(const Duration(seconds: 1));

    await $(SingInScreen).waitUntilVisible();

    // Tap the Google button. On a real device this
    // hands off to the native Google account picker
    // which Patrol cannot drive, so we only assert
    // that the Flutter side did not crash and we are
    // still on SingInScreen (the picker overlays
    // the existing route rather than replacing it).
    await $(keys.signInPage.googleButton).tap();
    await $.pump(const Duration(seconds: 1));

    expect($(SingInScreen), findsOneWidget);
  });
}
