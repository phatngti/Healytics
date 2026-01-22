import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner_verification_detail.entity.freezed.dart';
part 'partner_verification_detail.entity.g.dart';

/// KYC Document types
enum KycDocumentType {
  @JsonValue('id_card_front')
  idCardFront,
  @JsonValue('id_card_back')
  idCardBack,
  @JsonValue('authorization_letter')
  authorizationLetter,
}

/// KYC Document entity
@freezed
abstract class KycDocument with _$KycDocument {
  const factory KycDocument({
    required String id,
    required KycDocumentType type,
    required String fileName,
    String? fileUrl,
    String? fileSize,
    DateTime? uploadedAt,
  }) = _KycDocument;

  factory KycDocument.fromJson(Map<String, dynamic> json) =>
      _$KycDocumentFromJson(json);
}

/// Legal representative information
@freezed
abstract class LegalRepresentative with _$LegalRepresentative {
  const factory LegalRepresentative({
    required String fullName,
    String? position,
    String? citizenId,
    String? verificationNote,
  }) = _LegalRepresentative;

  factory LegalRepresentative.fromJson(Map<String, dynamic> json) =>
      _$LegalRepresentativeFromJson(json);
}

/// Address information
@freezed
abstract class AddressInfo with _$AddressInfo {
  const factory AddressInfo({
    required String streetAddress,
    String? ward,
    String? district,
    String? city,
    String? country,
    double? latitude,
    double? longitude,
  }) = _AddressInfo;

  factory AddressInfo.fromJson(Map<String, dynamic> json) =>
      _$AddressInfoFromJson(json);
}

/// Detailed partner verification entity for review page
@Freezed(toJson: true)
abstract class PartnerVerificationDetailEntity
    with _$PartnerVerificationDetailEntity {
  const factory PartnerVerificationDetailEntity({
    required PartnerVerificationId id,
    required String brandName,
    String? taxRegistrationCode,
    @Default(false) bool isTaxCodeValid,
    @Default([]) List<String> serviceTags,
    AddressInfo? address,

    // Account & Contact
    String? username,
    String? email,
    @Default(false) bool isEmailVerified,
    String? phoneNumber,

    // Legal Representative
    LegalRepresentative? legalRepresentative,

    // KYC Documents
    @Default([]) List<KycDocument> kycDocuments,

    // Status & Metadata
    @Default(PartnerVerificationStatus.pending)
    PartnerVerificationStatus status,
    @Default(PartnerPriority.normal) PartnerPriority priority,
    required DateTime submittedAt,
    String? reviewNote,
  }) = _PartnerVerificationDetailEntity;

  factory PartnerVerificationDetailEntity.fromJson(Map<String, dynamic> json) =>
      _$PartnerVerificationDetailEntityFromJson(json);
}
