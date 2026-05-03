//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeRoleDistributionDto {
  /// Returns a new [EmployeeRoleDistributionDto] instance.
  EmployeeRoleDistributionDto({
    required this.role,
    required this.count,
  });


  /// Human-readable role label
  String role;

  /// Number of employees with this role
  num count;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeRoleDistributionDto &&
    other.role == role &&
    other.count == count;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (role.hashCode) +
    (count.hashCode);

  @override
  String toString() => 'EmployeeRoleDistributionDto[role=$role, count=$count]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'role'] = this.role;
      json[r'count'] = this.count;
    return json;
  }

  /// Returns a new [EmployeeRoleDistributionDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeRoleDistributionDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeRoleDistributionDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeRoleDistributionDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeRoleDistributionDto(
        role: mapValueOfType<String>(json, r'role')!,
        count: num.parse('${json[r'count']}'),
      );
    }
    return null;
  }

  static List<EmployeeRoleDistributionDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeRoleDistributionDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeRoleDistributionDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeRoleDistributionDto> mapFromJson(dynamic json) {
    final map = <String, EmployeeRoleDistributionDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeRoleDistributionDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeRoleDistributionDto-objects as value to a dart map
  static Map<String, List<EmployeeRoleDistributionDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeRoleDistributionDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeRoleDistributionDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'role',
    'count',
  };
}

