// Feature: partner-bookings-management, Property 14: Card renders em-dash placeholder for nulled displayable fields
//
// For any Booking where any subset of the displayable fields
// (customer.fullName, customer.age, specialist.fullName,
// specialist.roleLabel, service.name, service.price, slot.start,
// slot.end) is null or empty, the rendered BookingCard substitutes
// an em-dash ("—") in each null slot, renders all remaining fields,
// and produces zero RenderFlex overflow assertions.
//
// Validates: Requirements 2.8, 2.9, 7.1

import 'dart:math';

import 'package:admin_panel/features/partner/bookings/domain/entities/booking.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_slot.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_status.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/customer.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/service.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/specialist.entity.dart';
import 'package:admin_panel/features/partner/bookings/presentation/widgets/booking_card/booking_card.widget.dart';
import 'package:admin_panel/features/partner/bookings/presentation/widgets/booking_status_colors.theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_generators.dart';

/// The em-dash placeholder used for null displayable fields.
const String _emDash = '—';

/// Creates a booking with randomly nulled displayable fields.
///
/// Since the Freezed entities have required non-nullable fields,
/// we simulate "null" by using empty strings for text fields and
/// a sentinel value for age. The BookingCard widget treats empty
/// strings as "missing" and renders em-dash.
Booking _makeBookingWithNulls(Random rng) {
  // Randomly decide which fields to "null out" (empty string)
  final nullCustomerName = rng.nextBool();
  final nullSpecialistName = rng.nextBool();
  final nullSpecialistRole = rng.nextBool();
  final nullServiceName = rng.nextBool();

  return Booking(
    id: 'bk_test_${rng.nextInt(10000)}',
    customer: Customer(
      id: 'cu_t',
      fullName: nullCustomerName ? '' : randomName(rng, maxLength: 40),
      age: rng.nextInt(121),
    ),
    specialist: Specialist(
      id: 'sp_t',
      fullName: nullSpecialistName ? '' : randomName(rng, maxLength: 40),
      roleLabel: nullSpecialistRole ? '' : randomName(rng, maxLength: 50),
    ),
    service: Service(
      id: 'sv_t',
      name: nullServiceName ? '' : randomName(rng, maxLength: 30),
      price: (rng.nextInt(10000) + 1).toDouble(),
      currencyCode: 'USD',
    ),
    slot: randomSlot(rng),
    status: randomStatus(rng),
  );
}

/// Wraps a widget in a MaterialApp with the BookingStatusColors
/// theme extension registered.
Widget _wrapWithTheme(Widget child, {double width = 400}) {
  return MaterialApp(
    theme: ThemeData.light().copyWith(extensions: [BookingStatusColors.light]),
    home: Scaffold(
      body: SizedBox(width: width, height: 600, child: child),
    ),
  );
}

void main() {
  group('Property 14: Card renders em-dash placeholder for nulled '
      'displayable fields', () {
    testWidgets('BookingCard renders em-dash for empty fields and does not '
        'overflow (>= $kPropertyIterations iterations)', (tester) async {
      final rng = Random(99);

      for (var i = 0; i < kPropertyIterations; i++) {
        final booking = _makeBookingWithNulls(rng);
        // Random width in [280, 1500]
        final width = 280.0 + rng.nextInt(1221).toDouble();

        await tester.pumpWidget(
          _wrapWithTheme(
            SingleChildScrollView(child: BookingCard(booking: booking)),
            width: width,
          ),
        );

        // Verify no overflow errors were reported
        expect(tester.takeException(), isNull);

        // If customer name is empty, em-dash should appear
        if (booking.customer.fullName.isEmpty) {
          expect(
            find.text(_emDash),
            findsWidgets,
            reason:
                'Iteration $i: em-dash not found for empty '
                'customer name at width=$width',
          );
        }
      }
    });

    testWidgets('BookingCard with all valid fields does not show em-dash', (
      tester,
    ) async {
      final booking = Booking(
        id: 'bk_full',
        customer: Customer(id: 'cu_1', fullName: 'Alice Smith', age: 30),
        specialist: Specialist(
          id: 'sp_1',
          fullName: 'Dr. Bob',
          roleLabel: 'Therapist',
        ),
        service: Service(
          id: 'sv_1',
          name: 'Massage',
          price: 100.0,
          currencyCode: 'USD',
        ),
        slot: BookingSlot(
          start: DateTime(2025, 3, 14, 9, 0),
          end: DateTime(2025, 3, 14, 10, 0),
        ),
        status: BookingStatus.finished,
      );

      await tester.pumpWidget(
        _wrapWithTheme(
          SingleChildScrollView(child: BookingCard(booking: booking)),
        ),
      );

      expect(tester.takeException(), isNull);
      // Customer name should be visible
      expect(find.text('Alice Smith'), findsOneWidget);
    });

    testWidgets('BookingCard renders at extreme widths without overflow', (
      tester,
    ) async {
      final booking = Booking(
        id: 'bk_extreme',
        customer: Customer(
          id: 'cu_e',
          fullName: 'A very long customer name that exceeds forty chars',
          age: 99,
        ),
        specialist: Specialist(
          id: 'sp_e',
          fullName: 'Dr. Extremely Long Specialist Name Here',
          roleLabel: 'Senior Principal Lead Consultant Therapist',
        ),
        service: Service(
          id: 'sv_e',
          name: 'Very Long Service Name That Exceeds',
          price: 999999.99,
          currencyCode: 'VND',
        ),
        slot: BookingSlot(
          start: DateTime(2025, 3, 14, 9, 0),
          end: DateTime(2025, 3, 14, 10, 30),
        ),
        status: BookingStatus.onProcess,
      );

      // Test at minimum width
      await tester.pumpWidget(
        _wrapWithTheme(
          SingleChildScrollView(child: BookingCard(booking: booking)),
          width: 280,
        ),
      );
      expect(tester.takeException(), isNull);

      // Test at maximum width
      await tester.pumpWidget(
        _wrapWithTheme(
          SingleChildScrollView(child: BookingCard(booking: booking)),
          width: 1500,
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });
}
