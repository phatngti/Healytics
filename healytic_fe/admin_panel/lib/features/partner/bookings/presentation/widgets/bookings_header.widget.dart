import 'package:common/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/bookings_controller.provider.dart';

/// Header widget for the bookings dashboard.
///
/// Displays the page title and a Refresh button that is
/// visible only on desktop viewports (parent layout
/// width > 1200 dp). The button invokes
/// [BookingsController.refresh] to re-fetch the booking
/// list from the repository.
///
/// _(Req 1.7)_
class BookingsHeader extends ConsumerWidget {
  /// Creates a bookings header.
  const BookingsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1200;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Bookings',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isDesktop)
                AppButton(
                  buttonType: ButtonType.elevated,
                  onPressed: () =>
                      ref.read(bookingsControllerProvider.notifier).refresh(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh, color: colorScheme.onPrimary),
                      const SizedBox(width: 8),
                      Text(
                        'Refresh',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
