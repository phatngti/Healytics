import 'package:admin_panel/router/admin_routes.dart';
import 'package:admin_panel/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('notifications menu item points to admin notification route', () {
    final notificationsItem = adminSlideMenuItems.firstWhere(
      (item) => item['label'] == 'Notifications',
    );

    expect(
      notificationsItem['route'],
      const AdminNotificationCampaignIndexRoute().location,
    );
    expect(
      const AdminNotificationCampaignIndexRoute().location,
      '/admin/notifications',
    );
  });
}
