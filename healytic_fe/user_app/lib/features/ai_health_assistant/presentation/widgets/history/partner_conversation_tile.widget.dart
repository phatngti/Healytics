import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/avatar.dart';
import 'package:flutter/material.dart';

import 'package:user_app/features/partner_chat/domain/entities/partner_conversation.entity.dart';
import 'package:user_app/router/routes.dart';

/// A single partner conversation card for the
/// history list.
///
/// Displays the partner's avatar, name, last message
/// preview, formatted time, unread badge, and a
/// chevron indicator. Older conversations render at
/// reduced opacity via [isOlder].
class PartnerConversationTile extends StatelessWidget {
  /// The partner conversation data to display.
  final PartnerConversation conversation;

  /// When `true`, the tile renders at 75 % opacity
  /// to visually distinguish older sessions.
  final bool isOlder;

  const PartnerConversationTile({
    super.key,
    required this.conversation,
    this.isOlder = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;
    final textTheme =
        Theme.of(context).textTheme;
    final cardPad =
        AppDimens.cardPadding(context);

    final partner = conversation.otherParticipant;
    final hasUnread = conversation.unreadCount > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(
          AppDimens.cardRadius(context),
        ),
        onTap: () => _navigateToChat(context),
        child: AnimatedOpacity(
          duration: const Duration(
            milliseconds: 200,
          ),
          opacity: isOlder ? 0.75 : 1.0,
          child: Container(
            padding: EdgeInsets.all(cardPad),
            decoration: _cardDecoration(
              context,
              colorScheme,
            ),
            child: Row(
              children: [
                // ── Avatar ──
                _PartnerAvatar(
                  name: partner.name,
                  avatarUrl: partner.avatar,
                ),
                SizedBox(
                  width: AppDimens.spaceLg,
                ),

                // ── Name + Preview ──
                Expanded(
                  child: _TileContent(
                    name: partner.name,
                    role: partner.role,
                    lastMessage:
                        conversation
                            .lastMessage
                            .text,
                    hasUnread: hasUnread,
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                ),
                SizedBox(
                  width: AppDimens.spaceSm,
                ),

                // ── Time + Badge + Chevron ──
                _TrailingInfo(
                  timestamp:
                      conversation
                          .lastMessage
                          .timestamp ??
                      conversation.createdAt,
                  unreadCount:
                      conversation.unreadCount,
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return BoxDecoration(
      color: colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(
        AppDimens.cardRadius(context),
      ),
      border: Border.all(
        color: colorScheme.outlineVariant
            .withValues(alpha: 0.1),
      ),
      boxShadow: [
        BoxShadow(
          color: colorScheme.primary
              .withValues(alpha: 0.04),
          blurRadius: AppDimens.spaceXl,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: colorScheme.shadow
              .withValues(alpha: 0.04),
          blurRadius: AppDimens.spaceXs + 2,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  void _navigateToChat(BuildContext context) {
    final partner = conversation.otherParticipant;
    PartnerChatRoute(
      partnerAccountId: partner.id,
      partnerName: partner.name,
      partnerAvatar: partner.avatar,
    ).push(context);
  }
}

// ─────────────────────────────────────────────────────
// Private sub-widgets
// ─────────────────────────────────────────────────────

/// Partner avatar using [AvatarImage] from common.
class _PartnerAvatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;

  const _PartnerAvatar({
    required this.name,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AvatarImage(
      name: name,
      imageUrl: avatarUrl,
      radius: AppDimens.avatarMd / 2,
    );
  }
}

/// Name, role badge, and last message preview.
class _TileContent extends StatelessWidget {
  final String name;
  final String role;
  final String? lastMessage;
  final bool hasUnread;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  const _TileContent({
    required this.name,
    required this.role,
    required this.lastMessage,
    required this.hasUnread,
    required this.textTheme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // Partner name
        Text(
          name,
          style:
              textTheme.titleSmall?.copyWith(
            fontWeight: hasUnread
                ? AppDimens.fontWeightBold
                : AppDimens.fontWeightSemiBold,
            color: colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: AppDimens.spaceXxs),

        // Last message preview
        Text(
          lastMessage ?? 'No messages yet',
          style:
              textTheme.bodySmall?.copyWith(
            color: hasUnread
                ? colorScheme.onSurface
                    .withValues(alpha: 0.75)
                : colorScheme.onSurface
                    .withValues(alpha: 0.55),
            fontWeight: hasUnread
                ? AppDimens.fontWeightMedium
                : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// Time label, unread badge, and chevron.
class _TrailingInfo extends StatelessWidget {
  final DateTime timestamp;
  final int unreadCount;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  const _TrailingInfo({
    required this.timestamp,
    required this.unreadCount,
    required this.textTheme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        // Timestamp
        Text(
          _formatTime(timestamp),
          style:
              textTheme.labelSmall?.copyWith(
            fontWeight:
                AppDimens.fontWeightMedium,
            color: unreadCount > 0
                ? colorScheme.primary
                : colorScheme.onSurface
                    .withValues(alpha: 0.4),
          ),
        ),
        SizedBox(height: AppDimens.spaceXs),

        // Unread badge or chevron
        if (unreadCount > 0)
          _UnreadBadge(
            count: unreadCount,
            colorScheme: colorScheme,
            textTheme: textTheme,
          )
        else
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurface
                .withValues(alpha: 0.25),
            size: AppDimens.iconSmMd,
          ),
      ],
    );
  }

  /// Formats [dt] to a short time label.
  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inDays < 2) {
      final hour =
          dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute =
          dt.minute.toString().padLeft(2, '0');
      final period =
          dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    }

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr',
      'May', 'Jun', 'Jul', 'Aug',
      'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }
}

/// Small circular unread count badge.
class _UnreadBadge extends StatelessWidget {
  final int count;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _UnreadBadge({
    required this.count,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      constraints: const BoxConstraints(
        minWidth: 20,
        minHeight: 20,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          count > 99 ? '99+' : '$count',
          style:
              textTheme.labelSmall?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight:
                AppDimens.fontWeightBold,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
