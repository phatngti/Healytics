//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminPartnerDetailResponseDto {
  /// Returns a new [AdminPartnerDetailResponseDto] instance.
  AdminPartnerDetailResponseDto({
    required this.id,
    required this.email,
    required this.taxCode,
    required this.legalName,
    required this.brandName,
    required this.businessType,
    required this.phoneNumber,
    required this.address,
    required this.verificationStatus,
    required this.verificationCompletedAt,
    required this.createdAt,
    required this.legalRepresentative,
    this.documents = const [],
    required this.rejectionDetails,
  });

  String id;

  String email;

  String taxCode;

  String legalName;

  String brandName;

  String businessType;

  Object? phoneNumber;

  AddressDto address;

  AdminPartnerDetailResponseDtoVerificationStatusEnum verificationStatus;

  Object? verificationCompletedAt;

  DateTime createdAt;

  AdminLegalRepresentativeDto? legalRepresentative;

  List<PartnerDocumentDto> documents;

  /// Field-level rejection details
  Object? rejectionDetails;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminPartnerDetailResponseDto &&
    other.id == id &&
    other.email == email &&
    other.taxCode == taxCode &&
    other.legalName == legalName &&
    other.brandName == brandName &&
    other.businessType == businessType &&
    other.phoneNumber == phoneNumber &&
    other.address == address &&
    other.verificationStatus == verificationStatus &&
    other.verificationCompletedAt == verificationCompletedAt &&
    other.createdAt == createdAt &&
    other.legalRepresentative == legalRepresentative &&
    _deepEquality.equals(other.documents, documents) &&
    other.rejectionDetails == rejectionDetails;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (email.hashCode) +
    (taxCode.hashCode) +
    (legalName.hashCode) +
    (brandName.hashCode) +
    (businessType.hashCode) +
    (phoneNumber == null ? 0 : phoneNumber!.hashCode) +
    (address.hashCode) +
    (verificationStatus.hashCode) +
    (verificationCompletedAt == null ? 0 : verificationCompletedAt!.hashCode) +
    (createdAt.hashCode) +
    (legalRepresentative == null ? 0 : legalRepresentative!.hashCode) +
    (documents.hashCode) +
    (rejectionDetails == null ? 0 : rejectionDetails!.hashCode);

  @override
  String toString() => 'AdminPartnerDetailResponseDto[id=$id, email=$email, taxCode=$taxCode, legalName=$legalName, brandName=$brandName, businessType=$businessType, phoneNumber=$phoneNumber, address=$address, verificationStatus=$verificationStatus, verificationCompletedAt=$verificationCompletedAt, createdAt=$createdAt, legalRepresentative=$legalRepresentative, documents=$documents, rejectionDetails=$rejectionDetails]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'email'] = this.email;
      json[r'taxCode'] = this.taxCode;
      json[r'legalName'] = this.legalName;
      json[r'brandName'] = this.brandName;
      json[r'businessType'] = this.businessType;
    if (this.phoneNumber != null) {
      json[r'phoneNumber'] = this.phoneNumber;
    } else {
      json[r'phoneNumber'] = null;
    }
      json[r'address'] = this.address;
      json[r'verificationStatus'] = this.verificationStatus;
    if (this.verificationCompletedAt != null) {
      json[r'verificationCompletedAt'] = this.verificationCompletedAt;
    } else {
      json[r'verificationCompletedAt'] = null;
    }
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    if (this.legalRepresentative != null) {
      json[r'legalRepresentative'] = this.legalRepresentative;
    } else {
      json[r'legalRepresentative'] = null;
    }
      json[r'documents'] = this.documents;
    if (this.rejectionDetails != null) {
      json[r'rejectionDetails'] = this.rejectionDetails;
    } else {
      json[r'rejectionDetails'] = null;
    }
    return json;
  }

  /// Returns a new [AdminPartnerDetailResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminPartnerDetailResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminPartnerDetailResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminPartnerDetailResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminPartnerDetailResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        email: mapValueOfType<String>(json, r'email')!,
        taxCode: mapValueOfType<String>(json, r'taxCode')!,
        legalName: mapValueOfType<String>(json, r'legalName')!,
        brandName: mapValueOfType<String>(json, r'brandName')!,
        businessType: mapValueOfType<String>(json, r'businessType')!,
        phoneNumber: mapValueOfType<Object>(json, r'phoneNumber'),
        address: AddressDto.fromJson(json[r'address'])!,
        verificationStatus: AdminPartnerDetailResponseDtoVerificationStatusEnum.fromJson(json[r'verificationStatus'])!,
        verificationCompletedAt: mapValueOfType<Object>(json, r'verificationCompletedAt'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        legalRepresentative: AdminLegalRepresentativeDto.fromJson(json[r'legalRepresentative']),
        documents: PartnerDocumentDto.listFromJson(json[r'documents']),
        rejectionDetails: mapValueOfType<Object>(json, r'rejectionDetails'),
      );
    }
    return null;
  }

  static List<AdminPartnerDetailResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPartnerDetailResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPartnerDetailResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminPartnerDetailResponseDto> mapFromJson(dynamic json) {
    final map = <String, AdminPartnerDetailResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminPartnerDetailResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminPartnerDetailResponseDto-objects as value to a dart map
  static Map<String, List<AdminPartnerDetailResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminPartnerDetailResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminPartnerDetailResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'email',
    'taxCode',
    'legalName',
    'brandName',
    'businessType',
    'phoneNumber',
    'address',
    'verificationStatus',
    'verificationCompletedAt',
    'createdAt',
    'legalRepresentative',
    'documents',
    'rejectionDetails',
  };
}


