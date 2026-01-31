//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerInfoDto {
  /// Returns a new [PartnerInfoDto] instance.
  PartnerInfoDto({
    required this.taxCode,
    required this.legalName,
    required this.brandName,
    required this.businessType,
    required this.phoneNumber,
  });

  VerificationStringFieldDto taxCode;

  VerificationStringFieldDto legalName;

  VerificationStringFieldDto brandName;

  VerificationStringFieldDto businessType;

  VerificationOptionalStringFieldDto phoneNumber;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerInfoDto &&
    other.taxCode == taxCode &&
    other.legalName == legalName &&
    other.brandName == brandName &&
    other.businessType == businessType &&
    other.phoneNumber == phoneNumber;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (taxCode.hashCode) +
    (legalName.hashCode) +
    (brandName.hashCode) +
    (businessType.hashCode) +
    (phoneNumber.hashCode);

  @override
  String toString() => 'PartnerInfoDto[taxCode=$taxCode, legalName=$legalName, brandName=$brandName, businessType=$businessType, phoneNumber=$phoneNumber]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'taxCode'] = this.taxCode;
      json[r'legalName'] = this.legalName;
      json[r'brandName'] = this.brandName;
      json[r'businessType'] = this.businessType;
      json[r'phoneNumber'] = this.phoneNumber;
    return json;
  }

  /// Returns a new [PartnerInfoDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerInfoDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerInfoDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerInfoDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerInfoDto(
        taxCode: VerificationStringFieldDto.fromJson(json[r'taxCode'])!,
        legalName: VerificationStringFieldDto.fromJson(json[r'legalName'])!,
        brandName: VerificationStringFieldDto.fromJson(json[r'brandName'])!,
        businessType: VerificationStringFieldDto.fromJson(json[r'businessType'])!,
        phoneNumber: VerificationOptionalStringFieldDto.fromJson(json[r'phoneNumber'])!,
      );
    }
    return null;
  }

  static List<PartnerInfoDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerInfoDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerInfoDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerInfoDto> mapFromJson(dynamic json) {
    final map = <String, PartnerInfoDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerInfoDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerInfoDto-objects as value to a dart map
  static Map<String, List<PartnerInfoDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerInfoDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerInfoDto.listFromJson(entry.value, growable: growable,);
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
    'phoneNumber',
  };
}

