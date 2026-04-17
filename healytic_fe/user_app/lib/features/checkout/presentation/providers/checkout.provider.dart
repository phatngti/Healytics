import 'package:logging/logging.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';
import 'package:user_app/features/checkout/data/provider/checkout.provider.dart';
import 'package:user_app/features/checkout/domain/entities/booking.entity.dart';
import 'package:user_app/features/checkout/domain/entities/booking_params.entity.dart';
import 'package:user_app/features/checkout/domain/entities/checkout.entity.dart';

part 'checkout.provider.g.dart';

/// Holds the booking parameters set by the service
/// details screen before navigating to checkout.
///
/// Reset to `null` when the checkout flow completes
/// or is cancelled.
@Riverpod(keepAlive: true)
class BookingParamsNotifier extends _$BookingParamsNotifier {
  @override
  BookingParams? build() => null;

  /// Sets the booking parameters before navigation.
  void set(BookingParams params) => state = params;

  /// Clears the parameters after checkout completes.
  void clear() => state = null;
}

/// Tracks the async checkout submission lifecycle.
enum CheckoutSubmissionStatus {
  /// No submission in progress.
  idle,

  /// Sending the async checkout request.
  submitting,

  /// Polling for ticket result.
  polling,

  /// Checkout succeeded — booking created.
  success,

  /// Checkout failed.
  failed,

  /// MoMo payment URL obtained; waiting for the user
  /// to complete payment in the MoMo app.
  awaitingMoMoPayment,

  /// Re-fetching the booking to confirm the payment
  /// was captured by the backend IPN.
  verifyingPayment,
}

/// Presentation state for the checkout screen.
class CheckoutState {
  final CheckoutData checkoutData;
  final PaymentMethodType selectedPayment;
  final bool useCoins;
  final BookingParams? bookingParams;
  final CheckoutSubmissionStatus submissionStatus;
  final String? errorMessage;
  final BookingEntity? booking;

  /// MoMo native deep link (e.g. `momo://…`).
  final String? moMoDeeplink;

  /// MoMo web redirect URL (fallback).
  final String? moMoPayUrl;

  const CheckoutState({
    required this.checkoutData,
    this.selectedPayment = PaymentMethodType.card,
    this.useCoins = false,
    this.bookingParams,
    this.submissionStatus = CheckoutSubmissionStatus.idle,
    this.errorMessage,
    this.booking,
    this.moMoDeeplink,
    this.moMoPayUrl,
  });

  /// Recomputed total considering coin toggle.
  int get effectiveTotal {
    final summary = checkoutData.summary;
    final coins = useCoins ? summary.coinsUsed : 0;
    return summary.subtotal -
        summary.shopDiscount -
        summary.platformVoucher -
        coins;
  }

  /// Recomputed saved amount.
  int get effectiveSaved {
    final summary = checkoutData.summary;
    final coins = useCoins ? summary.coinsUsed : 0;
    return summary.shopDiscount + summary.platformVoucher + coins;
  }

  /// Whether a submission is currently in progress.
  bool get isSubmitting =>
      submissionStatus == CheckoutSubmissionStatus.submitting ||
      submissionStatus == CheckoutSubmissionStatus.polling ||
      submissionStatus == CheckoutSubmissionStatus.verifyingPayment;

  CheckoutState copyWith({
    CheckoutData? checkoutData,
    PaymentMethodType? selectedPayment,
    bool? useCoins,
    BookingParams? bookingParams,
    CheckoutSubmissionStatus? submissionStatus,
    String? errorMessage,
    BookingEntity? booking,
    String? moMoDeeplink,
    String? moMoPayUrl,
  }) {
    return CheckoutState(
      checkoutData: checkoutData ?? this.checkoutData,
      selectedPayment: selectedPayment ?? this.selectedPayment,
      useCoins: useCoins ?? this.useCoins,
      bookingParams: bookingParams ?? this.bookingParams,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      errorMessage: errorMessage,
      booking: booking ?? this.booking,
      moMoDeeplink: moMoDeeplink ?? this.moMoDeeplink,
      moMoPayUrl: moMoPayUrl ?? this.moMoPayUrl,
    );
  }
}