class AdminPartnerDetailResponseDtoVerificationStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const AdminPartnerDetailResponseDtoVerificationStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const PENDING = AdminPartnerDetailResponseDtoVerificationStatusEnum._(r'PENDING');
  static const APPROVED = AdminPartnerDetailResponseDtoVerificationStatusEnum._(r'APPROVED');
  static const REJECTED = AdminPartnerDetailResponseDtoVerificationStatusEnum._(r'REJECTED');
  static const REQUIRED_RESUBMIT = AdminPartnerDetailResponseDtoVerificationStatusEnum._(r'REQUIRED_RESUBMIT');

  /// List of all possible values in this [enum][AdminPartnerDetailResponseDtoVerificationStatusEnum].
  static const values = <AdminPartnerDetailResponseDtoVerificationStatusEnum>[
    PENDING,
    APPROVED,
    REJECTED,
    REQUIRED_RESUBMIT,
  ];

  static AdminPartnerDetailResponseDtoVerificationStatusEnum? fromJson(dynamic value) => AdminPartnerDetailResponseDtoVerificationStatusEnumTypeTransformer().decode(value);

  static List<AdminPartnerDetailResponseDtoVerificationStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPartnerDetailResponseDtoVerificationStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPartnerDetailResponseDtoVerificationStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPartnerDetailResponseDtoVerificationStatusEnum] to String,
/// and [decode] dynamic data back to [AdminPartnerDetailResponseDtoVerificationStatusEnum].
class AdminPartnerDetailResponseDtoVerificationStatusEnumTypeTransformer {
  factory AdminPartnerDetailResponseDtoVerificationStatusEnumTypeTransformer() => _instance ??= const AdminPartnerDetailResponseDtoVerificationStatusEnumTypeTransformer._();

  const AdminPartnerDetailResponseDtoVerificationStatusEnumTypeTransformer._();

  String encode(AdminPartnerDetailResponseDtoVerificationStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminPartnerDetailResponseDtoVerificationStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPartnerDetailResponseDtoVerificationStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'PENDING': return AdminPartnerDetailResponseDtoVerificationStatusEnum.PENDING;
        case r'APPROVED': return AdminPartnerDetailResponseDtoVerificationStatusEnum.APPROVED;
        case r'REJECTED': return AdminPartnerDetailResponseDtoVerificationStatusEnum.REJECTED;
        case r'REQUIRED_RESUBMIT': return AdminPartnerDetailResponseDtoVerificationStatusEnum.REQUIRED_RESUBMIT;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminPartnerDetailResponseDtoVerificationStatusEnumTypeTransformer] instance.
  static AdminPartnerDetailResponseDtoVerificationStatusEnumTypeTransformer? _instance;
}


