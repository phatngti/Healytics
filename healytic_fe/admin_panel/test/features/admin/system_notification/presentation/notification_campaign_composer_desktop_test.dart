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

  testWidgets('renders simple send-now composer', (tester) async {
    tester.view.physicalSize = const Size(1800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Create System Notification'), findsOneWidget);
    expect(find.text('Message'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
    expect(find.text('Preview'), findsOneWidget);
    expect(find.text('Send Now'), findsOneWidget);
    expect(find.text('Audience'), findsNothing);
    expect(find.text('Channels'), findsNothing);
    expect(find.text('Delivery'), findsNothing);
    expect(find.text('Schedule'), findsNothing);
    expect(find.text('Save Draft'), findsNothing);
  });
}
