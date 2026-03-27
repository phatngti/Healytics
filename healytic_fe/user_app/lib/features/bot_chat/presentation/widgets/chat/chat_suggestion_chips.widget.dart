import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// Telegram-style horizontally scrollable suggestion chips.
///
/// Clean pill-shaped buttons with a subtle tinted
/// background and no heavy effects.
///
/// [onChipTapped] fires with the label text on press.
class ChatSuggestionChips extends StatelessWidget {
  final ValueChanged<String>? onChipTapped;

  const ChatSuggestionChips({super.key, this.onChipTapped});

  static const List<(String emoji, String label)> _suggestions = [
    ('🤒', 'Symptom Check'),
    ('📅', 'Book Appointment'),
    ('🥗', 'Diet Plan'),
    ('💊', 'Medication Info'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.horizontalPadding(context),
        ),
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) => SizedBox(width: AppDimens.spaceSm),
        itemBuilder: (context, index) {
          final (emoji, label) = _suggestions[index];
          return Material(
            color: colorScheme.primaryContainer.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              onTap: () => onChipTapped?.call(label),
              borderRadius: BorderRadius.circular(999),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                  vertical: AppDimens.spaceXs,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(emoji),
                    SizedBox(width: AppDimens.spaceXs),
                    Text(
                      label,
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
