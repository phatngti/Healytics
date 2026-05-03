//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicProfileChecklistItemDto {
  /// Returns a new [PublicProfileChecklistItemDto] instance.
  PublicProfileChecklistItemDto({
    required this.key,
    required this.label,
    required this.required_,
    required this.completed,
  });


  String key;

  String label;

  bool required_;

  bool completed;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicProfileChecklistItemDto &&
    other.key == key &&
    other.label == label &&
    other.required_ == required_ &&
    other.completed == completed;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (key.hashCode) +
    (label.hashCode) +
    (required_.hashCode) +
    (completed.hashCode);

  @override
  String toString() => 'PublicProfileChecklistItemDto[key=$key, label=$label, required_=$required_, completed=$completed]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'key'] = this.key;
      json[r'label'] = this.label;
      json[r'required'] = this.required_;
      json[r'completed'] = this.completed;
    return json;
  }

  /// Returns a new [PublicProfileChecklistItemDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicProfileChecklistItemDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicProfileChecklistItemDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicProfileChecklistItemDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicProfileChecklistItemDto(
        key: mapValueOfType<String>(json, r'key')!,
        label: mapValueOfType<String>(json, r'label')!,
        required_: mapValueOfType<bool>(json, r'required')!,
        completed: mapValueOfType<bool>(json, r'completed')!,
      );
    }
    return null;
  }

  static List<PublicProfileChecklistItemDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicProfileChecklistItemDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicProfileChecklistItemDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicProfileChecklistItemDto> mapFromJson(dynamic json) {
    final map = <String, PublicProfileChecklistItemDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicProfileChecklistItemDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicProfileChecklistItemDto-objects as value to a dart map
  static Map<String, List<PublicProfileChecklistItemDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicProfileChecklistItemDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicProfileChecklistItemDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'key',
    'label',
    'required',
    'completed',
  };
}

