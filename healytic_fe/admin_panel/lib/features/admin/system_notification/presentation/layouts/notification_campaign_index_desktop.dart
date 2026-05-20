import 'package:admin_panel/features/admin/system_notification/presentation/providers/notification_campaign.provider.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_campaign_table.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_filter_bar.widget.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_index_header.widget.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_stats_row.widget.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_status_tabs.widget.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Desktop layout for the notification campaign index.
///
/// Composes extracted widget components into the full
/// page layout without inline widget definitions.
class NotificationCampaignIndexDesktop extends ConsumerWidget {
  const NotificationCampaignIndexDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(notificationCampaignStatsProvider);
    final state = ref.watch(notificationCampaignIndexProvider);
    final notifier = ref.read(notificationCampaignIndexProvider.notifier);

    return SingleChildScrollView(
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NotificationIndexHeader(),
            AppDimens.verticalLarge,
            statsAsync.when(
              data: (stats) => NotificationStatsRow(stats: stats),
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('Failed to load stats: $error'),
            ),
            AppDimens.verticalLarge,
            NotificationStatusTabs(
              activeStatus: state.activeStatus,
              onChanged: notifier.setActiveStatus,
            ),
            AppDimens.verticalMedium,
            NotificationFilterBar(
              state: state,
              onSearchChanged: notifier.setSearchQuery,
              onChannelChanged: notifier.setChannelFilter,
              onAudienceChanged: notifier.setAudiencePreset,
              onCreatedByChanged: notifier.setCreatedBy,
              onStartDateChanged: notifier.setStartDate,
              onEndDateChanged: notifier.setEndDate,
              onReset: notifier.resetFilters,
            ),
            AppDimens.verticalLarge,
            Text(
              'Campaign Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: AppDimens.fontWeightBold,
              ),
            ),
            AppDimens.verticalSmall,
            Text(
              'Review sent history, scheduled work, and '
              'delivery state across system notifications.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppDimens.verticalMedium,
            NotificationCampaignTable(
              height: DeviceUtils.getScreenHeight(context) * 0.68,
            ),
          ],
        ),
      ),
    );
  }
}
