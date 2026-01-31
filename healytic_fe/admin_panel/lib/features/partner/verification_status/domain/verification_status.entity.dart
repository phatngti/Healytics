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

/// Wrapper for a required string verification field.
@freezed
abstract class VerificationStringField with _$VerificationStringField {
  const factory VerificationStringField({
    required String value,
    required String displayValue,
    @Default(false) bool requiresUpdate,
    String? adminFeedback,
  }) = _VerificationStringField;

  factory VerificationStringField.fromJson(Map<String, dynamic> json) =>
      _$VerificationStringFieldFromJson(json);
}

/// Wrapper for an optional string verification field.
@freezed
abstract class VerificationOptionalStringField
    with _$VerificationOptionalStringField {
  const factory VerificationOptionalStringField({
    String? value,
    required String displayValue,
    @Default(false) bool requiresUpdate,
    String? adminFeedback,
  }) = _VerificationOptionalStringField;

  factory VerificationOptionalStringField.fromJson(Map<String, dynamic> json) =>
      _$VerificationOptionalStringFieldFromJson(json);
}

/// Wrapper for a list of strings verification field.
@freezed
abstract class VerificationStringListField with _$VerificationStringListField {
  const factory VerificationStringListField({
    required List<String> value,
    required String displayValue,
    @Default(false) bool requiresUpdate,
    String? adminFeedback,
  }) = _VerificationStringListField;

  factory VerificationStringListField.fromJson(Map<String, dynamic> json) =>
      _$VerificationStringListFieldFromJson(json);
}

/// Represents partner (business entity) information for verification.
/// Aligned with PartnerRequestEntity from sign-up form.
@freezed
abstract class PartnerInfo with _$PartnerInfo {
  /// Creates a new [PartnerInfo].
  const factory PartnerInfo({
    /// Tax registration code.
    required VerificationStringField taxCode,

    /// Legal company name.
    required VerificationStringField legalName,

    /// Brand/trade name.
    required VerificationStringField brandName,

    /// Business type (e.g., 'Individual Business', 'Corporation').
    required VerificationStringField businessType,

    /// Business phone number.
    VerificationOptionalStringField? phoneNumber,
  }) = _PartnerInfo;

  /// Creates a [PartnerInfo] from JSON data.
  factory PartnerInfo.fromJson(Map<String, dynamic> json) =>
      _$PartnerInfoFromJson(json);
}

/// Represents location details information for verification.
/// Aligned with PartnerRequestEntity address fields from sign-up form.
@freezed
abstract class LocationDetailsInfo with _$LocationDetailsInfo {
  /// Creates a new [LocationDetailsInfo].
  const factory LocationDetailsInfo({
    /// Province ID.
    required VerificationStringField provinceId,

    /// District ID.
    required VerificationStringField districtId,

    /// Ward ID.
    required VerificationStringField wardId,

    /// Detailed street address.
    required VerificationStringField streetAddress,
  }) = _LocationDetailsInfo;

  /// Creates a [LocationDetailsInfo] from JSON data.
  factory LocationDetailsInfo.fromJson(Map<String, dynamic> json) =>
      _$LocationDetailsInfoFromJson(json);
}

/// Represents document verification information.
/// Aligned with PartnerDocumentVerificationEntity from sign-up form.
@freezed
abstract class DocumentVerificationInfo with _$DocumentVerificationInfo {
  /// Creates a new [DocumentVerificationInfo].
  const factory DocumentVerificationInfo({
    /// Business license document.
    VerificationDocument? businessLicense,

    /// Authorization letter document.
    VerificationDocument? authorizationLetter,

    /// Tax certificate document.
    VerificationDocument? taxCertificate,

    /// Other supporting documents.
    @Default([]) List<VerificationDocument> otherDocuments,
  }) = _DocumentVerificationInfo;

  /// Creates a [DocumentVerificationInfo] from JSON data.
  factory DocumentVerificationInfo.fromJson(Map<String, dynamic> json) =>
      _$DocumentVerificationInfoFromJson(json);
}

/// Represents the legal representative details and documents.
/// Aligned with LegalRepresentativeEntity from sign-up form.
@freezed
abstract class LegalRepresentativeInfo with _$LegalRepresentativeInfo {
  /// Creates a new [LegalRepresentativeInfo].
  const factory LegalRepresentativeInfo({
    /// Full legal name of the representative.
    required VerificationStringField fullName,

    /// Position/title of the representative.
    VerificationStringField? position,

    /// Phone number of the representative.
    VerificationStringField? phoneNumber,

    /// Type of government ID (e.g., 'ID Card', 'Passport').
    required VerificationStringField idType,

    /// Government ID number.
    required VerificationStringField idNumber,

    /// ID issue date (ISO format string).
    required VerificationStringField idIssueDate,

    /// Front side of government ID.
    required VerificationDocument idFrontImage,

    /// Back side of government ID.
    required VerificationDocument idBackImage,

    /// Document verification info (business license, authorization, etc.).
    DocumentVerificationInfo? documents,
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

    /// Partner (business entity) details, if available.
    PartnerInfo? partnerInfo,

    /// Location details, if available.
    LocationDetailsInfo? locationDetails,

    /// Legal representative details, if available.
    LegalRepresentativeInfo? legalRepresentative,

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
