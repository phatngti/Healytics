import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/avatar.dart';
import 'package:user_app/features/notifications/'
    'domain/entities/notification.entity.dart';

/// A single notification card, adapting its layout
/// based on [NotificationType] (user interaction vs
/// system alert).
///
/// Matches the card design in the HTML reference:
/// rounded-xl, subtle shadow, left icon/avatar,
/// time badge top-right, action button bottom.
class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
  });

  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardPad = AppDimens.cardPadding(context);
    final cardRad = AppDimens.cardRadius(context);
    final isRead = notification.isRead;

    return Opacity(
      opacity: isRead ? 0.8 : 1.0,
      child: Container(
        padding: EdgeInsets.all(cardPad),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius:
              BorderRadius.circular(cardRad),
          boxShadow: [
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
            _LeadingVisual(
              notification: notification,
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
    );
  }
}

// ─── Leading Visual (Avatar or Icon) ────────────

class _LeadingVisual extends StatelessWidget {
  const _LeadingVisual({
    required this.notification,
  });

  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    if (notification.type ==
        NotificationType.userInteraction) {
      return AvatarImage(
        name: notification.title,
        imageUrl: notification.avatarUrl,
        radius: 28,
      );
    }
    return _SystemIcon(icon: notification.icon);
  }
}

// ─── System Icon Container ──────────────────────

class _SystemIcon extends StatelessWidget {
  const _SystemIcon({this.icon});

  final NotificationIcon? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: AppDimens.avatarLg,
      height: AppDimens.avatarLg,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: AppDimens.radiusMedium,
      ),
      child: Icon(
        _resolveIcon(icon),
        color: colorScheme.primary,
        size: AppDimens.iconLg,
      ),
    );
  }

  IconData _resolveIcon(NotificationIcon? icon) {
    return switch (icon) {
      NotificationIcon.shipping =>
        Symbols.local_shipping,
      NotificationIcon.gift =>
        Symbols.featured_seasonal_and_gifts,
      NotificationIcon.shield => Symbols.shield,
      NotificationIcon.info => Symbols.info,
      null => Symbols.notifications,
    };
  }
}

// ─── Card Content (Title, Body, Action) ─────────

class _CardContent extends StatelessWidget {
  const _CardContent({
    required this.notification,
  });

  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleRow(notification: notification),
        SizedBox(height: AppDimens.spaceXs),
        _BodyText(notification: notification),
        if (notification.quote != null) ...[
          SizedBox(height: AppDimens.spaceXs),
          Text(
            '"${notification.quote}"',
            style: theme.textTheme.bodySmall
                ?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme
                  .colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        SizedBox(height: AppDimens.spaceLg),
        _ActionButton(
          label: notification.actionLabel,
          style: notification.actionStyle,
        ),
      ],
    );
  }
}

// ─── Title Row with Time Badge ──────────────────

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.notification});

  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = notification.type ==
        NotificationType.userInteraction;

    return Stack(
      children: [
        if (isUser)
          _UserTitle(notification: notification)
        else
          Text(
            notification.title,
            style:
                theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        Positioned(
          top: 0,
          right: 0,
          child: Text(
            notification.timeAgo,
            style:
                theme.textTheme.labelSmall?.copyWith(
              color: theme
                  .colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── User Interaction Title ─────────────────────

class _UserTitle extends StatelessWidget {
  const _UserTitle({required this.notification});

  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 60),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: notification.title,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(
                fontWeight: FontWeight.bold,
                color:
                    theme.colorScheme.onSurface,
              ),
            ),
            TextSpan(
              text: ' ${notification.body}',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(
                color:
                    theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ─── Body Text ──────────────────────────────────

class _BodyText extends StatelessWidget {
  const _BodyText({required this.notification});

  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    // User interaction body is rendered inline
    // with _UserTitle, so only render for system
    // alerts here.
    if (notification.type ==
        NotificationType.userInteraction) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Text(
      notification.body,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.5,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}

// ─── Action Button ──────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.style,
  });

  final String label;
  final NotificationActionStyle style;

  @override
  Widget build(BuildContext context) {
    return switch (style) {
      NotificationActionStyle.filled =>
        _FilledAction(label: label),
      NotificationActionStyle.tonal =>
        _TonalAction(label: label),
      NotificationActionStyle.outlined =>
        _OutlinedAction(label: label),
      NotificationActionStyle.text =>
        _TextAction(label: label),
    };
  }
}

// ─── Filled (Gradient Primary) ──────────────────

class _FilledAction extends StatelessWidget {
  const _FilledAction({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceXl,
        vertical: AppDimens.spaceSm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary
                .withValues(alpha: 0.85),
          ],
        ),
        borderRadius: AppDimens.radiusPill,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary
                .withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}

// ─── Tonal (Secondary Container) ────────────────

class _TonalAction extends StatelessWidget {
  const _TonalAction({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceLg,
        vertical: AppDimens.spaceSm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: AppDimens.radiusPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.reply,
            size: AppDimens.iconSmMd,
            color: colorScheme.primary,
          ),
          SizedBox(width: AppDimens.spaceSm),
          Text(
            label,
            style: theme.textTheme.labelMedium
                ?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Outlined ───────────────────────────────────

class _OutlinedAction extends StatelessWidget {
  const _OutlinedAction({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceXl,
        vertical: AppDimens.spaceSm,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.outlineVariant
              .withValues(alpha: 0.3),
        ),
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium
            ?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}

// ─── Text with Arrow ────────────────────────────

class _TextAction extends StatelessWidget {
  const _TextAction({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style:
              theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        SizedBox(width: AppDimens.spaceXs),
        Icon(
          Symbols.arrow_forward,
          size: AppDimens.iconSm,
          color: colorScheme.primary,
        ),
      ],
    );
  }
}