/// Parses a price string like "\$350.00" or
/// "850,000 VND" into an integer (cents / đồng).
int _parsePrice(String raw) {
  final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  return int.tryParse(digits) ?? 0;
}

/// Max polling attempts (2s each → 60s timeout).
const _kMaxPollAttempts = 30;

/// Interval between ticket status polls.
const _kPollInterval = Duration(seconds: 2);

/// Notifier managing checkout screen interactions.
///
/// Builds [CheckoutData] directly from [BookingParams]
/// set by the service details screen — no remote fetch.
@riverpod
class CheckoutNotifier extends _$CheckoutNotifier {
  static final _log = Logger('CheckoutNotifier');

  @override
  Future<CheckoutState> build() async {
    final params = ref.read(bookingParamsProvider);

    if (params == null) {
      throw StateError(
        'BookingParams must be set before '
        'navigating to checkout.',
      );
    }

    final price = _parsePrice(params.price);

    final item = CheckoutItem(
      id: params.serviceId,
      name: params.serviceName,
      imageUrl: params.serviceImageUrl,
      vendorName: params.clinicName,
      vendorIcon: 'local_hospital',
      vendorAddress: params.clinicAddress,
      duration: params.selectedTimeSlot,
      specialistName: params.employeeName,
      originalPrice: price,
      discountedPrice: price,
    );

    const customer = CustomerDetails(name: '', phone: '', address: '');

    const paymentMethods = <PaymentMethodOption>[
      PaymentMethodOption(
        type: PaymentMethodType.card,
        label: 'Credit/Debit Card',
      ),
      PaymentMethodOption(
        type: PaymentMethodType.eWallet,
        label: 'E-Wallet (Momo/ZaloPay)',
      ),
      PaymentMethodOption(type: PaymentMethodType.payLater, label: 'Pay Later'),
    ];

    final summary = CheckoutSummary(
      subtotal: price,
      shopDiscount: 0,
      platformVoucher: 0,
      coinsUsed: 0,
    );

    final checkoutData = CheckoutData(
      customer: customer,
      items: [item],
      coinBalance: 0,
      coinValue: 0,
      paymentMethods: paymentMethods,
      summary: summary,
    );

    return CheckoutState(checkoutData: checkoutData, bookingParams: params);
  }

