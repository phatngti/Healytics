//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeScheduleLoadDto {
  /// Returns a new [EmployeeScheduleLoadDto] instance.
  EmployeeScheduleLoadDto({
    required this.label,
    required this.availableHours,
    required this.bookedHours,
  });


  /// Weekday abbreviation
  String label;

  /// Total available hours from schedule for this weekday
  num availableHours;

  /// Total booked hours for this weekday
  num bookedHours;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeScheduleLoadDto &&
    other.label == label &&
    other.availableHours == availableHours &&
    other.bookedHours == bookedHours;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (label.hashCode) +
    (availableHours.hashCode) +
    (bookedHours.hashCode);

  @override
  String toString() => 'EmployeeScheduleLoadDto[label=$label, availableHours=$availableHours, bookedHours=$bookedHours]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'label'] = this.label;
      json[r'availableHours'] = this.availableHours;
      json[r'bookedHours'] = this.bookedHours;
    return json;
  }

  /// Returns a new [EmployeeScheduleLoadDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeScheduleLoadDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeScheduleLoadDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeScheduleLoadDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeScheduleLoadDto(
        label: mapValueOfType<String>(json, r'label')!,
        availableHours: num.parse('${json[r'availableHours']}'),
        bookedHours: num.parse('${json[r'bookedHours']}'),
      );
    }
    return null;
  }

  static List<EmployeeScheduleLoadDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeScheduleLoadDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeScheduleLoadDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeScheduleLoadDto> mapFromJson(dynamic json) {
    final map = <String, EmployeeScheduleLoadDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeScheduleLoadDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeScheduleLoadDto-objects as value to a dart map
  static Map<String, List<EmployeeScheduleLoadDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeScheduleLoadDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeScheduleLoadDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'label',
    'availableHours',
    'bookedHours',
  };
}

