//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicClinicCertificationDto {
  /// Returns a new [PublicClinicCertificationDto] instance.
  PublicClinicCertificationDto({
    required this.title,
    required this.subtitle,
    required this.iconName,
  });


  String title;

  String subtitle;

  String iconName;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicClinicCertificationDto &&
    other.title == title &&
    other.subtitle == subtitle &&
    other.iconName == iconName;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (title.hashCode) +
    (subtitle.hashCode) +
    (iconName.hashCode);

  @override
  String toString() => 'PublicClinicCertificationDto[title=$title, subtitle=$subtitle, iconName=$iconName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'title'] = this.title;
      json[r'subtitle'] = this.subtitle;
      json[r'iconName'] = this.iconName;
    return json;
  }

  /// Returns a new [PublicClinicCertificationDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicClinicCertificationDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicClinicCertificationDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicClinicCertificationDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicClinicCertificationDto(
        title: mapValueOfType<String>(json, r'title')!,
        subtitle: mapValueOfType<String>(json, r'subtitle')!,
        iconName: mapValueOfType<String>(json, r'iconName')!,
      );
    }
    return null;
  }

  static List<PublicClinicCertificationDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicClinicCertificationDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicClinicCertificationDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicClinicCertificationDto> mapFromJson(dynamic json) {
    final map = <String, PublicClinicCertificationDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicClinicCertificationDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicClinicCertificationDto-objects as value to a dart map
  static Map<String, List<PublicClinicCertificationDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicClinicCertificationDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicClinicCertificationDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'title',
    'subtitle',
    'iconName',
  };
}

