import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// Empty state placeholder shown when no conversations match the
/// current search query.
class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimens.spaceXxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: AppDimens.avatarLg,
              color: colorScheme.onSurface.withValues(alpha: 0.25),
            ),
            SizedBox(height: AppDimens.spaceLg),
            Text(
              'No conversations found',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimens.spaceSm),
            Text(
              'Start a new chat to get health advice',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.35),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
