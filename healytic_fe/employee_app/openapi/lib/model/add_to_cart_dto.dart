//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AddToCartDto {
  /// Returns a new [AddToCartDto] instance.
  AddToCartDto({
    required this.serviceId,
    this.employeeId,
    required this.timeSlot,
    this.autoAssignStaff = false,
  });


  /// UUID of the health service
  String serviceId;

  /// UUID of the assigned employee (doctor or therapist)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? employeeId;

  /// Desired time slot in ISO 8601 datetime format
  String timeSlot;

  /// If true, backend selects the best eligible available specialist for this service and time slot.
  bool autoAssignStaff;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AddToCartDto &&
    other.serviceId == serviceId &&
    other.employeeId == employeeId &&
    other.timeSlot == timeSlot &&
    other.autoAssignStaff == autoAssignStaff;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (serviceId.hashCode) +
    (employeeId == null ? 0 : employeeId!.hashCode) +
    (timeSlot.hashCode) +
    (autoAssignStaff.hashCode);

  @override
  String toString() => 'AddToCartDto[serviceId=$serviceId, employeeId=$employeeId, timeSlot=$timeSlot, autoAssignStaff=$autoAssignStaff]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'serviceId'] = this.serviceId;
    if (this.employeeId != null) {
      json[r'employeeId'] = this.employeeId;
    } else {
      json[r'employeeId'] = null;
    }
      json[r'timeSlot'] = this.timeSlot;
      json[r'autoAssignStaff'] = this.autoAssignStaff;
    return json;
  }

  /// Returns a new [AddToCartDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AddToCartDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AddToCartDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AddToCartDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AddToCartDto(
        serviceId: mapValueOfType<String>(json, r'serviceId')!,
        employeeId: mapValueOfType<String>(json, r'employeeId'),
        timeSlot: mapValueOfType<String>(json, r'timeSlot')!,
        autoAssignStaff: mapValueOfType<bool>(json, r'autoAssignStaff') ?? false,
      );
    }
    return null;
  }

  static List<AddToCartDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AddToCartDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AddToCartDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AddToCartDto> mapFromJson(dynamic json) {
    final map = <String, AddToCartDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AddToCartDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AddToCartDto-objects as value to a dart map
  static Map<String, List<AddToCartDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AddToCartDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AddToCartDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'serviceId',
    'timeSlot',
  };
}

