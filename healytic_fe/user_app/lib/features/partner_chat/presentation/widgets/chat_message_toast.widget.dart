import 'dart:ui';

import 'package:common/widgets/images/avatar.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A premium in-app toast shown when a chat message
/// arrives while the user is outside the conversation.
///
/// Features:
/// - Glassmorphism backdrop blur
/// - Sender avatar + name + message preview
/// - Blue accent bar (primary color)
/// - Tap → navigate to conversation
/// - Swipe up → dismiss
class ChatMessageToast extends StatelessWidget {
  const ChatMessageToast({
    super.key,
    required this.senderName,
    required this.messageContent,
    this.senderAvatar,
    this.onTap,
    this.onDismiss,
  });

  final String senderName;
  final String messageContent;
  final String? senderAvatar;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      onVerticalDragEnd: (details) {
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
                  color: cs.surface
                      .withValues(alpha: 0.92),
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                    color: cs.outlineVariant
                        .withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow
                          .withValues(alpha: 0.12),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      _AccentBar(color: cs.primary),
                      const SizedBox(width: 12),
                      _SenderAvatar(
                        name: senderName,
                        avatarUrl: senderAvatar,
                      ),
                      const SizedBox(width: 12),
                      _MessageContent(
                        senderName: senderName,
                        content: messageContent,
                        theme: theme,
                        colorScheme: cs,
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 12,
                        ),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: cs.onSurfaceVariant
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
}

class _AccentBar extends StatelessWidget {
  const _AccentBar({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
    );
  }
}

class _SenderAvatar extends StatelessWidget {
  const _SenderAvatar({
    required this.name,
    this.avatarUrl,
  });

  final String name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (avatarUrl != null &&
        avatarUrl!.isNotEmpty) {
      return AvatarImage(
        name: name,
        imageUrl: avatarUrl,
        radius: 20,
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Symbols.chat_bubble,
        color: cs.primary,
        size: 22,
      ),
    );
  }
}

class _MessageContent extends StatelessWidget {
  const _MessageContent({
    required this.senderName,
    required this.content,
    required this.theme,
    required this.colorScheme,
  });

  final String senderName;
  final String content;
  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              senderName,
              style: theme.textTheme.titleSmall
                  ?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              content,
              style: theme.textTheme.bodySmall
                  ?.copyWith(
                color:
                    colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
