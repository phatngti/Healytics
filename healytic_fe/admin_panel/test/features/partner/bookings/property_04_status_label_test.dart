// Feature: partner-bookings-management, Property 4: Status label mapping is total
//
// For any BookingStatus value, labelFor(status) returns exactly
// one non-empty string from the mapping {waiting -> "Waiting",
// onProcess -> "On process", canceled -> "Canceled",
// finished -> "Finished"}, with no nulls and no exceptions.
//
// Validates: Requirements 2.5, 3.1

import 'dart:math';

import 'package:admin_panel/features/partner/bookings/domain/entities/booking_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '_generators.dart';

void main() {
  group('Property 4: Status label mapping is total', () {
    /// The canonical expected mapping.
    final expectedLabels = {
      BookingStatus.waiting: 'Waiting',
      BookingStatus.onProcess: 'On process',
      BookingStatus.canceled: 'Canceled',
      BookingStatus.finished: 'Finished',
    };

    test('labelFor returns the correct non-empty label for random statuses '
        '(>= $kPropertyIterations iterations)', () {
      final rng = Random(55);
      for (var i = 0; i < kPropertyIterations; i++) {
        final status = randomStatus(rng);
        final label = labelFor(status);

        // Non-null, non-empty
        expect(label, isNotEmpty, reason: 'label for $status is empty');

        // Matches canonical mapping
        expect(
          label,
          expectedLabels[status],
          reason: 'label for $status should be "${expectedLabels[status]}"',
        );
      }
    });

    test('labelFor covers all enum values exhaustively', () {
      for (final status in BookingStatus.values) {
        final label = labelFor(status);
        expect(label, isNotEmpty);
        expect(label, expectedLabels[status]);
      }
    });

    test('labelFor never throws for any BookingStatus value', () {
      for (final status in BookingStatus.values) {
        expect(() => labelFor(status), returnsNormally);
      }
    });
  });
}
