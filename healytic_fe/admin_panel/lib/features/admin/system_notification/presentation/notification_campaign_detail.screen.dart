import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/layouts/notification_campaign_detail_desktop.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/providers/notification_campaign.provider.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationCampaignDetailScreen extends ConsumerWidget {
  const NotificationCampaignDetailScreen({super.key, required this.campaignId});

  final String campaignId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignAsync = ref.watch(
      notificationCampaignDetailProvider(NotificationCampaignId(campaignId)),
    );

    return campaignAsync.when(
      data: (campaign) => ResponsiveWrapper(
        useLayout: true,
        desktop: NotificationCampaignDetailDesktop(campaign: campaign),
        tablet: NotificationCampaignDetailDesktop(campaign: campaign),
        mobile: NotificationCampaignDetailDesktop(campaign: campaign),
      ),
      loading: () => const ResponsiveWrapper(
        useLayout: true,
        desktop: Center(child: CircularProgressIndicator()),
        tablet: Center(child: CircularProgressIndicator()),
        mobile: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => ResponsiveWrapper(
        useLayout: true,
        desktop: Center(child: Text('Failed to load campaign: $error')),
        tablet: Center(child: Text('Failed to load campaign: $error')),
        mobile: Center(child: Text('Failed to load campaign: $error')),
      ),
    );
  }
}
