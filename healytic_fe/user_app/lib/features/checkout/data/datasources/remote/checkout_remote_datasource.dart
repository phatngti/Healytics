import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/checkout/domain/entities/booking.entity.dart';
import 'package:user_app/features/checkout/domain/entities/checkout.entity.dart';
import 'package:user_app/features/checkout/domain/entities/momo_payment.entity.dart';
import 'package:user_openapi/api.dart';
import 'checkout_mock_data.dart';

// ────────────────────────────────────────────────────
// Abstract Interface
// ────────────────────────────────────────────────────

/// Contract for fetching checkout data from a remote
/// source.
abstract class CheckoutRemoteDatasource {
  /// Retrieves the full checkout payload.
  Future<CheckoutData> getCheckoutData();

  /// Starts an async checkout, returning a ticket.
  Future<AsyncCheckoutResult> asyncCheckout({
    required String userId,
    required String staffId,
    required String startTime,
    String? productId,
    required String idempotencyKey,
  });

  /// Polls the status of a checkout ticket.
  Future<CheckoutTicketEntity> getTicketStatus(
    String ticketId,
  );

  /// Fetches a booking by its ID.
  Future<BookingEntity> getBookingById(String bookingId);

  /// Acquires a micro-lock on a time slot.
  Future<MicroLockResult> acquireMicroLock({
    required String staffId,
    required String startTime,
    String? productId,
  });

  /// Creates a MoMo one-time payment and returns the
  /// redirect URLs.
  Future<MoMoPaymentResult> createMoMoPayment(
    String bookingId,
  );

  /// Requests a MoMo refund for a completed payment.
  Future<void> refundMoMoPayment({
    required String bookingId,
    required int transId,
  });
}

// ────────────────────────────────────────────────────
// Real Implementation
// ────────────────────────────────────────────────────

