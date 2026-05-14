import 'package:admin_panel/features/admin/dashboard/presentation/admin_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'common.dart';
import 'config/test_config.dart';
import 'helpers/auth_helper.dart';

void main() {
  patrolTest('dashboard renders after admin sign in', ($) async {
    await pumpApp($);
    await signIn($, role: 'admin');

    final config = TestConfig.instance;

    expect($(AdminDashboardScreen), findsOneWidget);
    expect($(find.textContaining(config.dashboardExpectedTitle)), findsWidgets);
  });

  patrolTest('side menu contains expected items', ($) async {
    await pumpApp($);
    await signIn($, role: 'admin');

    // Admin side menu items.
    expect($('Dashboard'), findsWidgets);
    expect($('Finance'), findsWidgets);
    expect($('Category'), findsWidgets);
    expect($('Provider'), findsWidgets);
  });

  patrolTest('web: resize window to test responsive', ($) async {
    await pumpApp($);
    await signIn($, role: 'admin');

    // Use Patrol web action to resize.
    await $.platform.web.resizeWindow(size: const Size(1920, 1080));
    await $.pump(const Duration(seconds: 1));

    expect($(AdminDashboardScreen), findsOneWidget);

    // Resize to smaller viewport.
    await $.platform.web.resizeWindow(size: const Size(768, 1024));
    await $.pump(const Duration(seconds: 1));
  });
}
