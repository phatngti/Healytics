/// Result of creating a Stripe PaymentIntent via the
/// backend.
///
/// Contains the [clientSecret] required by the Stripe
/// SDK to confirm payment on-device.
class StripePaymentResult {
  /// Stripe PaymentIntent ID (for logging/reference).
  final String paymentIntentId;

  /// One-time-use secret for the Stripe SDK —
  /// never persist this value.
  final String clientSecret;

  /// Amount in smallest currency unit (VND = đồng).
  final int amount;

  /// ISO currency code (e.g. `"vnd"`).
  final String currency;

  /// Initial PaymentIntent status — typically
  /// `"requires_payment_method"`.
  final String status;

  const StripePaymentResult({
    required this.paymentIntentId,
    required this.clientSecret,
    required this.amount,
    required this.currency,
    required this.status,
  });
}

/// Result of requesting a Stripe refund via the
/// backend.
class StripeRefundResult {
  /// Stripe Refund ID.
  final String refundId;

  /// Refunded amount in smallest currency unit.
  final int amount;

  /// ISO currency code.
  final String currency;

  /// Refund status: `"succeeded"`, `"pending"`, or
  /// `"failed"`.
  final String status;

  /// Original PaymentIntent ID that was refunded.
  final String? paymentIntentId;

  const StripeRefundResult({
    required this.refundId,
    required this.amount,
    required this.currency,
    required this.status,
    this.paymentIntentId,
  });
}
