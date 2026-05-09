import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';

import '../config/test_config.dart';

/// Signs in using fixture credentials via key finders.
///
/// In mock mode (ENV=dev) the router auto-redirects to
/// home, so this helper detects that and skips sign-in.
Future<void> signIn(PatrolIntegrationTester $) async {
  final config = TestConfig.instance;

  // In mock mode the user is already "logged in" and
  // the router redirects straight to home.
  if (config.useMock) {
    await $.pump(const Duration(seconds: 2));
    return;
  }

  try {
    // If on OnboardScreen, tap the Sign In button.
    final signInNavBtn = $(keys.onboardPage.signInButton);
    if (await signInNavBtn
        .waitUntilVisible(timeout: const Duration(seconds: 4))
        .then((_) => true)
        .catchError((_) => false)) {
      await signInNavBtn.tap();
      await $.pumpAndSettle();
    }
  } catch (_) {}

  // Wait for the SignInScreen form.
  await $(keys.signInPage.emailTextField).waitUntilVisible();

  await $(keys.signInPage.emailTextField).enterText(config.testEmail);

  await $(keys.signInPage.passwordTextField).enterText(config.testPassword);

  await $(keys.signInPage.signInButton).tap();

  await $.pumpAndSettle();
}
