import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_status.entity.freezed.dart';
part 'verification_status.entity.g.dart';

/// Status of the overall verification revision process.
enum VerificationRevisionStatus {
  /// Application is pending initial review.
  pending,

  /// Application is under review by admin.
  underReview,

  /// Admin has requested revisions.
  revisionRequested,

  /// Application has been approved.
  approved,

  /// Application has been rejected.
  rejected,
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

/// Status of an uploaded document.
enum DocumentStatus {
  /// Document has not been uploaded.
  notUploaded,

  /// Document is pending review.
  pendingReview,

  /// Document has been approved.
  approved,

  /// Document requires re-upload.
  revisionRequired,
}

/// Represents a verification document (ID card, authorization letter, etc.).
@freezed
abstract class VerificationDocument with _$VerificationDocument {
  /// Creates a new [VerificationDocument].
  const factory VerificationDocument({
    /// Unique identifier for the document.
    required String id,

    /// Display label for the document type.
    required String label,

    /// URL to the uploaded file, if any.
    String? fileUrl,

    /// Original filename of the uploaded file.
    String? fileName,

    /// Current status of the document.
    @Default(DocumentStatus.notUploaded) DocumentStatus status,

    /// Whether this document requires an update.
    @Default(false) bool requiresUpdate,

    /// Admin feedback for this specific document.
    String? adminFeedback,
  }) = _VerificationDocument;

  /// Creates a [VerificationDocument] from JSON data.
  factory VerificationDocument.fromJson(Map<String, dynamic> json) =>
      _$VerificationDocumentFromJson(json);
}

/// Represents the legal representative details and documents.
@freezed
abstract class LegalRepresentativeEntity with _$LegalRepresentativeEntity {
  /// Creates a new [LegalRepresentativeEntity].
  const factory LegalRepresentativeEntity({
    /// Full legal name of the representative.
    required String fullName,

    /// Government ID number.
    required String govIdNumber,

    /// Front side of government ID.
    required VerificationDocument idFront,

    /// Back side of government ID.
    required VerificationDocument idBack,

    /// Authorization letter document.
    VerificationDocument? authorizationLetter,
  }) = _LegalRepresentativeEntity;

  /// Creates a [LegalRepresentativeEntity] from JSON data.
  factory LegalRepresentativeEntity.fromJson(Map<String, dynamic> json) =>
      _$LegalRepresentativeEntityFromJson(json);
}

/// Represents business entity information for verification.
@freezed
abstract class BusinessEntityInfo with _$BusinessEntityInfo {
  /// Creates a new [BusinessEntityInfo].
  const factory BusinessEntityInfo({
    /// Company name.
    required String companyName,

    /// Tax registration code.
    required String taxRegistrationCode,

    /// Business email address.
    required String businessEmail,

    /// Business phone number.
    required String businessPhone,

    /// List of service categories.
    @Default([]) List<String> serviceCategories,
  }) = _BusinessEntityInfo;

  /// Creates a [BusinessEntityInfo] from JSON data.
  factory BusinessEntityInfo.fromJson(Map<String, dynamic> json) =>
      _$BusinessEntityInfoFromJson(json);
}

/// Represents location details information for verification.
@freezed
abstract class LocationDetailsInfo with _$LocationDetailsInfo {
  /// Creates a new [LocationDetailsInfo].
  const factory LocationDetailsInfo({
    /// Country name or code.
    String? country,

    /// City name.
    String? city,

    /// District or area.
    String? districtArea,

    /// Detailed street address.
    required String detailedAddress,
  }) = _LocationDetailsInfo;

  /// Creates a [LocationDetailsInfo] from JSON data.
  factory LocationDetailsInfo.fromJson(Map<String, dynamic> json) =>
      _$LocationDetailsInfoFromJson(json);
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
@freezed
abstract class ProviderVerificationStatusEntity
    with _$ProviderVerificationStatusEntity {
  /// Creates a new [ProviderVerificationStatusEntity].
  const factory ProviderVerificationStatusEntity({
    /// Application ID (e.g., "#SP-8821").
    required String applicationId,

    /// Overall status of the verification process.
    required VerificationRevisionStatus status,

    /// List of verification sections.
    required List<VerificationSectionEntity> sections,

    /// Business entity details, if available.
    BusinessEntityInfo? businessEntity,

    /// Location details, if available.
    LocationDetailsInfo? locationDetails,

    /// Legal representative details, if available.
    LegalRepresentativeEntity? legalRepresentative,

    /// Admin feedback title/summary.
    String? adminFeedback,

    /// Detailed admin feedback message.
    String? adminFeedbackDetail,

    /// Timestamp of last update.
    DateTime? lastUpdated,
  }) = _ProviderVerificationStatusEntity;

  /// Creates a [ProviderVerificationStatusEntity] from JSON data.
  factory ProviderVerificationStatusEntity.fromJson(
    Map<String, dynamic> json,
  ) => _$ProviderVerificationStatusEntityFromJson(json);
}
