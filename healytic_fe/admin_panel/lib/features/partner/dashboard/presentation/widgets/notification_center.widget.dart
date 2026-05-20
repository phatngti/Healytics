import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/dashboard_notification.entity.dart';
import 'dashboard_constants.dart';
import 'dashboard_panel.widget.dart';
import 'dashboard_section_header.widget.dart';

/// Notification center panel for the dashboard.
class NotificationCenterWidget extends StatelessWidget {
  const NotificationCenterWidget({super.key, required this.notifications});

  final List<DashboardNotification> notifications;

  @override
  Widget build(BuildContext context) {
    return DashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardSectionHeader(
            title: 'Notifications',
            icon: Icons.notifications_rounded,
            actionLabel: 'Mark All Read',
            onAction: () {},
          ),
          if (notifications.isEmpty)
            const _NotificationEmptyState()
          else
            ...notifications.map(
              (n) => Padding(
                padding: AppDimens.spaceMd.paddingBottom,
                child: _NotificationItem(notification: n),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({required this.notification});

  final DashboardNotification notification;

  IconData get _icon => switch (notification.type) {
    'appointment' => Icons.calendar_today_rounded,
    'review' => Icons.star_rounded,
    'alert' => Icons.warning_rounded,
    'system' => Icons.info_rounded,
    _ => Icons.circle_notifications_rounded,
  };

  Color _iconColor(ColorScheme colorScheme) => switch (notification.type) {
    'appointment' => colorScheme.primary,
    'review' => DashboardColors.starRating,
    'alert' => colorScheme.error,
    'system' => DashboardColors.infoBlue,
    _ => colorScheme.onSurfaceVariant,
  };

  String get _typeLabel => switch (notification.type) {
    'appointment' => 'Appointment',
    'review' => 'Review',
    'alert' => 'Alert',
    'system' => 'System',
    _ => 'Update',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final highlightColor = _iconColor(colorScheme);
    final borderColor = notification.isRead
        ? colorScheme.outlineVariant.withValues(alpha: 0.45)
        : highlightColor.withValues(alpha: 0.30);

    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMdLg),
      decoration: BoxDecoration(
        color: notification.isRead
            ? colorScheme.surfaceContainerLowest
            : highlightColor.withValues(alpha: 0.06),
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: DashboardSizes.iconContainer,
            height: DashboardSizes.iconContainer,
            decoration: BoxDecoration(
              color: highlightColor.withValues(alpha: 0.12),
              borderRadius: AppDimens.radiusMediumSmall,
            ),
            child: Icon(_icon, size: AppDimens.iconMd, color: highlightColor),
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: notification.isRead
                              ? AppDimens.fontWeightSemiBold
                              : AppDimens.fontWeightBold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppDimens.horizontalMediumSmall,
                    Text(
                      _formatTime(notification.createdAt),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                AppDimens.verticalSmall,
                Text(
                  notification.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                AppDimens.spaceSmMd.verticalSpace,
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceSmMd,
                        vertical: AppDimens.spaceXs + 1,
                      ),
                      decoration: BoxDecoration(
                        color: highlightColor.withValues(alpha: 0.12),
                        borderRadius: AppDimens.radiusPill,
                      ),
                      child: Text(
                        _typeLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: highlightColor,
                          fontWeight: AppDimens.fontWeightBold,
                        ),
                      ),
                    ),
                    if (!notification.isRead) ...[
                      AppDimens.horizontalSmall,
                      Container(
                        width: DashboardSizes.unreadDotSize,
                        height: DashboardSizes.unreadDotSize,
                        decoration: BoxDecoration(
                          color: highlightColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    return DateFormat('MMM d').format(dt);
  }
}

class _NotificationEmptyState extends StatelessWidget {
  const _NotificationEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: AppDimens.paddingAllMediumLarge,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Text(
        'No new notifications right now.',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
