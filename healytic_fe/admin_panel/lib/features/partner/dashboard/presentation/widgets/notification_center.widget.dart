import 'package:admin_panel/features/partner/dashboard/domain/dashboard_notification.entity.dart';
import 'package:admin_panel/features/partner/dashboard/presentation/widgets/dashboard_panel.widget.dart';
import 'package:admin_panel/features/partner/dashboard/presentation/widgets/dashboard_section_header.widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                padding: const EdgeInsets.only(bottom: 12),
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
    'review' => const Color(0xFFFBBF24),
    'alert' => colorScheme.error,
    'system' => const Color(0xFF0EA5E9),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: notification.isRead
            ? colorScheme.surfaceContainerLowest
            : highlightColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: highlightColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, size: 20, color: highlightColor),
          ),
          const SizedBox(width: 12),
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
                              ? FontWeight.w600
                              : FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _formatTime(notification.createdAt),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notification.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: highlightColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _typeLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: highlightColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (!notification.isRead) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
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
