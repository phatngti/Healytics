//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdatePartnerDto {
  /// Returns a new [UpdatePartnerDto] instance.
  UpdatePartnerDto({
    this.taxCode,
    this.businessType,
    this.legalName,
    this.brandName,
    this.phoneNumber,
    this.provinceId,
    this.districtId,
    this.wardId,
    this.streetAddress,
    this.legalRepresentative,
    this.documents = const [],
  });

  /// Tax code (updatable if rejected)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? taxCode;

  /// Business Type
  UpdatePartnerDtoBusinessTypeEnum? businessType;

  /// Legal name of the business
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? legalName;

  /// Brand name of the business
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? brandName;

  /// Contact phone number
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? phoneNumber;

  /// Province ID (administrative division)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? provinceId;

  /// District ID (administrative division)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? districtId;

  /// Ward ID (administrative division)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? wardId;

  /// Street address
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? streetAddress;

  /// Legal representative information to update
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UpdateLegalRepresentativeDto? legalRepresentative;

  /// List of documents to update or upload
  List<DocumentUpdateDto> documents;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdatePartnerDto &&
    other.taxCode == taxCode &&
    other.businessType == businessType &&
    other.legalName == legalName &&
    other.brandName == brandName &&
    other.phoneNumber == phoneNumber &&
    other.provinceId == provinceId &&
    other.districtId == districtId &&
    other.wardId == wardId &&
    other.streetAddress == streetAddress &&
    other.legalRepresentative == legalRepresentative &&
    _deepEquality.equals(other.documents, documents);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (taxCode == null ? 0 : taxCode!.hashCode) +
    (businessType == null ? 0 : businessType!.hashCode) +
    (legalName == null ? 0 : legalName!.hashCode) +
    (brandName == null ? 0 : brandName!.hashCode) +
    (phoneNumber == null ? 0 : phoneNumber!.hashCode) +
    (provinceId == null ? 0 : provinceId!.hashCode) +
    (districtId == null ? 0 : districtId!.hashCode) +
    (wardId == null ? 0 : wardId!.hashCode) +
    (streetAddress == null ? 0 : streetAddress!.hashCode) +
    (legalRepresentative == null ? 0 : legalRepresentative!.hashCode) +
    (documents.hashCode);

  @override
  String toString() => 'UpdatePartnerDto[taxCode=$taxCode, businessType=$businessType, legalName=$legalName, brandName=$brandName, phoneNumber=$phoneNumber, provinceId=$provinceId, districtId=$districtId, wardId=$wardId, streetAddress=$streetAddress, legalRepresentative=$legalRepresentative, documents=$documents]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.taxCode != null) {
      json[r'taxCode'] = this.taxCode;
    } else {
      json[r'taxCode'] = null;
    }
    if (this.businessType != null) {
      json[r'businessType'] = this.businessType;
    } else {
      json[r'businessType'] = null;
    }
    if (this.legalName != null) {
      json[r'legalName'] = this.legalName;
    } else {
      json[r'legalName'] = null;
    }
    if (this.brandName != null) {
      json[r'brandName'] = this.brandName;
    } else {
      json[r'brandName'] = null;
    }
    if (this.phoneNumber != null) {
      json[r'phoneNumber'] = this.phoneNumber;
    } else {
      json[r'phoneNumber'] = null;
    }
    if (this.provinceId != null) {
      json[r'provinceId'] = this.provinceId;
    } else {
      json[r'provinceId'] = null;
    }
    if (this.districtId != null) {
      json[r'districtId'] = this.districtId;
    } else {
      json[r'districtId'] = null;
    }
    if (this.wardId != null) {
      json[r'wardId'] = this.wardId;
    } else {
      json[r'wardId'] = null;
    }
    if (this.streetAddress != null) {
      json[r'streetAddress'] = this.streetAddress;
    } else {
      json[r'streetAddress'] = null;
    }
    if (this.legalRepresentative != null) {
      json[r'legalRepresentative'] = this.legalRepresentative;
    } else {
      json[r'legalRepresentative'] = null;
    }
      json[r'documents'] = this.documents;
    return json;
  }

  /// Returns a new [UpdatePartnerDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdatePartnerDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdatePartnerDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdatePartnerDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdatePartnerDto(
        taxCode: mapValueOfType<String>(json, r'taxCode'),
        businessType: UpdatePartnerDtoBusinessTypeEnum.fromJson(json[r'businessType']),
        legalName: mapValueOfType<String>(json, r'legalName'),
        brandName: mapValueOfType<String>(json, r'brandName'),
        phoneNumber: mapValueOfType<String>(json, r'phoneNumber'),
        provinceId: mapValueOfType<String>(json, r'provinceId'),
        districtId: mapValueOfType<String>(json, r'districtId'),
        wardId: mapValueOfType<String>(json, r'wardId'),
        streetAddress: mapValueOfType<String>(json, r'streetAddress'),
        legalRepresentative: UpdateLegalRepresentativeDto.fromJson(json[r'legalRepresentative']),
        documents: DocumentUpdateDto.listFromJson(json[r'documents']),
      );
    }
    return null;
  }

  static List<UpdatePartnerDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdatePartnerDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdatePartnerDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdatePartnerDto> mapFromJson(dynamic json) {
    final map = <String, UpdatePartnerDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdatePartnerDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdatePartnerDto-objects as value to a dart map
  static Map<String, List<UpdatePartnerDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdatePartnerDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdatePartnerDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

/// Business Type
class UpdatePartnerDtoBusinessTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const UpdatePartnerDtoBusinessTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MASSAGE_THERAPY = UpdatePartnerDtoBusinessTypeEnum._(r'MASSAGE_THERAPY');
  static const MASSAGE_REHABILITATION = UpdatePartnerDtoBusinessTypeEnum._(r'MASSAGE_REHABILITATION');
  static const SPA_BEAUTY = UpdatePartnerDtoBusinessTypeEnum._(r'SPA_BEAUTY');
  static const FITNESS = UpdatePartnerDtoBusinessTypeEnum._(r'FITNESS');
  static const PHARMACY = UpdatePartnerDtoBusinessTypeEnum._(r'PHARMACY');
  static const DENTAL = UpdatePartnerDtoBusinessTypeEnum._(r'DENTAL');
  static const TRADITIONAL_MEDICINE = UpdatePartnerDtoBusinessTypeEnum._(r'TRADITIONAL_MEDICINE');
  static const PSYCHOLOGY = UpdatePartnerDtoBusinessTypeEnum._(r'PSYCHOLOGY');
  static const DERMATOLOGY = UpdatePartnerDtoBusinessTypeEnum._(r'DERMATOLOGY');
  static const NUTRITION = UpdatePartnerDtoBusinessTypeEnum._(r'NUTRITION');
  static const PSYCHIATRY = UpdatePartnerDtoBusinessTypeEnum._(r'PSYCHIATRY');

  /// List of all possible values in this [enum][UpdatePartnerDtoBusinessTypeEnum].
  static const values = <UpdatePartnerDtoBusinessTypeEnum>[
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

  static UpdatePartnerDtoBusinessTypeEnum? fromJson(dynamic value) => UpdatePartnerDtoBusinessTypeEnumTypeTransformer().decode(value);

  static List<UpdatePartnerDtoBusinessTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdatePartnerDtoBusinessTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdatePartnerDtoBusinessTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UpdatePartnerDtoBusinessTypeEnum] to String,
/// and [decode] dynamic data back to [UpdatePartnerDtoBusinessTypeEnum].
class UpdatePartnerDtoBusinessTypeEnumTypeTransformer {
  factory UpdatePartnerDtoBusinessTypeEnumTypeTransformer() => _instance ??= const UpdatePartnerDtoBusinessTypeEnumTypeTransformer._();

  const UpdatePartnerDtoBusinessTypeEnumTypeTransformer._();

  String encode(UpdatePartnerDtoBusinessTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UpdatePartnerDtoBusinessTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UpdatePartnerDtoBusinessTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MASSAGE_THERAPY': return UpdatePartnerDtoBusinessTypeEnum.MASSAGE_THERAPY;
        case r'MASSAGE_REHABILITATION': return UpdatePartnerDtoBusinessTypeEnum.MASSAGE_REHABILITATION;
        case r'SPA_BEAUTY': return UpdatePartnerDtoBusinessTypeEnum.SPA_BEAUTY;
        case r'FITNESS': return UpdatePartnerDtoBusinessTypeEnum.FITNESS;
        case r'PHARMACY': return UpdatePartnerDtoBusinessTypeEnum.PHARMACY;
        case r'DENTAL': return UpdatePartnerDtoBusinessTypeEnum.DENTAL;
        case r'TRADITIONAL_MEDICINE': return UpdatePartnerDtoBusinessTypeEnum.TRADITIONAL_MEDICINE;
        case r'PSYCHOLOGY': return UpdatePartnerDtoBusinessTypeEnum.PSYCHOLOGY;
        case r'DERMATOLOGY': return UpdatePartnerDtoBusinessTypeEnum.DERMATOLOGY;
        case r'NUTRITION': return UpdatePartnerDtoBusinessTypeEnum.NUTRITION;
        case r'PSYCHIATRY': return UpdatePartnerDtoBusinessTypeEnum.PSYCHIATRY;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UpdatePartnerDtoBusinessTypeEnumTypeTransformer] instance.
  static UpdatePartnerDtoBusinessTypeEnumTypeTransformer? _instance;
}


