import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Horizontal chip row for filtering by campaign status.
class NotificationStatusTabs extends StatelessWidget {
  const NotificationStatusTabs({
    super.key,
    required this.activeStatus,
    required this.onChanged,
  });

  final NotificationCampaignStatus? activeStatus;
  final ValueChanged<NotificationCampaignStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    final statuses = <NotificationCampaignStatus?>[
      null,
      ...NotificationCampaignStatus.values,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: statuses.map((status) {
          final isSelected = activeStatus == status;
          return Padding(
            padding: EdgeInsets.only(right: AppDimens.spaceSmMd),
            child: ChoiceChip(
              label: Text(status?.label ?? 'All'),
              selected: isSelected,
              onSelected: (_) => onChanged(status),
            ),
          );
        }).toList(),
      ),
    );
  }
}
