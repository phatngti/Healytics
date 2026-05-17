import 'package:admin_panel/core/keys/integration_test_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:patrol/patrol.dart';

/// Navigates to a side menu item by tapping its key.
///
/// Uses [pump] instead of [pumpAndSettle] because
/// some pages contain continuous animations that
/// prevent settling.
Future<void> navigateToMenuItem(
  PatrolIntegrationTester $,
  Key menuItemKey,
) async {
  await $(menuItemKey).tap();
  await $.pump(const Duration(seconds: 2));
}

/// Side menu key constants for consistency.
abstract final class MenuItemKeys {
  static final dashboard = keys.sideMenu.dashboardItem;
  static final services = keys.sideMenu.servicesItem;
  static final employee = keys.sideMenu.employeeItem;
  static final serviceTags = keys.sideMenu.serviceTagsItem;
  static final finance = keys.sideMenu.financeItem;
  static final messages = keys.sideMenu.messagesItem;
}
