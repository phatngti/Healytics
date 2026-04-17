//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LocationInfo {
  /// Returns a new [LocationInfo] instance.
  LocationInfo({
    required this.address,
    required this.district,
    required this.city,
  });


  String address;

  String district;

  String city;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LocationInfo &&
    other.address == address &&
    other.district == district &&
    other.city == city;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (address.hashCode) +
    (district.hashCode) +
    (city.hashCode);

  @override
  String toString() => 'LocationInfo[address=$address, district=$district, city=$city]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'address'] = this.address;
      json[r'district'] = this.district;
      json[r'city'] = this.city;
    return json;
  }

  /// Returns a new [LocationInfo] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LocationInfo? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "LocationInfo[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "LocationInfo[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LocationInfo(
        address: mapValueOfType<String>(json, r'address')!,
        district: mapValueOfType<String>(json, r'district')!,
        city: mapValueOfType<String>(json, r'city')!,
      );
    }
    return null;
  }

  static List<LocationInfo> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LocationInfo>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LocationInfo.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LocationInfo> mapFromJson(dynamic json) {
    final map = <String, LocationInfo>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LocationInfo.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LocationInfo-objects as value to a dart map
  static Map<String, List<LocationInfo>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LocationInfo>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LocationInfo.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'address',
    'district',
    'city',
  };
}

