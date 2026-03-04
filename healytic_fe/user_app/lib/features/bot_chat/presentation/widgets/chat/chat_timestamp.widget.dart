import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// A centered timestamp divider with horizontal lines on
/// each side, displayed between message groups
/// (e.g. "Today, 9:41 AM").
///
/// Uses [AppDimens] for responsive padding, radius, and
/// font size.
class ChatTimestamp extends StatelessWidget {
  final String label;

  const ChatTimestamp({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final lineColor = colorScheme.outlineVariant.withValues(alpha: 0.3);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
      child: Row(
        children: [
          Expanded(
            child: Container(height: AppDimens.borderWidth, color: lineColor),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.spaceXs,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: AppDimens.fontWeightMedium,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(height: AppDimens.borderWidth, color: lineColor),
          ),
        ],
      ),
    );
  }
}
