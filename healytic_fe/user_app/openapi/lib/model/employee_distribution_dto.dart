//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeDistributionDto {
  /// Returns a new [EmployeeDistributionDto] instance.
  EmployeeDistributionDto({
    required this.role,
    required this.count,
    required this.status,
  });


  String role;

  num count;

  String status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeDistributionDto &&
    other.role == role &&
    other.count == count &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (role.hashCode) +
    (count.hashCode) +
    (status.hashCode);

  @override
  String toString() => 'EmployeeDistributionDto[role=$role, count=$count, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'role'] = this.role;
      json[r'count'] = this.count;
      json[r'status'] = this.status;
    return json;
  }

  /// Returns a new [EmployeeDistributionDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeDistributionDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeDistributionDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeDistributionDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeDistributionDto(
        role: mapValueOfType<String>(json, r'role')!,
        count: num.parse('${json[r'count']}'),
        status: mapValueOfType<String>(json, r'status')!,
      );
    }
    return null;
  }

  static List<EmployeeDistributionDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeDistributionDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeDistributionDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeDistributionDto> mapFromJson(dynamic json) {
    final map = <String, EmployeeDistributionDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeDistributionDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeDistributionDto-objects as value to a dart map
  static Map<String, List<EmployeeDistributionDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeDistributionDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeDistributionDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'role',
    'count',
    'status',
  };
}

