// Feature: partner-bookings-management
// Task 10.4: Responsive verification widget-test suite
//
// Drives BookingsDashboard at exactly 320, 393, 430, 768, and
// 1280 dp. Asserts column count, horizontal padding, gap, no
// RenderOverflowError, and ≥ 1 fully-visible BookingCard.
//
// Validates: Req 4.1–4.9, 9.4, Property 1, Property 2, Property 3

import 'package:admin_panel/features/partner/bookings/domain/entities/booking.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_filters.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_slot.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_sort.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_status.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/customer.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/service.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/specialist.entity.dart';
import 'package:admin_panel/features/partner/bookings/presentation/providers/bookings_controller.provider.dart';
import 'package:admin_panel/features/partner/bookings/presentation/providers/bookings_state.dart';
import 'package:admin_panel/features/partner/bookings/presentation/widgets/booking_card/booking_card.widget.dart';
import 'package:admin_panel/features/partner/bookings/presentation/widgets/booking_status_colors.theme.dart';
import 'package:admin_panel/features/partner/bookings/presentation/widgets/bookings_dashboard.widget.dart';
import 'package:admin_panel/features/partner/bookings/presentation/widgets/responsive_bookings_grid.widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Viewport height — tall enough to ensure at least one card
/// is fully visible even on narrow viewports where header +
/// filter bar consume vertical space.
const _viewportHeight = 1200.0;

/// Test fixture bookings — 8 records to fill the grid.
List<Booking> _testBookings() {
  return List.generate(8, (i) {
    return Booking(
      id: 'bk_test_$i',
      customer: Customer(id: 'cu_$i', fullName: 'Customer $i', age: 25 + i),
      specialist: Specialist(
        id: 'sp_$i',
        fullName: 'Dr. Specialist $i',
        roleLabel: 'Therapist',
      ),
      service: Service(
        id: 'sv_$i',
        name: 'Service $i',
        price: 100.0 * (i + 1),
        currencyCode: 'USD',
      ),
      slot: BookingSlot(
        start: DateTime(2025, 3, 14, 9 + i, 0),
        end: DateTime(2025, 3, 14, 10 + i, 0),
      ),
      status: BookingStatus.values[i % BookingStatus.values.length],
    );
  });
}

/// Builds a [BookingsState] pre-loaded with test bookings.
BookingsState _testState() {
  final bookings = _testBookings();
  return BookingsState(
    all: bookings,
    visible: bookings,
    filters: const BookingFilters(),
    sort: defaultBookingSort,
    refresh: const RefreshStatus.idle(),
  );
}

/// Wraps [BookingsDashboard] in a [ProviderScope] with the
/// controller overridden to return pre-loaded data and a
/// [MaterialApp] with the [BookingStatusColors] extension.
///
/// The viewport size is set via [tester.view] before pumping
/// so that [LayoutBuilder] receives the correct constraints.
Widget _buildTestApp(double width) {
  final state = _testState();

  return ProviderScope(
    overrides: [
      bookingsControllerProvider.overrideWith(() => _FakeController(state)),
      partnerBookingStatusRealtimeProvider.overrideWithValue(null),
    ],
    child: MaterialApp(
      theme: ThemeData.light().copyWith(
        extensions: const [BookingStatusColors.light],
      ),
      home: SizedBox(
        width: width,
        height: _viewportHeight,
        child: const Scaffold(body: BookingsDashboard()),
      ),
    ),
  );
}

/// Fake controller that immediately returns a pre-built state.
class _FakeController extends BookingsController {
  _FakeController(this._state);

  final BookingsState _state;

  @override
  Future<BookingsState> build() async => _state;
}

/// Breakpoint test configuration.
class _BreakpointSpec {
  const _BreakpointSpec({
    required this.width,
    required this.expectedColumns,
    required this.expectedPadding,
    required this.tierName,
  });

  final double width;
  final int expectedColumns;
  final double expectedPadding;
  final String tierName;
}

const _breakpoints = [
  _BreakpointSpec(
    width: 320,
    expectedColumns: 1,
    expectedPadding: 16,
    tierName: 'smallMobile',
  ),
  _BreakpointSpec(
    width: 393,
    expectedColumns: 1,
    expectedPadding: 20,
    tierName: 'mobile',
  ),
  _BreakpointSpec(
    width: 430,
    expectedColumns: 2,
    expectedPadding: 24,
    tierName: 'largeMobile',
  ),
  _BreakpointSpec(
    width: 768,
    expectedColumns: 3,
    expectedPadding: 24,
    tierName: 'tablet',
  ),
  _BreakpointSpec(
    width: 1280,
    expectedColumns: 4,
    expectedPadding: 24,
    tierName: 'desktop',
  ),
];

