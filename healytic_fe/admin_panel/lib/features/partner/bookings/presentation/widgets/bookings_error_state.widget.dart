import 'package:common/widgets/button/button.dart';
import 'package:flutter/material.dart';

/// Error state for the bookings dashboard.
///
/// Displays an error icon, a human-readable [message], and
/// a "Retry" button that invokes [onRetry]. The retry
/// action re-fetches using the previously applied filters
/// (filters are preserved by the controller).
///
/// _(Req 1.6, 6.4, 6.5)_
class BookingsErrorState extends StatelessWidget {
  /// Creates the bookings error state.
  const BookingsErrorState({
    required this.message,
    required this.onRetry,
    super.key,
  });

  /// Human-readable error message to display.
  final String message;

  /// Callback invoked when the user taps "Retry".
  ///
  /// Should re-invoke the fetch using the previously
  /// applied filter struct.
  final VoidCallback onRetry;

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
              Icons.error_outline_rounded,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load bookings',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            AppButton(
              buttonType: ButtonType.elevated,
              onPressed: onRetry,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    size: 18,
                    color: colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Retry',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
