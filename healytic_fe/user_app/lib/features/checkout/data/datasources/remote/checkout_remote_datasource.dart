import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/checkout/domain/entities/booking.entity.dart';
import 'package:user_app/features/checkout/domain/entities/checkout.entity.dart';
import 'package:user_app/features/checkout/domain/entities/momo_payment.entity.dart';
import 'package:user_app/features/checkout/domain/entities/payment_card.entity.dart';
import 'package:user_app/features/checkout/domain/entities/stripe_payment.entity.dart';
import 'package:user_openapi/api.dart' hide BookingStatus;
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
    String? staffId,
    required String startTime,
    String? productId,
    required String idempotencyKey,
    bool payLater = false,
    bool autoAssignStaff = false,
  });

  /// Polls the status of a checkout ticket.
  Future<CheckoutTicketEntity> getTicketStatus(String ticketId);

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
  Future<MoMoPaymentResult> createMoMoPayment(String bookingId);

  /// Confirms the signed MoMo return payload received
  /// through the app deeplink.
  Future<void> confirmMoMoReturn({
    required String bookingId,
    required Map<String, String> returnParams,
  });

  /// Requests a MoMo refund for a completed payment.
  Future<void> refundMoMoPayment({
    required String bookingId,
    required int transId,
  });

  /// Creates a Stripe PaymentIntent and returns the
  /// client secret for on-device confirmation.
  Future<StripePaymentResult> createStripePayment(
    String bookingId, {
    String? cardId,
  });

  /// Returns saved Stripe cards.
  Future<List<SavedPaymentCard>> listSavedPaymentCards();

  /// Creates a Stripe SetupIntent for adding a card.
  Future<StripeSetupIntentResult> createStripeSetupIntent();

  /// Persists metadata after PaymentSheet completes
  /// the SetupIntent.
  Future<SavedPaymentCard> confirmStripeSetupIntent({
    required String setupIntentId,
    bool setDefault = false,
  });

  /// Sets a saved card as default.
  Future<SavedPaymentCard> setDefaultPaymentCard(String cardId);

  /// Deletes a saved card and returns the refreshed list.
  Future<List<SavedPaymentCard>> deletePaymentCard(String cardId);

  /// Requests a full Stripe refund for a paid
  /// booking.
  Future<StripeRefundResult> refundStripePayment(String bookingId);
}

// ────────────────────────────────────────────────────
// Real Implementation
// ────────────────────────────────────────────────────

/// Real API implementation backed by OpenAPI clients.
class CheckoutRemoteDatasourceImpl implements CheckoutRemoteDatasource {
  static final _log = Logger('CheckoutRemoteDatasourceImpl');

  final ApiService _apiService;

  const CheckoutRemoteDatasourceImpl(this._apiService);

  @override
  Future<CheckoutData> getCheckoutData() async {
    _log.info('getCheckoutData not wired to API');
    throw UnimplementedError('Real checkout data API not implemented yet');
  }

  @override
  Future<AsyncCheckoutResult> asyncCheckout({
    required String userId,
    String? staffId,
    required String startTime,
    String? productId,
    required String idempotencyKey,
    bool payLater = false,
    bool autoAssignStaff = false,
  }) async {
    if (productId == null) {
      throw ArgumentError('productId is required for async checkout');
    }

    final response = await _apiService.apiClient.invokeAPI(
      '/user/bookings/async-checkout',
      'POST',
      const [],
      {
        'userId': userId,
        if (staffId != null && staffId.isNotEmpty) 'staffId': staffId,
        'startTime': startTime,
        'productId': productId,
        'idempotencyKey': idempotencyKey,
        'payLater': payLater,
        'autoAssignStaff': autoAssignStaff,
      },
      {},
      {},
      'application/json',
    );

    if (response.statusCode >= 400 || response.body.isEmpty) {
      throw Exception('Empty response from checkout');
    }

    final decoded = json.decode(response.body) as Map<String, dynamic>;
    return AsyncCheckoutResult(
      ticketId: decoded['ticketId']?.toString() ?? '',
      status: decoded['status']?.toString() ?? '',
      message: decoded['message']?.toString() ?? '',
    );
  }

  @override
  Future<CheckoutTicketEntity> getTicketStatus(String ticketId) async {
    final dto = await _apiService.userBookingsApi
        .bookingControllerGetTicketStatus(ticketId);

    if (dto == null) {
      throw Exception('Ticket not found: $ticketId');
    }

    return _mapTicketDto(dto);
  }

  @override
  Future<BookingEntity> getBookingById(String bookingId) async {
    final dto = await _apiService.userBookingsApi.bookingControllerGetBooking(
      bookingId,
    );

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

    final response = await _apiService.userSlotsApi.slotsControllerMicroLock(
      dto,
    );

    if (response == null) {
      throw Exception('Empty micro-lock response');
    }

    return MicroLockResult(
      locked: response.locked,
      expiresIn: response.expiresIn.toInt(),
    );
  }

