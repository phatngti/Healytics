import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/booking_sort.dart';
import '../providers/bookings_controller.provider.dart';

/// Segmented control that lets the partner change the grid
/// ordering between time-ascending, time-descending, and
/// status-grouping.
///
/// Reads the current [BookingSort] from
/// [bookingsControllerProvider] and calls
/// [BookingsController.setSort] on selection change.
/// Never touches filters (Property 10).
///
/// Status-grouping order:
/// Waiting → OnProcess → Finished → Canceled with
/// `slot.start` ascending tiebreaker.
///
/// _(Req 5.6, 5.7, 5.8, 5.9, Property 9, Property 10)_
class SortSelector extends ConsumerWidget {
  /// Creates the sort selector widget.
  const SortSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingsControllerProvider).asData?.value;
    if (state == null) return const SizedBox.shrink();

    final currentSort = state.sort;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<BookingSort>(
        showSelectedIcon: false,
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
        segments: BookingSort.values
            .map(
              (sort) => ButtonSegment<BookingSort>(
                value: sort,
                label: Text(sort.label),
              ),
            )
            .toList(),
        selected: {currentSort},
        onSelectionChanged: (selection) {
          ref
              .read(bookingsControllerProvider.notifier)
              .setSort(selection.first);
        },
      ),
    );
  }
}
