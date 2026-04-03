// Pure-Dart entities for the Clinic Info screen.
// Platform-agnostic — no Flutter or Riverpod imports.

/// Full clinic profile returned by the public clinic
/// info endpoint.
class ClinicInfoEntity {
  const ClinicInfoEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.isVerified,
    this.coverImageUrl,
    this.logoImageUrl,
    this.gallery = const [],
    required this.rating,
    required this.reviewCount,
    required this.followersLabel,
    this.phone,
    this.coordinates,
    this.chatPartnerId,
    this.description,
    required this.trustMetrics,
    this.certifications = const [],
    this.specialists = const [],
    this.facilityImages = const [],
    this.featuredServices = const [],
  });

  final String id;
  final String name;
  final String address;
  final bool isVerified;
  final String? coverImageUrl;
  final String? logoImageUrl;
  final List<String> gallery;
  final double rating;
  final int reviewCount;
  final String followersLabel;
  final String? phone;
  final String? coordinates;
  final String? chatPartnerId;
  final String? description;
  final ClinicTrustMetrics trustMetrics;
  final List<ClinicCertification> certifications;
  final List<ClinicSpecialistPreview> specialists;
  final List<ClinicFacilityImage> facilityImages;
  final List<ClinicFeaturedService> featuredServices;
}

/// Trust metrics bar displayed below the header.
class ClinicTrustMetrics {
  const ClinicTrustMetrics({
    required this.experienceLabel,
    required this.specialistsCount,
    required this.certifiedLabel,
    required this.clientsLabel,
  });

  final String experienceLabel;
  final int specialistsCount;
  final String certifiedLabel;
  final String clientsLabel;
}

/// A certification or award badge.
class ClinicCertification {
  const ClinicCertification({
    required this.title,
    required this.subtitle,
    required this.iconName,
  });

  final String title;
  final String subtitle;

  /// Material icon name, e.g. `'workspace_premium'`.
  final String iconName;
}

/// Lightweight specialist card for the horizontal
/// list.
class ClinicSpecialistPreview {
  const ClinicSpecialistPreview({
    required this.id,
    required this.name,
    required this.role,
    this.imageUrl,
    this.experienceLabel,
  });

  final String id;
  final String name;
  final String role;
  final String? imageUrl;
  final String? experienceLabel;
}

/// Facility tour image with caption.
class ClinicFacilityImage {
  const ClinicFacilityImage({required this.imageUrl, required this.label});

  final String imageUrl;
  final String label;
}

/// Featured service card shown in the grid.
class ClinicFeaturedService {
  const ClinicFeaturedService({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.price,
    required this.rating,
    required this.bookedLabel,
  });

  final String id;
  final String title;
  final String? imageUrl;
  final String price;
  final double rating;
  final String bookedLabel;
}
