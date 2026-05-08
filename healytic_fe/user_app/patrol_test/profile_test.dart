import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/features/profile/presentation/screens/edit_profile.screen.dart';
import 'package:user_app/features/profile/presentation/screens/profile.screen.dart';

import 'common.dart';
import 'config/test_config.dart';
import 'helpers/auth_helper.dart';
import 'helpers/navigation_helper.dart';

void main() {
  patrolTest('profile tab renders user information', ($) async {
    await pumpApp($);
    await signIn($);
    await navigateToTab($, TabKeys.profile);

    expect($(ProfilePage), findsOneWidget);
  });

  patrolTest('edit profile screen opens from profile tab', ($) async {
    await pumpApp($);
    await signIn($);
    await navigateToTab($, TabKeys.profile);

    await $('Edit Profile').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));

    expect($(EditProfileScreen), findsOneWidget);
    expect($('FULL NAME'), findsOneWidget);
    expect($('EMAIL ADDRESS'), findsOneWidget);
    expect($('PHONE NUMBER'), findsOneWidget);
    expect($('LOCATION'), findsOneWidget);
  });

  patrolTest('saving mock profile returns to profile page', ($) async {
    await pumpApp($);
    final config = TestConfig.instance;

    if (!config.useMock) {
      await $.pump(const Duration(seconds: 1));
      return;
    }

    await signIn($);
    await navigateToTab($, TabKeys.profile);

    await $('Mock User').waitUntilVisible();
    await $('Edit Profile').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));

    await $('Done').tap();
    await $.pump(const Duration(seconds: 2));

    expect($(ProfilePage), findsOneWidget);
  });
}
