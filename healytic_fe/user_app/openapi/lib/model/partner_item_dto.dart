//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerItemDto {
  /// Returns a new [PartnerItemDto] instance.
  PartnerItemDto({
    required this.id,
    required this.taxCode,
    required this.brandName,
    required this.legalName,
    required this.email,
    this.businessType = const [],
    required this.verificationStatus,
    required this.createdAt,
  });

  String id;

  String taxCode;

  String brandName;

  String legalName;

  String email;

  List<PartnerItemDtoBusinessTypeEnum> businessType;

  PartnerItemDtoVerificationStatusEnum verificationStatus;

  DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartnerItemDto &&
          other.id == id &&
          other.taxCode == taxCode &&
          other.brandName == brandName &&
          other.legalName == legalName &&
          other.email == email &&
          _deepEquality.equals(other.businessType, businessType) &&
          other.verificationStatus == verificationStatus &&
          other.createdAt == createdAt;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (id.hashCode) +
      (taxCode.hashCode) +
      (brandName.hashCode) +
      (legalName.hashCode) +
      (email.hashCode) +
      (businessType.hashCode) +
      (verificationStatus.hashCode) +
      (createdAt.hashCode);

  @override
  String toString() =>
      'PartnerItemDto[id=$id, taxCode=$taxCode, brandName=$brandName, legalName=$legalName, email=$email, businessType=$businessType, verificationStatus=$verificationStatus, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'id'] = this.id;
    json[r'taxCode'] = this.taxCode;
    json[r'brandName'] = this.brandName;
    json[r'legalName'] = this.legalName;
    json[r'email'] = this.email;
    json[r'businessType'] = this.businessType.map((e) => e.toJson()).toList();
    json[r'verificationStatus'] = this.verificationStatus;
    json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [PartnerItemDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerItemDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "PartnerItemDto[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "PartnerItemDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerItemDto(
        id: mapValueOfType<String>(json, r'id')!,
        taxCode: mapValueOfType<String>(json, r'taxCode')!,
        brandName: mapValueOfType<String>(json, r'brandName')!,
        legalName: mapValueOfType<String>(json, r'legalName')!,
        email: mapValueOfType<String>(json, r'email')!,
        businessType:
            PartnerItemDtoBusinessTypeEnum.listFromJson(json[r'businessType']),
        verificationStatus: PartnerItemDtoVerificationStatusEnum.fromJson(
            json[r'verificationStatus'])!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
      );
    }
    return null;
  }

  static List<PartnerItemDto> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <PartnerItemDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerItemDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerItemDto> mapFromJson(dynamic json) {
    final map = <String, PartnerItemDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerItemDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerItemDto-objects as value to a dart map
  static Map<String, List<PartnerItemDto>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<PartnerItemDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerItemDto.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'taxCode',
    'brandName',
    'legalName',
    'email',
    'businessType',
    'verificationStatus',
    'createdAt',
  };
}

class PartnerItemDtoBusinessTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const PartnerItemDtoBusinessTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MASSAGE_THERAPY =
      PartnerItemDtoBusinessTypeEnum._(r'MASSAGE_THERAPY');
  static const MASSAGE_REHABILITATION =
      PartnerItemDtoBusinessTypeEnum._(r'MASSAGE_REHABILITATION');
  static const SPA_BEAUTY = PartnerItemDtoBusinessTypeEnum._(r'SPA_BEAUTY');
  static const FITNESS = PartnerItemDtoBusinessTypeEnum._(r'FITNESS');
  static const PHARMACY = PartnerItemDtoBusinessTypeEnum._(r'PHARMACY');
  static const DENTAL = PartnerItemDtoBusinessTypeEnum._(r'DENTAL');
  static const TRADITIONAL_MEDICINE =
      PartnerItemDtoBusinessTypeEnum._(r'TRADITIONAL_MEDICINE');
  static const PSYCHOLOGY = PartnerItemDtoBusinessTypeEnum._(r'PSYCHOLOGY');
  static const DERMATOLOGY = PartnerItemDtoBusinessTypeEnum._(r'DERMATOLOGY');
  static const NUTRITION = PartnerItemDtoBusinessTypeEnum._(r'NUTRITION');
  static const PSYCHIATRY = PartnerItemDtoBusinessTypeEnum._(r'PSYCHIATRY');

  /// List of all possible values in this [enum][PartnerItemDtoBusinessTypeEnum].
  static const values = <PartnerItemDtoBusinessTypeEnum>[
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

  static PartnerItemDtoBusinessTypeEnum? fromJson(dynamic value) =>
      PartnerItemDtoBusinessTypeEnumTypeTransformer().decode(value);

  static List<PartnerItemDtoBusinessTypeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <PartnerItemDtoBusinessTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerItemDtoBusinessTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PartnerItemDtoBusinessTypeEnum] to String,
