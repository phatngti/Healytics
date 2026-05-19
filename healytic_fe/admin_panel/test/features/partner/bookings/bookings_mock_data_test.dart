import 'package:admin_panel/features/partner/bookings/data/datasources/remote/bookings_mock_data.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mockBookings', () {
    test('covers the full bookings dashboard fixture contract', () {
      expect(mockBookings, hasLength(greaterThanOrEqualTo(12)));

      final statuses = mockBookings.map((booking) => booking.status).toSet();
      expect(statuses, containsAll(BookingStatus.values));

      final ids = mockBookings.map((booking) => booking.id).toSet();
      expect(ids, hasLength(mockBookings.length));

      final longNameRecords = mockBookings.where((booking) {
        return booking.customer.fullName.length > 30 ||
            booking.specialist.fullName.length > 30 ||
            booking.service.name.length > 30;
      });
      expect(longNameRecords, hasLength(greaterThanOrEqualTo(3)));

      final shortNameRecords = mockBookings.where((booking) {
        return booking.customer.fullName.length <= 10 ||
            booking.specialist.fullName.length <= 10 ||
            booking.service.name.length <= 10;
      });
      expect(shortNameRecords, hasLength(greaterThanOrEqualTo(3)));
    });

    test('contains only valid entity data that the UI can render', () {
      for (final booking in mockBookings) {
        expect(booking.customer.fullName.trim(), isNotEmpty);
        expect(booking.customer.age, inInclusiveRange(0, 120));
        expect(booking.specialist.fullName.trim(), isNotEmpty);
        expect(booking.specialist.roleLabel.trim(), isNotEmpty);
        expect(booking.service.name.trim(), isNotEmpty);
        expect(booking.service.price, greaterThanOrEqualTo(0));
        expect(booking.service.currencyCode.trim(), isNotEmpty);
        expect(booking.slot.end.isAfter(booking.slot.start), isTrue);
        expect(booking.slot.end.year, booking.slot.start.year);
        expect(booking.slot.end.month, booking.slot.start.month);
        expect(booking.slot.end.day, booking.slot.start.day);
      }
    });

    test('exercises initials fallback and network avatar states', () {
      expect(
        mockBookings.any((booking) => booking.customer.avatarUrl == null),
        isTrue,
      );
      expect(
        mockBookings.any((booking) => booking.customer.avatarUrl != null),
        isTrue,
      );
      expect(
        mockBookings.any((booking) => booking.specialist.avatarUrl == null),
        isTrue,
      );
      expect(
        mockBookings.any((booking) => booking.specialist.avatarUrl != null),
        isTrue,
      );
    });
  });
}
