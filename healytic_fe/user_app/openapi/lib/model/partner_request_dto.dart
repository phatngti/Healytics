//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerRequestDto {
  /// Returns a new [PartnerRequestDto] instance.
  PartnerRequestDto({
    required this.taxCode,
    required this.legalName,
    required this.brandName,
    required this.businessType,
    required this.provinceId,
    required this.districtId,
    required this.wardId,
    required this.streetAddress,
    this.phoneNumber,
  });

  /// Tax code of the business (unique identifier)
  String taxCode;

  /// Legal name of the business
  String legalName;

  /// Brand name of the business
  String brandName;

  /// Type of business
  PartnerRequestDtoBusinessTypeEnum businessType;

  /// UUID of the province (from Location tree)
  String provinceId;

  /// UUID of the district (from Location tree)
  String districtId;

  /// UUID of the ward (from Location tree)
  String wardId;

  /// Street address of the business
  String streetAddress;

  /// Contact phone number for the business
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? phoneNumber;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerRequestDto &&
    other.taxCode == taxCode &&
    other.legalName == legalName &&
    other.brandName == brandName &&
    other.businessType == businessType &&
    other.provinceId == provinceId &&
    other.districtId == districtId &&
    other.wardId == wardId &&
    other.streetAddress == streetAddress &&
    other.phoneNumber == phoneNumber;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (taxCode.hashCode) +
    (legalName.hashCode) +
    (brandName.hashCode) +
    (businessType.hashCode) +
    (provinceId.hashCode) +
    (districtId.hashCode) +
    (wardId.hashCode) +
    (streetAddress.hashCode) +
    (phoneNumber == null ? 0 : phoneNumber!.hashCode);

  @override
  String toString() => 'PartnerRequestDto[taxCode=$taxCode, legalName=$legalName, brandName=$brandName, businessType=$businessType, provinceId=$provinceId, districtId=$districtId, wardId=$wardId, streetAddress=$streetAddress, phoneNumber=$phoneNumber]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'taxCode'] = this.taxCode;
      json[r'legalName'] = this.legalName;
      json[r'brandName'] = this.brandName;
      json[r'businessType'] = this.businessType;
      json[r'provinceId'] = this.provinceId;
      json[r'districtId'] = this.districtId;
      json[r'wardId'] = this.wardId;
      json[r'streetAddress'] = this.streetAddress;
    if (this.phoneNumber != null) {
      json[r'phoneNumber'] = this.phoneNumber;
    } else {
      json[r'phoneNumber'] = null;
    }
    return json;
  }

  /// Returns a new [PartnerRequestDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerRequestDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerRequestDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerRequestDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerRequestDto(
        taxCode: mapValueOfType<String>(json, r'taxCode')!,
        legalName: mapValueOfType<String>(json, r'legalName')!,
        brandName: mapValueOfType<String>(json, r'brandName')!,
        businessType: PartnerRequestDtoBusinessTypeEnum.fromJson(json[r'businessType'])!,
        provinceId: mapValueOfType<String>(json, r'provinceId')!,
        districtId: mapValueOfType<String>(json, r'districtId')!,
        wardId: mapValueOfType<String>(json, r'wardId')!,
        streetAddress: mapValueOfType<String>(json, r'streetAddress')!,
        phoneNumber: mapValueOfType<String>(json, r'phoneNumber'),
      );
    }
    return null;
  }

  static List<PartnerRequestDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerRequestDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerRequestDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerRequestDto> mapFromJson(dynamic json) {
    final map = <String, PartnerRequestDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerRequestDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerRequestDto-objects as value to a dart map
  static Map<String, List<PartnerRequestDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerRequestDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerRequestDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'taxCode',
    'legalName',
    'brandName',
    'businessType',
    'provinceId',
    'districtId',
    'wardId',
    'streetAddress',
  };
}

