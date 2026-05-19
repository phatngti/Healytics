// Feature: partner-bookings-management, Property 11: Repository drops only malformed bookings
//
// For any list of raw booking records where some have required
// fields (customer.fullName, specialist.fullName, service.name)
// missing or empty, the repository's returned list contains
// exactly the records whose required fields are all non-empty
// after trimming, and the repository never throws when at least
// one valid record is present.
//
// Validates: Requirements 6.7, 6.8

import 'dart:math';

import 'package:admin_panel/features/partner/bookings/data/repositories/bookings_impl.repository.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_slot.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_status.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/customer.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/service.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/specialist.entity.dart';
import 'package:admin_panel/features/partner/bookings/data/datasources/remote/bookings_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

import '_generators.dart';

/// A fake data source that returns a pre-configured list.
class _FakeDataSource implements BookingsRemoteDataSource {
  _FakeDataSource(this._bookings);
  final List<Booking> _bookings;

  @override
  Future<List<Booking>> listBookings() async => _bookings;
}

/// Returns true if a booking has all required fields non-empty.
bool _hasAllRequired(Booking b) {
  return b.customer.fullName.trim().isNotEmpty &&
      b.specialist.fullName.trim().isNotEmpty &&
      b.service.name.trim().isNotEmpty;
}

void main() {
  group('Property 11: Repository drops only malformed bookings', () {
    test('returned list contains exactly the valid records '
        '(>= $kPropertyIterations iterations)', () async {
      final rng = Random(55);
      for (var i = 0; i < kPropertyIterations; i++) {
        final count = 2 + rng.nextInt(10);
        final bookings = <Booking>[];

        for (var j = 0; j < count; j++) {
          // Randomly make some bookings malformed
          final malformType = rng.nextInt(5);
          String customerName;
          String specialistName;
          String serviceName;

          switch (malformType) {
            case 0:
              // Empty customer name
              customerName = rng.nextBool() ? '' : '   ';
              specialistName = randomName(rng, maxLength: 20);
              serviceName = randomName(rng, maxLength: 20);
            case 1:
              // Empty specialist name
              customerName = randomName(rng, maxLength: 20);
              specialistName = rng.nextBool() ? '' : '   ';
              serviceName = randomName(rng, maxLength: 20);
            case 2:
              // Empty service name
              customerName = randomName(rng, maxLength: 20);
              specialistName = randomName(rng, maxLength: 20);
              serviceName = rng.nextBool() ? '' : '   ';
            default:
              // Valid booking
              customerName = randomName(rng, maxLength: 20);
              specialistName = randomName(rng, maxLength: 20);
              serviceName = randomName(rng, maxLength: 20);
          }

          bookings.add(
            Booking(
              id: 'bk_${i}_$j',
              customer: Customer(
                id: 'cu_$j',
                fullName: customerName,
                age: rng.nextInt(121),
              ),
              specialist: Specialist(
                id: 'sp_$j',
                fullName: specialistName,
                roleLabel: 'Role',
              ),
              service: Service(
                id: 'sv_$j',
                name: serviceName,
                price: 100.0,
                currencyCode: 'USD',
              ),
              slot: BookingSlot(
                start: DateTime(2025, 3, 14, 9, 0),
                end: DateTime(2025, 3, 14, 10, 0),
              ),
              status: randomStatus(rng),
            ),
          );
        }

        final repo = BookingsRepositoryImpl(
          remoteDataSource: _FakeDataSource(bookings),
        );
        final result = await repo.listBookings();

        // Count expected valid bookings
        final expectedCount = bookings.where(_hasAllRequired).length;
        expect(
          result.length,
          expectedCount,
          reason:
              'Iteration $i: result.length=${result.length} '
              '!= expected=$expectedCount',
        );

        // Every returned booking has all required fields
        for (final b in result) {
          expect(
            _hasAllRequired(b),
            isTrue,
            reason:
                'Returned booking ${b.id} has missing required '
                'fields',
          );
        }
      }
    });

    test('repository never throws when at least one valid record', () async {
      for (var i = 0; i < kPropertyIterations; i++) {
        // Always include at least one valid booking
        final valid = Booking(
          id: 'bk_valid_$i',
          customer: Customer(id: 'cu_v', fullName: 'Valid Customer', age: 30),
          specialist: Specialist(
            id: 'sp_v',
            fullName: 'Valid Specialist',
            roleLabel: 'Doctor',
          ),
          service: Service(
            id: 'sv_v',
            name: 'Valid Service',
            price: 50.0,
            currencyCode: 'USD',
          ),
          slot: BookingSlot(
            start: DateTime(2025, 3, 14, 9, 0),
            end: DateTime(2025, 3, 14, 10, 0),
          ),
          status: BookingStatus.waiting,
        );

        // Add some malformed ones
        final malformed = Booking(
          id: 'bk_bad_$i',
          customer: Customer(id: 'cu_b', fullName: '', age: 25),
          specialist: Specialist(
            id: 'sp_b',
            fullName: 'Spec',
            roleLabel: 'Role',
          ),
          service: Service(
            id: 'sv_b',
            name: 'Svc',
            price: 10.0,
            currencyCode: 'USD',
          ),
          slot: BookingSlot(
            start: DateTime(2025, 3, 14, 9, 0),
            end: DateTime(2025, 3, 14, 10, 0),
          ),
          status: BookingStatus.canceled,
        );

        final bookings = [valid, malformed];
        final repo = BookingsRepositoryImpl(
          remoteDataSource: _FakeDataSource(bookings),
        );

        // Should not throw
        final result = await repo.listBookings();
        expect(result.length, greaterThanOrEqualTo(1));
      }
    });
  });
}
