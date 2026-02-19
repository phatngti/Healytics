// Pure-Dart entities for the Service Details screen.
//
// These classes are platform-agnostic — no Flutter or Riverpod
// imports — keeping the domain layer testable in isolation.

/// Aggregated data needed to render [ServiceDetailsScreen].
class ServiceDetailsEntity {
  const ServiceDetailsEntity({
    required this.id,
    required this.title,
    required this.categoryLabel,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.isVerified,
    required this.description,
    required this.featureTags,
    required this.clinic,
    required this.specialists,
    required this.daySchedules,
    required this.facilityImages,
    this.reviews = const [],
    this.recommendedServices = const [],
  });

  final String id;
  final String title;
  final String categoryLabel;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final String price;
  final bool isVerified;
  final String description;
  final List<FeatureTagEntity> featureTags;
  final ClinicEntity clinic;
  final List<SpecialistEntity> specialists;

  /// Per-day schedules with bookable time slots.
  final List<DayScheduleEntity> daySchedules;
  final List<FacilityImageEntity> facilityImages;

  /// User-submitted reviews for this service.
  final List<ReviewEntity> reviews;

  /// Other services the user might be interested in.
  final List<RecommendedServiceEntity> recommendedServices;

  @override
  String toString() {
    return 'ServiceDetailsEntity('
        'id: $id, title: $title, '
        'categoryLabel: $categoryLabel, '
        'images: $images, rating: $rating, '
        'reviewCount: $reviewCount, '
        'price: $price, isVerified: $isVerified, '
        'description: $description, '
        'featureTags: $featureTags, '
        'clinic: $clinic, '
        'specialists: $specialists, '
        'daySchedules: $daySchedules, '
        'facilityImages: $facilityImages, '
        'reviews: $reviews, '
        'recommendedServices: $recommendedServices)';
  }
}

/// A lightweight summary of a service shown in "Recommended"
/// carousels. Pure Dart — no Flutter dependencies.
class RecommendedServiceEntity {
  const RecommendedServiceEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.reviewLabel,
    required this.bookedLabel,
    required this.price,
  });

  /// Unique identifier for navigation.
  final String id;

  /// Display title, e.g. "HydraFacial Deep Clean".
  final String title;

  /// Cover image URL.
  final String imageUrl;

  /// Average star rating (0–5).
  final double rating;

  /// Human-readable review count, e.g. "(500+ Reviews)".
  final String reviewLabel;

  /// Human-readable bookings count, e.g. "1.2k+ Booked".
  final String bookedLabel;

  /// Formatted price string, e.g. "\$120.00".
  final String price;
}

/// A specialist who can perform the treatment.
class SpecialistEntity {
  const SpecialistEntity({
    required this.name,
    required this.role,
    required this.imageUrl,
    this.isSelected = false,
    this.quote,
    this.degrees,
    this.languages,
    this.experience,
    this.specializations,
    this.bio,
  });

  final String name;
  final String role;
  final String imageUrl;
  final bool isSelected;
  final String? quote;
  final String? degrees;
  final String? languages;

  /// Years / area of experience, e.g. "12 years".
  final String? experience;

  /// List of specialization tags.
  final List<String>? specializations;

  /// Extended biography shown in the "Show More" panel.
  final String? bio;
}

/// One day's schedule of bookable time slots.
class DayScheduleEntity {
  const DayScheduleEntity({
    required this.date,
    required this.timeSlots,
    this.isAvailable = true,
  });

  /// The calendar date for this schedule.
  final DateTime date;

  /// Time slots offered on this date.
  final List<TimeSlotEntity> timeSlots;

  /// False when the clinic is closed or fully booked.
  final bool isAvailable;

  @override
  String toString() {
    return 'DayScheduleEntity(date: $date, timeSlots: $timeSlots, isAvailable: $isAvailable)';
  }
}

/// A bookable time slot.
class TimeSlotEntity {
  const TimeSlotEntity({required this.label, this.isAvailable = true});

  final String label;
  final bool isAvailable;

  @override
  String toString() {
    return 'TimeSlotEntity(label: $label, isAvailable: $isAvailable)';
  }
}

/// A feature tag chip (e.g. "60 min", "Advanced Tech").
///
/// Stores the icon as a [String] key rather than `IconData`
/// to keep the domain layer free of Flutter dependencies.
class FeatureTagEntity {
  const FeatureTagEntity({required this.iconName, required this.label});

  /// Semantic icon identifier, e.g. `'schedule'`, `'spa'`,
  /// `'biotech'`. Mapped to `IconData` in the presentation layer.
  final String iconName;
  final String label;
}

/// A facility tour image with caption.
class FacilityImageEntity {
  const FacilityImageEntity({required this.imageUrl, required this.label});

  final String imageUrl;
  final String label;
}

/// Basic clinic information.
class ClinicEntity {
  const ClinicEntity({required this.name, required this.address});

  final String name;
  final String address;
}

/// A user-submitted review for a service.
class ReviewEntity {
  const ReviewEntity({
    required this.reviewerName,
    required this.avatarUrl,
    required this.rating,
    required this.date,
    required this.text,
    this.status = 'Completed',
    this.imageUrls = const [],
  });

  /// Display name of the reviewer.
  final String reviewerName;

  /// URL for the reviewer's avatar image.
  final String avatarUrl;

  /// Star rating (1–5).
  final int rating;

  /// Completion status label, e.g. "Completed".
  final String status;

  /// When the review was submitted.
  final DateTime date;

  /// Full review text.
  final String text;

  /// Optional attached images.
  final List<String> imageUrls;
}
