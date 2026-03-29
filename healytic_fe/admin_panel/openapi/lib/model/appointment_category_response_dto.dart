//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AppointmentCategoryResponseDto {
  /// Returns a new [AppointmentCategoryResponseDto] instance.
  AppointmentCategoryResponseDto({
    required this.id,
    required this.name,
    required this.iconSlug,
  });

  String id;

  String name;

  String iconSlug;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AppointmentCategoryResponseDto &&
    other.id == id &&
    other.name == name &&
    other.iconSlug == iconSlug;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (iconSlug.hashCode);

  @override
  String toString() => 'AppointmentCategoryResponseDto[id=$id, name=$name, iconSlug=$iconSlug]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'iconSlug'] = this.iconSlug;
    return json;
  }

  /// Returns a new [AppointmentCategoryResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AppointmentCategoryResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AppointmentCategoryResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AppointmentCategoryResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AppointmentCategoryResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        iconSlug: mapValueOfType<String>(json, r'iconSlug')!,
      );
    }
    return null;
  }

  static List<AppointmentCategoryResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AppointmentCategoryResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AppointmentCategoryResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AppointmentCategoryResponseDto> mapFromJson(dynamic json) {
    final map = <String, AppointmentCategoryResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AppointmentCategoryResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AppointmentCategoryResponseDto-objects as value to a dart map
  static Map<String, List<AppointmentCategoryResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AppointmentCategoryResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AppointmentCategoryResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'iconSlug',
  };
}

