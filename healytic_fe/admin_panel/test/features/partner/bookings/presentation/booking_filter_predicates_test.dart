import 'package:admin_panel/features/partner/bookings/domain/entities/booking.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_filters.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_slot.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_sort.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_status.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/customer.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/service.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/specialist.entity.dart';
import 'package:admin_panel/features/partner/bookings/presentation/providers/booking_filter_predicates.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_test/flutter_test.dart';

/// Creates a test [Booking] with configurable fields.
Booking _makeBooking({
  String id = 'bk_001',
  String customerName = 'Alice Smith',
  int customerAge = 30,
  String specialistName = 'Dr. Bob',
  String specialistRole = 'Therapist',
  String serviceName = 'Massage',
  double servicePrice = 100.0,
  String currencyCode = 'USD',
  required DateTime slotStart,
  required DateTime slotEnd,
  BookingStatus status = BookingStatus.waiting,
}) {
  return Booking(
    id: id,
    customer: Customer(id: 'cu_$id', fullName: customerName, age: customerAge),
    specialist: Specialist(
      id: 'sp_$id',
      fullName: specialistName,
      roleLabel: specialistRole,
    ),
    service: Service(
      id: 'sv_$id',
      name: serviceName,
      price: servicePrice,
      currencyCode: currencyCode,
    ),
    slot: BookingSlot(start: slotStart, end: slotEnd),
    status: status,
  );
}

