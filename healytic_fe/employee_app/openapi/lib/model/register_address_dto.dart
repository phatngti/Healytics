//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RegisterAddressDto {
  /// Returns a new [RegisterAddressDto] instance.
  RegisterAddressDto({
    required this.streetAddress,
    required this.provinceId,
    required this.districtId,
    required this.wardId,
  });


  String streetAddress;

  /// Province/city Location UUID
  String provinceId;

  /// District Location UUID
  String districtId;

  /// Ward/commune Location UUID
  String wardId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RegisterAddressDto &&
    other.streetAddress == streetAddress &&
    other.provinceId == provinceId &&
    other.districtId == districtId &&
    other.wardId == wardId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (streetAddress.hashCode) +
    (provinceId.hashCode) +
    (districtId.hashCode) +
    (wardId.hashCode);

  @override
  String toString() => 'RegisterAddressDto[streetAddress=$streetAddress, provinceId=$provinceId, districtId=$districtId, wardId=$wardId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'streetAddress'] = this.streetAddress;
      json[r'provinceId'] = this.provinceId;
      json[r'districtId'] = this.districtId;
      json[r'wardId'] = this.wardId;
    return json;
  }

  /// Returns a new [RegisterAddressDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RegisterAddressDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RegisterAddressDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RegisterAddressDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RegisterAddressDto(
        streetAddress: mapValueOfType<String>(json, r'streetAddress')!,
        provinceId: mapValueOfType<String>(json, r'provinceId')!,
        districtId: mapValueOfType<String>(json, r'districtId')!,
        wardId: mapValueOfType<String>(json, r'wardId')!,
      );
    }
    return null;
  }

  static List<RegisterAddressDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RegisterAddressDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RegisterAddressDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RegisterAddressDto> mapFromJson(dynamic json) {
    final map = <String, RegisterAddressDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RegisterAddressDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RegisterAddressDto-objects as value to a dart map
  static Map<String, List<RegisterAddressDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RegisterAddressDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RegisterAddressDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'streetAddress',
    'provinceId',
    'districtId',
    'wardId',
  };
}