  /// Selects a payment method.
  void selectPaymentMethod(PaymentMethodType type) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(selectedPayment: type));
  }

  /// Toggles the coin redemption switch.
  void toggleCoins(bool value) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(useCoins: value));
  }

  /// Initiates the async checkout flow:
  /// 1. POST async-checkout
  /// 2. Poll ticket status until SUCCESS/FAILED
  /// 3. Fetch booking on success
  /// 4. If eWallet selected → initiate MoMo payment
  Future<void> confirmBooking() async {
    final current = state.value;
    if (current == null) return;
    if (current.isSubmitting) return;

    final params = current.bookingParams;
    if (params == null) {
      _setError('Missing booking parameters.');
      return;
    }

    final userId = ref.read(currentUserIdProvider);
    if (userId == null || userId.isEmpty) {
      _setError('Please log in to continue.');
      return;
    }

    final repo = ref.read(checkoutRepositoryProvider);

    // ── Step 1: Start async checkout ──────────
    _setStatus(CheckoutSubmissionStatus.submitting);

    try {
      final startTime = _buildStartTimeIso(params);
      final idempotencyKey =
          'checkout_${params.serviceId}_'
          '${DateTime.now().millisecondsSinceEpoch}';

      final result = await repo.asyncCheckout(
        userId: userId,
        staffId: params.employeeId,
        startTime: startTime,
        productId: params.serviceId,
        idempotencyKey: idempotencyKey,
      );

      // Fast-fail: slot already taken.
      if (result.status == 'FAILED') {
        _setError(result.message);
        return;
      }

      // ── Step 2: Poll ticket status ──────────
      _setStatus(CheckoutSubmissionStatus.polling);

      final ticket = await _pollTicket(repo, result.ticketId);

      if (ticket.status == CheckoutTicketStatus.success &&
          ticket.bookingId != null) {
        // ── Step 3: Fetch booking details ─────
        final booking = await repo.getBookingById(ticket.bookingId!);

        // ── Step 4: MoMo payment if applicable ─
        final isMoMo = current.selectedPayment == PaymentMethodType.eWallet;
        if (isMoMo && booking.status == BookingStatus.pendingPayment) {
          await _initiateMoMoPayment(booking);
        } else {
          _setSuccess(booking);
        }
      } else {
        _setError(ticket.errorMessage ?? 'Checkout failed. Please try again.');
      }
    } catch (e, st) {
      _log.severe('Checkout error', e, st);
      _setError('$e');
    }
  }

  /// Creates a MoMo payment for the booking and
  /// transitions to [awaitingMoMoPayment].
  Future<void> _initiateMoMoPayment(BookingEntity booking) async {
    final repo = ref.read(checkoutRepositoryProvider);
    try {
      final result = await repo.createMoMoPayment(booking.id);

      if (!result.isSuccess) {
        _setError(
          result.message.isNotEmpty
              ? result.message
              : 'Failed to initiate MoMo payment.',
        );
        return;
      }

      final current = state.value;
      if (current == null) return;

      state = AsyncValue.data(
        current.copyWith(
          submissionStatus: CheckoutSubmissionStatus.awaitingMoMoPayment,
          booking: booking,
          moMoDeeplink: result.deeplink,
          moMoPayUrl: result.payUrl,
        ),
      );
    } catch (e, st) {
      _log.severe('MoMo payment initiation error', e, st);
      _setError('$e');
    }
  }

  /// Called when the user returns to the app after
  /// completing (or cancelling) MoMo payment.
  ///
  /// Re-fetches the booking to verify the payment
  /// was captured by the backend IPN.
  Future<void> verifyMoMoPayment(String bookingId) async {
    final current = state.value;
    if (current == null) return;

    _setStatus(CheckoutSubmissionStatus.verifyingPayment);

    final repo = ref.read(checkoutRepositoryProvider);
    try {
      final booking = await repo.getBookingById(bookingId);

      if (booking.status == BookingStatus.confirmed) {
        _setSuccess(booking);
      } else {
        // Payment not yet confirmed — inform the user.
        _setError(
          'Payment not confirmed. '
          'Please try again or contact support.',
        );
      }
    } catch (e, st) {
      _log.severe('MoMo verify error', e, st);
      _setError('$e');
    }
  }

  /// Polls the ticket endpoint until a terminal status
  /// is reached or the poll limit is exceeded.
  Future<CheckoutTicketEntity> _pollTicket(
    dynamic repo,
    String ticketId,
  ) async {
    for (var i = 0; i < _kMaxPollAttempts; i++) {
      final ticket = await repo.getTicketStatus(ticketId);

      if (ticket.status == CheckoutTicketStatus.success ||
          ticket.status == CheckoutTicketStatus.failed) {
        return ticket;
      }

      await Future.delayed(_kPollInterval);
    }

    // Timeout.
    return CheckoutTicketEntity(
      id: ticketId,
      userId: '',
      staffId: '',
      startTime: DateTime.now(),
      status: CheckoutTicketStatus.failed,
      idempotencyKey: '',
      errorMessage:
          'Checkout is taking too long. '
          'Please check your bookings later.',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Builds an ISO 8601 start time from booking
  /// params date + time slot.
  String _buildStartTimeIso(BookingParams params) {
    final date = params.selectedDate;
    final timeStr = params.selectedTimeSlot;

    // Parse "09:00 AM" style time strings.
    final parts = timeStr.split(RegExp(r'[\s:]+'));
    if (parts.length >= 3) {
      var hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      final period = parts[2].toUpperCase();
      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return DateTime(
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      ).toUtc().toIso8601String();
    }

    // Fallback: use date as-is with midnight.
    return DateTime(date.year, date.month, date.day).toUtc().toIso8601String();
  }

  void _setStatus(CheckoutSubmissionStatus status) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(submissionStatus: status));
  }

  void _setError(String message) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(
        submissionStatus: CheckoutSubmissionStatus.failed,
        errorMessage: message,
      ),
    );
  }

  void _setSuccess(BookingEntity booking) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(
        submissionStatus: CheckoutSubmissionStatus.success,
        booking: booking,
      ),
    );
  }

  /// Resets the submission status to idle.
  void resetSubmission() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(
        submissionStatus: CheckoutSubmissionStatus.idle,
        errorMessage: null,
      ),
    );
  }
}
