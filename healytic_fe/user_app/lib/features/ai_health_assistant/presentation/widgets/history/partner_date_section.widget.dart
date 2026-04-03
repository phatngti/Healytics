import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

import 'package:user_app/features/partner_chat/domain/entities/partner_conversation.entity.dart';
import 'partner_conversation_tile.widget.dart';

/// A group of partner conversations sharing the
/// same date label.
class PartnerDateGroup {
  /// Display label, e.g. "Today - Feb 10, 2026".
  final String label;

  /// Conversations belonging to this date bucket.
  final List<PartnerConversation> conversations;

  /// Whether the section represents older
  /// conversations that should render with reduced
  /// visual emphasis.
  final bool isOlder;

  const PartnerDateGroup({
    required this.label,
    required this.conversations,
    this.isOlder = false,
  });
}

/// Groups [conversations] into [PartnerDateGroup]
/// sections (Today, Yesterday, Last Week, older
/// months) based on the last message timestamp.
List<PartnerDateGroup> groupPartnerConversationsByDate(
  List<PartnerConversation> conversations,
) {
  if (conversations.isEmpty) return [];

  final now = DateTime.now();
  final today = DateTime(
    now.year,
    now.month,
    now.day,
  );
  final yesterday = today.subtract(
    const Duration(days: 1),
  );
  final lastWeekStart = today.subtract(
    const Duration(days: 7),
  );

  final groups =
      <String, List<PartnerConversation>>{};
  final olderFlags = <String, bool>{};

  const months = [
    'Jan', 'Feb', 'Mar', 'Apr',
    'May', 'Jun', 'Jul', 'Aug',
    'Sep', 'Oct', 'Nov', 'Dec',
  ];

  for (final c in conversations) {
    final ts =
        c.lastMessage.timestamp ?? c.createdAt;
    final date = DateTime(
      ts.year,
      ts.month,
      ts.day,
    );

    String label;
    bool isOlder = false;

    if (date == today) {
      label =
          'Today - '
          '${months[now.month - 1]} '
          '${now.day}, ${now.year}';
    } else if (date == yesterday) {
      label =
          'Yesterday - '
          '${months[yesterday.month - 1]} '
          '${yesterday.day}, '
          '${yesterday.year}';
    } else if (date.isAfter(lastWeekStart)) {
      label = 'Last Week';
      isOlder = true;
    } else {
      label =
          '${months[date.month - 1]} '
          '${date.year}';
      isOlder = true;
    }

    groups.putIfAbsent(label, () => []).add(c);
    olderFlags[label] = isOlder;
  }

  return groups.entries
      .map(
        (e) => PartnerDateGroup(
          label: e.key,
          conversations: e.value,
          isOlder: olderFlags[e.key] ?? false,
        ),
      )
      .toList();
}

// ─────────────────────────────────────────────────
// Section UI
// ─────────────────────────────────────────────────

/// Renders a date-labelled section containing a
/// list of [PartnerConversationTile] cards.
class PartnerDateSection extends StatelessWidget {
  /// Label displayed above the section.
  final String label;

  /// Conversations in this section.
  final List<PartnerConversation> conversations;

  /// Reduces emphasis on older sections.
  final bool isOlder;

  const PartnerDateSection({
    super.key,
    required this.label,
    required this.conversations,
    this.isOlder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppDimens.sectionSpacing(context),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _DateSectionHeader(label: label),
          SizedBox(
            height: AppDimens.spaceMd,
          ),
          ...conversations.map(
            (c) => Padding(
              padding: EdgeInsets.only(
                bottom: AppDimens.spaceMd,
              ),
              child: PartnerConversationTile(
                conversation: c,
                isOlder: isOlder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Uppercase date label rendered above a group of
/// partner conversation tiles.
class _DateSectionHeader extends StatelessWidget {
  final String label;
  const _DateSectionHeader({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme;
    final colorScheme =
        Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceXxs,
      ),
      child: Text(
        label.toUpperCase(),
        style: textTheme.labelSmall?.copyWith(
          fontWeight:
              AppDimens.fontWeightSemiBold,
          letterSpacing:
              AppDimens.letterSpacingLarge,
          color: colorScheme.onSurface
              .withValues(alpha: 0.45),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
