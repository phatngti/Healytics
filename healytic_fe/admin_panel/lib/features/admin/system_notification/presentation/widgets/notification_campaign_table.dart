import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/providers/notification_campaign.provider.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_ui_helpers.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/table/helper.dart';
import 'package:common/widgets/table/table.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Paginated data table for notification campaigns.
class NotificationCampaignTable extends ConsumerWidget {
  const NotificationCampaignTable({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reloadToken = ref.watch(
      notificationCampaignIndexProvider.select((state) => state.reloadToken),
    );

    return SizedBox(
      height: height,
      child: AppTable(
        key: ValueKey('notification-campaign-table-$reloadToken'),
        columns: const TableColumns(
          columns: [
            TableColumnData(label: 'Campaign', size: ColumnSize.L),
            TableColumnData(label: 'Channel', size: ColumnSize.S),
            TableColumnData(label: 'Audience', size: ColumnSize.M),
            TableColumnData(label: 'Status', size: ColumnSize.S),
            TableColumnData(label: 'Scheduled / Sent', size: ColumnSize.M),
            TableColumnData(label: 'Updated', size: ColumnSize.M),
            TableColumnData(label: 'Actions', size: ColumnSize.S),
          ],
        ).dataColumns(context),
        getTotalRows: () =>
            ref.read(notificationCampaignIndexProvider.notifier).getTotalRows(),
        getData: (setRowSelection, startingAt, count) async {
          final campaigns = await ref
              .read(notificationCampaignIndexProvider.notifier)
              .getCampaigns(startingAt: startingAt, count: count);
          return campaigns.map((campaign) {
            return DataRow(
              key: ValueKey(campaign.id.value),
              onSelectChanged: (selected) {
                if (selected != null) {
                  setRowSelection(ValueKey(campaign.id.value), selected);
                }
              },
              cells: [
                DataCell(_CampaignNameCell(campaign: campaign)),
                DataCell(_ChannelPillsCell(campaign: campaign)),
                DataCell(
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: Text(
                      campaign.audience.presetLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(NotificationStatusBadge(status: campaign.status)),
                DataCell(
                  Text(
                    formatNotificationDateTime(
                      campaign.sentAt ??
                          campaign.schedule.scheduledAt ??
                          campaign.updatedAt,
                    ),
                  ),
                ),
                DataCell(Text(formatNotificationDateTime(campaign.updatedAt))),
                DataCell(
                  PopupMenuButton<String>(
                    tooltip: 'Campaign actions',
                    onSelected: (value) {
                      if (value == 'view') {
                        context.goNamed(
                          AdminNotificationCampaignDetailRoute.name,
                          pathParameters: {'id': campaign.id.value},
                        );
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'view', child: Text('View details')),
                    ],
                  ),
                ),
              ],
            );
          }).toList();
        },
        defaultRowsPerPage: 10,
      ),
    );
  }
}

/// Campaign name + subtitle cell.
class _CampaignNameCell extends StatelessWidget {
  const _CampaignNameCell({required this.campaign});

  final NotificationCampaign campaign;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          campaign.campaignName,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: AppDimens.fontWeightBold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: AppDimens.spaceXxs),
        Text(
          campaign.content.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Channel pill badges for a table row.
class _ChannelPillsCell extends StatelessWidget {
  const _ChannelPillsCell({required this.campaign});

  final NotificationCampaign campaign;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimens.spaceXs,
      runSpacing: AppDimens.spaceXs,
      children: campaign.channels
          .map((channel) => _Pill(label: channel.label))
          .toList(),
    );
  }
}

/// Small pill badge for channel names.
class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSmMd,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: AppDimens.fontWeightSemiBold,
        ),
      ),
    );
  }
}
