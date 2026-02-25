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

  List<BusinessType> businessType;

  PartnerVerificationStatus verificationStatus;

  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerItemDto &&
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
  String toString() => 'PartnerItemDto[id=$id, taxCode=$taxCode, brandName=$brandName, legalName=$legalName, email=$email, businessType=$businessType, verificationStatus=$verificationStatus, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'taxCode'] = this.taxCode;
      json[r'brandName'] = this.brandName;
      json[r'legalName'] = this.legalName;
      json[r'email'] = this.email;
      json[r'businessType'] = this.businessType;
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
          assert(json.containsKey(key), 'Required key "PartnerItemDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerItemDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerItemDto(
        id: mapValueOfType<String>(json, r'id')!,
        taxCode: mapValueOfType<String>(json, r'taxCode')!,
        brandName: mapValueOfType<String>(json, r'brandName')!,
        legalName: mapValueOfType<String>(json, r'legalName')!,
        email: mapValueOfType<String>(json, r'email')!,
        businessType: BusinessType.listFromJson(json[r'businessType']),
        verificationStatus: PartnerVerificationStatus.fromJson(json[r'verificationStatus'])!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
      );
    }
    return null;
  }

  static List<PartnerItemDto> listFromJson(dynamic json, {bool growable = false,}) {
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
  static Map<String, List<PartnerItemDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerItemDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerItemDto.listFromJson(entry.value, growable: growable,);
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

