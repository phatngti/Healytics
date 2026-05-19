// Feature: partner-bookings-management, Property 2: Horizontal padding step function
//
// For any layout width w >= 0 in dp, getHorizontalPadding(w)
// returns 16 when w < 360, 20 when 360 <= w < 400, and 24
// when w >= 400.
//
// Validates: Requirements 4.6

import 'dart:math';

import 'package:admin_panel/features/partner/bookings/presentation/widgets/responsive_bookings_grid.widget.dart';
import 'package:flutter_test/flutter_test.dart';

import '_generators.dart';

void main() {
  group(
    'Property 2: Horizontal padding is a step function of viewport width',
    () {
      test('getHorizontalPadding returns correct value for random widths '
          '(>= $kPropertyIterations iterations)', () {
        final rng = Random(7);
        for (var i = 0; i < kPropertyIterations; i++) {
          final w = randomViewportWidth(rng);
          final padding = getHorizontalPadding(w);

          if (w < 360) {
            expect(padding, 16.0, reason: 'width=$w should give 16dp');
          } else if (w < 400) {
            expect(padding, 20.0, reason: 'width=$w should give 20dp');
          } else {
            expect(padding, 24.0, reason: 'width=$w should give 24dp');
          }
        }
      });

      test('getHorizontalPadding handles boundary values exactly', () {
        expect(getHorizontalPadding(0), 16.0);
        expect(getHorizontalPadding(200), 16.0);
        expect(getHorizontalPadding(359.9), 16.0);
        expect(getHorizontalPadding(360), 20.0);
        expect(getHorizontalPadding(399.9), 20.0);
        expect(getHorizontalPadding(400), 24.0);
        expect(getHorizontalPadding(600), 24.0);
        expect(getHorizontalPadding(1200), 24.0);
        expect(getHorizontalPadding(1600), 24.0);
      });

      test('getHorizontalPadding is monotonic non-decreasing', () {
        final rng = Random(13);
        final widths = List.generate(
          kPropertyIterations,
          (_) => randomViewportWidth(rng),
        )..sort();

        for (var i = 1; i < widths.length; i++) {
          expect(
            getHorizontalPadding(widths[i]),
            greaterThanOrEqualTo(getHorizontalPadding(widths[i - 1])),
            reason:
                'padding(${widths[i]}) should be >= '
                'padding(${widths[i - 1]})',
          );
        }
      });
    },
  );
}
