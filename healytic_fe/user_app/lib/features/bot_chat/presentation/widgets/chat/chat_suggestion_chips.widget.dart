import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';

/// A horizontally scrollable row of quick-action suggestion chips.
///
/// Each chip uses [AppButton] from the common package with the
/// [ButtonType.outline] variant. All dimensions use [AppDimens]
/// responsive helpers.
///
/// [onChipTapped] fires with the label text when pressed.
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
    final chipHeight = AppDimens.adaptive(
      context,
      small: 36,
      medium: 38,
      large: 40,
    );

    return SizedBox(
      height: chipHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.horizontalPadding(context),
        ),
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) => SizedBox(width: AppDimens.spaceSm),
        itemBuilder: (context, index) {
          final (emoji, label) = _suggestions[index];
          return AppButton(
            buttonType: ButtonType.outline,
            onPressed: () => onChipTapped?.call(label),
            customStyle: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.buttonPaddingH(context),
                vertical: AppDimens.buttonPaddingV(context),
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.2),
                width: AppDimens.borderWidth,
              ),
              shape: const StadiumBorder(),
              backgroundColor: colorScheme.surface,
              elevation: 0,
            ),
            child: Text(
              '$emoji $label',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: AppDimens.fontWeightSemiBold,
              ),
            ),
          );
        },
      ),
    );
  }
}
