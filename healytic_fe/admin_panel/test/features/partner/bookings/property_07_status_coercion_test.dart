// Feature: partner-bookings-management, Property 7: Status coercion is total and maps unknown to Waiting
//
// For any string s (including null and the empty string),
// statusFromWire(s) returns a value from {waiting, onProcess,
// canceled, finished}; if s is one of the four canonical wire
// names the result is the matching status, otherwise the result
// is BookingStatus.waiting.
//
// Validates: Requirements 3.5

import 'dart:math';

import 'package:admin_panel/features/partner/bookings/domain/entities/booking_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '_generators.dart';

void main() {
  group('Property 7: Status coercion is total and maps unknown to Waiting', () {
    test('statusFromWire always returns a valid BookingStatus for '
        'random inputs (>= $kPropertyIterations iterations)', () {
      final rng = Random(11);
      for (var i = 0; i < kPropertyIterations; i++) {
        final wire = randomWireStatus(rng);
        final result = statusFromWire(wire);

        // Always returns a valid enum member
        expect(
          BookingStatus.values.contains(result),
          isTrue,
          reason: 'statusFromWire("$wire") returned invalid value',
        );
      }
    });

    test('canonical wire values map to their matching status', () {
      expect(statusFromWire('Waiting'), BookingStatus.waiting);
      expect(statusFromWire('OnProcess'), BookingStatus.onProcess);
      expect(statusFromWire('Canceled'), BookingStatus.canceled);
      expect(statusFromWire('Finished'), BookingStatus.finished);
    });

    test('non-canonical values coerce to BookingStatus.waiting '
        '(>= $kPropertyIterations iterations)', () {
      final rng = Random(22);
      final nonCanonical = <String?>[
        null,
        '',
        'waiting',
        'WAITING',
        'onProcess',
        'ONPROCESS',
        'canceled',
        'CANCELED',
        'finished',
        'FINISHED',
        'unknown',
        'On process',
        '123',
        'cancelled',
        'done',
      ];

      for (var i = 0; i < kPropertyIterations; i++) {
        final wire = nonCanonical[rng.nextInt(nonCanonical.length)];
        final result = statusFromWire(wire);
        expect(
          result,
          BookingStatus.waiting,
          reason: 'statusFromWire("$wire") should coerce to waiting',
        );
      }
    });

    test('statusFromWire never throws', () {
      final rng = Random(44);
      for (var i = 0; i < kPropertyIterations; i++) {
        final wire = randomWireStatus(rng);
        expect(
          () => statusFromWire(wire),
          returnsNormally,
          reason: 'statusFromWire("$wire") threw',
        );
      }
    });
  });
}
