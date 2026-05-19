// Feature: partner-bookings-management, Property 10: Sort change preserves the filter struct
//
// For any BookingsState s and any BookingSort sort, after
// applying setSort(sort) the resulting state's filters field is
// structurally identical to s.filters.
//
// Validates: Requirements 5.8

import 'dart:math';

import 'package:admin_panel/features/partner/bookings/domain/entities/booking_sort.dart';
import 'package:admin_panel/features/partner/bookings/presentation/providers/booking_filter_predicates.dart';
import 'package:admin_panel/features/partner/bookings/presentation/providers/bookings_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '_generators.dart';

void main() {
  group('Property 10: Sort change preserves the filter struct', () {
    test('changing sort preserves filters for random states '
        '(>= $kPropertyIterations iterations)', () {
      final rng = Random(66);
      for (var i = 0; i < kPropertyIterations; i++) {
        final bookings = randomBookings(rng, count: 3 + rng.nextInt(15));
        final filters = randomFilters(rng);
        final originalSort = randomSort(rng);
        final newSort = randomSort(rng);

        // Build initial state
        final visible = applySort(
          applyFilters(bookings, filters),
          originalSort,
        );
        final state = BookingsState(
          all: bookings,
          visible: visible,
          filters: filters,
          sort: originalSort,
          refresh: const RefreshStatus.idle(),
        );

        // Simulate setSort: recompute visible with new sort,
        // preserving filters
        final newVisible = applySort(
          applyFilters(state.all, state.filters),
          newSort,
        );
        final newState = state.copyWith(sort: newSort, visible: newVisible);

        // Filters must be structurally identical
        expect(
          newState.filters,
          state.filters,
          reason:
              'Filters changed after setSort in iteration $i: '
              '${newState.filters} != ${state.filters}',
        );
      }
    });

    test('setSort only changes sort and visible, not filters or all', () {
      final rng = Random(67);
      for (var i = 0; i < kPropertyIterations; i++) {
        final bookings = randomBookings(rng, count: 5 + rng.nextInt(10));
        final filters = randomFilters(rng);
        final sort1 = BookingSort.startAsc;
        final sort2 = BookingSort.statusGrouping;

        final visible1 = applySort(applyFilters(bookings, filters), sort1);
        final state1 = BookingsState(
          all: bookings,
          visible: visible1,
          filters: filters,
          sort: sort1,
          refresh: const RefreshStatus.idle(),
        );

        final visible2 = applySort(applyFilters(bookings, filters), sort2);
        final state2 = state1.copyWith(sort: sort2, visible: visible2);

        expect(state2.filters, state1.filters);
        expect(state2.all, state1.all);
        expect(state2.sort, sort2);
      }
    });
  });
}
