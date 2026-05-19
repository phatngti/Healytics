/// Display-safe metadata for a saved Stripe card.
///
/// The app never receives or stores PAN/CVC data.
class SavedPaymentCard {
  final String id;
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;
  final String? funding;
  final String? country;
  final bool isDefault;

  const SavedPaymentCard({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    this.funding,
    this.country,
    required this.isDefault,
  });

  String get brandLabel {
    if (brand.isEmpty) return 'Card';
    return brand[0].toUpperCase() + brand.substring(1);
  }

  String get maskedLabel => '$brandLabel •••• $last4';

  String get expiryLabel {
    final month = expMonth.toString().padLeft(2, '0');
    final year = expYear.toString().padLeft(4, '0');
    return '$month/$year';
  }
}

/// Backend response for a Stripe SetupIntent.
class StripeSetupIntentResult {
  final String setupIntentId;
  final String clientSecret;

  const StripeSetupIntentResult({
    required this.setupIntentId,
    required this.clientSecret,
  });
}
