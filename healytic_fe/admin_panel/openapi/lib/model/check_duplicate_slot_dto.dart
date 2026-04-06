//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CheckDuplicateSlotDto {
  /// Returns a new [CheckDuplicateSlotDto] instance.
  CheckDuplicateSlotDto({
    required this.startTime,
  });

  /// Desired slot start time (ISO 8601)
  String startTime;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CheckDuplicateSlotDto &&
    other.startTime == startTime;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (startTime.hashCode);

  @override
  String toString() => 'CheckDuplicateSlotDto[startTime=$startTime]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'startTime'] = this.startTime;
    return json;
  }

  /// Returns a new [CheckDuplicateSlotDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CheckDuplicateSlotDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CheckDuplicateSlotDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CheckDuplicateSlotDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CheckDuplicateSlotDto(
        startTime: mapValueOfType<String>(json, r'startTime')!,
      );
    }
    return null;
  }

  static List<CheckDuplicateSlotDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CheckDuplicateSlotDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CheckDuplicateSlotDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CheckDuplicateSlotDto> mapFromJson(dynamic json) {
    final map = <String, CheckDuplicateSlotDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CheckDuplicateSlotDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CheckDuplicateSlotDto-objects as value to a dart map
  static Map<String, List<CheckDuplicateSlotDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CheckDuplicateSlotDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CheckDuplicateSlotDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'startTime',
  };
}

