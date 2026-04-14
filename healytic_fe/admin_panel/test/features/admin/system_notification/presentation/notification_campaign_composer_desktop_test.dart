import 'package:admin_panel/features/admin/system_notification/datasource/system_notification_impl.repository.dart';
import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/layouts/notification_campaign_composer_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_notification_repository.dart';

void main() {
  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        notificationCampaignRepositoryProvider.overrideWithValue(
          buildTestNotificationRepository(
            capability: const NotificationCapability.real(),
          ),
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(body: NotificationCampaignComposerDesktop()),
      ),
    );
  }

  testWidgets('renders capability-gated composer sections', (tester) async {
    tester.view.physicalSize = const Size(1800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Create Notification Campaign'), findsOneWidget);
    expect(
      find.textContaining('disabled by backend capabilities'),
      findsNWidgets(2),
    );
    expect(
      find.textContaining('whole-platform broadcast delivery'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Scheduling is intentionally visible'),
      findsOneWidget,
    );
    expect(find.text('Send Now'), findsOneWidget);
  });
}
