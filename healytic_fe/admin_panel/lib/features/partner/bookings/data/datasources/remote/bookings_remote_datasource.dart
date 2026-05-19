import 'dart:math';

import 'package:admin_openapi/api.dart' as api;
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/bookings/data/datasources/remote/bookings_mock_data.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_slot.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_status.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/customer.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/service.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/specialist.entity.dart';

// ============================================================
// 1. ABSTRACT INTERFACE
// ============================================================

/// Contract for fetching partner bookings from a remote source.
///
/// Implementations return raw [Booking] entities decoded from
/// JSON. The repository layer is responsible for dropping
/// malformed records and coercing unknown status values.
abstract class BookingsRemoteDataSource {
  /// Fetches the partner's booking list.
  Future<List<Booking>> listBookings();
}

// ============================================================
// 2. REAL API IMPLEMENTATION
// ============================================================

/// Real implementation backed by the generated OpenAPI client.
///
class BookingsRemoteDataSourceImpl implements BookingsRemoteDataSource {
  /// Creates an instance with the shared [ApiService].
  BookingsRemoteDataSourceImpl({required ApiService apiService})
    : _apiService = apiService;

  final ApiService _apiService;

  @override
  Future<List<Booking>> listBookings() async {
    final dtos = await _apiService.partnerBookingsApi
        .partnerBookingsControllerListBookings();
    return dtos?.map(_mapBooking).toList(growable: false) ?? const <Booking>[];
  }

  Booking _mapBooking(api.PartnerBookingResponseDto dto) {
    return Booking(
      id: dto.id,
      customer: Customer(
        id: dto.customer.id,
        fullName: dto.customer.fullName,
        age: dto.customer.age.toInt(),
        avatarUrl: dto.customer.avatarUrl?.toString(),
      ),
      specialist: Specialist(
        id: dto.specialist.id,
        fullName: dto.specialist.fullName,
        roleLabel: dto.specialist.roleLabel,
        avatarUrl: dto.specialist.avatarUrl?.toString(),
      ),
      service: Service(
        id: dto.service.id,
        name: dto.service.name,
        categoryName: dto.service.categoryName,
        price: dto.service.price.toDouble(),
        currencyCode: dto.service.currencyCode,
      ),
      slot: BookingSlot(start: dto.slot.start, end: dto.slot.end),
      status: _mapStatus(dto.status),
    );
  }

  BookingStatus _mapStatus(api.PartnerBookingStatus status) {
    if (status == api.PartnerBookingStatus.onProcess) {
      return BookingStatus.onProcess;
    }
    if (status == api.PartnerBookingStatus.finished) {
      return BookingStatus.finished;
    }
    if (status == api.PartnerBookingStatus.canceled) {
      return BookingStatus.canceled;
    }
    return BookingStatus.waiting;
  }
}

// ============================================================
// 3. MOCK IMPLEMENTATION
// ============================================================

/// Mock data source returning fixture data after a simulated
/// network delay of 300–800 ms (Req 8.4).
///
/// When [StoreKey.mockBookingsSimulateFailure] is `true`, the
/// mock throws an [Exception] after the same latency window so
/// the Error_State can be exercised without a backend (Req 8.5).
class BookingsRemoteDataSourceMock implements BookingsRemoteDataSource {
  final _random = Random();

  @override
  Future<List<Booking>> listBookings() async {
    final delayMs = 300 + _random.nextInt(501); // 300..800
    await Future.delayed(Duration(milliseconds: delayMs));

    final simulateFailure = Store.get(
      StoreKey.mockBookingsSimulateFailure,
      false,
    );
    if (simulateFailure) {
      throw Exception(
        'Simulated bookings fetch failure '
        '(mockBookingsSimulateFailure is enabled)',
      );
    }

    return mockBookings;
  }
}
