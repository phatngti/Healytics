//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicProductEmployeeResponseDto {
  /// Returns a new [PublicProductEmployeeResponseDto] instance.
  PublicProductEmployeeResponseDto({
    required this.id,
    required this.name,
    required this.role,
    this.imageUrl,
    required this.isSelected,
    this.quote,
    this.degrees,
    this.languages,
    this.experience,
    this.specializations = const [],
    this.bio,
    this.daySchedules = const [],
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

  bool isSelected;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? quote;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? degrees;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? languages;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? experience;

  List<String> specializations;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? bio;

  List<PublicProductEmployeeDayScheduleDto> daySchedules;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicProductEmployeeResponseDto &&
    other.id == id &&
    other.name == name &&
    other.role == role &&
    other.imageUrl == imageUrl &&
    other.isSelected == isSelected &&
    other.quote == quote &&
    other.degrees == degrees &&
    other.languages == languages &&
    other.experience == experience &&
    _deepEquality.equals(other.specializations, specializations) &&
    other.bio == bio &&
    _deepEquality.equals(other.daySchedules, daySchedules);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (role.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (isSelected.hashCode) +
    (quote == null ? 0 : quote!.hashCode) +
    (degrees == null ? 0 : degrees!.hashCode) +
    (languages == null ? 0 : languages!.hashCode) +
    (experience == null ? 0 : experience!.hashCode) +
    (specializations.hashCode) +
    (bio == null ? 0 : bio!.hashCode) +
    (daySchedules.hashCode);

  @override
  String toString() => 'PublicProductEmployeeResponseDto[id=$id, name=$name, role=$role, imageUrl=$imageUrl, isSelected=$isSelected, quote=$quote, degrees=$degrees, languages=$languages, experience=$experience, specializations=$specializations, bio=$bio, daySchedules=$daySchedules]';

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
      json[r'isSelected'] = this.isSelected;
    if (this.quote != null) {
      json[r'quote'] = this.quote;
    } else {
      json[r'quote'] = null;
    }
    if (this.degrees != null) {
      json[r'degrees'] = this.degrees;
    } else {
      json[r'degrees'] = null;
    }
    if (this.languages != null) {
      json[r'languages'] = this.languages;
    } else {
      json[r'languages'] = null;
    }
    if (this.experience != null) {
      json[r'experience'] = this.experience;
    } else {
      json[r'experience'] = null;
    }
      json[r'specializations'] = this.specializations;
    if (this.bio != null) {
      json[r'bio'] = this.bio;
    } else {
      json[r'bio'] = null;
    }
      json[r'daySchedules'] = this.daySchedules;
    return json;
  }

  /// Returns a new [PublicProductEmployeeResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicProductEmployeeResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicProductEmployeeResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicProductEmployeeResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicProductEmployeeResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        role: mapValueOfType<String>(json, r'role')!,
        imageUrl: mapValueOfType<Object>(json, r'imageUrl'),
        isSelected: mapValueOfType<bool>(json, r'isSelected')!,
        quote: mapValueOfType<Object>(json, r'quote'),
        degrees: mapValueOfType<Object>(json, r'degrees'),
        languages: mapValueOfType<Object>(json, r'languages'),
        experience: mapValueOfType<Object>(json, r'experience'),
        specializations: json[r'specializations'] is Iterable
            ? (json[r'specializations'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        bio: mapValueOfType<Object>(json, r'bio'),
        daySchedules: PublicProductEmployeeDayScheduleDto.listFromJson(json[r'daySchedules']),
      );
    }
    return null;
  }

  static List<PublicProductEmployeeResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicProductEmployeeResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicProductEmployeeResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicProductEmployeeResponseDto> mapFromJson(dynamic json) {
    final map = <String, PublicProductEmployeeResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicProductEmployeeResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicProductEmployeeResponseDto-objects as value to a dart map
  static Map<String, List<PublicProductEmployeeResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicProductEmployeeResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicProductEmployeeResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'role',
    'isSelected',
    'daySchedules',
  };
}