void main() {
  group('Responsive verification', () {
    for (final spec in _breakpoints) {
      group('at ${spec.width}dp (${spec.tierName})', () {
        testWidgets('renders ${spec.expectedColumns} column(s)', (
          tester,
        ) async {
          tester.view.physicalSize = Size(spec.width, _viewportHeight);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(_buildTestApp(spec.width));
          await tester.pumpAndSettle();

          // Verify column count via the pure function
          expect(columnsFor(spec.width), spec.expectedColumns);

          // Verify the GridView uses the correct count
          final gridFinder = find.byType(GridView);
          expect(gridFinder, findsOneWidget);

          final gridView = tester.widget<GridView>(gridFinder);
          final delegate =
              gridView.gridDelegate
                  as SliverGridDelegateWithFixedCrossAxisCount;
          expect(delegate.crossAxisCount, spec.expectedColumns);
        });

        testWidgets('applies ${spec.expectedPadding}dp horizontal padding', (
          tester,
        ) async {
          tester.view.physicalSize = Size(spec.width, _viewportHeight);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(_buildTestApp(spec.width));
          await tester.pumpAndSettle();

          // Verify padding via the pure function
          expect(getHorizontalPadding(spec.width), spec.expectedPadding);

          // Verify the GridView has the correct padding
          final gridFinder = find.byType(GridView);
          expect(gridFinder, findsOneWidget);

          final gridView = tester.widget<GridView>(gridFinder);
          expect(
            gridView.padding,
            EdgeInsets.symmetric(
              horizontal: spec.expectedPadding,
              vertical: kBookingsGridGap,
            ),
          );
        });

        testWidgets('uses 16dp gap on both axes', (tester) async {
          tester.view.physicalSize = Size(spec.width, _viewportHeight);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(_buildTestApp(spec.width));
          await tester.pumpAndSettle();

          final gridFinder = find.byType(GridView);
          expect(gridFinder, findsOneWidget);

          final gridView = tester.widget<GridView>(gridFinder);
          final delegate =
              gridView.gridDelegate
                  as SliverGridDelegateWithFixedCrossAxisCount;
          expect(delegate.crossAxisSpacing, 16.0);
          expect(delegate.mainAxisSpacing, 16.0);
        });

        testWidgets('no RenderOverflowError', (tester) async {
          tester.view.physicalSize = Size(spec.width, _viewportHeight);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          // Capture overflow errors
          final errors = <FlutterErrorDetails>[];
          final originalHandler = FlutterError.onError;
          FlutterError.onError = (details) {
            errors.add(details);
          };

          await tester.pumpWidget(_buildTestApp(spec.width));
          await tester.pumpAndSettle();

          FlutterError.onError = originalHandler;

          final overflowErrors = errors.where(
            (e) => e.toString().contains('overflowed'),
          );
          expect(
            overflowErrors,
            isEmpty,
            reason:
                'No RenderOverflowError at '
                '${spec.width}dp (${spec.tierName})',
          );
        });

        testWidgets('renders ≥ 1 fully-visible BookingCard', (tester) async {
          tester.view.physicalSize = Size(spec.width, _viewportHeight);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(_buildTestApp(spec.width));
          await tester.pumpAndSettle();

          final cardFinder = find.byType(BookingCard);
          expect(
            cardFinder,
            findsAtLeast(1),
            reason:
                'At least 1 BookingCard should be '
                'rendered at ${spec.width}dp',
          );

          // Verify at least one card is fully visible
          // (its render box is within the viewport)
          final cards = tester.widgetList<BookingCard>(cardFinder);
          var hasFullyVisible = false;

          for (final card in cards) {
            final element = tester.element(find.byWidget(card));
            final renderBox = element.renderObject as RenderBox?;
            if (renderBox == null || !renderBox.hasSize) {
              continue;
            }

            final position = renderBox.localToGlobal(Offset.zero);
            final size = renderBox.size;

            // Card is fully visible if entirely within
            // the viewport dimensions
            if (position.dx >= 0 &&
                position.dy >= 0 &&
                position.dx + size.width <= spec.width &&
                position.dy + size.height <= _viewportHeight) {
              hasFullyVisible = true;
              break;
            }
          }

          expect(
            hasFullyVisible,
            isTrue,
            reason:
                'At least 1 BookingCard should be '
                'fully visible at ${spec.width}dp',
          );
        });
      });
    }

    testWidgets('collapses controls on mouse-wheel scroll over card grid', (
      tester,
    ) async {
      const width = 1280.0;
      tester.view.physicalSize = const Size(width, _viewportHeight);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildTestApp(width));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('filter_sort_controls')), findsOneWidget);

      final gridCenter = tester.getCenter(find.byType(GridView));
      await tester.sendEventToBinding(
        PointerScrollEvent(
          position: gridCenter,
          scrollDelta: const Offset(0, 48),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('filter_sort_controls')), findsNothing);

      await tester.sendEventToBinding(
        PointerScrollEvent(
          position: gridCenter,
          scrollDelta: const Offset(0, -48),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('filter_sort_controls')), findsOneWidget);
    });
  });
}
