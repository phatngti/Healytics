//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdateEmployeeProfileDto {
  /// Returns a new [UpdateEmployeeProfileDto] instance.
  UpdateEmployeeProfileDto({
    this.phone,
    this.avatarUrl,
    this.description,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.schedule = const [],
  });


  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? phone;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? avatarUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? emergencyContactName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? emergencyContactPhone;

  /// Weekly work schedule
  List<WorkScheduleEntryDto> schedule;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateEmployeeProfileDto &&
    other.phone == phone &&
    other.avatarUrl == avatarUrl &&
    other.description == description &&
    other.emergencyContactName == emergencyContactName &&
    other.emergencyContactPhone == emergencyContactPhone &&
    _deepEquality.equals(other.schedule, schedule);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (phone == null ? 0 : phone!.hashCode) +
    (avatarUrl == null ? 0 : avatarUrl!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (emergencyContactName == null ? 0 : emergencyContactName!.hashCode) +
    (emergencyContactPhone == null ? 0 : emergencyContactPhone!.hashCode) +
    (schedule.hashCode);

  @override
  String toString() => 'UpdateEmployeeProfileDto[phone=$phone, avatarUrl=$avatarUrl, description=$description, emergencyContactName=$emergencyContactName, emergencyContactPhone=$emergencyContactPhone, schedule=$schedule]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.phone != null) {
      json[r'phone'] = this.phone;
    } else {
      json[r'phone'] = null;
    }
    if (this.avatarUrl != null) {
      json[r'avatarUrl'] = this.avatarUrl;
    } else {
      json[r'avatarUrl'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.emergencyContactName != null) {
      json[r'emergencyContactName'] = this.emergencyContactName;
    } else {
      json[r'emergencyContactName'] = null;
    }
    if (this.emergencyContactPhone != null) {
      json[r'emergencyContactPhone'] = this.emergencyContactPhone;
    } else {
      json[r'emergencyContactPhone'] = null;
    }
      json[r'schedule'] = this.schedule;
    return json;
  }

  /// Returns a new [UpdateEmployeeProfileDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdateEmployeeProfileDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdateEmployeeProfileDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdateEmployeeProfileDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdateEmployeeProfileDto(
        phone: mapValueOfType<String>(json, r'phone'),
        avatarUrl: mapValueOfType<String>(json, r'avatarUrl'),
        description: mapValueOfType<String>(json, r'description'),
        emergencyContactName: mapValueOfType<String>(json, r'emergencyContactName'),
        emergencyContactPhone: mapValueOfType<String>(json, r'emergencyContactPhone'),
        schedule: WorkScheduleEntryDto.listFromJson(json[r'schedule']),
      );
    }
    return null;
  }

  static List<UpdateEmployeeProfileDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateEmployeeProfileDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateEmployeeProfileDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateEmployeeProfileDto> mapFromJson(dynamic json) {
    final map = <String, UpdateEmployeeProfileDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateEmployeeProfileDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateEmployeeProfileDto-objects as value to a dart map
  static Map<String, List<UpdateEmployeeProfileDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateEmployeeProfileDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateEmployeeProfileDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

