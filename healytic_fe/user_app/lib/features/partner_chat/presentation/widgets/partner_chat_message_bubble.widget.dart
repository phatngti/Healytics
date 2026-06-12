import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/avatar.dart';
import 'package:intl/intl.dart';

import 'package:user_app/features/partner_chat/domain/entities/partner_chat_message.entity.dart';

/// P2P chat message bubble.
///
/// Differentiates sender vs receiver by comparing
/// [message.senderId] with [currentUserId].
/// - Current user: right-aligned, primary color.
/// - Partner: left-aligned, surface container.
class PartnerChatMessageBubble extends StatelessWidget {
  final PartnerChatMessage message;
  final String currentUserId;

  const PartnerChatMessageBubble({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  bool get _isCurrentUser => message.senderId == currentUserId;

  @override
  Widget build(BuildContext context) {
    return _isCurrentUser
        ? _SentBubble(message: message)
        : _ReceivedBubble(message: message);
  }
}

// ─── Sent bubble (right-aligned) ────────────────────

class _SentBubble extends StatelessWidget {
  final PartnerChatMessage message;
  const _SentBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final timeStr = DateFormat.jm().format(message.createdAt);

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppDimens.widthFraction(context, fraction: 0.78),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.spaceSm,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                message.content,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  height: 1.4,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: AppDimens.spaceSm,
                top: AppDimens.spaceXxs,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeStr,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimens.spaceXxs),
                  _StatusIcon(message: message),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Received bubble (left-aligned) ─────────────────

class _ReceivedBubble extends StatelessWidget {
  final PartnerChatMessage message;
  const _ReceivedBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final timeStr = DateFormat.jm().format(message.createdAt);

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppDimens.widthFraction(context, fraction: 0.78),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Partner avatar
            Padding(
              padding: EdgeInsets.only(bottom: AppDimens.spaceMd),
              child: AvatarImage(
                name: message.senderName ?? 'Partner',
                imageUrl: message.senderAvatar,
                radius: 16,
              ),
            ),
            SizedBox(width: AppDimens.spaceXs),

            // Bubble + timestamp
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceMd,
                      vertical: AppDimens.spaceSm,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: Text(
                      message.content,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppDimens.spaceSm,
                      top: AppDimens.spaceXxs,
                    ),
                    child: Text(
                      timeStr,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Delivery status icon ───────────────────────────

/// Delivery status icon for sent messages:
/// - [MessageStatus.sending] → clock (in-flight)
/// - [MessageStatus.sent] + !read → single check
/// - [MessageStatus.sent] + read → double check (blue)
class _StatusIcon extends StatelessWidget {
  final PartnerChatMessage message;
  const _StatusIcon({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (message.status == MessageStatus.sending) {
      return Icon(
        Icons.access_time_rounded,
        size: 14,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      );
    }

    if (message.isRead) {
      return Icon(Icons.done_all_rounded, size: 14, color: colorScheme.primary);
    }

    return Icon(
      Icons.done_rounded,
      size: 14,
      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
    );
  }
}
