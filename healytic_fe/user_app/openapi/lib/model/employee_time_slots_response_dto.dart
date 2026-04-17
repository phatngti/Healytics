//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeTimeSlotsResponseDto {
  /// Returns a new [EmployeeTimeSlotsResponseDto] instance.
  EmployeeTimeSlotsResponseDto({
    required this.employeeId,
    required this.employeeName,
    required this.slotDurationMinutes,
    this.schedule = const [],
    required this.rangeStart,
    required this.rangeEnd,
  });


  /// Employee ID
  String employeeId;

  /// Employee full name
  String employeeName;

  /// Slot duration in minutes
  num slotDurationMinutes;

  /// Day-by-day schedule with time slots
  List<DayScheduleDto> schedule;

  /// Start of the schedule range
  String rangeStart;

  /// End of the schedule range
  String rangeEnd;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeTimeSlotsResponseDto &&
    other.employeeId == employeeId &&
    other.employeeName == employeeName &&
    other.slotDurationMinutes == slotDurationMinutes &&
    _deepEquality.equals(other.schedule, schedule) &&
    other.rangeStart == rangeStart &&
    other.rangeEnd == rangeEnd;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (employeeId.hashCode) +
    (employeeName.hashCode) +
    (slotDurationMinutes.hashCode) +
    (schedule.hashCode) +
    (rangeStart.hashCode) +
    (rangeEnd.hashCode);

  @override
  String toString() => 'EmployeeTimeSlotsResponseDto[employeeId=$employeeId, employeeName=$employeeName, slotDurationMinutes=$slotDurationMinutes, schedule=$schedule, rangeStart=$rangeStart, rangeEnd=$rangeEnd]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'employeeId'] = this.employeeId;
      json[r'employeeName'] = this.employeeName;
      json[r'slotDurationMinutes'] = this.slotDurationMinutes;
      json[r'schedule'] = this.schedule;
      json[r'rangeStart'] = this.rangeStart;
      json[r'rangeEnd'] = this.rangeEnd;
    return json;
  }

  /// Returns a new [EmployeeTimeSlotsResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeTimeSlotsResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeTimeSlotsResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeTimeSlotsResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeTimeSlotsResponseDto(
        employeeId: mapValueOfType<String>(json, r'employeeId')!,
        employeeName: mapValueOfType<String>(json, r'employeeName')!,
        slotDurationMinutes: num.parse('${json[r'slotDurationMinutes']}'),
        schedule: DayScheduleDto.listFromJson(json[r'schedule']),
        rangeStart: mapValueOfType<String>(json, r'rangeStart')!,
        rangeEnd: mapValueOfType<String>(json, r'rangeEnd')!,
      );
    }
    return null;
  }

  static List<EmployeeTimeSlotsResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeTimeSlotsResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeTimeSlotsResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeTimeSlotsResponseDto> mapFromJson(dynamic json) {
    final map = <String, EmployeeTimeSlotsResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeTimeSlotsResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeTimeSlotsResponseDto-objects as value to a dart map
  static Map<String, List<EmployeeTimeSlotsResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeTimeSlotsResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeTimeSlotsResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'employeeId',
    'employeeName',
    'slotDurationMinutes',
    'schedule',
    'rangeStart',
    'rangeEnd',
  };
}

