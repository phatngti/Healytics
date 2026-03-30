import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/router/routes.dart';

import 'package:user_app/features/ai_health_assistant/domain/entities/chat_conversation.entity.dart';

/// Maps a string icon name to its [IconData].
///
/// Used to bridge the domain layer (pure Dart, no
/// Flutter) with the presentation layer.
IconData _resolveIcon(String? iconName) {
  return switch (iconName) {
    'smart_toy' => Icons.smart_toy_outlined,
    'fitness_center' => Icons.fitness_center,
    'medical_services' => Icons.medical_services,
    'psychology' => Icons.psychology_outlined,
    'health_and_safety' =>
      Icons.health_and_safety_outlined,
    _ => Icons.smart_toy_outlined,
  };
}

/// A single conversation card for the history list.
///
/// Displays an avatar (network image or icon fallback), the
/// conversation [title], a [lastMessage] preview, formatted time,
/// and a chevron indicator. Older conversations render at reduced
/// opacity via [isOlder].
class ConversationTile extends StatelessWidget {
  /// The conversation data to display.
  final ChatConversation conversation;

  /// When `true`, the tile renders at 75 % opacity to visually
  /// distinguish older sessions.
  final bool isOlder;

  const ConversationTile({
    super.key,
    required this.conversation,
    this.isOlder = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final cardPad = AppDimens.cardPadding(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.cardRadius(context)),
        onTap: () {
          ChatRoute(conversationId: conversation.id).push(context);
        },
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isOlder ? 0.75 : 1.0,
          child: Container(
            padding: EdgeInsets.all(cardPad),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(
                AppDimens.cardRadius(context),
              ),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.04),
                  blurRadius: AppDimens.spaceXl,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.04),
                  blurRadius: AppDimens.spaceXs + 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // ── Avatar / Icon ──
                _TileAvatar(conversation: conversation),
                SizedBox(width: AppDimens.spaceLg),

                // ── Title + Preview ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conversation.title,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: AppDimens.fontWeightSemiBold,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppDimens.spaceXxs),
                      Text(
                        conversation.lastMessage,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppDimens.spaceSm),

                // ── Time + Chevron ──
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatTime(conversation.timestamp),
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: AppDimens.fontWeightMedium,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                    SizedBox(height: AppDimens.spaceXs),
                    Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurface.withValues(alpha: 0.25),
                      size: AppDimens.iconSmMd,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Formats [timestamp] to a short time label.
  ///
  /// Shows "h:mm AM/PM" for today/yesterday, or "MMM d" for older.
  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inDays < 2) {
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }
}

// ─────────────────────────────────────────────────────────────────
// Avatar Helpers (private to this file)
// ─────────────────────────────────────────────────────────────────

class _TileAvatar extends StatelessWidget {
  final ChatConversation conversation;
  const _TileAvatar({required this.conversation});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: AppDimens.avatarMd,
      height: AppDimens.avatarMd,
      child: conversation.avatarUrl != null
          ? _NetworkAvatar(
              url: conversation.avatarUrl!,
              colorScheme: colorScheme,
            )
          : _IconAvatar(
              icon: _resolveIcon(conversation.iconName),
              colorScheme: colorScheme,
            ),
    );
  }
}

class _NetworkAvatar extends StatelessWidget {
  final String url;
  final ColorScheme colorScheme;

  const _NetworkAvatar({required this.url, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
          width: AppDimens.borderWidthThick,
        ),
      ),
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: AppDimens.avatarMd,
          height: AppDimens.avatarMd,
          errorBuilder: (_, __, ___) => _IconAvatar(
            icon: Icons.smart_toy_outlined,
            colorScheme: colorScheme,
          ),
        ),
      ),
    );
  }
}

class _IconAvatar extends StatelessWidget {
  final IconData icon;
  final ColorScheme colorScheme;

  const _IconAvatar({required this.icon, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
      ),
      child: Center(
        child: Icon(icon, color: colorScheme.primary, size: AppDimens.iconLg),
      ),
    );
  }
}
