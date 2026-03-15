import 'package:flutter/foundation.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';

/// Navigates to a bottom tab by tapping its key.
///
/// Uses [pump] instead of [pumpAndSettle] because some
/// pages contain continuous animations (e.g. loading
/// indicators) that prevent settling.
Future<void> navigateToTab(
  PatrolIntegrationTester $,
  Key tabKey,
) async {
  await $(tabKey).tap();
  await $.pump(const Duration(seconds: 2));
}

/// Tab key constants for consistency.
abstract final class TabKeys {
  static final home = keys.bottomNav.homeTab;
  static final orders = keys.bottomNav.ordersTab;
  static final chat = keys.bottomNav.chatTab;
  static final notifications =
      keys.bottomNav.notificationsTab;
  static final profile = keys.bottomNav.profileTab;
}
