import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/notifications/'
    'domain/entities/notification.entity.dart';

/// A premium in-app toast card shown when a real-time
/// notification arrives.
///
/// Features:
/// - Glassmorphism backdrop blur
/// - Type-coloured left accent bar
/// - Title (1 line) + body (2 lines) + relative time
/// - Tap → callback for navigation
/// - Swipe up → dismiss
///
/// This widget is stateless; animation is driven by
/// the parent overlay entry via [AnimationController].
class NotificationToast extends StatelessWidget {
  const NotificationToast({
    super.key,
    required this.title,
    required this.body,
    required this.type,
    this.onTap,
    this.onDismiss,
  });

  final String title;
  final String body;
  final NotificationType type;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor =
        _resolveAccentColor(type, colorScheme);
    final icon = _resolveIcon(type);

    return GestureDetector(
      onTap: onTap,
      onVerticalDragEnd: (details) {
        // Swipe up to dismiss
        if (details.primaryVelocity != null &&
            details.primaryVelocity! < -100) {
          onDismiss?.call();
        }
      },
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 24,
                sigmaY: 24,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface
                      .withValues(alpha: 0.92),
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outlineVariant
                        .withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow
                          .withValues(alpha: 0.12),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      // Left accent bar
                      Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius:
                              const BorderRadius.only(
                            topLeft:
                                Radius.circular(16),
                            bottomLeft:
                                Radius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: accentColor
                              .withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          color: accentColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Content
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                style: theme
                                    .textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight:
                                      FontWeight.w600,
                                  color: colorScheme
                                      .onSurface,
                                ),
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                body,
                                style: theme
                                    .textTheme.bodySmall
                                    ?.copyWith(
                                  color: colorScheme
                                      .onSurfaceVariant,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow:
                                    TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Close hint
                      Padding(
                        padding:
                            const EdgeInsets.only(
                          right: 12,
                        ),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: colorScheme
                              .onSurfaceVariant
                              .withValues(alpha: 0.4),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Icon & Color Resolution ──────────────────────

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

  Color _resolveAccentColor(
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
