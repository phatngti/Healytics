/// A voucher/coupon that can be applied to a cart
/// item for a discount.
///
/// Vouchers are scoped per service and/or clinic.
/// Pure Dart — no Flutter or Riverpod imports.
class VoucherEntity {
  /// Creates a voucher entity.
  const VoucherEntity({
    required this.id,
    required this.code,
    required this.label,
    required this.discountPercent,
    this.maxDiscount,
    this.expiresAt,
    this.serviceId,
    this.clinicId,
  });

  /// Unique voucher identifier.
  final String id;

  /// The redeemable code, e.g. "SAVE10".
  final String code;

  /// Human-readable label, e.g. "10% off massage".
  final String label;

  /// Discount percentage, e.g. 10 for 10%.
  final int discountPercent;

  /// Optional maximum discount cap in VND.
  final int? maxDiscount;

  /// Expiration date (null if no expiry).
  final DateTime? expiresAt;

  /// Service this voucher applies to (null = all).
  final String? serviceId;

  /// Clinic this voucher applies to (null = all).
  final String? clinicId;

  /// Whether this voucher has expired.
  bool get isExpired =>
      expiresAt != null && expiresAt!.isBefore(DateTime.now());

  /// Whether this voucher is still valid.
  bool get isValid => !isExpired;
}
