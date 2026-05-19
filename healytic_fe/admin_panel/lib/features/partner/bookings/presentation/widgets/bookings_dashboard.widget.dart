import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/booking_filters.entity.dart';
import '../providers/bookings_controller.provider.dart';
import '../providers/bookings_state.dart';
import 'bookings_empty_state.widget.dart';
import 'bookings_error_state.widget.dart';
import 'bookings_header.widget.dart';
import 'bookings_loading_state.widget.dart';
import 'bookings_refresh_indicator.widget.dart';
import 'filter_bar.widget.dart';
import 'responsive_bookings_grid.widget.dart';
import 'sort_selector.widget.dart';

/// Composition root for the partner bookings dashboard.
///
/// Watches [bookingsControllerProvider] and switches on the
/// outer `AsyncValue` to render the appropriate state:
/// - `AsyncValue.loading` → [BookingsLoadingState]
/// - `AsyncValue.data` with `all` empty + no filters →
///   [BookingsEmptyState] (no Clear button)
/// - `AsyncValue.data` with `visible` empty + filters set →
///   [BookingsEmptyState] (Clear filters button)
/// - `AsyncValue.data` with `visible` non-empty →
///   [ResponsiveBookingsGrid]
/// - `AsyncValue.error` → [BookingsErrorState] (Retry)
///
/// When `RefreshStatus.refreshing`, overlays a
/// [BookingsRefreshIndicator] above the grid while keeping
/// the previous list visible, scrollable, and tappable.
///
/// The [FilterBar] and [SortSelector] are wrapped in a
/// [FocusTraversalGroup] with [OrderedTraversalPolicy] so
/// Tab order is LTR through FilterBar → SortSelector on
/// desktop. Focus indicators use ≥ 2 dp thickness and
/// ≥ 3:1 contrast in both themes.
///
/// _(Req 1.1, 1.4, 1.5, 1.6, 5.8, 5.10, 6.1–6.6, 7.5, 7.6)_
class BookingsDashboard extends ConsumerWidget {
  /// Creates the bookings dashboard widget.
  const BookingsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(partnerBookingStatusRealtimeProvider);

    final asyncState = ref.watch(bookingsControllerProvider);

    return asyncState.when(
      loading: () => const BookingsLoadingState(),
      error: (error, stackTrace) => _buildError(ref, error),
      data: (state) => _buildData(context, ref, state),
    );
  }

  /// Error state — renders [BookingsErrorState] with a
  /// Retry action that re-invokes the fetch preserving
  /// the previously applied filters.
  Widget _buildError(WidgetRef ref, Object error) {
    return BookingsErrorState(
      message: error.toString(),
      onRetry: () => ref.read(bookingsControllerProvider.notifier).refresh(),
    );
  }

  /// Data state — determines which sub-state to render
  /// based on the list contents and active filters.
  Widget _buildData(BuildContext context, WidgetRef ref, BookingsState state) {
    final hasActiveFilters = _hasActiveFilters(state.filters);
    final isRefreshing = state.refresh is RefreshRefreshing;

    // Empty state: all bookings empty + no filters active
    if (state.all.isEmpty && !hasActiveFilters) {
      return const BookingsEmptyState(hasActiveFilters: false);
    }

    // Empty state: visible list empty after applying the selected date/search/status.
    if (state.visible.isEmpty) {
      return Column(
        children: [
          const BookingsHeader(),
          const _FilterSortControls(key: Key('filter_sort_controls')),
          const SizedBox(height: 12),
          Expanded(
            child: BookingsEmptyState(
              hasActiveFilters: hasActiveFilters,
              onClearFilters: hasActiveFilters
                  ? () => ref
                        .read(bookingsControllerProvider.notifier)
                        .clearFilters()
                  : null,
            ),
          ),
        ],
      );
    }

    // Normal data state with grid
    return Column(
      children: [
        const BookingsHeader(),
        const _FilterSortControls(key: Key('filter_sort_controls')),
        const SizedBox(height: 12),
        BookingsRefreshIndicator(isRefreshing: isRefreshing),
        if (isRefreshing) const SizedBox(height: 8),
        Expanded(child: ResponsiveBookingsGrid(bookings: state.visible)),
      ],
    );
  }

  /// Returns `true` when at least one filter axis is
  /// non-default (statuses non-empty, dateRange set, or
  /// searchQuery non-empty).
  bool _hasActiveFilters(BookingFilters filters) {
    final selectedDate = filters.dateRange?.start;
    final today = DateTime.now();
    final isDefaultDate =
        selectedDate == null ||
        (selectedDate.year == today.year &&
            selectedDate.month == today.month &&
            selectedDate.day == today.day);

    return filters.statuses.isNotEmpty ||
        !isDefaultDate ||
        filters.searchQuery.isNotEmpty;
  }
}

/// Groups [FilterBar] and [SortSelector] inside a
/// [FocusTraversalGroup] with [OrderedTraversalPolicy] so
/// keyboard Tab order is LTR: FilterBar → SortSelector on
/// desktop.
///
/// Applies a [Theme] override to ensure focus indicators
/// have ≥ 2 dp thickness and ≥ 3:1 contrast against the
/// adjacent background in both light and dark themes.
///
/// _(Req 7.5, 7.6)_
class _FilterSortControls extends StatelessWidget {
  const _FilterSortControls({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Focus indicator colour: use primary which guarantees
    // ≥ 3:1 contrast against surface in both Material 3
    // light and dark themes.
    final focusColor = colorScheme.primary;

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Theme(
        data: Theme.of(context).copyWith(
          // Override focus indicator for chips and buttons
          // to ensure ≥ 2 dp thickness and ≥ 3:1 contrast.
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: focusColor, width: 2),
            ),
          ),
          chipTheme: Theme.of(context).chipTheme.copyWith(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide.none,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FocusTraversalOrder(
                order: const NumericFocusOrder(1),
                child: Focus(
                  debugLabel: 'BookingDateStrip',
                  child: Builder(
                    builder: (context) {
                      return _FocusHighlight(
                        focusColor: focusColor,
                        child: const BookingDateStrip(),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FocusTraversalOrder(
                order: const NumericFocusOrder(2),
                child: Focus(
                  debugLabel: 'FilterBar',
                  child: Builder(
                    builder: (context) {
                      return _FocusHighlight(
                        focusColor: focusColor,
                        child: const FilterBar(),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FocusTraversalOrder(
                order: const NumericFocusOrder(3),
                child: Focus(
                  debugLabel: 'SortSelector',
                  child: Builder(
                    builder: (context) {
                      return _FocusHighlight(
                        focusColor: focusColor,
                        child: const SortSelector(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Wraps a child widget with a visible focus indicator
/// (≥ 2 dp thickness, ≥ 3:1 contrast) when the nearest
/// [Focus] ancestor has focus.
///
/// _(Req 7.6)_
class _FocusHighlight extends StatelessWidget {
  const _FocusHighlight({required this.focusColor, required this.child});

  /// The colour used for the focus ring. Must have ≥ 3:1
  /// contrast against the adjacent background.
  final Color focusColor;

  /// The child widget to wrap.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final hasFocus = Focus.of(context).hasFocus;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: hasFocus ? Border.all(color: focusColor, width: 2) : null,
      ),
      child: Padding(padding: const EdgeInsets.all(2), child: child),
    );
  }
}
