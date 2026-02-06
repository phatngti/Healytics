import 'package:freezed_annotation/freezed_annotation.dart';

part 'authenticate.entity.freezed.dart';
part 'authenticate.entity.g.dart';

@Freezed(toJson: true)
abstract class SignInRequestEntity with _$SignInRequestEntity {
  const factory SignInRequestEntity({
    required String email,
    required String password,
  }) = _SignInRequestEntity;

  factory SignInRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$SignInRequestEntityFromJson(json);
}

@Freezed(toJson: true)
abstract class SignInResponseEntity with _$SignInResponseEntity {
  const factory SignInResponseEntity({
    required String accessToken,
    required String refreshToken,
    required String role,
    String? verificationStatus,
    String? verificationCompletedAt,
  }) = _SignInResponseEntity;

  factory SignInResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseEntityFromJson(json);
}

// ===========================================================================
// OTP Flow Entities (Mock only - no backend endpoints)
// ===========================================================================

/// Response from sending OTP to email (mock implementation).
@Freezed(toJson: true)
abstract class SendOtpResponseEntity with _$SendOtpResponseEntity {
  const factory SendOtpResponseEntity({
    required String emailToken,
    required String message,
  }) = _SendOtpResponseEntity;

  factory SendOtpResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$SendOtpResponseEntityFromJson(json);
}

/// Response from verifying OTP (mock implementation).
@Freezed(toJson: true)
abstract class VerifyOtpResponseEntity with _$VerifyOtpResponseEntity {
  const factory VerifyOtpResponseEntity({
    required String otpToken,
    required String message,
  }) = _VerifyOtpResponseEntity;

  factory VerifyOtpResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseEntityFromJson(json);
}

// ===========================================================================
// Partner Registration Entities (Maps to OpenAPI DTOs)
// ===========================================================================

/// Account credentials for registration.
@Freezed(toJson: true)
abstract class AccountRequestEntity with _$AccountRequestEntity {
  const factory AccountRequestEntity({
    required String username,
    required String email,
    required String password,
  }) = _AccountRequestEntity;

  factory AccountRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$AccountRequestEntityFromJson(json);
}

/// Partner (Business Entity) information.
@Freezed(toJson: true)
abstract class PartnerRequestEntity with _$PartnerRequestEntity {
  const factory PartnerRequestEntity({
    required String taxCode,
    required String legalName,
    required String brandName,
    required List<String> businessType,
    required String provinceId,
    required String districtId,
    required String wardId,
    required String streetAddress,
    String? phoneNumber,
  }) = _PartnerRequestEntity;

  factory PartnerRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$PartnerRequestEntityFromJson(json);
}

/// Authorization information for legal representative.
@Freezed(toJson: true)
abstract class AuthorizationEntity with _$AuthorizationEntity {
  const factory AuthorizationEntity({
    required bool isAuthorizedUser,
    String? authLetterDocUrl,
  }) = _AuthorizationEntity;

  factory AuthorizationEntity.fromJson(Map<String, dynamic> json) =>
      _$AuthorizationEntityFromJson(json);
}

/// Partner document verification information.
///
/// Each document has a type, fileType, documentKey, and list of URLs.
@Freezed(toJson: true)
abstract class PartnerDocumentVerificationEntity
    with _$PartnerDocumentVerificationEntity {
  const factory PartnerDocumentVerificationEntity({
    /// File type of document (e.g., 'pdf', 'image').
    required String fileType,

    /// Type of document (e.g., 'BUSINESS_LICENSE', 'AUTHORIZATION_LETTER').
    required String type,

    /// Document key/identifier (e.g., 'business_license').
    required String documentKey,

    /// Array of URLs to document files.
    @Default([]) List<String> urls,
  }) = _PartnerDocumentVerificationEntity;

  factory PartnerDocumentVerificationEntity.fromJson(
    Map<String, dynamic> json,
  ) => _$PartnerDocumentVerificationEntityFromJson(json);
}

/// Legal representative information.
@Freezed(toJson: true)
abstract class LegalRepresentativeEntity with _$LegalRepresentativeEntity {
  const factory LegalRepresentativeEntity({
    required String fullName,
    String? position,
    String? phoneNumber,
    required String idType,
    required String idNumber,
    required String idIssueDate,

    /// List of verification documents.
    @Default([]) List<PartnerDocumentVerificationEntity> documents,
  }) = _LegalRepresentativeEntity;

  factory LegalRepresentativeEntity.fromJson(Map<String, dynamic> json) =>
      _$LegalRepresentativeEntityFromJson(json);
}

/// Complete partner registration request.
@Freezed(toJson: true)
abstract class RegisterPartnerRequestEntity
    with _$RegisterPartnerRequestEntity {
  const factory RegisterPartnerRequestEntity({
    required AccountRequestEntity account,
    required PartnerRequestEntity partner,
    required LegalRepresentativeEntity legalRepresentative,
  }) = _RegisterPartnerRequestEntity;

  factory RegisterPartnerRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$RegisterPartnerRequestEntityFromJson(json);
}

/// Response from partner registration.
@Freezed(toJson: true)
abstract class RegisterPartnerResponseEntity
    with _$RegisterPartnerResponseEntity {
  const factory RegisterPartnerResponseEntity({
    required String accountId,
    required String businessEntityId,
    required String status,
    required String message,
    required String accessToken,
    required String accessExpiresIn,
    required String refreshToken,
    required String refreshExpiresIn,
  }) = _RegisterPartnerResponseEntity;

  factory RegisterPartnerResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$RegisterPartnerResponseEntityFromJson(json);
}

// ===========================================================================
// Legacy SignUpRequestEntity (kept for backward compatibility)
// ===========================================================================

@Freezed(toJson: true)
abstract class SignUpRequestEntity with _$SignUpRequestEntity {
  const factory SignUpRequestEntity({
    // Business Entity (Step 1)
    @Default('') String companyName,
    @Default('') String taxRegistrationCode,
    @Default('') String businessEmail,
    @Default('') String businessPhone,
    @Default([]) List<String> serviceCategories,

    // Location (Step 2)
    @Default('') String country,
    @Default('') String city,
    @Default('') String district,
    @Default('') String detailedAddress,

    // Legal Representative (Step 3)
    @Default('') String representativeName,
    @Default('') String governmentIdNumber,
    String? frontIdUrl,
    String? backIdUrl,
    @Default(false) bool requiresAuthorizationLetter,
    String? authorizationLetterUrl,

    // Account Security
    @Default('') String password,
  }) = _SignUpRequestEntity;

  factory SignUpRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestEntityFromJson(json);
}
