import 'package:admin_panel/features/admin/system_notification/datasource/data/system_notification_mock_data.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/layouts/notification_campaign_detail_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders detail metadata and audit trail', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NotificationCampaignDetailDesktop(
            campaign: mockNotificationCampaigns.first,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Campaign Metadata'), findsOneWidget);
    expect(find.text('Rendered Content'), findsOneWidget);
    expect(find.text('Audit Trail'), findsOneWidget);
    expect(
      find.text(mockNotificationCampaigns.first.campaignName),
      findsWidgets,
    );
  });
}
