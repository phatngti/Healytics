//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AddressDto {
  /// Returns a new [AddressDto] instance.
  AddressDto({
    required this.provinceId,
    required this.province,
    required this.districtId,
    required this.district,
    required this.wardId,
    required this.ward,
    required this.streetAddress,
  });

  Object? provinceId;

  String province;

  Object? districtId;

  String district;

  Object? wardId;

  String ward;

  String streetAddress;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AddressDto &&
    other.provinceId == provinceId &&
    other.province == province &&
    other.districtId == districtId &&
    other.district == district &&
    other.wardId == wardId &&
    other.ward == ward &&
    other.streetAddress == streetAddress;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (provinceId == null ? 0 : provinceId!.hashCode) +
    (province.hashCode) +
    (districtId == null ? 0 : districtId!.hashCode) +
    (district.hashCode) +
    (wardId == null ? 0 : wardId!.hashCode) +
    (ward.hashCode) +
    (streetAddress.hashCode);

  @override
  String toString() => 'AddressDto[provinceId=$provinceId, province=$province, districtId=$districtId, district=$district, wardId=$wardId, ward=$ward, streetAddress=$streetAddress]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.provinceId != null) {
      json[r'provinceId'] = this.provinceId;
    } else {
      json[r'provinceId'] = null;
    }
      json[r'province'] = this.province;
    if (this.districtId != null) {
      json[r'districtId'] = this.districtId;
    } else {
      json[r'districtId'] = null;
    }
      json[r'district'] = this.district;
    if (this.wardId != null) {
      json[r'wardId'] = this.wardId;
    } else {
      json[r'wardId'] = null;
    }
      json[r'ward'] = this.ward;
      json[r'streetAddress'] = this.streetAddress;
    return json;
  }

  /// Returns a new [AddressDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AddressDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AddressDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AddressDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AddressDto(
        provinceId: mapValueOfType<Object>(json, r'provinceId'),
        province: mapValueOfType<String>(json, r'province')!,
        districtId: mapValueOfType<Object>(json, r'districtId'),
        district: mapValueOfType<String>(json, r'district')!,
        wardId: mapValueOfType<Object>(json, r'wardId'),
        ward: mapValueOfType<String>(json, r'ward')!,
        streetAddress: mapValueOfType<String>(json, r'streetAddress')!,
      );
    }
    return null;
  }

  static List<AddressDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AddressDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AddressDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AddressDto> mapFromJson(dynamic json) {
    final map = <String, AddressDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AddressDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AddressDto-objects as value to a dart map
  static Map<String, List<AddressDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AddressDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AddressDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'provinceId',
    'province',
    'districtId',
    'district',
    'wardId',
    'ward',
    'streetAddress',
  };
}

