import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_ui_helpers.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Horizontal row of metric cards showing campaign stats.
class NotificationStatsRow extends StatelessWidget {
  const NotificationStatsRow({super.key, required this.stats});

  final NotificationStats stats;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          NotificationMetricCard(
            label: 'Sent Today',
            value: '${stats.sentToday}',
            caption: 'Messages already broadcast today',
            icon: Icons.send_rounded,
          ),
          AppDimens.horizontalMedium,
          NotificationMetricCard(
            label: 'Scheduled',
            value: '${stats.scheduled}',
            caption: 'Queued campaigns awaiting delivery',
            icon: Icons.schedule_rounded,
          ),
          AppDimens.horizontalMedium,
          NotificationMetricCard(
            label: 'Drafts',
            value: '${stats.drafts}',
            caption: 'Work in progress across the admin team',
            icon: Icons.drafts_outlined,
          ),
          AppDimens.horizontalMedium,
          NotificationMetricCard(
            label: 'Active Segments',
            value: '${stats.activeSegments}',
            caption: 'Audience groups available in the workspace',
            icon: Icons.people_alt_outlined,
          ),
        ],
      ),
    );
  }
}
