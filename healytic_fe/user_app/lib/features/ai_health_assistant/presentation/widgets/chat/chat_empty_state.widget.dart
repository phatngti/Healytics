import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

import 'chat_suggestion_chips.widget.dart';

/// Friendly empty state when no messages exist.
///
/// Shows a bot avatar, greeting text, and suggestion
/// chips to help the user start a conversation.
class ChatEmptyState extends StatelessWidget {
  /// Called when user taps a suggestion chip.
  final ValueChanged<String>? onSend;

  const ChatEmptyState({super.key, this.onSend});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.horizontalPadding(context) * 2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bot icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
              ),
              child: Icon(
                Icons.smart_toy_rounded,
                size: 36,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: AppDimens.spaceXl),

            Text(
              'Hi! I\'m Dr. AI 👋',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: AppDimens.spaceSm),

            Text(
              'Ask me about symptoms, appointments,'
              ' or health questions.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppDimens.spaceXl),

            ChatSuggestionChips(
              onChipTapped: onSend,
            ),
          ],
        ),
      ),
    );
  }
}
