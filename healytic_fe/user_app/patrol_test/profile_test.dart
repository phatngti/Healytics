import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/features/profile/presentation/screens/profile.screen.dart';

import 'common.dart';
import 'helpers/auth_helper.dart';
import 'helpers/navigation_helper.dart';

void main() {
  patrolTest(
    'profile tab renders user information',
    ($) async {
      await pumpApp($);
      await signIn($);
      await navigateToTab($, TabKeys.profile);

      expect($(ProfilePage), findsOneWidget);
    },
  );

  // TODO: re-enable once ProfilePage has edit UI
  // patrolTest(
  //   'editing profile updates user info',
  //   ($) async {
  //     await pumpApp($);
  //     await signIn($);
  //     await navigateToTab($, TabKeys.profile);
  //
  //     await $(keys.profilePage.editButton)
  //         .scrollTo()
  //         .tap();
  //     ...
  //   },
  // );
}
