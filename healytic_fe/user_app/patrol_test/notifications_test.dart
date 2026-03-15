import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/features/notifications/presentation/screens/notifications.screen.dart';

import 'common.dart';
import 'helpers/auth_helper.dart';
import 'helpers/navigation_helper.dart';
import 'helpers/permission_helper.dart';

void main() {
  patrolTest(
    'notifications tab renders page',
    ($) async {
      await pumpApp($);
      await signIn($);
      await handlePermissionIfVisible($);

      await navigateToTab(
        $,
        TabKeys.notifications,
      );

      expect(
        $(NotificationsPage),
        findsOneWidget,
      );
    },
  );

  // TODO: re-enable once NotificationsPage has
  // a ListView with notification items
  // patrolTest(
  //   'tapping a notification navigates to target',
  //   ($) async {
  //     ...
  //   },
  // );

  patrolTest(
    'grants notification permission via '
    'native dialog',
    ($) async {
      await pumpApp($);
      await signIn($);

      await navigateToTab(
        $,
        TabKeys.notifications,
      );

      await grantAllPermissions($);

      expect(
        $(NotificationsPage),
        findsOneWidget,
      );
    },
  );

  // TODO: re-enable once push notifications
  // are implemented
  // patrolTest(
  //   'opens native notification shade and '
  //   'taps notification',
  //   ($) async {
  //     ...
  //   },
  // );
}
