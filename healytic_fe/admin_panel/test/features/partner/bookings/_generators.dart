// Feature: partner-bookings-management
// Shared generators for property-based tests.
//
// Provides hand-rolled random generators for domain entities,
// filters, sort options, viewport widths, and wire status strings.
// Each generator is deterministic given a [Random] seed so tests
// are reproducible on failure.

import 'dart:math';

import 'package:admin_panel/features/partner/bookings/domain/entities/booking.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_filters.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_slot.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_sort.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_status.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/customer.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/service.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/specialist.entity.dart';
import 'package:flutter/material.dart' show DateTimeRange;

/// Default iteration count for property tests.
const int kPropertyIterations = 100;

/// Generates a random string of [length] from ASCII printable
/// characters.
String randomString(Random rng, int length) {
  const chars =
      'abcdefghijklmnopqrstuvwxyz'
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      '0123456789 ';
  return String.fromCharCodes(
    List.generate(length, (_) => chars.codeUnitAt(rng.nextInt(chars.length))),
  );
}

/// Generates a random non-empty name string between 1 and
/// [maxLength] characters.
String randomName(Random rng, {int maxLength = 50}) {
  final length = 1 + rng.nextInt(maxLength);
  return randomString(rng, length).trim().isEmpty
      ? 'Name${rng.nextInt(1000)}'
      : randomString(rng, length);
}

/// Generates a random [BookingStatus].
BookingStatus randomStatus(Random rng) {
  return BookingStatus.values[rng.nextInt(BookingStatus.values.length)];
}

/// Generates a random [BookingSort].
BookingSort randomSort(Random rng) {
  return BookingSort.values[rng.nextInt(BookingSort.values.length)];
}

/// Generates a random [BookingSlot] with end strictly after
/// start on the same calendar day.
BookingSlot randomSlot(Random rng) {
  final year = 2025;
  final month = 1 + rng.nextInt(12);
  final day = 1 + rng.nextInt(28);
  final startHour = rng.nextInt(22); // 0..21
  final startMinute = rng.nextInt(60);
  final start = DateTime(year, month, day, startHour, startMinute);
  final durationMinutes = 15 + rng.nextInt(180); // 15..194 min
  final end = start.add(Duration(minutes: durationMinutes));
  // Ensure same calendar day
  final clampedEnd = end.day != start.day
      ? DateTime(year, month, day, 23, 59)
      : end;
  return BookingSlot(start: start, end: clampedEnd);
}

/// Generates a random [Customer].
Customer randomCustomer(Random rng) {
  return Customer(
    id: 'cu_${rng.nextInt(10000)}',
    fullName: randomName(rng, maxLength: 40),
    age: rng.nextInt(121), // 0..120
    avatarUrl: rng.nextBool() ? 'https://example.com/a.jpg' : null,
  );
}

/// Generates a random [Specialist].
Specialist randomSpecialist(Random rng) {
  return Specialist(
    id: 'sp_${rng.nextInt(10000)}',
    fullName: randomName(rng, maxLength: 40),
    roleLabel: randomName(rng, maxLength: 50),
    avatarUrl: rng.nextBool() ? 'https://example.com/s.jpg' : null,
  );
}

/// Generates a random [Service].
Service randomService(Random rng) {
  return Service(
    id: 'sv_${rng.nextInt(10000)}',
    name: randomName(rng, maxLength: 30),
    price: (rng.nextInt(100000) + 1).toDouble(),
    currencyCode: rng.nextBool() ? 'VND' : 'USD',
  );
}

/// Generates a random [Booking].
Booking randomBooking(Random rng) {
  return Booking(
    id: 'bk_${rng.nextInt(100000)}',
    customer: randomCustomer(rng),
    specialist: randomSpecialist(rng),
    service: randomService(rng),
    slot: randomSlot(rng),
    status: randomStatus(rng),
  );
}

/// Generates a list of [count] random bookings.
List<Booking> randomBookings(Random rng, {int? count}) {
  final n = count ?? (1 + rng.nextInt(20));
  return List.generate(n, (_) => randomBooking(rng));
}

/// Generates a random [BookingFilters].
BookingFilters randomFilters(Random rng) {
  // Random subset of statuses
  final statuses = <BookingStatus>{};
  for (final s in BookingStatus.values) {
    if (rng.nextBool()) statuses.add(s);
  }

  // Random date range (or null)
  DateTimeRange? dateRange;
  if (rng.nextBool()) {
    final startDay = 1 + rng.nextInt(25);
    final endDay = startDay + rng.nextInt(5);
    dateRange = DateTimeRange(
      start: DateTime(2025, 3, startDay),
      end: DateTime(2025, 3, endDay.clamp(1, 28)),
    );
  }

  // Random search query (or empty)
  final query = rng.nextBool()
      ? randomString(rng, 1 + rng.nextInt(10)).trim().toLowerCase()
      : '';

  return BookingFilters(
    statuses: statuses,
    dateRange: dateRange,
    searchQuery: query,
  );
}

/// Generates a random viewport width in [200, 1600] dp.
double randomViewportWidth(Random rng) {
  return 200.0 + rng.nextInt(1401).toDouble();
}

/// Generates a random wire status string. Includes valid
/// canonical values and random garbage.
String? randomWireStatus(Random rng) {
  final options = [
    'Waiting',
    'OnProcess',
    'Canceled',
    'Finished',
    null,
    '',
    'waiting',
    'ONPROCESS',
    'unknown',
    'cancelled',
    'done',
    '123',
    'On process',
    'WAITING',
    randomString(rng, 1 + rng.nextInt(20)),
  ];
  return options[rng.nextInt(options.length)];
}

/// The four canonical wire status strings.
const List<String> canonicalWireStatuses = [
  'Waiting',
  'OnProcess',
  'Canceled',
  'Finished',
];
