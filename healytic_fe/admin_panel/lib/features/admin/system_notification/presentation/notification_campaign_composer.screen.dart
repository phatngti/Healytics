import 'package:admin_panel/features/admin/system_notification/presentation/layouts/notification_campaign_composer_desktop.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';

class NotificationCampaignComposerScreen extends StatelessWidget {
  const NotificationCampaignComposerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveWrapper(
      useLayout: true,
      desktop: NotificationCampaignComposerDesktop(),
      tablet: NotificationCampaignComposerDesktop(),
      mobile: NotificationCampaignComposerDesktop(),
    );
  }
}
