// Domain entities for the appointment / orders feature.
//
// Pure Dart — no Flutter or framework imports.

/// Represents a booked appointment.
class AppointmentEntity {
  final String id;
  final String serviceName;
  final String vendorName;
  final String imageUrl;
  final String status;
  final String category;
  final String providerName;
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
  final String? providerId;

  /// The account UUID of the health partner (vendor).
  /// Used for creating chat conversations.
  final String? vendorAccountId;

  /// Whether the user has already submitted
  /// a review for this appointment.
  final bool isReviewed;

  const AppointmentEntity({
    required this.id,
    required this.serviceName,
    required this.vendorName,
    required this.imageUrl,
    required this.status,
    required this.category,
    required this.providerName,
    required this.address,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.duration,
    this.distanceKm,
    this.providerId,
    this.vendorAccountId,
    this.isReviewed = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentEntity &&
          id == other.id &&
          serviceName == other.serviceName &&
          vendorName == other.vendorName &&
          imageUrl == other.imageUrl &&
          status == other.status &&
          category == other.category &&
          providerName == other.providerName &&
          address == other.address &&
          date == other.date &&
          checkInTime == other.checkInTime &&
          checkOutTime == other.checkOutTime &&
          duration == other.duration &&
          distanceKm == other.distanceKm &&
          providerId == other.providerId &&
          vendorAccountId == other.vendorAccountId &&
          isReviewed == other.isReviewed;

  @override
  int get hashCode => Object.hash(
        id,
        serviceName,
        vendorName,
        imageUrl,
        status,
        category,
        providerName,
        address,
        date,
        checkInTime,
        checkOutTime,
        duration,
        distanceKm,
        providerId,
        vendorAccountId,
        isReviewed,
      );
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
  int get hashCode => Object.hash(
        id,
        name,
        description,
        imageUrl,
        price,
        duration,
      );
}
