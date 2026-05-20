import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// Chat session types available in history.
enum ChatType {
  /// AI assistant sessions.
  aiSession('AI Session'),

  /// Partner (human) chat sessions.
  partnerChat('Partner Chat');

  const ChatType(this.label);

  /// Display label shown on the tab.
  final String label;
}

/// Segmented tab selector for filtering chat
/// history by [ChatType].
///
/// Renders two equal-width tabs with an animated
/// underline indicator and text weight transition
/// on the selected tab.
class ChatTypeSelector extends StatelessWidget {
  /// Currently selected chat type.
  final ChatType selected;

  /// Called when the user taps a different tab.
  final ValueChanged<ChatType> onChanged;

  const ChatTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: AppDimens.borderWidth,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.horizontalPadding(context),
        ),
        child: Row(
          children: ChatType.values.map((type) {
            return Expanded(
              child: _ChatTypeTab(
                type: type,
                isSelected: type == selected,
                onTap: () => onChanged(type),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Individual tab inside [ChatTypeSelector].
///
/// Animates the underline indicator colour and
/// text weight between selected / unselected
/// states over 200 ms for a polished feel.
class _ChatTypeTab extends StatelessWidget {
  final ChatType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChatTypeTab({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final duration = const Duration(milliseconds: 200);

    return Semantics(
      button: true,
      selected: isSelected,
      label: type.label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: duration,
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: AppDimens.spaceLg),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: AppDimens.borderWidthThick,
              ),
            ),
          ),
          child: Center(child: _buildLabel(textTheme, colorScheme, duration)),
        ),
      ),
    );
  }

  Widget _buildLabel(
    TextTheme textTheme,
    ColorScheme colorScheme,
    Duration duration,
  ) {
    return AnimatedDefaultTextStyle(
      duration: duration,
      style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
        fontWeight: isSelected ? AppDimens.fontWeightBold : FontWeight.w500,
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      child: Text(type.label),
    );
  }
}
