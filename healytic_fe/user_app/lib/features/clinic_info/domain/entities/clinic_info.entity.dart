// Pure-Dart entities for the Clinic Info screen.
// Platform-agnostic — no Flutter or Riverpod imports.

/// Full clinic profile returned by the public clinic
/// info endpoint.
class ClinicInfoEntity {
  const ClinicInfoEntity({
    required this.id,
    required this.name,
    this.coverImageUrl,
    this.logoImageUrl,
    this.gallery = const [],
    required this.followersLabel,
    this.followerCount = 0,
    this.isFollowing = false,
    this.chatPartnerId,
    required this.reviewsLabel,
    this.description,
    this.address,
    this.phoneNumber,
    required this.trustMetrics,
    this.certifications = const [],
    this.specialists = const [],
    this.businessTypes = const [],
    this.facilityImages = const [],
  });

  final String id;
  final String name;
  final String? coverImageUrl;
  final String? logoImageUrl;
  final List<String> gallery;
  final String followersLabel;
  final int followerCount;
  final bool isFollowing;
  final String? chatPartnerId;
  final String reviewsLabel;
  final String? description;
  final String? address;
  final String? phoneNumber;
  final ClinicTrustMetrics trustMetrics;
  final List<ClinicCertification> certifications;
  final List<ClinicSpecialistPreview> specialists;
  final List<String> businessTypes;

  /// Facility tour images derived from [gallery].
  final List<ClinicFacilityImage> facilityImages;

  ClinicInfoEntity copyWith({
    String? followersLabel,
    int? followerCount,
    bool? isFollowing,
  }) {
    return ClinicInfoEntity(
      id: id,
      name: name,
      coverImageUrl: coverImageUrl,
      logoImageUrl: logoImageUrl,
      gallery: gallery,
      followersLabel: followersLabel ?? this.followersLabel,
      followerCount: followerCount ?? this.followerCount,
      isFollowing: isFollowing ?? this.isFollowing,
      chatPartnerId: chatPartnerId,
      reviewsLabel: reviewsLabel,
      description: description,
      address: address,
      phoneNumber: phoneNumber,
      trustMetrics: trustMetrics,
      certifications: certifications,
      specialists: specialists,
      businessTypes: businessTypes,
      facilityImages: facilityImages,
    );
  }
}

/// Trust metrics bar displayed below the header.
///
/// Fields map 1:1 to [ClinicTrustMetricsDto] from the
/// backend: rating, reviewCount, experienceLabel,
/// clientsLabel.
class ClinicTrustMetrics {
  const ClinicTrustMetrics({
    required this.rating,
    required this.reviewCount,
    required this.experienceLabel,
    required this.clientsLabel,
  });

  /// Average rating across all clinic products.
  final double rating;

  /// Total number of treatment reviews.
  final int reviewCount;

  final String experienceLabel;
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
