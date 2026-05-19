// Domain entities for the appointment / orders feature.
//
// Pure Dart — no Flutter or framework imports.

/// Represents a booked appointment.
class AppointmentEntity {
  final String id;
  final String serviceName;
  final String healthPartnerName;
  final String healthPartnerId;
  final String imageUrl;
  final String status;
  final String category;
  final String specialistName;
  final String address;
  final DateTime date;
  final String checkInTime;
  final String checkOutTime;
  final String duration;

  /// Distance from user to the clinic in km.
  /// Null when coordinates are unavailable.
  final double? distanceKm;

  /// The employee ID of the assigned provider.
  /// Used for navigating to the employee detail.
  final String? specialistId;

  /// The product/service ID.
  /// Used for navigating to service details.
  final String? serviceId;

  /// Whether the user has already submitted
  /// a review for this appointment.
  final bool isReviewed;

  /// Payment gateway checkout URL.
  /// Non-null only when status is `pending_payment`.
  final String? paymentUrl;

  /// Deep link to open the payment app directly
  /// (e.g. MoMo). Non-null only when status is
  /// `pending_payment`.
  final String? paymentDeeplink;

  /// When the payment link expires.
  /// Non-null only when status is `pending_payment`.
  final DateTime? paymentExpiresAt;

  const AppointmentEntity({
    required this.id,
    required this.serviceName,
    required this.healthPartnerName,
    required this.healthPartnerId,
    required this.imageUrl,
    required this.status,
    required this.category,
    required this.specialistName,
    required this.address,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.duration,
    this.distanceKm,
    this.specialistId,
    this.serviceId,
    this.isReviewed = false,
    this.paymentUrl,
    this.paymentDeeplink,
    this.paymentExpiresAt,
  });

  AppointmentEntity copyWith({
    String? id,
    String? serviceName,
    String? healthPartnerName,
    String? healthPartnerId,
    String? imageUrl,
    String? status,
    String? category,
    String? specialistName,
    String? address,
    DateTime? date,
    String? checkInTime,
    String? checkOutTime,
    String? duration,
    double? distanceKm,
    String? specialistId,
    String? serviceId,
    bool? isReviewed,
    String? paymentUrl,
    String? paymentDeeplink,
    DateTime? paymentExpiresAt,
  }) {
    return AppointmentEntity(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      healthPartnerName: healthPartnerName ?? this.healthPartnerName,
      healthPartnerId: healthPartnerId ?? this.healthPartnerId,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      category: category ?? this.category,
      specialistName: specialistName ?? this.specialistName,
      address: address ?? this.address,
      date: date ?? this.date,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      duration: duration ?? this.duration,
      distanceKm: distanceKm ?? this.distanceKm,
      specialistId: specialistId ?? this.specialistId,
      serviceId: serviceId ?? this.serviceId,
      isReviewed: isReviewed ?? this.isReviewed,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      paymentDeeplink: paymentDeeplink ?? this.paymentDeeplink,
      paymentExpiresAt: paymentExpiresAt ?? this.paymentExpiresAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentEntity &&
          id == other.id &&
          serviceName == other.serviceName &&
          healthPartnerName == other.healthPartnerName &&
          healthPartnerId == other.healthPartnerId &&
          imageUrl == other.imageUrl &&
          status == other.status &&
          category == other.category &&
          specialistName == other.specialistName &&
          address == other.address &&
          date == other.date &&
          checkInTime == other.checkInTime &&
          checkOutTime == other.checkOutTime &&
          duration == other.duration &&
          distanceKm == other.distanceKm &&
          specialistId == other.specialistId &&
          serviceId == other.serviceId &&
          isReviewed == other.isReviewed &&
          paymentUrl == other.paymentUrl &&
          paymentDeeplink == other.paymentDeeplink &&
          paymentExpiresAt == other.paymentExpiresAt;

  @override
  int get hashCode => Object.hashAll([
    id,
    serviceName,
    healthPartnerName,
    healthPartnerId,
    imageUrl,
    status,
    category,
    specialistName,
    address,
    date,
    checkInTime,
    checkOutTime,
    duration,
    distanceKm,
    specialistId,
    serviceId,
    isReviewed,
    paymentUrl,
    paymentDeeplink,
    paymentExpiresAt,
  ]);
}

/// Category filter for appointments.
class AppointmentCategory {
  final String id;
  final String name;
  final String iconSlug;

  const AppointmentCategory({
    required this.id,
    required this.name,
    required this.iconSlug,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentCategory &&
          id == other.id &&
          name == other.name &&
          iconSlug == other.iconSlug;

  @override
  int get hashCode => Object.hash(id, name, iconSlug);
}

/// A service recommendation shown below appointments.
class RecommendedServiceEntity {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String price;
  final String duration;

  const RecommendedServiceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.duration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendedServiceEntity &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          imageUrl == other.imageUrl &&
          price == other.price &&
          duration == other.duration;

  @override
  int get hashCode =>
      Object.hash(id, name, description, imageUrl, price, duration);
}