  @override
  Future<MoMoPaymentResult> createMoMoPayment(String bookingId) async {
    final dto = CreateMoMoPaymentDto(requestType: 'captureWallet');

    final raw = await _apiService.userPaymentsApi
        .userPaymentControllerCreateMoMoPayment(bookingId, dto);

    return _mapMoMoPaymentResponse(raw);
  }

  @override
  Future<void> confirmMoMoReturn({
    required String bookingId,
    required Map<String, String> returnParams,
  }) async {
    final response = await _apiService.apiClient.invokeAPI(
      '/user/payments/momo/$bookingId/return',
      'POST',
      const [],
      _mapMoMoReturnPayload(returnParams),
      {},
      {},
      'application/json',
    );

    if (response.statusCode >= 400) {
      throw ApiException(
        response.statusCode,
        'Failed to verify MoMo payment return.',
      );
    }
  }

  @override
  Future<void> refundMoMoPayment({
    required String bookingId,
    required int transId,
  }) async {
    final dto = CreateMoMoRefundDto(transId: transId);

    await _apiService.userPaymentsApi.userPaymentControllerRefundMoMoPayment(
      bookingId,
      dto,
    );
  }

  // ── DTO → Entity Mapping ───────────────────────────

  /// Defensively maps the untyped [Object?] response
  /// from the MoMo payment endpoint.
  MoMoPaymentResult _mapMoMoPaymentResponse(Object? raw) {
    final map = (raw as Map?)?.cast<String, dynamic>() ?? {};
    return MoMoPaymentResult(
      payUrl: map['payUrl']?.toString(),
      deeplink: map['deeplink']?.toString(),
      qrCodeUrl: map['qrCodeUrl']?.toString(),
      resultCode: (map['resultCode'] as num?)?.toInt() ?? -1,
      message: map['message']?.toString() ?? '',
    );
  }

  Map<String, Object?> _mapMoMoReturnPayload(Map<String, String> params) {
    return {
      'partnerCode': params['partnerCode'],
      'orderId': params['orderId'],
      'requestId': params['requestId'],
      'amount': int.tryParse(params['amount'] ?? ''),
      'orderInfo': params['orderInfo'],
      'orderType': params['orderType'],
      'transId': int.tryParse(params['transId'] ?? ''),
      'resultCode': int.tryParse(params['resultCode'] ?? ''),
      'message': params['message'],
      'responseTime': int.tryParse(params['responseTime'] ?? ''),
      'payType': params['payType'],
      'extraData': params['extraData'],
      'signature': params['signature'],
      if (params['partnerUserId'] != null)
        'partnerUserId': params['partnerUserId'],
      if (params['storeId'] != null) 'storeId': params['storeId'],
      if (params['localMessage'] != null)
        'localMessage': params['localMessage'],
      if (params['paymentOption'] != null)
        'paymentOption': params['paymentOption'],
      if (params['userFee'] != null)
        'userFee': int.tryParse(params['userFee'] ?? ''),
      if (params['promotionInfo'] != null)
        'promotionInfo': params['promotionInfo'],
    };
  }

