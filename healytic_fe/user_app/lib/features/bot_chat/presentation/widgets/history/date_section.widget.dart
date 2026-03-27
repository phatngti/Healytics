import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

import 'package:user_app/features/bot_chat/domain/entities/chat_conversation.entity.dart';
import 'conversation_tile.widget.dart';

/// A section of conversations sharing the same date label.
///
/// Used by [groupConversationsByDate] to bucket conversations
/// into "Today", "Yesterday", "Last Week", etc.
class DateGroup {
  /// Display label, e.g. "Today - Feb 10, 2026".
  final String label;

  /// Conversations belonging to this date bucket.
  final List<ChatConversation> conversations;

  /// Whether the section represents older conversations that
  /// should render with reduced visual emphasis.
  final bool isOlder;

  const DateGroup({
    required this.label,
    required this.conversations,
    this.isOlder = false,
  });
}

/// Groups [conversations] into [DateGroup] sections (Today,
/// Yesterday, Last Week, older months).
List<DateGroup> groupConversationsByDate(List<ChatConversation> conversations) {
  if (conversations.isEmpty) return [];

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final lastWeekStart = today.subtract(const Duration(days: 7));

  final Map<String, List<ChatConversation>> groups = {};
  final Map<String, bool> olderFlags = {};

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

  for (final c in conversations) {
    final date = DateTime(c.timestamp.year, c.timestamp.month, c.timestamp.day);

    String label;
    bool isOlder = false;

    if (date == today) {
      label =
          'Today - '
          '${months[now.month - 1]} ${now.day}, ${now.year}';
    } else if (date == yesterday) {
      label =
          'Yesterday - '
          '${months[yesterday.month - 1]} ${yesterday.day}, '
          '${yesterday.year}';
    } else if (date.isAfter(lastWeekStart)) {
      label = 'Last Week';
      isOlder = true;
    } else {
      label = '${months[date.month - 1]} ${date.year}';
      isOlder = true;
    }

    groups.putIfAbsent(label, () => []).add(c);
    olderFlags[label] = isOlder;
  }

  return groups.entries
      .map(
        (e) => DateGroup(
          label: e.key,
          conversations: e.value,
          isOlder: olderFlags[e.key] ?? false,
        ),
      )
      .toList();
}

// ─────────────────────────────────────────────────────────────────
// Section UI
// ─────────────────────────────────────────────────────────────────

/// Renders a date-labelled section containing a list of
/// [ConversationTile] cards.
class DateSection extends StatelessWidget {
  /// Label displayed above the section, e.g. "TODAY - FEB 10".
  final String label;

  /// Conversations in this section.
  final List<ChatConversation> conversations;

  /// Reduces emphasis on older sections.
  final bool isOlder;

  const DateSection({
    super.key,
    required this.label,
    required this.conversations,
    this.isOlder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.sectionSpacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DateSectionHeader(label: label),
          SizedBox(height: AppDimens.spaceMd),
          ...conversations.map(
            (c) => Padding(
              padding: EdgeInsets.only(bottom: AppDimens.spaceMd),
              child: ConversationTile(conversation: c, isOlder: isOlder),
            ),
          ),
        ],
      ),
    );
  }
}

/// Uppercase date label rendered above a group of conversation
/// tiles.
class _DateSectionHeader extends StatelessWidget {
  final String label;
  const _DateSectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceXxs),
      child: Text(
        label.toUpperCase(),
        style: textTheme.labelSmall?.copyWith(
          fontWeight: AppDimens.fontWeightSemiBold,
          letterSpacing: AppDimens.letterSpacingLarge,
          color: colorScheme.onSurface.withValues(alpha: 0.45),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
