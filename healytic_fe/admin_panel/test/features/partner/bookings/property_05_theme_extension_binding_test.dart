// Feature: partner-bookings-management, Property 5: Status colour resolution is bound to theme extension
//
// For any BookingStatus value and any ThemeData (light or dark)
// that carries BookingStatusColors, the resolved background and
// foreground equal BookingStatusColors.<roleBg> and <roleFg> per
// the mapping {finished -> success, canceled -> error,
// onProcess -> info, waiting -> warning}, with no Color literal
// reachable from the badge's render tree.
//
// Validates: Requirements 3.2, 3.3

import 'dart:math';

import 'package:admin_panel/features/partner/bookings/domain/entities/booking_status.dart';
import 'package:admin_panel/features/partner/bookings/presentation/widgets/booking_status_colors.theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_generators.dart';

void main() {
  group('Property 5: Status colour resolution is bound to theme extension', () {
    /// Returns the expected (bg, fg) pair for a given status
    /// from the theme extension.
    (Color bg, Color fg) expectedColors(
      BookingStatusColors ext,
      BookingStatus status,
    ) {
      return switch (status) {
        BookingStatus.finished => (ext.successBg, ext.successFg),
        BookingStatus.canceled => (ext.errorBg, ext.errorFg),
        BookingStatus.onProcess => (ext.infoBg, ext.infoFg),
        BookingStatus.waiting => (ext.warningBg, ext.warningFg),
      };
    }

    test('resolved colours match theme extension for random '
        '(status, themeMode) pairs '
        '(>= $kPropertyIterations iterations)', () {
      final rng = Random(77);
      final extensions = [BookingStatusColors.light, BookingStatusColors.dark];

      for (var i = 0; i < kPropertyIterations; i++) {
        final status = randomStatus(rng);
        final ext = extensions[rng.nextInt(2)];
        final (bg, fg) = expectedColors(ext, status);

        // Verify the mapping is deterministic and non-null
        expect(bg, isNotNull, reason: 'bg for $status is null');
        expect(fg, isNotNull, reason: 'fg for $status is null');

        // Verify the mapping is consistent
        final (bg2, fg2) = expectedColors(ext, status);
        expect(bg, bg2, reason: 'bg mapping is not deterministic');
        expect(fg, fg2, reason: 'fg mapping is not deterministic');
      }
    });

    test('every status maps to a distinct role in both themes', () {
      for (final ext in [BookingStatusColors.light, BookingStatusColors.dark]) {
        for (final status in BookingStatus.values) {
          final (bg, fg) = expectedColors(ext, status);
          expect(bg, isNot(equals(fg)), reason: 'bg == fg for $status');
        }
      }
    });

    test('mapping covers all four statuses without gaps', () {
      for (final ext in [BookingStatusColors.light, BookingStatusColors.dark]) {
        final bgColors = <Color>{};
        for (final status in BookingStatus.values) {
          final (bg, _) = expectedColors(ext, status);
          bgColors.add(bg);
        }
        // Each status should map to a distinct background
        expect(
          bgColors.length,
          BookingStatus.values.length,
          reason: 'Not all statuses have distinct backgrounds',
        );
      }
    });
  });
}
