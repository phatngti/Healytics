import 'package:riverpod_annotation/riverpod_annotation.dart';
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

/// Presentation state for the checkout screen.
class CheckoutState {
  final CheckoutData checkoutData;
  final PaymentMethodType selectedPayment;
  final bool useCoins;
  final BookingParams? bookingParams;

  const CheckoutState({
    required this.checkoutData,
    this.selectedPayment = PaymentMethodType.card,
    this.useCoins = false,
    this.bookingParams,
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

  CheckoutState copyWith({
    CheckoutData? checkoutData,
    PaymentMethodType? selectedPayment,
    bool? useCoins,
    BookingParams? bookingParams,
  }) {
    return CheckoutState(
      checkoutData: checkoutData ?? this.checkoutData,
      selectedPayment: selectedPayment ?? this.selectedPayment,
      useCoins: useCoins ?? this.useCoins,
      bookingParams: bookingParams ?? this.bookingParams,
    );
  }
}

/// Parses a price string like "\$350.00" or
/// "850,000 VND" into an integer (cents / đồng).
int _parsePrice(String raw) {
  final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  return int.tryParse(digits) ?? 0;
}

/// Notifier managing checkout screen interactions.
///
/// Builds [CheckoutData] directly from [BookingParams]
/// set by the service details screen — no remote fetch.
@riverpod
class CheckoutNotifier extends _$CheckoutNotifier {
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

    // Default placeholders until customer / voucher
    // / payment APIs are available.
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
}
