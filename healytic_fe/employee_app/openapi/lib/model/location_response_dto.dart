//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LocationResponseDto {
  /// Returns a new [LocationResponseDto] instance.
  LocationResponseDto({
    required this.id,
    required this.code,
    required this.name,
    this.nameEn,
    required this.fullName,
    this.fullNameEn,
    required this.level,
  });


  /// Location UUID
  String id;

  /// Official administrative code
  String code;

  /// Location name
  String name;

  /// English name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? nameEn;

  /// Full name with prefix
  String fullName;

  /// Full English name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? fullNameEn;

  /// Administrative level
  String level;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LocationResponseDto &&
    other.id == id &&
    other.code == code &&
    other.name == name &&
    other.nameEn == nameEn &&
    other.fullName == fullName &&
    other.fullNameEn == fullNameEn &&
    other.level == level;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (code.hashCode) +
    (name.hashCode) +
    (nameEn == null ? 0 : nameEn!.hashCode) +
    (fullName.hashCode) +
    (fullNameEn == null ? 0 : fullNameEn!.hashCode) +
    (level.hashCode);

  @override
  String toString() => 'LocationResponseDto[id=$id, code=$code, name=$name, nameEn=$nameEn, fullName=$fullName, fullNameEn=$fullNameEn, level=$level]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'code'] = this.code;
      json[r'name'] = this.name;
    if (this.nameEn != null) {
      json[r'nameEn'] = this.nameEn;
    } else {
      json[r'nameEn'] = null;
    }
      json[r'fullName'] = this.fullName;
    if (this.fullNameEn != null) {
      json[r'fullNameEn'] = this.fullNameEn;
    } else {
      json[r'fullNameEn'] = null;
    }
      json[r'level'] = this.level;
    return json;
  }

  /// Returns a new [LocationResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LocationResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "LocationResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "LocationResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LocationResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        code: mapValueOfType<String>(json, r'code')!,
        name: mapValueOfType<String>(json, r'name')!,
        nameEn: mapValueOfType<String>(json, r'nameEn'),
        fullName: mapValueOfType<String>(json, r'fullName')!,
        fullNameEn: mapValueOfType<String>(json, r'fullNameEn'),
        level: mapValueOfType<String>(json, r'level')!,
      );
    }
    return null;
  }

  static List<LocationResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LocationResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LocationResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LocationResponseDto> mapFromJson(dynamic json) {
    final map = <String, LocationResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LocationResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LocationResponseDto-objects as value to a dart map
  static Map<String, List<LocationResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LocationResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LocationResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'code',
    'name',
    'fullName',
    'level',
  };
}

