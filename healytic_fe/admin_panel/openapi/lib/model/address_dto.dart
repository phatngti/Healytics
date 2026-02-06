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
    this.streetAddress,
    this.ward,
    this.district,
    this.city,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? streetAddress;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? ward;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? district;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? city;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AddressDto &&
    other.streetAddress == streetAddress &&
    other.ward == ward &&
    other.district == district &&
    other.city == city;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (streetAddress == null ? 0 : streetAddress!.hashCode) +
    (ward == null ? 0 : ward!.hashCode) +
    (district == null ? 0 : district!.hashCode) +
    (city == null ? 0 : city!.hashCode);

  @override
  String toString() => 'AddressDto[streetAddress=$streetAddress, ward=$ward, district=$district, city=$city]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.streetAddress != null) {
      json[r'streetAddress'] = this.streetAddress;
    } else {
      json[r'streetAddress'] = null;
    }
    if (this.ward != null) {
      json[r'ward'] = this.ward;
    } else {
      json[r'ward'] = null;
    }
    if (this.district != null) {
      json[r'district'] = this.district;
    } else {
      json[r'district'] = null;
    }
    if (this.city != null) {
      json[r'city'] = this.city;
    } else {
      json[r'city'] = null;
    }
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
        streetAddress: mapValueOfType<Object>(json, r'streetAddress'),
        ward: mapValueOfType<Object>(json, r'ward'),
        district: mapValueOfType<Object>(json, r'district'),
        city: mapValueOfType<Object>(json, r'city'),
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
  };
}

