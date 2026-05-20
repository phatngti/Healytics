import 'package:freezed_annotation/freezed_annotation.dart';

part 'public_profile.entity.freezed.dart';

/// Full aggregate returned by GET /public-profile.
/// Contains both read-only business context and
/// the editable storefront section.
@freezed
abstract class PartnerPublicProfileEntity with _$PartnerPublicProfileEntity {
  const factory PartnerPublicProfileEntity({
    required String id,
    required PublicProfileBusinessInfo businessInfo,
    required PublicProfileAddress address,
    PublicProfileLegalSummary? legalSummary,
    required String verificationStatus,
    required PublicProfileStorefront storefront,
    required PublicProfileCompletionSummary completionSummary,
  }) = _PartnerPublicProfileEntity;
}

/// Read-only verified business identity data.
@freezed
abstract class PublicProfileBusinessInfo with _$PublicProfileBusinessInfo {
  const factory PublicProfileBusinessInfo({
    required String brandName,
    required String legalName,
    required String taxCode,
    @Default([]) List<String> businessType,
    String? phoneNumber,
    String? email,
    String? username,
  }) = _PublicProfileBusinessInfo;
}

/// Named location reference (ward, district,
/// province) with id and display name.
@freezed
abstract class LocationRef with _$LocationRef {
  const factory LocationRef({required String id, required String name}) =
      _LocationRef;
}

/// Read-only partner address information.
@freezed
abstract class PublicProfileAddress with _$PublicProfileAddress {
  const factory PublicProfileAddress({
    required String streetAddress,
    LocationRef? ward,
    LocationRef? district,
    LocationRef? province,
    double? latitude,
    double? longitude,
    String? formattedAddress,
  }) = _PublicProfileAddress;
}

/// Read-only legal representative summary.
@freezed
abstract class PublicProfileLegalSummary with _$PublicProfileLegalSummary {
  const factory PublicProfileLegalSummary({
    required String fullName,
    required String position,
    required String idType,
    required String idNumber,
  }) = _PublicProfileLegalSummary;
}

/// Editable storefront fields shown on the
/// partner's public clinic page.
@freezed
abstract class PublicProfileStorefront with _$PublicProfileStorefront {
  const factory PublicProfileStorefront({
    String? coverImageUrl,
    String? logoImageUrl,
    String? description,
    @Default([]) List<String> gallery,
    @Default([]) List<PublicProfileCertification> certifications,
  }) = _PublicProfileStorefront;
}

/// A single trust badge or certification.
@freezed
abstract class PublicProfileCertification with _$PublicProfileCertification {
  const factory PublicProfileCertification({
    String? id,
    required String title,
    String? subtitle,
    required String iconName,
    @Default(0) int sortOrder,
  }) = _PublicProfileCertification;
}

/// Single item in the server-derived checklist.
@freezed
abstract class PublicProfileChecklistItem with _$PublicProfileChecklistItem {
  const factory PublicProfileChecklistItem({
    required String key,
    required String label,
    @Default(false) bool isRequired,
    @Default(false) bool completed,
  }) = _PublicProfileChecklistItem;
}

/// Backend-computed completion summary.
@freezed
abstract class PublicProfileCompletionSummary
    with _$PublicProfileCompletionSummary {
  const factory PublicProfileCompletionSummary({
    @Default([]) List<PublicProfileChecklistItem> checklist,
    @Default(0) int completionPercent,
    @Default(false) bool isCompleted,
  }) = _PublicProfileCompletionSummary;
}

/// Request payload for `PUT /public-profile`.
/// Null fields mean "don't change".
@freezed
abstract class PublicProfileUpdateRequest with _$PublicProfileUpdateRequest {
  const factory PublicProfileUpdateRequest({
    String? coverImageUrl,
    String? logoImageUrl,
    String? description,
    List<String>? gallery,
    List<PublicProfileCertification>? certifications,
  }) = _PublicProfileUpdateRequest;
}

/// Sparse request payload for `PUT /public-profile`.
///
/// The generated OpenAPI DTO cannot represent "omitted"
/// separately from `null`, but this screen needs both:
/// omitted means "leave the backend value unchanged", while
/// included `null` means "clear this field".
class PublicProfileUpdatePatch {
  const PublicProfileUpdatePatch({
    this.coverImageUrl,
    this.logoImageUrl,
    this.description,
    this.gallery,
    this.certifications,
    this.includeCoverImageUrl = false,
    this.includeLogoImageUrl = false,
    this.includeDescription = false,
    this.includeGallery = false,
    this.includeCertifications = false,
  });

  final String? coverImageUrl;
  final String? logoImageUrl;
  final String? description;
  final List<String>? gallery;
  final List<PublicProfileCertification>? certifications;

  final bool includeCoverImageUrl;
  final bool includeLogoImageUrl;
  final bool includeDescription;
  final bool includeGallery;
  final bool includeCertifications;

  bool get hasChanges =>
      includeCoverImageUrl ||
      includeLogoImageUrl ||
      includeDescription ||
      includeGallery ||
      includeCertifications;
}
