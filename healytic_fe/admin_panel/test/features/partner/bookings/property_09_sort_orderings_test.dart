// Feature: partner-bookings-management, Property 9: Sort orderings are monotonic and lex-stable
//
// For any list of bookings xs:
// - applySort(xs, startAsc).map(slot.start) is monotonic non-decreasing
// - applySort(xs, startDesc) is monotonic non-increasing
// - applySort(xs, statusGrouping) is lex non-decreasing under the key
//   (statusOrder(status), slot.start) where
//   statusOrder(waiting) < statusOrder(onProcess) <
//   statusOrder(finished) < statusOrder(canceled)
//
// Validates: Requirements 5.6, 5.7

import 'dart:math';

import 'package:admin_panel/features/partner/bookings/domain/entities/booking_sort.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_status.dart';
import 'package:admin_panel/features/partner/bookings/presentation/providers/booking_filter_predicates.dart';
import 'package:flutter_test/flutter_test.dart';

import '_generators.dart';

/// Canonical status ordering for statusGrouping sort.
int _statusOrder(BookingStatus status) => switch (status) {
  BookingStatus.waiting => 0,
  BookingStatus.onProcess => 1,
  BookingStatus.finished => 2,
  BookingStatus.canceled => 3,
};

void main() {
  group('Property 9: Sort orderings are monotonic and lex-stable', () {
    test('startAsc produces monotonic non-decreasing slot.start '
        '(>= $kPropertyIterations iterations)', () {
      final rng = Random(42);
      for (var i = 0; i < kPropertyIterations; i++) {
        final bookings = randomBookings(rng, count: 2 + rng.nextInt(15));
        final sorted = applySort(bookings, BookingSort.startAsc);

        for (var j = 1; j < sorted.length; j++) {
          expect(
            sorted[j].slot.start.compareTo(sorted[j - 1].slot.start),
            greaterThanOrEqualTo(0),
            reason:
                'startAsc: slot.start at index $j is before index '
                '${j - 1} in iteration $i',
          );
        }
      }
    });

    test('startDesc produces monotonic non-increasing slot.start '
        '(>= $kPropertyIterations iterations)', () {
      final rng = Random(43);
      for (var i = 0; i < kPropertyIterations; i++) {
        final bookings = randomBookings(rng, count: 2 + rng.nextInt(15));
        final sorted = applySort(bookings, BookingSort.startDesc);

        for (var j = 1; j < sorted.length; j++) {
          expect(
            sorted[j].slot.start.compareTo(sorted[j - 1].slot.start),
            lessThanOrEqualTo(0),
            reason:
                'startDesc: slot.start at index $j is after index '
                '${j - 1} in iteration $i',
          );
        }
      }
    });

    test('statusGrouping produces lex non-decreasing '
        '(statusOrder, slot.start) '
        '(>= $kPropertyIterations iterations)', () {
      final rng = Random(44);
      for (var i = 0; i < kPropertyIterations; i++) {
        final bookings = randomBookings(rng, count: 2 + rng.nextInt(15));
        final sorted = applySort(bookings, BookingSort.statusGrouping);

        for (var j = 1; j < sorted.length; j++) {
          final prevOrder = _statusOrder(sorted[j - 1].status);
          final currOrder = _statusOrder(sorted[j].status);

          if (currOrder == prevOrder) {
            // Within same group: slot.start ascending
            expect(
              sorted[j].slot.start.compareTo(sorted[j - 1].slot.start),
              greaterThanOrEqualTo(0),
              reason:
                  'statusGrouping: within group, slot.start at '
                  'index $j is before index ${j - 1}',
            );
          } else {
            // Across groups: order must be non-decreasing
            expect(
              currOrder,
              greaterThan(prevOrder),
              reason:
                  'statusGrouping: status order at index $j '
                  '($currOrder) is less than at index ${j - 1} '
                  '($prevOrder)',
            );
          }
        }
      }
    });

    test('applySort does not mutate the input list', () {
      final rng = Random(45);
      for (var i = 0; i < kPropertyIterations; i++) {
        final bookings = randomBookings(rng, count: 3 + rng.nextInt(10));
        final originalIds = bookings.map((b) => b.id).toList();
        final sort = randomSort(rng);
        applySort(bookings, sort);
        final afterIds = bookings.map((b) => b.id).toList();
        expect(afterIds, originalIds, reason: 'Input was mutated');
      }
    });
  });
}