void main() {
  group('applyFilters', () {
    final bookings = [
      _makeBooking(
        id: 'bk_1',
        customerName: 'Alice Smith',
        specialistName: 'Dr. Bob',
        serviceName: 'Massage',
        slotStart: DateTime(2025, 3, 14, 9, 0),
        slotEnd: DateTime(2025, 3, 14, 10, 0),
        status: BookingStatus.waiting,
      ),
      _makeBooking(
        id: 'bk_2',
        customerName: 'Charlie Brown',
        specialistName: 'Dr. Eve',
        serviceName: 'Acupuncture',
        slotStart: DateTime(2025, 3, 15, 14, 0),
        slotEnd: DateTime(2025, 3, 15, 15, 0),
        status: BookingStatus.onProcess,
      ),
      _makeBooking(
        id: 'bk_3',
        customerName: 'Diana Prince',
        specialistName: 'Dr. Frank',
        serviceName: 'Yoga Session',
        slotStart: DateTime(2025, 3, 16, 8, 0),
        slotEnd: DateTime(2025, 3, 16, 9, 0),
        status: BookingStatus.finished,
      ),
      _makeBooking(
        id: 'bk_4',
        customerName: 'Edward Norton',
        specialistName: 'Dr. Grace',
        serviceName: 'Consultation',
        slotStart: DateTime(2025, 3, 17, 11, 0),
        slotEnd: DateTime(2025, 3, 17, 12, 0),
        status: BookingStatus.canceled,
      ),
    ];

    test('returns all bookings when no filters are active', () {
      const filters = BookingFilters();
      final result = applyFilters(bookings, filters);
      expect(result, hasLength(4));
    });

    test('filters by status set membership', () {
      const filters = BookingFilters(
        statuses: {BookingStatus.waiting, BookingStatus.finished},
      );
      final result = applyFilters(bookings, filters);
      expect(result, hasLength(2));
      expect(result[0].id, 'bk_1');
      expect(result[1].id, 'bk_3');
    });

    test('filters by date range inclusive', () {
      final filters = BookingFilters(
        dateRange: DateTimeRange(
          start: DateTime(2025, 3, 14),
          end: DateTime(2025, 3, 15),
        ),
      );
      final result = applyFilters(bookings, filters);
      expect(result, hasLength(2));
      expect(result[0].id, 'bk_1');
      expect(result[1].id, 'bk_2');
    });

    test('filters by search query case-insensitively', () {
      const filters = BookingFilters(searchQuery: 'alice');
      final result = applyFilters(bookings, filters);
      expect(result, hasLength(1));
      expect(result[0].id, 'bk_1');
    });

    test('search matches specialist name', () {
      const filters = BookingFilters(searchQuery: 'eve');
      final result = applyFilters(bookings, filters);
      expect(result, hasLength(1));
      expect(result[0].id, 'bk_2');
    });

    test('search matches service name', () {
      const filters = BookingFilters(searchQuery: 'yoga');
      final result = applyFilters(bookings, filters);
      expect(result, hasLength(1));
      expect(result[0].id, 'bk_3');
    });

    test('combines status and date range filters', () {
      final filters = BookingFilters(
        statuses: const {BookingStatus.waiting},
        dateRange: DateTimeRange(
          start: DateTime(2025, 3, 14),
          end: DateTime(2025, 3, 14),
        ),
      );
      final result = applyFilters(bookings, filters);
      expect(result, hasLength(1));
      expect(result[0].id, 'bk_1');
    });

    test('empty status set means All (no status filter)', () {
      const filters = BookingFilters(statuses: {});
      final result = applyFilters(bookings, filters);
      expect(result, hasLength(4));
    });
  });

  group('applySort', () {
    final bookings = [
      _makeBooking(
        id: 'bk_c',
        slotStart: DateTime(2025, 3, 16, 8, 0),
        slotEnd: DateTime(2025, 3, 16, 9, 0),
        status: BookingStatus.canceled,
      ),
      _makeBooking(
        id: 'bk_a',
        slotStart: DateTime(2025, 3, 14, 9, 0),
        slotEnd: DateTime(2025, 3, 14, 10, 0),
        status: BookingStatus.waiting,
      ),
      _makeBooking(
        id: 'bk_b',
        slotStart: DateTime(2025, 3, 15, 14, 0),
        slotEnd: DateTime(2025, 3, 15, 15, 0),
        status: BookingStatus.finished,
      ),
    ];

    test('startAsc sorts by slot.start ascending', () {
      final result = applySort(bookings, BookingSort.startAsc);
      expect(result[0].id, 'bk_a');
      expect(result[1].id, 'bk_b');
      expect(result[2].id, 'bk_c');
    });

    test('startDesc sorts by slot.start descending', () {
      final result = applySort(bookings, BookingSort.startDesc);
      expect(result[0].id, 'bk_c');
      expect(result[1].id, 'bk_b');
      expect(result[2].id, 'bk_a');
    });

    test('statusGrouping groups Waiting > OnProcess > '
        'Finished > Canceled with start ascending tiebreaker', () {
      final mixed = [
        _makeBooking(
          id: 'bk_f1',
          slotStart: DateTime(2025, 3, 16, 8, 0),
          slotEnd: DateTime(2025, 3, 16, 9, 0),
          status: BookingStatus.finished,
        ),
        _makeBooking(
          id: 'bk_w1',
          slotStart: DateTime(2025, 3, 15, 9, 0),
          slotEnd: DateTime(2025, 3, 15, 10, 0),
          status: BookingStatus.waiting,
        ),
        _makeBooking(
          id: 'bk_c1',
          slotStart: DateTime(2025, 3, 14, 11, 0),
          slotEnd: DateTime(2025, 3, 14, 12, 0),
          status: BookingStatus.canceled,
        ),
        _makeBooking(
          id: 'bk_o1',
          slotStart: DateTime(2025, 3, 17, 10, 0),
          slotEnd: DateTime(2025, 3, 17, 11, 0),
          status: BookingStatus.onProcess,
        ),
        _makeBooking(
          id: 'bk_w2',
          slotStart: DateTime(2025, 3, 14, 8, 0),
          slotEnd: DateTime(2025, 3, 14, 9, 0),
          status: BookingStatus.waiting,
        ),
      ];
      final result = applySort(mixed, BookingSort.statusGrouping);
      // Waiting group first (sorted by start)
      expect(result[0].id, 'bk_w2');
      expect(result[1].id, 'bk_w1');
      // OnProcess group
      expect(result[2].id, 'bk_o1');
      // Finished group
      expect(result[3].id, 'bk_f1');
      // Canceled group
      expect(result[4].id, 'bk_c1');
    });

    test('does not mutate the input list', () {
      final original = List<Booking>.of(bookings);
      applySort(bookings, BookingSort.startAsc);
      expect(bookings[0].id, original[0].id);
      expect(bookings[1].id, original[1].id);
      expect(bookings[2].id, original[2].id);
    });
  });

  group('formatPrice', () {
    test('formats VND with 2 decimal digits', () {
      final result = formatPrice(850000.0, 'VND');
      expect(result, contains('VND'));
      expect(result, contains('850'));
    });

    test('formats USD with dollar sign and 2 decimals', () {
      final result = formatPrice(99.5, 'USD');
      expect(result, contains('\$'));
      expect(result, contains('99'));
      expect(result, contains('50'));
    });

    test('handles zero price', () {
      final result = formatPrice(0.0, 'USD');
      expect(result, contains('0'));
    });
  });

  group('formatSlot', () {
    test('formats slot as HH:mm - HH:mm', () {
      final slot = BookingSlot(
        start: DateTime(2025, 3, 14, 9, 0),
        end: DateTime(2025, 3, 14, 10, 30),
      );
      final result = formatSlot(slot);
      expect(result, '09:00 - 10:30');
    });

    test('handles afternoon times', () {
      final slot = BookingSlot(
        start: DateTime(2025, 3, 14, 14, 15),
        end: DateTime(2025, 3, 14, 16, 45),
      );
      final result = formatSlot(slot);
      expect(result, '14:15 - 16:45');
    });
  });

  group('deriveInitials', () {
    test('derives two initials from two-word name', () {
      expect(deriveInitials('Alice Smith'), 'AS');
    });

    test('derives two initials from multi-word name', () {
      expect(deriveInitials('Dr. Linh Nguyen'), 'DN');
    });

    test('derives one initial from single-word name', () {
      expect(deriveInitials('Madonna'), 'M');
    });

    test('returns empty for empty string', () {
      expect(deriveInitials(''), '');
    });

    test('returns empty for whitespace-only string', () {
      expect(deriveInitials('   '), '');
    });

    test('uppercases initials', () {
      expect(deriveInitials('alice smith'), 'AS');
    });

    test('handles extra whitespace between words', () {
      expect(deriveInitials('  Alice   Smith  '), 'AS');
    });
  });
}
