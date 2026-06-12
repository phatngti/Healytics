// Domain entities for the booking flow.
//
// Pure Dart — no Flutter or framework imports.

/// Lightweight specialist entity for the
/// booking selection flow.
class BookingSpecialist {
  /// Unique identifier.
  final String id;

  /// Surrogate PK from the
  /// product_employee_eligibility table.
  ///
  /// Used to fetch detailed booking summary
  /// via the eligibility detail API.
  final String? eligibilityId;

  /// Display name (e.g. "Dr. James Wilson").
  final String name;

  /// Short specialty label (e.g. "Dentist").
  final String specialty;

  /// Optional avatar URL.
  final String? avatarUrl;

  const BookingSpecialist({
    required this.id,
    this.eligibilityId,
    required this.name,
    required this.specialty,
    this.avatarUrl,
  });
}

/// Lightweight service entity for the
/// booking selection flow.
class BookingService {
  /// Unique identifier — maps to
  /// [ServiceDetailsRoute.serviceId].
  final String id;

  /// Service image URL (shown in cards).
  final String? imageUrl;

  /// Service name.
  final String title;

  /// Formatted duration (e.g. "60 min").
  final String duration;

  /// Formatted price (e.g. "850,000 VND").
  final String price;

  /// Numeric price amount in VND.
  final num priceAmount;

  /// Clinic or facility name.
  final String? clinicName;

  final String? categoryId;
  final String? categoryName;
  final String? parentCategoryId;
  final String? parentCategoryName;

  /// Clinic or facility ID.
  final String? clinicId;

  /// Clinic street address.
  final String? clinicAddress;

  /// Clinic location label.
  final String? location;

  /// Distance from user (e.g. "2.3 km").
  final String? distance;

  const BookingService({
    required this.id,
    this.imageUrl,
    required this.title,
    required this.duration,
    required this.price,
    this.priceAmount = 0,
    this.clinicName,
    this.categoryId,
    this.categoryName,
    this.parentCategoryId,
    this.parentCategoryName,
    this.clinicId,
    this.clinicAddress,
    this.location,
    this.distance,
  });

  /// Convenience getter combining duration + price.
  String get subtitle => '$duration • $price';
}

/// Composite result returned by the search API.
///
/// Groups matching [BookingService] and
/// [BookingSpecialist] entries to display in
/// separate popup sections.
class BookingSearchResult {
  /// Matched services.
  final List<BookingService> services;

  /// Matched specialists.
  final List<BookingSpecialist> specialists;

  const BookingSearchResult({
    this.services = const [],
    this.specialists = const [],
  });

  /// Whether neither list has any results.
  bool get isEmpty => services.isEmpty && specialists.isEmpty;
}
