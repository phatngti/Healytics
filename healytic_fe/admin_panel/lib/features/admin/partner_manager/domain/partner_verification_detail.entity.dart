import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner_verification_detail.entity.freezed.dart';
part 'partner_verification_detail.entity.g.dart';

/// A field that can be verified with optional feedback.
/// Uses generic type [T] for the value, with JSON serialization support.
@freezed
abstract class VerifiedFieldEntity<T> with _$VerifiedFieldEntity<T> {
  const factory VerifiedFieldEntity({
    required String fieldKey,
    required T value,
    @Default(false) bool isVerified,
    String? feedback,
  }) = _VerifiedFieldEntity<T>;

  /// Creates a [VerifiedFieldEntity] from JSON.
  /// The [valueConverter] function is used to convert the value from JSON.
  static VerifiedFieldEntity<T> fromJsonWithConverter<T>(
    Map<String, dynamic> json,
    T Function(Object? value) valueConverter,
  ) {
    return VerifiedFieldEntity<T>(
      fieldKey: json['fieldKey'] as String,
      value: valueConverter(json['value']),
      isVerified: json['isVerified'] as bool? ?? false,
      feedback: json['feedback'] as String?,
    );
  }

  /// Helper for converting string values from JSON
  static VerifiedFieldEntity<String> stringFromJson(Map<String, dynamic> json) {
    return fromJsonWithConverter<String>(json, (v) => v?.toString() ?? '');
  }

  /// Helper for nullable string values from JSON
  static VerifiedFieldEntity<String?> nullableStringFromJson(
    Map<String, dynamic> json,
  ) {
    return fromJsonWithConverter<String?>(json, (v) => v?.toString());
  }

  /// Helper for list of strings from JSON
  static VerifiedFieldEntity<List<String>> stringListFromJson(
    Map<String, dynamic> json,
  ) {
    return fromJsonWithConverter<List<String>>(json, (v) {
      if (v is List) {
        return v.map((e) => e.toString()).toList();
      }
      return [];
    });
  }
}

/// Extension methods for [VerifiedFieldEntity] to help with JSON serialization.
extension VerifiedFieldEntityJson<T> on VerifiedFieldEntity<T> {
  Map<String, dynamic> toJson() {
    return {
      'fieldKey': fieldKey,
      'value': value,
      'isVerified': isVerified,
      'feedback': feedback,
    };
  }
}

/// KYC Document entity
@freezed
abstract class KycDocument with _$KycDocument {
  const factory KycDocument({
    required String id,
    required String fileName,
    required String fileType,
    required String documentKey,
    String? fileUrl,
    String? fileSize,
    DateTime? uploadedAt,
  }) = _KycDocument;

  factory KycDocument.fromJson(Map<String, dynamic> json) =>
      _$KycDocumentFromJson(json);
}

/// Legal representative information
@Freezed(fromJson: false, toJson: false)
abstract class LegalRepresentative with _$LegalRepresentative {
  const LegalRepresentative._();

  const factory LegalRepresentative({
    required VerifiedFieldEntity<String> fullName,
    VerifiedFieldEntity<String>? position,
    VerifiedFieldEntity<String>? idType,
    VerifiedFieldEntity<String>? idNumber,
    VerifiedFieldEntity<String>? idIssueDate,
  }) = _LegalRepresentative;

  /// Custom JSON serialization for VerifiedFieldEntity fields
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName.toJson(),
      'position': position?.toJson(),
      'idType': idType?.toJson(),
      'idNumber': idNumber?.toJson(),
      'idIssueDate': idIssueDate?.toJson(),
    };
  }
}

@freezed
abstract class AddressLocation with _$AddressLocation {
  const factory AddressLocation({required String id, required String name}) =
      _AddressLocation;

  factory AddressLocation.fromJson(Map<String, dynamic> json) =>
      _$AddressLocationFromJson(json);
}

/// Address information
@Freezed(fromJson: false, toJson: false)
abstract class AddressInfo with _$AddressInfo {
  const AddressInfo._();

  const factory AddressInfo({
    VerifiedFieldEntity<String>? streetAddress,

    // Location IDs for reference
    VerifiedFieldEntity<AddressLocation>? ward,
    VerifiedFieldEntity<AddressLocation>? district,
    VerifiedFieldEntity<AddressLocation>? city,
    String? country,
    double? latitude,
    double? longitude,
  }) = _AddressInfo;

  /// Custom JSON serialization for VerifiedFieldEntity fields
  Map<String, dynamic> toJson() {
    return {
      'streetAddress': streetAddress?.toJson(),
      'ward': ward != null
          ? {
              'fieldKey': ward!.fieldKey,
              'value': {'id': ward!.value.id, 'name': ward!.value.name},
              'isVerified': ward!.isVerified,
              'feedback': ward!.feedback,
            }
          : null,
      'district': district != null
          ? {
              'fieldKey': district!.fieldKey,
              'value': {'id': district!.value.id, 'name': district!.value.name},
              'isVerified': district!.isVerified,
              'feedback': district!.feedback,
            }
          : null,
      'city': city != null
          ? {
              'fieldKey': city!.fieldKey,
              'value': {'id': city!.value.id, 'name': city!.value.name},
              'isVerified': city!.isVerified,
              'feedback': city!.feedback,
            }
          : null,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

/// Detailed partner verification entity for review page
///
/// Uses [VerifiedFieldEntity] for fields that support field-level verification
/// with `isVerified` and `feedback` properties.
@Freezed(toJson: false)
abstract class PartnerVerificationDetailEntity
    with _$PartnerVerificationDetailEntity {
  const PartnerVerificationDetailEntity._();

  const factory PartnerVerificationDetailEntity({
    required PartnerVerificationId id,

    // Business Info with verification status
    required VerifiedFieldEntity<String> brandName,
    VerifiedFieldEntity<String?>? taxRegistrationCode,
    @Default(false) bool isTaxCodeValid,
    AddressInfo? address,

    // Account & Contact with verification status
    VerifiedFieldEntity<String?>? email,
    @Default(false) bool isEmailVerified,
    VerifiedFieldEntity<String?>? phoneNumber,

    // Business Type with verification status
    required VerifiedFieldEntity<List<String>> businessType,

    // Legal Representative
    LegalRepresentative? legalRepresentative,

    // KYC Documents
    @Default([]) List<VerifiedFieldEntity<KycDocument>> kycDocuments,

    // Status & Metadata
    @Default(PartnerVerificationStatus.pending)
    PartnerVerificationStatus status,
    @Default(PartnerPriority.normal) PartnerPriority priority,
    required DateTime submittedAt,
    String? reviewNote,
  }) = _PartnerVerificationDetailEntity;

  /// Custom JSON serialization to handle generic VerifiedFieldEntity types
  Map<String, dynamic> toJson() {
    return {
      'id': id.value,
      'brandName': brandName.toJson(),
      'taxRegistrationCode': taxRegistrationCode?.toJson(),
      'isTaxCodeValid': isTaxCodeValid,
      'address': address?.toJson(),
      'email': email?.toJson(),
      'isEmailVerified': isEmailVerified,
      'phoneNumber': phoneNumber?.toJson(),
      'businessType': businessType.toJson(),
      'legalRepresentative': legalRepresentative?.toJson(),
      'kycDocuments': kycDocuments.map((e) => e.toJson()).toList(),
      'status': status.name,
      'priority': priority.name,
      'submittedAt': submittedAt.toIso8601String(),
      'reviewNote': reviewNote,
    };
  }
}
