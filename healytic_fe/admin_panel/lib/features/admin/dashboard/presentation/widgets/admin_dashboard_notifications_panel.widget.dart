import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_notification.entity.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_badges.widget.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_formatters.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_panel.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class AdminDashboardNotificationsPanel extends StatelessWidget {
  const AdminDashboardNotificationsPanel({super.key, required this.items});

  final List<AdminDashboardNotificationItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return AdminDashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications Summary',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Text(
            'Recent operational notifications and broadcast audit trail.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXl),
          if (items.isEmpty)
            const Text('No notification items available.')
          else
            ...items.map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
                padding: AppDimens.paddingAllMediumSmall,
                decoration: BoxDecoration(
                  color: item.isRead
                      ? colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.28,
                        )
                      : colorScheme.primaryContainer.withValues(alpha: 0.18),
                  borderRadius: AppDimens.radiusMediumSmall,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppDimens.spaceSm,
                      runSpacing: AppDimens.spaceSm,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        notificationPriorityBadge(context, item.priority),
                        Text(
                          formatRelativeTime(item.createdAt),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.spaceSmMd),
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: item.isRead
                            ? FontWeight.w600
                            : FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    Text(item.body, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
