//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicHealthServiceEmployeeEligibilityDto {
  /// Returns a new [PublicHealthServiceEmployeeEligibilityDto] instance.
  PublicHealthServiceEmployeeEligibilityDto({
    required this.productId,
    required this.employeeId,
    required this.isPrimary,
  });

  /// Product ID
  String productId;

  /// Employee ID
  String employeeId;

  /// Whether this is the primary employee
  bool isPrimary;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicHealthServiceEmployeeEligibilityDto &&
    other.productId == productId &&
    other.employeeId == employeeId &&
    other.isPrimary == isPrimary;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (productId.hashCode) +
    (employeeId.hashCode) +
    (isPrimary.hashCode);

  @override
  String toString() => 'PublicHealthServiceEmployeeEligibilityDto[productId=$productId, employeeId=$employeeId, isPrimary=$isPrimary]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'productId'] = this.productId;
      json[r'employeeId'] = this.employeeId;
      json[r'isPrimary'] = this.isPrimary;
    return json;
  }

  /// Returns a new [PublicHealthServiceEmployeeEligibilityDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicHealthServiceEmployeeEligibilityDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicHealthServiceEmployeeEligibilityDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicHealthServiceEmployeeEligibilityDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicHealthServiceEmployeeEligibilityDto(
        productId: mapValueOfType<String>(json, r'productId')!,
        employeeId: mapValueOfType<String>(json, r'employeeId')!,
        isPrimary: mapValueOfType<bool>(json, r'isPrimary')!,
      );
    }
    return null;
  }

  static List<PublicHealthServiceEmployeeEligibilityDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicHealthServiceEmployeeEligibilityDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicHealthServiceEmployeeEligibilityDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicHealthServiceEmployeeEligibilityDto> mapFromJson(dynamic json) {
    final map = <String, PublicHealthServiceEmployeeEligibilityDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicHealthServiceEmployeeEligibilityDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicHealthServiceEmployeeEligibilityDto-objects as value to a dart map
  static Map<String, List<PublicHealthServiceEmployeeEligibilityDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicHealthServiceEmployeeEligibilityDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicHealthServiceEmployeeEligibilityDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'productId',
    'employeeId',
    'isPrimary',
  };
}