  CheckoutTicketEntity _mapTicketDto(CheckoutTicketResponseDto dto) {
    return CheckoutTicketEntity(
      id: dto.id,
      userId: dto.userId,
      staffId: dto.staffId,
      startTime: dto.startTime,
      status: CheckoutTicketStatus.fromString(dto.status.value),
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
      productId: dto.productId,
      startTime: dto.startTime,
      endTime: dto.endTime,
      status: BookingStatus.fromString(dto.status.value),
      paymentUrl: dto.paymentUrl,
      paymentExpiresAt: dto.paymentExpiresAt,
      notes: dto.notes,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  @override
  Future<StripePaymentResult> createStripePayment(
    String bookingId, {
    String? cardId,
  }) async {
    final response = await _apiService.apiClient.invokeAPI(
      '/user/payments/stripe/$bookingId',
      'POST',
      const [],
      {if (cardId != null) 'cardId': cardId},
      {},
      {},
      'application/json',
    );

    final dto = _decodeMapResponse(response, 'Failed to create Stripe payment');

    return StripePaymentResult(
      paymentIntentId: dto['paymentIntentId']?.toString() ?? '',
      clientSecret: dto['clientSecret']?.toString() ?? '',
      amount: _toInt(dto['amount']),
      currency: dto['currency']?.toString() ?? 'vnd',
      status: dto['status']?.toString() ?? '',
    );
  }

  @override
  Future<List<SavedPaymentCard>> listSavedPaymentCards() async {
    final response = await _apiService.apiClient.invokeAPI(
      '/user/payments/cards',
      'GET',
      const [],
      null,
      {},
      {},
      null,
    );

    return _decodeListResponse(
      response,
      'Failed to load saved cards',
    ).map(_mapSavedPaymentCard).toList(growable: false);
  }

  @override
  Future<StripeSetupIntentResult> createStripeSetupIntent() async {
    final response = await _apiService.apiClient.invokeAPI(
      '/user/payments/stripe/setup-intents',
      'POST',
      const [],
      <String, dynamic>{},
      {},
      {},
      'application/json',
    );

    final json = _decodeMapResponse(
      response,
      'Failed to create Stripe setup intent',
    );
    return StripeSetupIntentResult(
      setupIntentId: json['setupIntentId']?.toString() ?? '',
      clientSecret: json['clientSecret']?.toString() ?? '',
    );
  }

  @override
  Future<SavedPaymentCard> confirmStripeSetupIntent({
    required String setupIntentId,
    bool setDefault = false,
  }) async {
    final response = await _apiService.apiClient.invokeAPI(
      '/user/payments/stripe/setup-intents/$setupIntentId/confirm',
      'POST',
      const [],
      {'setDefault': setDefault},
      {},
      {},
      'application/json',
    );

    return _mapSavedPaymentCard(
      _decodeMapResponse(response, 'Failed to save payment card'),
    );
  }

  @override
  Future<SavedPaymentCard> setDefaultPaymentCard(String cardId) async {
    final response = await _apiService.apiClient.invokeAPI(
      '/user/payments/cards/$cardId/default',
      'PATCH',
      const [],
      <String, dynamic>{},
      {},
      {},
      'application/json',
    );

    return _mapSavedPaymentCard(
      _decodeMapResponse(response, 'Failed to set default card'),
    );
  }

  @override
  Future<List<SavedPaymentCard>> deletePaymentCard(String cardId) async {
    final response = await _apiService.apiClient.invokeAPI(
      '/user/payments/cards/$cardId',
      'DELETE',
      const [],
      null,
      {},
      {},
      null,
    );

    return _decodeListResponse(
      response,
      'Failed to delete payment card',
    ).map(_mapSavedPaymentCard).toList(growable: false);
  }

  @override
  Future<StripeRefundResult> refundStripePayment(String bookingId) async {
    final dto = await _apiService.userPaymentsApi
        .userPaymentControllerRefundStripePayment(bookingId);

    if (dto == null) {
      throw Exception('Empty Stripe refund response');
    }

    return StripeRefundResult(
      refundId: dto.refundId,
      amount: dto.amount.toInt(),
      currency: dto.currency,
      status: dto.status,
      paymentIntentId: dto.paymentIntentId,
    );
  }

  Map<String, dynamic> _decodeMapResponse(
    dynamic response,
    String failureMessage,
  ) {
    if (response.statusCode >= 400 || response.body.isEmpty) {
      throw ApiException(response.statusCode, failureMessage);
    }
    return (jsonDecode(response.body) as Map).cast<String, dynamic>();
  }

  List<Map<String, dynamic>> _decodeListResponse(
    dynamic response,
    String failureMessage,
  ) {
    if (response.statusCode >= 400 || response.body.isEmpty) {
      throw ApiException(response.statusCode, failureMessage);
    }
    return (jsonDecode(response.body) as List)
        .map((item) => (item as Map).cast<String, dynamic>())
        .toList(growable: false);
  }

  SavedPaymentCard _mapSavedPaymentCard(Map<String, dynamic> json) {
    return SavedPaymentCard(
      id: json['id']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      last4: json['last4']?.toString() ?? '',
      expMonth: _toInt(json['expMonth']),
      expYear: _toInt(json['expYear']),
      funding: json['funding']?.toString(),
      country: json['country']?.toString(),
      isDefault: json['isDefault'] == true,
    );
  }

  int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

// ────────────────────────────────────────────────────
// Mock Implementation
// ────────────────────────────────────────────────────

/// Mock implementation returning fake data after a
/// simulated network delay.
class CheckoutRemoteDatasourceMock implements CheckoutRemoteDatasource {
  final List<SavedPaymentCard> _cards = [
    const SavedPaymentCard(
      id: 'card_mock_001',
      brand: 'visa',
      last4: '4242',
      expMonth: 12,
      expYear: 2030,
      funding: 'credit',
      country: 'US',
      isDefault: true,
    ),
  ];

  @override
  Future<CheckoutData> getCheckoutData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockCheckoutData;
  }

  @override
  Future<AsyncCheckoutResult> asyncCheckout({
    required String userId,
    String? staffId,
    required String startTime,
    String? productId,
    required String idempotencyKey,
    bool payLater = false,
    bool autoAssignStaff = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return kMockAsyncCheckoutResult;
  }

  int _pollCount = 0;

  @override
  Future<CheckoutTicketEntity> getTicketStatus(String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 400));

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
  Future<BookingEntity> getBookingById(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return kMockBooking;
  }

  @override
  Future<MicroLockResult> acquireMicroLock({
    required String staffId,
    required String startTime,
    String? productId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return kMockMicroLockResult;
  }

  @override
  Future<MoMoPaymentResult> createMoMoPayment(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Simulate a successful MoMo payment initiation.
    return const MoMoPaymentResult(
      payUrl:
          'https://test-payment.momo.vn/v2/gateway'
          '/pay?t=MOCK_TOKEN',
      deeplink:
          'momo://app?action=payWithApp'
          '&isScanQR=false'
          '&serviceType=app'
          '&sid=MOCK_SID'
          '&v=3.0',
      resultCode: 0,
      message: 'Successful.',
    );
  }

  @override
  Future<void> confirmMoMoReturn({
    required String bookingId,
    required Map<String, String> returnParams,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // No-op in mock.
  }

  @override
  Future<void> refundMoMoPayment({
    required String bookingId,
    required int transId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // No-op in mock.
  }

  @override
  Future<StripePaymentResult> createStripePayment(
    String bookingId, {
    String? cardId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const StripePaymentResult(
      paymentIntentId: 'pi_mock_001',
      clientSecret: 'pi_mock_001_secret_mock',
      amount: 500000,
      currency: 'vnd',
      status: 'requires_payment_method',
    );
  }

  @override
  Future<List<SavedPaymentCard>> listSavedPaymentCards() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_cards);
  }

  @override
  Future<StripeSetupIntentResult> createStripeSetupIntent() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const StripeSetupIntentResult(
      setupIntentId: 'seti_mock_001',
      clientSecret: 'seti_mock_001_secret_mock',
    );
  }

  @override
  Future<SavedPaymentCard> confirmStripeSetupIntent({
    required String setupIntentId,
    bool setDefault = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final shouldDefault = setDefault || _cards.isEmpty;
    if (shouldDefault) {
      _replaceCards(_cards.map((card) => _copyCard(card, isDefault: false)));
    }
    final card = SavedPaymentCard(
      id: 'card_mock_${DateTime.now().millisecondsSinceEpoch}',
      brand: 'visa',
      last4: '4242',
      expMonth: 12,
      expYear: 2030,
      funding: 'credit',
      country: 'US',
      isDefault: shouldDefault,
    );
    _cards.add(card);
    return card;
  }

  @override
  Future<SavedPaymentCard> setDefaultPaymentCard(String cardId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    SavedPaymentCard? updated;
    _replaceCards(
      _cards.map((card) {
        final next = _copyCard(card, isDefault: card.id == cardId);
        if (next.id == cardId) updated = next;
        return next;
      }),
    );
    if (updated == null) {
      throw Exception('Card not found: $cardId');
    }
    return updated!;
  }

  @override
  Future<List<SavedPaymentCard>> deletePaymentCard(String cardId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final wasDefault = _cards.any(
      (card) => card.id == cardId && card.isDefault,
    );
    _cards.removeWhere((card) => card.id == cardId);
    if (wasDefault && _cards.isNotEmpty) {
      _cards[0] = _copyCard(_cards.first, isDefault: true);
    }
    return List.unmodifiable(_cards);
  }

  @override
  Future<StripeRefundResult> refundStripePayment(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const StripeRefundResult(
      refundId: 're_mock_001',
      amount: 500000,
      currency: 'vnd',
      status: 'succeeded',
      paymentIntentId: 'pi_mock_001',
    );
  }

  void _replaceCards(Iterable<SavedPaymentCard> cards) {
    _cards
      ..clear()
      ..addAll(cards);
  }

  SavedPaymentCard _copyCard(SavedPaymentCard card, {required bool isDefault}) {
    return SavedPaymentCard(
      id: card.id,
      brand: card.brand,
      last4: card.last4,
      expMonth: card.expMonth,
      expYear: card.expYear,
      funding: card.funding,
      country: card.country,
      isDefault: isDefault,
    );
  }
}

// ────────────────────────────────────────────────────
// Provider
// ────────────────────────────────────────────────────

/// Switches between real and mock implementations
/// using [AppEnvironment.useMock].
final checkoutRemoteDatasourceProvider = Provider<CheckoutRemoteDatasource>((
  ref,
) {
  if (AppEnvironment.current.useMock) {
    return CheckoutRemoteDatasourceMock();
  }

  return CheckoutRemoteDatasourceImpl(ref.read(apiServiceProvider));
});
