// Feature: partner-bookings-management, Property 6: Status badge contrast >= 4.5:1
//
// For any BookingStatus value, any theme mode in {light, dark},
// and any breakpoint in {smallMobile, mobile, largeMobile, tablet,
// desktop}, the WCAG contrast ratio between the resolved badge
// background and foreground colour is at least 4.5:1.
//
// Validates: Requirements 3.4, 7.3

import 'dart:math';

import 'package:admin_panel/features/partner/bookings/domain/entities/booking_status.dart';
import 'package:admin_panel/features/partner/bookings/presentation/widgets/booking_status_colors.theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_generators.dart';

/// Computes the relative luminance of a colour per WCAG 2.1.
double _relativeLuminance(Color color) {
  double linearize(double channel) {
    return channel <= 0.03928
        ? channel / 12.92
        : pow((channel + 0.055) / 1.055, 2.4).toDouble();
  }

  final r = linearize(color.r);
  final g = linearize(color.g);
  final b = linearize(color.b);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/// Computes the WCAG contrast ratio between two colours.
double _contrastRatio(Color fg, Color bg) {
  final l1 = _relativeLuminance(fg);
  final l2 = _relativeLuminance(bg);
  final lighter = l1 > l2 ? l1 : l2;
  final darker = l1 > l2 ? l2 : l1;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('Property 6: Status badge contrast is at least 4.5 to 1', () {
    /// Returns the (bg, fg) pair for a status from the extension.
    (Color bg, Color fg) colorsFor(
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

    test('contrast ratio >= 4.5:1 for all (status, themeMode) '
        'combinations (>= $kPropertyIterations iterations)', () {
      final rng = Random(33);
      final themes = [BookingStatusColors.light, BookingStatusColors.dark];

      for (var i = 0; i < kPropertyIterations; i++) {
        final status = randomStatus(rng);
        final ext = themes[rng.nextInt(2)];
        final (bg, fg) = colorsFor(ext, status);
        final ratio = _contrastRatio(fg, bg);

        expect(
          ratio,
          greaterThanOrEqualTo(4.5),
          reason:
              'Contrast ratio for $status '
              '(${ext == BookingStatusColors.light ? "light" : "dark"}) '
              'is $ratio, expected >= 4.5',
        );
      }
    });

    test('exhaustive check: all status x theme combinations', () {
      for (final ext in [BookingStatusColors.light, BookingStatusColors.dark]) {
        final themeName = ext == BookingStatusColors.light ? 'light' : 'dark';
        for (final status in BookingStatus.values) {
          final (bg, fg) = colorsFor(ext, status);
          final ratio = _contrastRatio(fg, bg);
          expect(
            ratio,
            greaterThanOrEqualTo(4.5),
            reason:
                'Contrast for $status ($themeName) is '
                '${ratio.toStringAsFixed(2)}, expected >= 4.5',
          );
        }
      }
    });
  });
}
