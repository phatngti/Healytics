import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/features/notifications/'
    'domain/entities/notification.entity.dart';

/// A single notification card that derives its
/// visual presentation (icon, colours, action label)
/// from the pure [NotificationEntity.type].
///
/// Tap gesture triggers the [onTap] callback for
/// mark-read + deep-link navigation.
class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  final NotificationEntity notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardPad = AppDimens.cardPadding(context);
    final cardRad = AppDimens.cardRadius(context);
    final isRead = notification.isRead;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: isRead ? 0.7 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: EdgeInsets.all(cardPad),
          decoration: BoxDecoration(
            color: isRead
                ? colorScheme.surfaceContainerLow
                : colorScheme.surface,
            borderRadius:
                BorderRadius.circular(cardRad),
            border: isRead
                ? null
                : Border.all(
                    color: colorScheme.primary
                        .withValues(alpha: 0.08),
                  ),
            boxShadow: isRead
                ? null
                : [
                    BoxShadow(
                      color: colorScheme.shadow
                          .withValues(alpha: 0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _IconContainer(
                type: notification.type,
                isBroadcast: notification.isBroadcast,
              ),
              SizedBox(width: AppDimens.spaceLg),
              Expanded(
                child: _CardContent(
                  notification: notification,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Icon Container ─────────────────────────────────

class _IconContainer extends StatelessWidget {
  const _IconContainer({
    required this.type,
    required this.isBroadcast,
  });

  final NotificationType type;
  final bool isBroadcast;

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;
    final iconColor = _resolveIconColor(
      type,
      colorScheme,
    );
    final bgColor = iconColor.withValues(alpha: 0.12);

    return Container(
      width: AppDimens.avatarLg,
      height: AppDimens.avatarLg,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppDimens.radiusMedium,
      ),
      child: Icon(
        _resolveIcon(type),
        color: iconColor,
        size: AppDimens.iconLg,
      ),
    );
  }

  IconData _resolveIcon(NotificationType type) {
    return switch (type) {
      NotificationType.bookingConfirmed =>
        Symbols.event_available,
      NotificationType.bookingCancelled =>
        Symbols.event_busy,
      NotificationType.bookingCompleted =>
        Symbols.check_circle,
      NotificationType.appointmentReminder =>
        Symbols.alarm,
      NotificationType.appointmentUpdated =>
        Symbols.edit_calendar,
      NotificationType.newChatMessage =>
        Symbols.chat_bubble,
      NotificationType.paymentSuccess =>
        Symbols.payments,
      NotificationType.paymentFailed =>
        Symbols.credit_card_off,
      NotificationType.systemBroadcast =>
        Symbols.campaign,
      NotificationType.systemMaintenance =>
        Symbols.engineering,
      NotificationType.partnerVerified =>
        Symbols.verified,
      NotificationType.partnerRejected =>
        Symbols.block,
    };
  }

  Color _resolveIconColor(
    NotificationType type,
    ColorScheme cs,
  ) {
    return switch (type) {
      NotificationType.bookingConfirmed ||
      NotificationType.bookingCompleted ||
      NotificationType.paymentSuccess ||
      NotificationType.partnerVerified =>
        const Color(0xFF2E7D32), // green
      NotificationType.bookingCancelled ||
      NotificationType.paymentFailed ||
      NotificationType.partnerRejected =>
        cs.error,
      NotificationType.appointmentReminder ||
      NotificationType.appointmentUpdated =>
        const Color(0xFFF57C00), // orange
      NotificationType.newChatMessage =>
        cs.primary,
      NotificationType.systemBroadcast ||
      NotificationType.systemMaintenance =>
        cs.tertiary,
    };
  }
}

// ─── Card Content ───────────────────────────────────

class _CardContent extends StatelessWidget {
  const _CardContent({
    required this.notification,
  });

  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row with time
        Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(
                  fontWeight: notification.isRead
                      ? FontWeight.w500
                      : FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: AppDimens.spaceSm),
            // Unread dot
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        SizedBox(height: AppDimens.spaceXs),
        // Body text
        Text(
          notification.body,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: AppDimens.spaceSm),
        // Time + broadcast badge
        Row(
          children: [
            Text(
              _formatTimeAgo(notification.createdAt),
              style: theme.textTheme.labelSmall
                  ?.copyWith(
                color: colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
            if (notification.isBroadcast) ...[
              SizedBox(width: AppDimens.spaceSm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius:
                      AppDimens.radiusExtraSmall,
                ),
                child: Text(
                  'Broadcast',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color:
                        colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// Formats a DateTime into a human-readable
  /// relative time string.
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    // Fallback: date
    return '${dateTime.day}/${dateTime.month}';
  }
}
