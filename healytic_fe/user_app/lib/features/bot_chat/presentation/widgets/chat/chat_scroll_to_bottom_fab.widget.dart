import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// Clean scroll-to-bottom floating action button.
///
/// Renders a small circular button with a down-arrow
/// icon. Appears when the user scrolls up in the
/// message list.
class ChatScrollToBottomFab extends StatelessWidget {
  /// Called when the button is tapped.
  final VoidCallback onTap;

  const ChatScrollToBottomFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.15),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colorScheme.onSurfaceVariant,
            size: AppDimens.iconLg,
          ),
        ),
      ),
    );
  }
}
