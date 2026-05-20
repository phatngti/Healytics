//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdateAvatarDto {
  /// Returns a new [UpdateAvatarDto] instance.
  UpdateAvatarDto({
    required this.avatarUrl,
  });


  /// S3 storage key of the uploaded avatar
  String avatarUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateAvatarDto &&
    other.avatarUrl == avatarUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (avatarUrl.hashCode);

  @override
  String toString() => 'UpdateAvatarDto[avatarUrl=$avatarUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'avatarUrl'] = this.avatarUrl;
    return json;
  }

  /// Returns a new [UpdateAvatarDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdateAvatarDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdateAvatarDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdateAvatarDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdateAvatarDto(
        avatarUrl: mapValueOfType<String>(json, r'avatarUrl')!,
      );
    }
    return null;
  }

  static List<UpdateAvatarDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateAvatarDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateAvatarDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateAvatarDto> mapFromJson(dynamic json) {
    final map = <String, UpdateAvatarDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateAvatarDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateAvatarDto-objects as value to a dart map
  static Map<String, List<UpdateAvatarDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateAvatarDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateAvatarDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'avatarUrl',
  };
}

