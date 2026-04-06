//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicClinicSpecialistPreviewDto {
  /// Returns a new [PublicClinicSpecialistPreviewDto] instance.
  PublicClinicSpecialistPreviewDto({
    required this.id,
    required this.name,
    required this.role,
    this.imageUrl,
    this.experienceLabel,
  });

  String id;

  String name;

  String role;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? imageUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? experienceLabel;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicClinicSpecialistPreviewDto &&
    other.id == id &&
    other.name == name &&
    other.role == role &&
    other.imageUrl == imageUrl &&
    other.experienceLabel == experienceLabel;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (role.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (experienceLabel == null ? 0 : experienceLabel!.hashCode);

  @override
  String toString() => 'PublicClinicSpecialistPreviewDto[id=$id, name=$name, role=$role, imageUrl=$imageUrl, experienceLabel=$experienceLabel]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'role'] = this.role;
    if (this.imageUrl != null) {
      json[r'imageUrl'] = this.imageUrl;
    } else {
      json[r'imageUrl'] = null;
    }
    if (this.experienceLabel != null) {
      json[r'experienceLabel'] = this.experienceLabel;
    } else {
      json[r'experienceLabel'] = null;
    }
    return json;
  }

  /// Returns a new [PublicClinicSpecialistPreviewDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicClinicSpecialistPreviewDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicClinicSpecialistPreviewDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicClinicSpecialistPreviewDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicClinicSpecialistPreviewDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        role: mapValueOfType<String>(json, r'role')!,
        imageUrl: mapValueOfType<Object>(json, r'imageUrl'),
        experienceLabel: mapValueOfType<Object>(json, r'experienceLabel'),
      );
    }
    return null;
  }

  static List<PublicClinicSpecialistPreviewDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicClinicSpecialistPreviewDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicClinicSpecialistPreviewDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicClinicSpecialistPreviewDto> mapFromJson(dynamic json) {
    final map = <String, PublicClinicSpecialistPreviewDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicClinicSpecialistPreviewDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicClinicSpecialistPreviewDto-objects as value to a dart map
  static Map<String, List<PublicClinicSpecialistPreviewDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicClinicSpecialistPreviewDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicClinicSpecialistPreviewDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'role',
  };
}

