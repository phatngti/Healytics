//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicEmployeeTimeSlotDto {
  /// Returns a new [PublicEmployeeTimeSlotDto] instance.
  PublicEmployeeTimeSlotDto({
    required this.label,
    required this.isAvailable,
  });


  String label;

  bool isAvailable;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicEmployeeTimeSlotDto &&
    other.label == label &&
    other.isAvailable == isAvailable;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (label.hashCode) +
    (isAvailable.hashCode);

  @override
  String toString() => 'PublicEmployeeTimeSlotDto[label=$label, isAvailable=$isAvailable]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'label'] = this.label;
      json[r'isAvailable'] = this.isAvailable;
    return json;
  }

  /// Returns a new [PublicEmployeeTimeSlotDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicEmployeeTimeSlotDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicEmployeeTimeSlotDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicEmployeeTimeSlotDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicEmployeeTimeSlotDto(
        label: mapValueOfType<String>(json, r'label')!,
        isAvailable: mapValueOfType<bool>(json, r'isAvailable')!,
      );
    }
    return null;
  }

  static List<PublicEmployeeTimeSlotDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicEmployeeTimeSlotDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicEmployeeTimeSlotDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicEmployeeTimeSlotDto> mapFromJson(dynamic json) {
    final map = <String, PublicEmployeeTimeSlotDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicEmployeeTimeSlotDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicEmployeeTimeSlotDto-objects as value to a dart map
  static Map<String, List<PublicEmployeeTimeSlotDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicEmployeeTimeSlotDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicEmployeeTimeSlotDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'label',
    'isAvailable',
  };
}

