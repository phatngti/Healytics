import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_status.entity.freezed.dart';
part 'verification_status.entity.g.dart';

/// Status of the overall verification revision process.
/// Aligned with `PartnerVerificationStatus` enum from API.
enum VerificationRevisionStatus {
  /// Application is pending review by admin.
  pending,

  /// Application has been approved.
  approved,

  /// Application has been rejected.
  rejected,

  /// Admin has requested revisions (resubmit required).
  requiredResubmit,
}

/// Status of an individual verification section.
enum SectionStatus {
  /// Section has not been started.
  notStarted,

  /// Section is in progress.
  inProgress,

  /// Section is complete and verified.
  completed,

  /// Section requires revision.
  revisionRequired,
}

/// Types of verification sections in the application.
enum VerificationSectionType {
  /// Business entity information.
  businessEntity,

  /// Location and address details.
  locationDetails,

  /// Legal representative information and documents.
  legalRepresentative,

  /// Account security settings.
  accountSecurity,
}

/// Generic verified field entity aligned with API's `VerifiedField`.
/// Contains a value of any type with verification status and optional feedback.
@freezed
abstract class VerifiedField with _$VerifiedField {
  /// Creates a new [VerifiedField].
  const factory VerifiedField({
    /// Field key used for identification (e.g., 'brand_name', 'tax_code').
    required String fieldKey,

    /// The actual value of the field (can be any type: String, List, etc.).
    required Object value,

    /// Whether this field has been verified by admin.
    required bool isVerified,

    /// Admin feedback for this specific field, if any.
    String? feedback,
  }) = _VerifiedField;

  /// Creates a [VerifiedField] from JSON data.
  factory VerifiedField.fromJson(Map<String, dynamic> json) =>
      _$VerifiedFieldFromJson(json);
}

/// Represents address/location information for verification.
/// Aligned with `AddressInfoDto` from API.
@freezed
abstract class AddressInfo with _$AddressInfo {
  /// Creates a new [AddressInfo].
  const factory AddressInfo({
    /// Street address.
    required VerifiedField streetAddress,

    /// Ward name.
    VerifiedField? ward,

    /// District name.
    VerifiedField? district,

    /// City/Province name.
    VerifiedField? city,

    /// Country.
    String? country,

    /// Latitude coordinate.
    double? latitude,

    /// Longitude coordinate.
    double? longitude,
  }) = _AddressInfo;

  /// Creates an [AddressInfo] from JSON data.
  factory AddressInfo.fromJson(Map<String, dynamic> json) =>
      _$AddressInfoFromJson(json);
}

/// Represents partner (business entity) information for verification.
/// Aligned with `BusinessInfoDto` from API.
@freezed
abstract class BusinessInfo with _$BusinessInfo {
  /// Creates a new [BusinessInfo].
  const factory BusinessInfo({
    /// Brand/trade name.
    required VerifiedField brandName,

    /// Tax registration code.
    VerifiedField? taxRegistrationCode,

    /// Service tags/categories.
    required VerifiedField serviceTags,

    /// Business address information.
    AddressInfo? address,

    /// Username for the partner account.
    VerifiedField? username,

    /// Email address.
    VerifiedField? email,

    /// Business phone number.
    VerifiedField? phoneNumber,
  }) = _BusinessInfo;

  /// Creates a [BusinessInfo] from JSON data.
  factory BusinessInfo.fromJson(Map<String, dynamic> json) =>
      _$BusinessInfoFromJson(json);
}

/// Represents the legal representative details.
/// Aligned with `LegalRepresentativeDto` from API.
@freezed
abstract class LegalRepresentativeInfo with _$LegalRepresentativeInfo {
  /// Creates a new [LegalRepresentativeInfo].
  const factory LegalRepresentativeInfo({
    /// Full legal name of the representative.
    required VerifiedField fullName,

    /// Position/title of the representative.
    VerifiedField? position,

    /// Phone number of the representative.
    VerifiedField? phoneNumber,

    /// Type of government ID (e.g., 'ID Card', 'Passport').
    VerifiedField? idType,

    /// Government ID number.
    VerifiedField? idNumber,

    /// ID issue date.
    VerifiedField? idIssueDate,
  }) = _LegalRepresentativeInfo;

  /// Creates a [LegalRepresentativeInfo] from JSON data.
  factory LegalRepresentativeInfo.fromJson(Map<String, dynamic> json) =>
      _$LegalRepresentativeInfoFromJson(json);
}

/// Represents a single verification section in the application.
@freezed
abstract class VerificationSectionEntity with _$VerificationSectionEntity {
  /// Creates a new [VerificationSectionEntity].
  const factory VerificationSectionEntity({
    /// The type of this section.
    required VerificationSectionType type,

    /// Display label for the section.
    required String label,

    /// Current status of the section.
    required SectionStatus status,

    /// Whether the section is locked (cannot be edited).
    @Default(false) bool isLocked,

    /// Step number for display (1-based).
    int? stepNumber,
  }) = _VerificationSectionEntity;

  /// Creates a [VerificationSectionEntity] from JSON data.
  factory VerificationSectionEntity.fromJson(Map<String, dynamic> json) =>
      _$VerificationSectionEntityFromJson(json);
}

/// Main entity representing the provider's verification status.
/// Aligned with `MyProfileResponseDto` from API.
@freezed
abstract class ProviderVerificationStatusEntity
    with _$ProviderVerificationStatusEntity {
  /// Creates a new [ProviderVerificationStatusEntity].
  const factory ProviderVerificationStatusEntity({
    /// Partner ID (UUID).
    required String id,

    /// Business entity details.
    required BusinessInfo businessInfo,

    /// Legal representative details, if available.
    LegalRepresentativeInfo? legalRepresentative,

    /// KYC documents as verified fields.
    @Default([]) List<VerifiedField> kycDocuments,

    /// Overall status of the verification process.
    required VerificationRevisionStatus verificationStatus,

    /// When verification was completed (if applicable).
    DateTime? verificationCompletedAt,

    /// When the partner was created.
    required DateTime createdAt,

    /// List of verification sections for UI navigation.
    @Default([]) List<VerificationSectionEntity> sections,
  }) = _ProviderVerificationStatusEntity;

  /// Creates a [ProviderVerificationStatusEntity] from JSON data.
  factory ProviderVerificationStatusEntity.fromJson(
    Map<String, dynamic> json,
  ) => _$ProviderVerificationStatusEntityFromJson(json);
}