/// and [decode] dynamic data back to [PartnerItemDtoBusinessTypeEnum].
class PartnerItemDtoBusinessTypeEnumTypeTransformer {
  factory PartnerItemDtoBusinessTypeEnumTypeTransformer() =>
      _instance ??= const PartnerItemDtoBusinessTypeEnumTypeTransformer._();

  const PartnerItemDtoBusinessTypeEnumTypeTransformer._();

  String encode(PartnerItemDtoBusinessTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a PartnerItemDtoBusinessTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PartnerItemDtoBusinessTypeEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MASSAGE_THERAPY':
          return PartnerItemDtoBusinessTypeEnum.MASSAGE_THERAPY;
        case r'MASSAGE_REHABILITATION':
          return PartnerItemDtoBusinessTypeEnum.MASSAGE_REHABILITATION;
        case r'SPA_BEAUTY':
          return PartnerItemDtoBusinessTypeEnum.SPA_BEAUTY;
        case r'FITNESS':
          return PartnerItemDtoBusinessTypeEnum.FITNESS;
        case r'PHARMACY':
          return PartnerItemDtoBusinessTypeEnum.PHARMACY;
        case r'DENTAL':
          return PartnerItemDtoBusinessTypeEnum.DENTAL;
        case r'TRADITIONAL_MEDICINE':
          return PartnerItemDtoBusinessTypeEnum.TRADITIONAL_MEDICINE;
        case r'PSYCHOLOGY':
          return PartnerItemDtoBusinessTypeEnum.PSYCHOLOGY;
        case r'DERMATOLOGY':
          return PartnerItemDtoBusinessTypeEnum.DERMATOLOGY;
        case r'NUTRITION':
          return PartnerItemDtoBusinessTypeEnum.NUTRITION;
        case r'PSYCHIATRY':
          return PartnerItemDtoBusinessTypeEnum.PSYCHIATRY;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PartnerItemDtoBusinessTypeEnumTypeTransformer] instance.
  static PartnerItemDtoBusinessTypeEnumTypeTransformer? _instance;
}

class PartnerItemDtoVerificationStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const PartnerItemDtoVerificationStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const ONBOARDING =
      PartnerItemDtoVerificationStatusEnum._(r'ONBOARDING');
  static const PENDING = PartnerItemDtoVerificationStatusEnum._(r'PENDING');
  static const APPROVED = PartnerItemDtoVerificationStatusEnum._(r'APPROVED');
  static const REJECTED = PartnerItemDtoVerificationStatusEnum._(r'REJECTED');
  static const REQUIRED_RESUBMIT =
      PartnerItemDtoVerificationStatusEnum._(r'REQUIRED_RESUBMIT');

  /// List of all possible values in this [enum][PartnerItemDtoVerificationStatusEnum].
  static const values = <PartnerItemDtoVerificationStatusEnum>[
    ONBOARDING,
    PENDING,
    APPROVED,
    REJECTED,
    REQUIRED_RESUBMIT,
  ];

  static PartnerItemDtoVerificationStatusEnum? fromJson(dynamic value) =>
      PartnerItemDtoVerificationStatusEnumTypeTransformer().decode(value);

  static List<PartnerItemDtoVerificationStatusEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <PartnerItemDtoVerificationStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerItemDtoVerificationStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PartnerItemDtoVerificationStatusEnum] to String,
/// and [decode] dynamic data back to [PartnerItemDtoVerificationStatusEnum].
class PartnerItemDtoVerificationStatusEnumTypeTransformer {
  factory PartnerItemDtoVerificationStatusEnumTypeTransformer() => _instance ??=
      const PartnerItemDtoVerificationStatusEnumTypeTransformer._();

  const PartnerItemDtoVerificationStatusEnumTypeTransformer._();

  String encode(PartnerItemDtoVerificationStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a PartnerItemDtoVerificationStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PartnerItemDtoVerificationStatusEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'ONBOARDING':
          return PartnerItemDtoVerificationStatusEnum.ONBOARDING;
        case r'PENDING':
          return PartnerItemDtoVerificationStatusEnum.PENDING;
        case r'APPROVED':
          return PartnerItemDtoVerificationStatusEnum.APPROVED;
        case r'REJECTED':
          return PartnerItemDtoVerificationStatusEnum.REJECTED;
        case r'REQUIRED_RESUBMIT':
          return PartnerItemDtoVerificationStatusEnum.REQUIRED_RESUBMIT;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PartnerItemDtoVerificationStatusEnumTypeTransformer] instance.
  static PartnerItemDtoVerificationStatusEnumTypeTransformer? _instance;
}
