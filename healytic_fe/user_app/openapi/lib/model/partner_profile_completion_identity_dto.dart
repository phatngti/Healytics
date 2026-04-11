//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerProfileCompletionIdentityDto {
  /// Returns a new [PartnerProfileCompletionIdentityDto] instance.
  PartnerProfileCompletionIdentityDto({
    required this.brandName,
    required this.legalName,
    this.businessType = const [],
    this.phoneNumber,
    this.address,
  });

  String brandName;

  String legalName;

  List<String> businessType;

  Object? phoneNumber;

  Object? address;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerProfileCompletionIdentityDto &&
    other.brandName == brandName &&
    other.legalName == legalName &&
    _deepEquality.equals(other.businessType, businessType) &&
    other.phoneNumber == phoneNumber &&
    other.address == address;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (brandName.hashCode) +
    (legalName.hashCode) +
    (businessType.hashCode) +
    (phoneNumber == null ? 0 : phoneNumber!.hashCode) +
    (address == null ? 0 : address!.hashCode);

  @override
  String toString() => 'PartnerProfileCompletionIdentityDto[brandName=$brandName, legalName=$legalName, businessType=$businessType, phoneNumber=$phoneNumber, address=$address]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'brandName'] = this.brandName;
      json[r'legalName'] = this.legalName;
      json[r'businessType'] = this.businessType;
    if (this.phoneNumber != null) {
      json[r'phoneNumber'] = this.phoneNumber;
    } else {
      json[r'phoneNumber'] = null;
    }
    if (this.address != null) {
      json[r'address'] = this.address;
    } else {
      json[r'address'] = null;
    }
    return json;
  }

  /// Returns a new [PartnerProfileCompletionIdentityDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerProfileCompletionIdentityDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerProfileCompletionIdentityDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerProfileCompletionIdentityDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerProfileCompletionIdentityDto(
        brandName: mapValueOfType<String>(json, r'brandName')!,
        legalName: mapValueOfType<String>(json, r'legalName')!,
        businessType: json[r'businessType'] is Iterable
            ? (json[r'businessType'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        phoneNumber: mapValueOfType<Object>(json, r'phoneNumber'),
        address: mapValueOfType<Object>(json, r'address'),
      );
    }
    return null;
  }

  static List<PartnerProfileCompletionIdentityDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerProfileCompletionIdentityDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerProfileCompletionIdentityDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerProfileCompletionIdentityDto> mapFromJson(dynamic json) {
    final map = <String, PartnerProfileCompletionIdentityDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerProfileCompletionIdentityDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerProfileCompletionIdentityDto-objects as value to a dart map
  static Map<String, List<PartnerProfileCompletionIdentityDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerProfileCompletionIdentityDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerProfileCompletionIdentityDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'brandName',
    'legalName',
    'businessType',
  };
}

