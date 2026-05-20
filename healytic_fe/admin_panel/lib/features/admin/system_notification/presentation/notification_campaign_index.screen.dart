import 'package:admin_panel/features/admin/system_notification/presentation/layouts/notification_campaign_index_desktop.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';

class NotificationCampaignIndexScreen extends StatelessWidget {
  const NotificationCampaignIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveWrapper(
      useLayout: true,
      desktop: NotificationCampaignIndexDesktop(),
      tablet: NotificationCampaignIndexDesktop(),
      mobile: NotificationCampaignIndexDesktop(),
    );
  }
}
