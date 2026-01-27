//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MyProfileResponseDto {
  /// Returns a new [MyProfileResponseDto] instance.
  MyProfileResponseDto({
    required this.id,
    required this.taxCode,
    required this.legalName,
    required this.brandName,
    required this.businessType,
    required this.phoneNumber,
    required this.address,
    required this.legalRepresentative,
    required this.verificationStatus,
    required this.rejectionDetails,
    this.documents = const [],
    required this.verificationCompletedAt,
    required this.createdAt,
  });

  String id;

  String taxCode;

  String legalName;

  String brandName;

  MyProfileResponseDtoBusinessTypeEnum businessType;

  Object? phoneNumber;

  AddressDto address;

  LegalRepresentativeDto legalRepresentative;

  MyProfileResponseDtoVerificationStatusEnum verificationStatus;

  /// Field-level rejection details
  Object? rejectionDetails;

  /// List of documents with their status
  List<PartnerDocumentDto> documents;

  Object? verificationCompletedAt;

  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MyProfileResponseDto &&
    other.id == id &&
    other.taxCode == taxCode &&
    other.legalName == legalName &&
    other.brandName == brandName &&
    other.businessType == businessType &&
    other.phoneNumber == phoneNumber &&
    other.address == address &&
    other.legalRepresentative == legalRepresentative &&
    other.verificationStatus == verificationStatus &&
    other.rejectionDetails == rejectionDetails &&
    _deepEquality.equals(other.documents, documents) &&
    other.verificationCompletedAt == verificationCompletedAt &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (taxCode.hashCode) +
    (legalName.hashCode) +
    (brandName.hashCode) +
    (businessType.hashCode) +
    (phoneNumber == null ? 0 : phoneNumber!.hashCode) +
    (address.hashCode) +
    (legalRepresentative.hashCode) +
    (verificationStatus.hashCode) +
    (rejectionDetails == null ? 0 : rejectionDetails!.hashCode) +
    (documents.hashCode) +
    (verificationCompletedAt == null ? 0 : verificationCompletedAt!.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'MyProfileResponseDto[id=$id, taxCode=$taxCode, legalName=$legalName, brandName=$brandName, businessType=$businessType, phoneNumber=$phoneNumber, address=$address, legalRepresentative=$legalRepresentative, verificationStatus=$verificationStatus, rejectionDetails=$rejectionDetails, documents=$documents, verificationCompletedAt=$verificationCompletedAt, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
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
      json[r'legalRepresentative'] = this.legalRepresentative;
      json[r'verificationStatus'] = this.verificationStatus;
    if (this.rejectionDetails != null) {
      json[r'rejectionDetails'] = this.rejectionDetails;
    } else {
      json[r'rejectionDetails'] = null;
    }
      json[r'documents'] = this.documents;
    if (this.verificationCompletedAt != null) {
      json[r'verificationCompletedAt'] = this.verificationCompletedAt;
    } else {
      json[r'verificationCompletedAt'] = null;
    }
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [MyProfileResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MyProfileResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MyProfileResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MyProfileResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MyProfileResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        taxCode: mapValueOfType<String>(json, r'taxCode')!,
        legalName: mapValueOfType<String>(json, r'legalName')!,
        brandName: mapValueOfType<String>(json, r'brandName')!,
        businessType: MyProfileResponseDtoBusinessTypeEnum.fromJson(json[r'businessType'])!,
        phoneNumber: mapValueOfType<Object>(json, r'phoneNumber'),
        address: AddressDto.fromJson(json[r'address'])!,
        legalRepresentative: LegalRepresentativeDto.fromJson(json[r'legalRepresentative'])!,
        verificationStatus: MyProfileResponseDtoVerificationStatusEnum.fromJson(json[r'verificationStatus'])!,
        rejectionDetails: mapValueOfType<Object>(json, r'rejectionDetails'),
        documents: PartnerDocumentDto.listFromJson(json[r'documents']),
        verificationCompletedAt: mapValueOfType<Object>(json, r'verificationCompletedAt'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
      );
    }
    return null;
  }

  static List<MyProfileResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MyProfileResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MyProfileResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MyProfileResponseDto> mapFromJson(dynamic json) {
    final map = <String, MyProfileResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MyProfileResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MyProfileResponseDto-objects as value to a dart map
  static Map<String, List<MyProfileResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MyProfileResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MyProfileResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'taxCode',
    'legalName',
    'brandName',
    'businessType',
    'phoneNumber',
    'address',
    'legalRepresentative',
    'verificationStatus',
    'rejectionDetails',
    'documents',
    'verificationCompletedAt',
    'createdAt',
  };
}


class MyProfileResponseDtoBusinessTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const MyProfileResponseDtoBusinessTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MASSAGE_THERAPY = MyProfileResponseDtoBusinessTypeEnum._(r'MASSAGE_THERAPY');
  static const MASSAGE_REHABILITATION = MyProfileResponseDtoBusinessTypeEnum._(r'MASSAGE_REHABILITATION');
  static const SPA_BEAUTY = MyProfileResponseDtoBusinessTypeEnum._(r'SPA_BEAUTY');
  static const FITNESS = MyProfileResponseDtoBusinessTypeEnum._(r'FITNESS');
  static const PHARMACY = MyProfileResponseDtoBusinessTypeEnum._(r'PHARMACY');
  static const DENTAL = MyProfileResponseDtoBusinessTypeEnum._(r'DENTAL');
  static const TRADITIONAL_MEDICINE = MyProfileResponseDtoBusinessTypeEnum._(r'TRADITIONAL_MEDICINE');
  static const PSYCHOLOGY = MyProfileResponseDtoBusinessTypeEnum._(r'PSYCHOLOGY');
  static const DERMATOLOGY = MyProfileResponseDtoBusinessTypeEnum._(r'DERMATOLOGY');
  static const NUTRITION = MyProfileResponseDtoBusinessTypeEnum._(r'NUTRITION');
  static const PSYCHIATRY = MyProfileResponseDtoBusinessTypeEnum._(r'PSYCHIATRY');

  /// List of all possible values in this [enum][MyProfileResponseDtoBusinessTypeEnum].
  static const values = <MyProfileResponseDtoBusinessTypeEnum>[
    MASSAGE_THERAPY,
    MASSAGE_REHABILITATION,
    SPA_BEAUTY,
    FITNESS,
    PHARMACY,
    DENTAL,
    TRADITIONAL_MEDICINE,
    PSYCHOLOGY,
    DERMATOLOGY,
    NUTRITION,
    PSYCHIATRY,
  ];

  static MyProfileResponseDtoBusinessTypeEnum? fromJson(dynamic value) => MyProfileResponseDtoBusinessTypeEnumTypeTransformer().decode(value);

  static List<MyProfileResponseDtoBusinessTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MyProfileResponseDtoBusinessTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MyProfileResponseDtoBusinessTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MyProfileResponseDtoBusinessTypeEnum] to String,
/// and [decode] dynamic data back to [MyProfileResponseDtoBusinessTypeEnum].
class MyProfileResponseDtoBusinessTypeEnumTypeTransformer {
  factory MyProfileResponseDtoBusinessTypeEnumTypeTransformer() => _instance ??= const MyProfileResponseDtoBusinessTypeEnumTypeTransformer._();

  const MyProfileResponseDtoBusinessTypeEnumTypeTransformer._();

  String encode(MyProfileResponseDtoBusinessTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a MyProfileResponseDtoBusinessTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MyProfileResponseDtoBusinessTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MASSAGE_THERAPY': return MyProfileResponseDtoBusinessTypeEnum.MASSAGE_THERAPY;
        case r'MASSAGE_REHABILITATION': return MyProfileResponseDtoBusinessTypeEnum.MASSAGE_REHABILITATION;
        case r'SPA_BEAUTY': return MyProfileResponseDtoBusinessTypeEnum.SPA_BEAUTY;
        case r'FITNESS': return MyProfileResponseDtoBusinessTypeEnum.FITNESS;
        case r'PHARMACY': return MyProfileResponseDtoBusinessTypeEnum.PHARMACY;
        case r'DENTAL': return MyProfileResponseDtoBusinessTypeEnum.DENTAL;
        case r'TRADITIONAL_MEDICINE': return MyProfileResponseDtoBusinessTypeEnum.TRADITIONAL_MEDICINE;
        case r'PSYCHOLOGY': return MyProfileResponseDtoBusinessTypeEnum.PSYCHOLOGY;
        case r'DERMATOLOGY': return MyProfileResponseDtoBusinessTypeEnum.DERMATOLOGY;
        case r'NUTRITION': return MyProfileResponseDtoBusinessTypeEnum.NUTRITION;
        case r'PSYCHIATRY': return MyProfileResponseDtoBusinessTypeEnum.PSYCHIATRY;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [MyProfileResponseDtoBusinessTypeEnumTypeTransformer] instance.
  static MyProfileResponseDtoBusinessTypeEnumTypeTransformer? _instance;
}



class MyProfileResponseDtoVerificationStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const MyProfileResponseDtoVerificationStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const PENDING = MyProfileResponseDtoVerificationStatusEnum._(r'PENDING');
  static const APPROVED = MyProfileResponseDtoVerificationStatusEnum._(r'APPROVED');
  static const REJECTED = MyProfileResponseDtoVerificationStatusEnum._(r'REJECTED');
  static const REQUIRED_RESUBMIT = MyProfileResponseDtoVerificationStatusEnum._(r'REQUIRED_RESUBMIT');

  /// List of all possible values in this [enum][MyProfileResponseDtoVerificationStatusEnum].
  static const values = <MyProfileResponseDtoVerificationStatusEnum>[
    PENDING,
    APPROVED,
    REJECTED,
    REQUIRED_RESUBMIT,
  ];

  static MyProfileResponseDtoVerificationStatusEnum? fromJson(dynamic value) => MyProfileResponseDtoVerificationStatusEnumTypeTransformer().decode(value);

  static List<MyProfileResponseDtoVerificationStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MyProfileResponseDtoVerificationStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MyProfileResponseDtoVerificationStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MyProfileResponseDtoVerificationStatusEnum] to String,
/// and [decode] dynamic data back to [MyProfileResponseDtoVerificationStatusEnum].
class MyProfileResponseDtoVerificationStatusEnumTypeTransformer {
  factory MyProfileResponseDtoVerificationStatusEnumTypeTransformer() => _instance ??= const MyProfileResponseDtoVerificationStatusEnumTypeTransformer._();

  const MyProfileResponseDtoVerificationStatusEnumTypeTransformer._();

  String encode(MyProfileResponseDtoVerificationStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a MyProfileResponseDtoVerificationStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MyProfileResponseDtoVerificationStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'PENDING': return MyProfileResponseDtoVerificationStatusEnum.PENDING;
        case r'APPROVED': return MyProfileResponseDtoVerificationStatusEnum.APPROVED;
        case r'REJECTED': return MyProfileResponseDtoVerificationStatusEnum.REJECTED;
        case r'REQUIRED_RESUBMIT': return MyProfileResponseDtoVerificationStatusEnum.REQUIRED_RESUBMIT;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [MyProfileResponseDtoVerificationStatusEnumTypeTransformer] instance.
  static MyProfileResponseDtoVerificationStatusEnumTypeTransformer? _instance;
}


