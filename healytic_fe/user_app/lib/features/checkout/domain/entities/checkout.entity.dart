/// Represents a single item in the checkout order.
class CheckoutItem {
  final String id;
  final String name;
  final String imageUrl;
  final String vendorName;
  final String vendorIcon;
  final String vendorAddress;
  final String duration;
  final String specialistName;
  final int originalPrice;
  final int discountedPrice;
  final int quantity;

  const CheckoutItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.vendorName,
    this.vendorIcon = 'spa',
    this.vendorAddress = '',
    required this.duration,
    required this.specialistName,
    required this.originalPrice,
    required this.discountedPrice,
    this.quantity = 1,
  });
}

/// Customer contact and address information.
class CustomerDetails {
  final String name;
  final String phone;
  final String address;

  const CustomerDetails({
    required this.name,
    required this.phone,
    required this.address,
  });
}

/// Enum-like payment method options.
enum PaymentMethodType { card, eWallet, payLater }

/// A selectable payment method entry.
class PaymentMethodOption {
  final PaymentMethodType type;
  final String label;
  final String? subLabel;

  const PaymentMethodOption({
    required this.type,
    required this.label,
    this.subLabel,
  });
}

/// Represents a voucher (shop or platform level).
class VoucherInfo {
  final String label;
  final int discountAmount;
  final bool isApplied;

  const VoucherInfo({
    required this.label,
    required this.discountAmount,
    this.isApplied = false,
  });
}

/// Aggregated checkout pricing breakdown.
class CheckoutSummary {
  final int subtotal;
  final int shopDiscount;
  final int platformVoucher;
  final int coinsUsed;

  const CheckoutSummary({
    required this.subtotal,
    required this.shopDiscount,
    required this.platformVoucher,
    required this.coinsUsed,
  });

  /// Total after all discounts.
  int get total => subtotal - shopDiscount - platformVoucher - coinsUsed;

  /// Total amount saved.
  int get saved => shopDiscount + platformVoucher + coinsUsed;
}

/// Full checkout state combining all sections.
class CheckoutData {
  final CustomerDetails customer;
  final List<CheckoutItem> items;
  final VoucherInfo? shopVoucher;
  final VoucherInfo? platformVoucher;
  final int coinBalance;
  final int coinValue;
  final List<PaymentMethodOption> paymentMethods;
  final CheckoutSummary summary;

  const CheckoutData({
    required this.customer,
    required this.items,
    this.shopVoucher,
    this.platformVoucher,
    required this.coinBalance,
    required this.coinValue,
    required this.paymentMethods,
    required this.summary,
  });
}
