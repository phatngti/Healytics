//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LocationInfoDto {
  /// Returns a new [LocationInfoDto] instance.
  LocationInfoDto({
    required this.name,
    required this.address,
    this.mapUrl,
  });

  String name;

  String address;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? mapUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LocationInfoDto &&
    other.name == name &&
    other.address == address &&
    other.mapUrl == mapUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (address.hashCode) +
    (mapUrl == null ? 0 : mapUrl!.hashCode);

  @override
  String toString() => 'LocationInfoDto[name=$name, address=$address, mapUrl=$mapUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'address'] = this.address;
    if (this.mapUrl != null) {
      json[r'mapUrl'] = this.mapUrl;
    } else {
      json[r'mapUrl'] = null;
    }
    return json;
  }

  /// Returns a new [LocationInfoDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LocationInfoDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "LocationInfoDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "LocationInfoDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LocationInfoDto(
        name: mapValueOfType<String>(json, r'name')!,
        address: mapValueOfType<String>(json, r'address')!,
        mapUrl: mapValueOfType<Object>(json, r'mapUrl'),
      );
    }
    return null;
  }

  static List<LocationInfoDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LocationInfoDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LocationInfoDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LocationInfoDto> mapFromJson(dynamic json) {
    final map = <String, LocationInfoDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LocationInfoDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LocationInfoDto-objects as value to a dart map
  static Map<String, List<LocationInfoDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LocationInfoDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LocationInfoDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'address',
  };
}

