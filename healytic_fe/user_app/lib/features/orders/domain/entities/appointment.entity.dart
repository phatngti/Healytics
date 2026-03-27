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
  });
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
}
