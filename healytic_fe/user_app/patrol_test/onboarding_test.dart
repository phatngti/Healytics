import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/authenticate/presentation/screens/signin.screen.dart';
import 'package:user_app/features/onboarding/presentation/screens/onboard.screen.dart';

import 'common.dart';
import 'config/test_config.dart';

void main() {
  patrolTest('onboarding entry points navigate correctly', ($) async {
    await pumpApp($);
    final config = TestConfig.instance;

    if (config.useMock) {
      await $(keys.bottomNav.homeTab).waitUntilVisible();
      return;
    }

    await $(OnboardScreen).waitUntilVisible();
    expect($(keys.onboardPage.signInButton), findsOneWidget);
    expect($(keys.onboardPage.createAccountButton), findsOneWidget);

    await $(keys.onboardPage.signInButton).tap();
    await $.pump(const Duration(seconds: 1));
    expect($(SingInScreen), findsOneWidget);
  });
}
