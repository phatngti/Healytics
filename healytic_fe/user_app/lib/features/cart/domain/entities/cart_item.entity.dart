/// A single item in the user's shopping cart.
///
/// Data comes from the backend cart API. Each item
/// bundles service info with optional coupon details,
/// specialist assignment, and appointment slot.
///
/// Pure Dart — no Flutter or Riverpod imports.
class CartItemEntity {
  /// Creates a cart item entity.
  const CartItemEntity({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.serviceImageUrl,
    required this.price,
    required this.priceAmount,
    required this.clinicId,
    required this.clinicName,
    required this.clinicAddress,
    required this.clinicImageUrl,
    this.specialistId,
    this.specialistName,
    this.specialistPosition,
    this.slotTime,
    this.couponCode,
    this.couponDiscountPercent,
    this.couponDiscountAmount,
    this.isSelected = true,
    required this.createdAt,
  });

  /// Backend-generated cart item ID.
  final String id;

  /// Service (product) identifier.
  final String serviceId;

  /// Display name of the service.
  final String serviceName;

  /// Cover image URL for the service.
  final String serviceImageUrl;

  /// Formatted price, e.g. "500.000đ".
  final String price;

  /// Numeric price in smallest unit (VND) for
  /// calculations.
  final int priceAmount;

  /// Clinic / vendor identifier.
  final String clinicId;

  /// Clinic display name.
  final String clinicName;

  /// Full address string.
  final String clinicAddress;

  /// Clinic cover / logo image URL.
  final String clinicImageUrl;

  /// Backend employee ID of the specialist
  /// (null if not yet assigned).
  final String? specialistId;

  /// Full name of the assigned specialist
  /// (null if not yet assigned).
  final String? specialistName;

  /// Position / title of the specialist,
  /// e.g. "Senior Therapist".
  final String? specialistPosition;

  /// Booked appointment slot date and time
  /// (null if not yet scheduled).
  final DateTime? slotTime;

  /// Applied coupon code (null if none).
  final String? couponCode;

  /// Discount percentage, e.g. 5 for 5%.
  final int? couponDiscountPercent;

  /// Discount amount in VND derived from percentage.
  final int? couponDiscountAmount;

  /// Client-side selection state for checkout.
  final bool isSelected;

  /// When the item was added to cart.
  final DateTime createdAt;

  /// Effective price after coupon discount.
  int get effectivePrice => priceAmount - (couponDiscountAmount ?? 0);

  /// Whether a valid coupon is applied.
  bool get hasCoupon =>
      couponCode != null &&
      couponDiscountAmount != null &&
      couponDiscountAmount! > 0;

  /// Whether specialist info is available.
  bool get hasSpecialist =>
      specialistId != null &&
      specialistName != null &&
      specialistName!.isNotEmpty;

  /// Whether a slot time has been assigned.
  bool get hasSlotTime => slotTime != null;

  /// Creates a copy with overridden fields.
  CartItemEntity copyWith({
    String? id,
    String? serviceId,
    String? serviceName,
    String? serviceImageUrl,
    String? price,
    int? priceAmount,
    String? clinicId,
    String? clinicName,
    String? clinicAddress,
    String? clinicImageUrl,
    String? specialistId,
    String? specialistName,
    String? specialistPosition,
    DateTime? slotTime,
    String? couponCode,
    int? couponDiscountPercent,
    int? couponDiscountAmount,
    bool? isSelected,
    DateTime? createdAt,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceImageUrl: serviceImageUrl ?? this.serviceImageUrl,
      price: price ?? this.price,
      priceAmount: priceAmount ?? this.priceAmount,
      clinicId: clinicId ?? this.clinicId,
      clinicName: clinicName ?? this.clinicName,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      clinicImageUrl: clinicImageUrl ?? this.clinicImageUrl,
      specialistId: specialistId ?? this.specialistId,
      specialistName: specialistName ?? this.specialistName,
      specialistPosition: specialistPosition ?? this.specialistPosition,
      slotTime: slotTime ?? this.slotTime,
      couponCode: couponCode ?? this.couponCode,
      couponDiscountPercent:
          couponDiscountPercent ?? this.couponDiscountPercent,
      couponDiscountAmount: couponDiscountAmount ?? this.couponDiscountAmount,
      isSelected: isSelected ?? this.isSelected,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
