import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// A centered pill-shaped timestamp divider displayed between
/// message groups (e.g. "Today, 9:41 AM").
///
/// Uses [AppDimens] for responsive padding, radius, and font size.
class ChatTimestamp extends StatelessWidget {
  final String label;

  const ChatTimestamp({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceXs,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
          borderRadius: AppDimens.radiusMediumSmall,
        ),
        child: Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: AppDimens.fontWeightMedium,
          ),
        ),
      ),
    );
  }
}
