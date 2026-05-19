// Feature: partner-bookings-management, Property 8: Visible bookings is the subset satisfying every active filter
//
// For any list of bookings xs, any status set S (where the empty
// set means "All"), any optional date range R, and any search
// query q (after trimming and lowercasing), the visible list
// equals the subset of xs satisfying all active predicates.
//
// Validates: Requirements 5.1, 5.2, 5.4

import 'dart:math';

import 'package:admin_panel/features/partner/bookings/domain/entities/booking.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_filters.entity.dart';
import 'package:admin_panel/features/partner/bookings/presentation/providers/booking_filter_predicates.dart';
import 'package:flutter_test/flutter_test.dart';

import '_generators.dart';

void main() {
  group(
    'Property 8: Visible bookings is the subset satisfying every active filter',
    () {
      /// Reference implementation of the filter predicate.
      bool satisfiesAll(Booking b, BookingFilters f) {
        // Status filter
        if (f.statuses.isNotEmpty && !f.statuses.contains(b.status)) {
          return false;
        }
        // Date range filter
        if (f.dateRange != null) {
          final local = b.slot.start.toLocal();
          final start = DateTime(
            f.dateRange!.start.year,
            f.dateRange!.start.month,
            f.dateRange!.start.day,
          );
          final end = DateTime(
            f.dateRange!.end.year,
            f.dateRange!.end.month,
            f.dateRange!.end.day,
            23,
            59,
            59,
          );
          if (local.isBefore(start) || local.isAfter(end)) {
            return false;
          }
        }
        // Search query filter
        if (f.searchQuery.isNotEmpty) {
          final q = f.searchQuery;
          final matches = [
            b.customer.fullName,
            b.specialist.fullName,
            b.service.name,
          ].any((n) => n.toLowerCase().contains(q));
          if (!matches) return false;
        }
        return true;
      }

      test('applyFilters returns exactly the bookings satisfying all '
          'predicates (>= $kPropertyIterations iterations)', () {
        final rng = Random(88);
        for (var i = 0; i < kPropertyIterations; i++) {
          final bookings = randomBookings(rng, count: 5 + rng.nextInt(15));
          final filters = randomFilters(rng);
          final result = applyFilters(bookings, filters);

          // Every result item satisfies all predicates
          for (final b in result) {
            expect(
              satisfiesAll(b, filters),
              isTrue,
              reason: 'Booking ${b.id} in result does not satisfy filters',
            );
          }

          // Every input item satisfying all predicates is in result
          final expected = bookings
              .where((b) => satisfiesAll(b, filters))
              .toList();
          expect(
            result.length,
            expected.length,
            reason:
                'Result length ${result.length} != expected '
                '${expected.length} for iteration $i',
          );
        }
      });

      test('empty status set means All (no status filter)', () {
        final rng = Random(99);
        for (var i = 0; i < kPropertyIterations; i++) {
          final bookings = randomBookings(rng, count: 5 + rng.nextInt(10));
          const filters = BookingFilters(statuses: {});
          final result = applyFilters(bookings, filters);
          expect(result.length, bookings.length);
        }
      });

      test('result is always a subset of input', () {
        final rng = Random(101);
        for (var i = 0; i < kPropertyIterations; i++) {
          final bookings = randomBookings(rng, count: 3 + rng.nextInt(10));
          final filters = randomFilters(rng);
          final result = applyFilters(bookings, filters);
          final inputIds = bookings.map((b) => b.id).toSet();
          for (final b in result) {
            expect(
              inputIds.contains(b.id),
              isTrue,
              reason: 'Result contains ${b.id} not in input',
            );
          }
        }
      });
    },
  );
}
