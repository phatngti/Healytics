// Feature: partner-bookings-management, Property 1: Column count step function
//
// For any layout width w >= 0 in dp, columnsFor(w) returns
// 1 when w < 400, 2 when 400 <= w < 600, 3 when 600 <= w <= 1200,
// 4 when w > 1200, and is monotonic non-decreasing.
//
// Validates: Requirements 1.1, 4.1, 4.2, 4.3, 4.4

import 'dart:math';

import 'package:admin_panel/features/partner/bookings/presentation/widgets/responsive_bookings_grid.widget.dart';
import 'package:flutter_test/flutter_test.dart';

import '_generators.dart';

void main() {
  group('Property 1: Column count is a step function of viewport width', () {
    test('columnsFor returns correct value for random widths '
        '(>= $kPropertyIterations iterations)', () {
      final rng = Random(42);
      for (var i = 0; i < kPropertyIterations; i++) {
        final w = randomViewportWidth(rng);
        final cols = columnsFor(w);

        if (w < 400) {
          expect(cols, 1, reason: 'width=$w should give 1 column');
        } else if (w < 600) {
          expect(cols, 2, reason: 'width=$w should give 2 columns');
        } else if (w <= 1200) {
          expect(cols, 3, reason: 'width=$w should give 3 columns');
        } else {
          expect(cols, 4, reason: 'width=$w should give 4 columns');
        }
      }
    });

    test('columnsFor is monotonic non-decreasing', () {
      final rng = Random(99);
      final widths = List.generate(
        kPropertyIterations,
        (_) => randomViewportWidth(rng),
      )..sort();

      for (var i = 1; i < widths.length; i++) {
        expect(
          columnsFor(widths[i]),
          greaterThanOrEqualTo(columnsFor(widths[i - 1])),
          reason:
              'columnsFor(${widths[i]}) should be >= '
              'columnsFor(${widths[i - 1]})',
        );
      }
    });

    test('columnsFor handles boundary values exactly', () {
      expect(columnsFor(0), 1);
      expect(columnsFor(359.9), 1);
      expect(columnsFor(399.9), 1);
      expect(columnsFor(400), 2);
      expect(columnsFor(599.9), 2);
      expect(columnsFor(600), 3);
      expect(columnsFor(1200), 3);
      expect(columnsFor(1200.1), 4);
      expect(columnsFor(1600), 4);
    });
  });
}