/// Real API implementation backed by OpenAPI clients.
class CheckoutRemoteDatasourceImpl
    implements CheckoutRemoteDatasource {
  static final _log =
      Logger('CheckoutRemoteDatasourceImpl');

  final ApiService _apiService;

  const CheckoutRemoteDatasourceImpl(this._apiService);

  @override
  Future<CheckoutData> getCheckoutData() async {
    _log.info('getCheckoutData not wired to API');
    throw UnimplementedError(
      'Real checkout data API not implemented yet',
    );
  }

  @override
  Future<AsyncCheckoutResult> asyncCheckout({
    required String userId,
    required String staffId,
    required String startTime,
    String? productId,
    required String idempotencyKey,
  }) async {
    final dto = AsyncCheckoutDto(
      userId: userId,
      staffId: staffId,
      startTime: startTime,
      productId: productId,
      idempotencyKey: idempotencyKey,
    );

    final response = await _apiService
        .userBookingsApi
        .bookingControllerAsyncCheckout(dto);

    if (response == null) {
      throw Exception('Empty response from checkout');
    }

    return AsyncCheckoutResult(
      ticketId: response.ticketId,
      status: response.status,
      message: response.message,
    );
  }

  @override
  Future<CheckoutTicketEntity> getTicketStatus(
    String ticketId,
  ) async {
    final dto = await _apiService
        .userBookingsApi
        .bookingControllerGetTicketStatus(ticketId);

    if (dto == null) {
      throw Exception('Ticket not found: $ticketId');
    }

    return _mapTicketDto(dto);
  }

  @override
  Future<BookingEntity> getBookingById(
    String bookingId,
  ) async {
    final dto = await _apiService
        .userBookingsApi
        .bookingControllerGetBooking(bookingId);

    if (dto == null) {
      throw Exception('Booking not found: $bookingId');
    }

    return _mapBookingDto(dto);
  }

  @override
  Future<MicroLockResult> acquireMicroLock({
    required String staffId,
    required String startTime,
    String? productId,
  }) async {
    final dto = MicroLockDto(
      staffId: staffId,
      startTime: startTime,
      productId: productId,
    );

    final response = await _apiService
        .userSlotsApi
        .slotsControllerMicroLock(dto);

    if (response == null) {
      throw Exception('Empty micro-lock response');
    }

    return MicroLockResult(
      locked: response.locked,
      expiresIn: response.expiresIn.toInt(),
    );
  }

  @override
  Future<MoMoPaymentResult> createMoMoPayment(
    String bookingId,
  ) async {
    final dto = CreateMoMoPaymentDto(
      requestType: 'captureWallet',
    );

    final raw = await _apiService.userPaymentsApi
        .userPaymentControllerCreateMoMoPayment(
          bookingId,
          dto,
        );

    return _mapMoMoPaymentResponse(raw);
  }

  @override
  Future<void> refundMoMoPayment({
    required String bookingId,
    required int transId,
  }) async {
    final dto = CreateMoMoRefundDto(transId: transId);

    await _apiService.userPaymentsApi
        .userPaymentControllerRefundMoMoPayment(
          bookingId,
          dto,
        );
  }

  // ── DTO → Entity Mapping ───────────────────────────

  /// Defensively maps the untyped [Object?] response
  /// from the MoMo payment endpoint.
  MoMoPaymentResult _mapMoMoPaymentResponse(
    Object? raw,
  ) {
    final map =
        (raw as Map?)?.cast<String, dynamic>() ?? {};
    return MoMoPaymentResult(
      payUrl: map['payUrl']?.toString(),
      deeplink: map['deeplink']?.toString(),
      qrCodeUrl: map['qrCodeUrl']?.toString(),
      resultCode:
          (map['resultCode'] as num?)?.toInt() ?? -1,
      message: map['message']?.toString() ?? '',
    );
  }

  CheckoutTicketEntity _mapTicketDto(
    CheckoutTicketResponseDto dto,
  ) {
    return CheckoutTicketEntity(
      id: dto.id,
      userId: dto.userId,
      staffId: dto.staffId,
      startTime: dto.startTime,
      status: CheckoutTicketStatus.fromString(
        dto.status.value,
      ),
      idempotencyKey: dto.idempotencyKey,
      bookingId: dto.bookingId?.toString(),
      errorMessage: dto.errorMessage?.toString(),
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  BookingEntity _mapBookingDto(BookingResponseDto dto) {
    return BookingEntity(
      id: dto.id,
      userId: dto.userId,
      staffId: dto.staffId,
      productId: dto.productId?.toString(),
      startTime: dto.startTime,
      endTime: dto.endTime is DateTime
          ? dto.endTime! as DateTime
          : null,
      status: BookingStatus.fromString(dto.status.value),
      paymentUrl: dto.paymentUrl?.toString(),
      paymentExpiresAt: dto.paymentExpiresAt is DateTime
          ? dto.paymentExpiresAt! as DateTime
          : null,
      notes: dto.notes?.toString(),
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }
}

// ────────────────────────────────────────────────────
// Mock Implementation
// ────────────────────────────────────────────────────

/// Mock implementation returning fake data after a
/// simulated network delay.
class CheckoutRemoteDatasourceMock
    implements CheckoutRemoteDatasource {
  @override
  Future<CheckoutData> getCheckoutData() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    return kMockCheckoutData;
  }

  @override
  Future<AsyncCheckoutResult> asyncCheckout({
    required String userId,
    required String staffId,
    required String startTime,
    String? productId,
    required String idempotencyKey,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 600),
    );
    return kMockAsyncCheckoutResult;
  }

  int _pollCount = 0;

  @override
  Future<CheckoutTicketEntity> getTicketStatus(
    String ticketId,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 400),
    );

    _pollCount++;

    // Simulate PROCESSING for first 2 polls, then
    // SUCCESS.
    if (_pollCount < 3) {
      return kMockTicketProcessing;
    }

    _pollCount = 0;
    return kMockTicketSuccess;
  }

  @override
  Future<BookingEntity> getBookingById(
    String bookingId,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );
    return kMockBooking;
  }

  @override
  Future<MicroLockResult> acquireMicroLock({
    required String staffId,
    required String startTime,
    String? productId,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );
    return kMockMicroLockResult;
  }

  @override
  Future<MoMoPaymentResult> createMoMoPayment(
    String bookingId,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 400),
    );
    // Simulate a successful MoMo payment initiation.
    return const MoMoPaymentResult(
      payUrl: 'https://test-payment.momo.vn/v2/gateway'
          '/pay?t=MOCK_TOKEN',
      deeplink: 'momo://app?action=payWithApp'
          '&isScanQR=false'
          '&serviceType=app'
          '&sid=MOCK_SID'
          '&v=3.0',
      resultCode: 0,
      message: 'Successful.',
    );
  }

  @override
  Future<void> refundMoMoPayment({
    required String bookingId,
    required int transId,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );
    // No-op in mock.
  }
}

// ────────────────────────────────────────────────────
// Provider
// ────────────────────────────────────────────────────

/// Switches between real and mock implementations
/// using [AppEnvironment.useMock].
final checkoutRemoteDatasourceProvider =
    Provider<CheckoutRemoteDatasource>((ref) {
  if (AppEnvironment.current.useMock) {
    return CheckoutRemoteDatasourceMock();
  }

  return CheckoutRemoteDatasourceImpl(
    ref.read(apiServiceProvider),
  );
});
