//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class StaffScheduleEntryDto {
  /// Returns a new [StaffScheduleEntryDto] instance.
  StaffScheduleEntryDto({
    required this.employeeId,
    required this.employeeName,
    required this.role,
    required this.startTime,
    required this.endTime,
    required this.serviceName,
    this.patientName,
  });

  String employeeId;

  String employeeName;

  String role;

  String startTime;

  String endTime;

  String serviceName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? patientName;

  @override
  bool operator ==(Object other) => identical(this, other) || other is StaffScheduleEntryDto &&
    other.employeeId == employeeId &&
    other.employeeName == employeeName &&
    other.role == role &&
    other.startTime == startTime &&
    other.endTime == endTime &&
    other.serviceName == serviceName &&
    other.patientName == patientName;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (employeeId.hashCode) +
    (employeeName.hashCode) +
    (role.hashCode) +
    (startTime.hashCode) +
    (endTime.hashCode) +
    (serviceName.hashCode) +
    (patientName == null ? 0 : patientName!.hashCode);

  @override
  String toString() => 'StaffScheduleEntryDto[employeeId=$employeeId, employeeName=$employeeName, role=$role, startTime=$startTime, endTime=$endTime, serviceName=$serviceName, patientName=$patientName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'employeeId'] = this.employeeId;
      json[r'employeeName'] = this.employeeName;
      json[r'role'] = this.role;
      json[r'startTime'] = this.startTime;
      json[r'endTime'] = this.endTime;
      json[r'serviceName'] = this.serviceName;
    if (this.patientName != null) {
      json[r'patientName'] = this.patientName;
    } else {
      json[r'patientName'] = null;
    }
    return json;
  }

  /// Returns a new [StaffScheduleEntryDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StaffScheduleEntryDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "StaffScheduleEntryDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "StaffScheduleEntryDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return StaffScheduleEntryDto(
        employeeId: mapValueOfType<String>(json, r'employeeId')!,
        employeeName: mapValueOfType<String>(json, r'employeeName')!,
        role: mapValueOfType<String>(json, r'role')!,
        startTime: mapValueOfType<String>(json, r'startTime')!,
        endTime: mapValueOfType<String>(json, r'endTime')!,
        serviceName: mapValueOfType<String>(json, r'serviceName')!,
        patientName: mapValueOfType<String>(json, r'patientName'),
      );
    }
    return null;
  }

  static List<StaffScheduleEntryDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <StaffScheduleEntryDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StaffScheduleEntryDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StaffScheduleEntryDto> mapFromJson(dynamic json) {
    final map = <String, StaffScheduleEntryDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StaffScheduleEntryDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StaffScheduleEntryDto-objects as value to a dart map
  static Map<String, List<StaffScheduleEntryDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<StaffScheduleEntryDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = StaffScheduleEntryDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'employeeId',
    'employeeName',
    'role',
    'startTime',
    'endTime',
    'serviceName',
  };
}

