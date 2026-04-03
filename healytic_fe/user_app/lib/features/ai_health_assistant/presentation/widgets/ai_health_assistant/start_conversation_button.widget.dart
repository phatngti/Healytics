import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

/// Primary CTA button that navigates the user to
/// the bot chat screen.
class StartConversationButton extends StatelessWidget {
  const StartConversationButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: colorScheme.primary,
        borderRadius: AppDimens.radiusMediumSmall,
        elevation: 4,
        shadowColor:
            colorScheme.primary.withValues(alpha: 0.3),
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppDimens.radiusMediumSmall,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppDimens.spaceMdLg,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  Symbols.chat,
                  size: AppDimens.iconMd,
                  color: colorScheme.onPrimary,
                ),
                SizedBox(width: AppDimens.spaceMd),
                Text(
                  'Start a Conversation',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
