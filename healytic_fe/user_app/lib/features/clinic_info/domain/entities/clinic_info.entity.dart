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
  const ClinicFacilityImage({
    required this.imageUrl,
    required this.label,
  });

  final String imageUrl;
  final String label;
}
