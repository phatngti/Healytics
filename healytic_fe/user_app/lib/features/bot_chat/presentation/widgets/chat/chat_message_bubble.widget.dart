import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';
import 'package:intl/intl.dart';

import 'package:user_app/features/bot_chat/domain/entities/chat_message.entity.dart';

/// A single chat bubble that renders differently for user vs AI
/// messages.
///
/// AI messages are left-aligned with a small avatar; user messages
/// are right-aligned with the primary color and a read-receipt icon.
/// All dimensions use [AppDimens] responsive helpers.
class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  /// Small avatar URL shown beside AI messages.
  static const String _botAvatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuC8GfSYKLidcI6WkfSjR9kq2CSeJJBNIN_Hsarp_MgZcaIVmyjsCO8m1dILd3Fzk_Kc7RO-zBbIsr2biiY3sRXO8X6nbbmeaxdbxQqOylWGdPsPhtiycvRSp1EMfwjslvHeb_GSvUgWJpMqhvTONsLtcbSPTqPmDAJgAcrQ_w4hAjGKKN2x-pq53vY5DQUtagO9cyliTTYNRQVDJUqwiYbkGaAcISV5S05iYIlsBmDiTdZN4j2pBQs3hocgvSMCGLgLHIw8Mo9USy6o';

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return message.isUser
        ? _UserBubble(message: message)
        : _AiBubble(message: message);
  }
}

// ─────────────────────────────────────────────────────────────────
// AI bubble — left-aligned with avatar
// ─────────────────────────────────────────────────────────────────

class _AiBubble extends StatelessWidget {
  final ChatMessage message;
  const _AiBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final timeStr = DateFormat.jm().format(message.timestamp);
    final bubbleRadius = AppDimens.cardRadius(context);
    final tailRadius = AppDimens.spaceXs;

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppDimens.widthFraction(context, fraction: 0.82),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Bot avatar
            Padding(
              padding: EdgeInsets.only(bottom: AppDimens.spaceXs),
              child: CircleAvatar(
                radius: AppDimens.iconSm,
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: const NetworkImage(
                  ChatMessageBubble._botAvatarUrl,
                ),
                onBackgroundImageError: (_, __) {},
                child: Icon(
                  Icons.smart_toy_outlined,
                  size: AppDimens.iconSm,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            SizedBox(width: AppDimens.spaceSm),

            // Bubble + time
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppDimens.contentPadding(context)),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(bubbleRadius),
                        topRight: Radius.circular(bubbleRadius),
                        bottomLeft: Radius.circular(tailRadius),
                        bottomRight: Radius.circular(bubbleRadius),
                      ),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.4,
                        ),
                        width: AppDimens.borderWidth,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.04),
                          blurRadius: AppDimens.spaceSmMd,
                          offset: Offset(0, AppDimens.spaceXxs),
                        ),
                      ],
                    ),
                    child: Text(
                      message.text,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ),
                  AppDimens.verticalExtraSmall,
                  Padding(
                    padding: EdgeInsets.only(left: AppDimens.spaceXs),
                    child: Text(
                      timeStr,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                        fontSize: AppDimens.fontSizeSmall - 2,
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

// ─────────────────────────────────────────────────────────────────
// User bubble — right-aligned, primary color
// ─────────────────────────────────────────────────────────────────

class _UserBubble extends StatelessWidget {
  final ChatMessage message;
  const _UserBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final timeStr = DateFormat.jm().format(message.timestamp);
    final bubbleRadius = AppDimens.cardRadius(context);
    final tailRadius = AppDimens.spaceXs;

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppDimens.widthFraction(context, fraction: 0.82),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(AppDimens.contentPadding(context)),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(bubbleRadius),
                  topRight: Radius.circular(bubbleRadius),
                  bottomLeft: Radius.circular(bubbleRadius),
                  bottomRight: Radius.circular(tailRadius),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: AppDimens.spaceMd,
                    offset: Offset(0, AppDimens.spaceXs),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  height: 1.5,
                ),
              ),
            ),
            AppDimens.verticalExtraSmall,
            Padding(
              padding: EdgeInsets.only(right: AppDimens.spaceXs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeStr,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                      fontSize: AppDimens.fontSizeSmall - 2,
                    ),
                  ),
                  if (message.isRead) ...[
                    SizedBox(width: AppDimens.spaceXs),
                    Icon(
                      Icons.done_all,
                      size: AppDimens.spaceMd,
                      color: colorScheme.primary,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
