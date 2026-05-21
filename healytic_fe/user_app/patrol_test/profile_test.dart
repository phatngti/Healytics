import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/features/profile/presentation/screens/edit_profile.screen.dart';
import 'package:user_app/features/profile/presentation/screens/profile.screen.dart';

import 'common.dart';
import 'config/test_config.dart';
import 'helpers/auth_helper.dart';
import 'helpers/navigation_helper.dart';

void main() {
  patrolTest('profile tab and edit profile flow render correctly', ($) async {
    await pumpApp($);
    await signIn($);
    await navigateToTab($, TabKeys.profile);

    expect($(ProfilePage), findsOneWidget);

    await $('Edit Profile').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));

    expect($(EditProfileScreen), findsOneWidget);
    expect($('FULL NAME'), findsOneWidget);
    expect($('EMAIL ADDRESS'), findsOneWidget);
    expect($('PHONE NUMBER'), findsOneWidget);
    expect($('LOCATION'), findsOneWidget);

    final config = TestConfig.instance;
    if (config.useMock) {
      await $('Done').tap();
      await $.pump(const Duration(seconds: 2));
      expect($(ProfilePage), findsOneWidget);
    }
  });
}
