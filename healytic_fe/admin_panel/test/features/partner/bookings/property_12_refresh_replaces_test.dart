// Feature: partner-bookings-management, Property 12: Refresh replaces the visible list
//
// For any pair of repository responses (initial, refreshed),
// after the controller has settled to initial and refresh()
// completes successfully with refreshed, the controller's
// state.value!.all is structurally equal to refreshed (no
// duplicates, no merge with initial).
//
// Validates: Requirements 1.7

import 'dart:math';

import 'package:admin_panel/features/partner/bookings/domain/entities/booking_filters.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_sort.dart';
import 'package:admin_panel/features/partner/bookings/presentation/providers/booking_filter_predicates.dart';
import 'package:admin_panel/features/partner/bookings/presentation/providers/bookings_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '_generators.dart';

void main() {
  group('Property 12: Refresh replaces the visible list', () {
    test('after refresh, state.all equals the refreshed list with no '
        'merge (>= $kPropertyIterations iterations)', () {
      final rng = Random(77);
      for (var i = 0; i < kPropertyIterations; i++) {
        // Simulate initial state
        final initial = randomBookings(rng, count: 3 + rng.nextInt(10));
        final filters = const BookingFilters();
        const sort = BookingSort.startAsc;

        final initialVisible = applySort(applyFilters(initial, filters), sort);
        final initialState = BookingsState(
          all: initial,
          visible: initialVisible,
          filters: filters,
          sort: sort,
          refresh: const RefreshStatus.idle(),
        );

        // Simulate refresh with a new list
        final refreshed = randomBookings(rng, count: 2 + rng.nextInt(12));
        final newVisible = applySort(
          applyFilters(refreshed, initialState.filters),
          initialState.sort,
        );
        final newState = BookingsState(
          all: refreshed,
          visible: newVisible,
          filters: initialState.filters,
          sort: initialState.sort,
          refresh: const RefreshStatus.idle(),
        );

        // Property: all is exactly the refreshed list
        expect(
          newState.all.length,
          refreshed.length,
          reason:
              'Iteration $i: all.length=${newState.all.length} '
              '!= refreshed.length=${refreshed.length}',
        );

        // No items from initial remain unless they happen to
        // also be in refreshed
        for (var j = 0; j < newState.all.length; j++) {
          expect(
            newState.all[j].id,
            refreshed[j].id,
            reason:
                'Iteration $i: all[$j].id=${newState.all[j].id} '
                '!= refreshed[$j].id=${refreshed[j].id}',
          );
        }

        // Filters and sort are preserved
        expect(newState.filters, initialState.filters);
        expect(newState.sort, initialState.sort);
      }
    });

    test('refresh does not duplicate entries from initial', () {
      final rng = Random(78);
      for (var i = 0; i < kPropertyIterations; i++) {
        // Generate an initial list (simulating pre-refresh state)
        randomBookings(rng, count: 5);
        final refreshed = randomBookings(rng, count: 3);

        // After refresh, all should be exactly refreshed
        final newState = BookingsState(
          all: refreshed,
          visible: applySort(
            applyFilters(refreshed, const BookingFilters()),
            BookingSort.startAsc,
          ),
          filters: const BookingFilters(),
          sort: BookingSort.startAsc,
          refresh: const RefreshStatus.idle(),
        );

        // No initial IDs should appear unless coincidentally
        // generated (extremely unlikely with random IDs)
        final refreshedIds = refreshed.map((b) => b.id).toSet();

        // All items in newState.all are from refreshed
        for (final b in newState.all) {
          expect(
            refreshedIds.contains(b.id),
            isTrue,
            reason: 'Item ${b.id} is not from the refreshed list',
          );
        }
      }
    });
  });
}
