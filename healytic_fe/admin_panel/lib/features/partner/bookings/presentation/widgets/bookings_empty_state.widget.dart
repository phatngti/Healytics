import 'package:common/widgets/button/button.dart';
import 'package:flutter/material.dart';

/// Empty state for the bookings dashboard.
///
/// Renders two variants based on whether filters are active:
///
/// - **Variant A** ([hasActiveFilters] = `false`): icon +
///   message only. No "Clear filters" action is shown.
/// - **Variant B** ([hasActiveFilters] = `true`): icon +
///   message + "Clear filters" button that invokes
///   [onClearFilters].
///
/// _(Req 1.5, 5.10, 6.2, 6.3)_
class BookingsEmptyState extends StatelessWidget {
  /// Creates the bookings empty state.
  const BookingsEmptyState({
    required this.hasActiveFilters,
    this.onClearFilters,
    super.key,
  });

  /// Whether at least one filter is currently active.
  ///
  /// When `true`, the "Clear filters" button is rendered.
  final bool hasActiveFilters;

  /// Callback invoked when the user taps "Clear filters".
  ///
  /// Only relevant when [hasActiveFilters] is `true`.
  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_busy_rounded,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              hasActiveFilters
                  ? 'No bookings match the current filters'
                  : 'No bookings yet',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              hasActiveFilters
                  ? 'Try adjusting your filters to see '
                        'more results.'
                  : 'Bookings will appear here once '
                        'customers start scheduling.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (hasActiveFilters) ...[
              const SizedBox(height: 24),
              AppButton(
                buttonType: ButtonType.outline,
                onPressed: onClearFilters,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.filter_alt_off_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Clear filters',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
