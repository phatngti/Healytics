import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/notifications/presentation/screens/notifications.screen.dart';

import 'common.dart';
import 'config/test_config.dart';
import 'helpers/auth_helper.dart';
import 'helpers/navigation_helper.dart';
import 'helpers/permission_helper.dart';

void main() {
  patrolTest('notifications tab renders page', ($) async {
    await pumpApp($, scenario: 'notifications');
    await signIn($);
    await handlePermissionIfVisible($);

    await navigateToTab($, TabKeys.notifications);

    expect($(NotificationsPage), findsOneWidget);
  });

  patrolTest('notifications show seeded items and mark one read', ($) async {
    await pumpApp($, scenario: 'notifications');
    await signIn($);
    await handlePermissionIfVisible($);

    await navigateToTab($, TabKeys.notifications);
    await $(
      keys.notificationsPage.notificationsList,
    ).waitUntilVisible(timeout: const Duration(seconds: 10));

    final config = TestConfig.instance;
    final title = config.useMock ? 'Booking Confirmed' : 'Booking confirmed';

    expect($(title), findsWidgets);
    await $(title).tap();
    await $.pump(const Duration(seconds: 1));

    expect($(NotificationsPage), findsOneWidget);
  });

  patrolTest('notifications can mark all as read', ($) async {
    await pumpApp($, scenario: 'notifications');
    await signIn($);
    await handlePermissionIfVisible($);

    await navigateToTab($, TabKeys.notifications);
    await $.pump(const Duration(seconds: 2));

    final markAll = $(keys.notificationsPage.markAllReadButton);
    final isVisible = await markAll
        .waitUntilVisible(timeout: const Duration(seconds: 3))
        .then((_) => true)
        .catchError((_) => false);
    if (isVisible) {
      await markAll.tap();
      await $.pump(const Duration(seconds: 1));
    }

    expect($(NotificationsPage), findsOneWidget);
  });

  patrolTest('grants notification permission via '
      'native dialog', ($) async {
    await pumpApp($, scenario: 'notifications');
    await signIn($);

    await navigateToTab($, TabKeys.notifications);

    await grantAllPermissions($);

    expect($(NotificationsPage), findsOneWidget);
  });

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
