import 'package:admin_panel/features/admin/system_notification/datasource/system_notification_impl.repository.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/layouts/notification_campaign_index_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_notification_repository.dart';

void main() {
  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        notificationCampaignRepositoryProvider.overrideWithValue(
          buildTestNotificationRepository(),
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(body: NotificationCampaignIndexDesktop()),
      ),
    );
  }

  testWidgets('renders campaign index and applies search filter', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('System Notification Control Center'), findsOneWidget);
    expect(find.text('Campaign Activity'), findsOneWidget);

    await tester.enterText(
      find.byType(TextField).first,
      'Partner Operations Refresh',
    );
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Partner Operations Refresh'), findsOneWidget);
    expect(find.text('Golden Week Service Reminder'), findsNothing);
    await tester.pump(const Duration(seconds: 1));
  });
}