/// Type of business
class PartnerRequestDtoBusinessTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const PartnerRequestDtoBusinessTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MASSAGE_THERAPY = PartnerRequestDtoBusinessTypeEnum._(r'MASSAGE_THERAPY');
  static const MASSAGE_REHABILITATION = PartnerRequestDtoBusinessTypeEnum._(r'MASSAGE_REHABILITATION');
  static const SPA_BEAUTY = PartnerRequestDtoBusinessTypeEnum._(r'SPA_BEAUTY');
  static const FITNESS = PartnerRequestDtoBusinessTypeEnum._(r'FITNESS');
  static const PHARMACY = PartnerRequestDtoBusinessTypeEnum._(r'PHARMACY');
  static const DENTAL = PartnerRequestDtoBusinessTypeEnum._(r'DENTAL');
  static const TRADITIONAL_MEDICINE = PartnerRequestDtoBusinessTypeEnum._(r'TRADITIONAL_MEDICINE');
  static const PSYCHOLOGY = PartnerRequestDtoBusinessTypeEnum._(r'PSYCHOLOGY');
  static const DERMATOLOGY = PartnerRequestDtoBusinessTypeEnum._(r'DERMATOLOGY');
  static const NUTRITION = PartnerRequestDtoBusinessTypeEnum._(r'NUTRITION');
  static const PSYCHIATRY = PartnerRequestDtoBusinessTypeEnum._(r'PSYCHIATRY');

  /// List of all possible values in this [enum][PartnerRequestDtoBusinessTypeEnum].
  static const values = <PartnerRequestDtoBusinessTypeEnum>[
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

  static PartnerRequestDtoBusinessTypeEnum? fromJson(dynamic value) => PartnerRequestDtoBusinessTypeEnumTypeTransformer().decode(value);

  static List<PartnerRequestDtoBusinessTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerRequestDtoBusinessTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerRequestDtoBusinessTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PartnerRequestDtoBusinessTypeEnum] to String,
/// and [decode] dynamic data back to [PartnerRequestDtoBusinessTypeEnum].
class PartnerRequestDtoBusinessTypeEnumTypeTransformer {
  factory PartnerRequestDtoBusinessTypeEnumTypeTransformer() => _instance ??= const PartnerRequestDtoBusinessTypeEnumTypeTransformer._();

  const PartnerRequestDtoBusinessTypeEnumTypeTransformer._();

  String encode(PartnerRequestDtoBusinessTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a PartnerRequestDtoBusinessTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PartnerRequestDtoBusinessTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MASSAGE_THERAPY': return PartnerRequestDtoBusinessTypeEnum.MASSAGE_THERAPY;
        case r'MASSAGE_REHABILITATION': return PartnerRequestDtoBusinessTypeEnum.MASSAGE_REHABILITATION;
        case r'SPA_BEAUTY': return PartnerRequestDtoBusinessTypeEnum.SPA_BEAUTY;
        case r'FITNESS': return PartnerRequestDtoBusinessTypeEnum.FITNESS;
        case r'PHARMACY': return PartnerRequestDtoBusinessTypeEnum.PHARMACY;
        case r'DENTAL': return PartnerRequestDtoBusinessTypeEnum.DENTAL;
        case r'TRADITIONAL_MEDICINE': return PartnerRequestDtoBusinessTypeEnum.TRADITIONAL_MEDICINE;
        case r'PSYCHOLOGY': return PartnerRequestDtoBusinessTypeEnum.PSYCHOLOGY;
        case r'DERMATOLOGY': return PartnerRequestDtoBusinessTypeEnum.DERMATOLOGY;
        case r'NUTRITION': return PartnerRequestDtoBusinessTypeEnum.NUTRITION;
        case r'PSYCHIATRY': return PartnerRequestDtoBusinessTypeEnum.PSYCHIATRY;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PartnerRequestDtoBusinessTypeEnumTypeTransformer] instance.
  static PartnerRequestDtoBusinessTypeEnumTypeTransformer? _instance;
}


