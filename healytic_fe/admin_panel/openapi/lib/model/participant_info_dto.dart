//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ParticipantInfoDto {
  /// Returns a new [ParticipantInfoDto] instance.
  ParticipantInfoDto({
    required this.id,
    required this.name,
    this.avatar,
    required this.role,
  });

  String id;

  String name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? avatar;

  String role;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ParticipantInfoDto &&
    other.id == id &&
    other.name == name &&
    other.avatar == avatar &&
    other.role == role;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (avatar == null ? 0 : avatar!.hashCode) +
    (role.hashCode);

  @override
  String toString() => 'ParticipantInfoDto[id=$id, name=$name, avatar=$avatar, role=$role]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
    if (this.avatar != null) {
      json[r'avatar'] = this.avatar;
    } else {
      json[r'avatar'] = null;
    }
      json[r'role'] = this.role;
    return json;
  }

  /// Returns a new [ParticipantInfoDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ParticipantInfoDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ParticipantInfoDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ParticipantInfoDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ParticipantInfoDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        avatar: mapValueOfType<String>(json, r'avatar'),
        role: mapValueOfType<String>(json, r'role')!,
      );
    }
    return null;
  }

  static List<ParticipantInfoDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ParticipantInfoDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ParticipantInfoDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ParticipantInfoDto> mapFromJson(dynamic json) {
    final map = <String, ParticipantInfoDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ParticipantInfoDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ParticipantInfoDto-objects as value to a dart map
  static Map<String, List<ParticipantInfoDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ParticipantInfoDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ParticipantInfoDto.listFromJson(entry.value, growable: growable,);
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

