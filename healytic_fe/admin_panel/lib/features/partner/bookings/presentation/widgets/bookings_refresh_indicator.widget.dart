import 'package:flutter/material.dart';

/// Non-blocking refresh indicator for the bookings dashboard.
///
/// Renders a [LinearProgressIndicator] above the grid only
/// while [isRefreshing] is `true`. The previous list remains
/// visible, scrollable, and tappable beneath the indicator.
///
/// Uses Flutter's built-in [LinearProgressIndicator] in
/// indeterminate mode, styled with the theme's primary colour.
///
/// _(Req 6.6)_
class BookingsRefreshIndicator extends StatelessWidget {
  /// Creates the bookings refresh indicator.
  const BookingsRefreshIndicator({required this.isRefreshing, super.key});

  /// Whether a refresh is currently in progress.
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    if (!isRefreshing) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          minHeight: 3,
          backgroundColor: colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
        ),
      ),
    );
  }
}
