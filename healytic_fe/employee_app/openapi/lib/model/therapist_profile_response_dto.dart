//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TherapistProfileResponseDto {
  /// Returns a new [TherapistProfileResponseDto] instance.
  TherapistProfileResponseDto({
    this.employeeId,
    this.level,
    this.type,
    this.strengthLevel,
    this.commissionRate,
    this.healthCheckDate,
    this.skills = const [],
    this.deviceProficiency = const [],
  });


  /// Employee ID (primary key)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? employeeId;

  /// Therapist level (junior, senior, etc.)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? level;

  /// Therapist type
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? type;

  /// Strength level
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? strengthLevel;

  /// Commission rate (percentage)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? commissionRate;

  /// Health check date
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? healthCheckDate;

  /// List of skills
  List<String> skills;

  /// Device proficiency list
  List<String> deviceProficiency;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TherapistProfileResponseDto &&
    other.employeeId == employeeId &&
    other.level == level &&
    other.type == type &&
    other.strengthLevel == strengthLevel &&
    other.commissionRate == commissionRate &&
    other.healthCheckDate == healthCheckDate &&
    _deepEquality.equals(other.skills, skills) &&
    _deepEquality.equals(other.deviceProficiency, deviceProficiency);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (employeeId == null ? 0 : employeeId!.hashCode) +
    (level == null ? 0 : level!.hashCode) +
    (type == null ? 0 : type!.hashCode) +
    (strengthLevel == null ? 0 : strengthLevel!.hashCode) +
    (commissionRate == null ? 0 : commissionRate!.hashCode) +
    (healthCheckDate == null ? 0 : healthCheckDate!.hashCode) +
    (skills.hashCode) +
    (deviceProficiency.hashCode);

  @override
  String toString() => 'TherapistProfileResponseDto[employeeId=$employeeId, level=$level, type=$type, strengthLevel=$strengthLevel, commissionRate=$commissionRate, healthCheckDate=$healthCheckDate, skills=$skills, deviceProficiency=$deviceProficiency]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.employeeId != null) {
      json[r'employeeId'] = this.employeeId;
    } else {
      json[r'employeeId'] = null;
    }
    if (this.level != null) {
      json[r'level'] = this.level;
    } else {
      json[r'level'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
    if (this.strengthLevel != null) {
      json[r'strengthLevel'] = this.strengthLevel;
    } else {
      json[r'strengthLevel'] = null;
    }
    if (this.commissionRate != null) {
      json[r'commissionRate'] = this.commissionRate;
    } else {
      json[r'commissionRate'] = null;
    }
    if (this.healthCheckDate != null) {
      json[r'healthCheckDate'] = this.healthCheckDate!.toUtc().toIso8601String();
    } else {
      json[r'healthCheckDate'] = null;
    }
      json[r'skills'] = this.skills;
      json[r'deviceProficiency'] = this.deviceProficiency;
    return json;
  }

  /// Returns a new [TherapistProfileResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TherapistProfileResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TherapistProfileResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TherapistProfileResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TherapistProfileResponseDto(
        employeeId: mapValueOfType<String>(json, r'employeeId'),
        level: mapValueOfType<String>(json, r'level'),
        type: mapValueOfType<String>(json, r'type'),
        strengthLevel: mapValueOfType<String>(json, r'strengthLevel'),
        commissionRate: num.parse('${json[r'commissionRate']}'),
        healthCheckDate: mapDateTime(json, r'healthCheckDate', r''),
        skills: json[r'skills'] is Iterable
            ? (json[r'skills'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        deviceProficiency: json[r'deviceProficiency'] is Iterable
            ? (json[r'deviceProficiency'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<TherapistProfileResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TherapistProfileResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TherapistProfileResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TherapistProfileResponseDto> mapFromJson(dynamic json) {
    final map = <String, TherapistProfileResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TherapistProfileResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TherapistProfileResponseDto-objects as value to a dart map
  static Map<String, List<TherapistProfileResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TherapistProfileResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TherapistProfileResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

