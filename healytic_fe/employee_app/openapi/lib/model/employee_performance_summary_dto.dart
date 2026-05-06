//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeePerformanceSummaryDto {
  /// Returns a new [EmployeePerformanceSummaryDto] instance.
  EmployeePerformanceSummaryDto({
    required this.employeeName,
    required this.roleLabel,
    required this.rating,
    required this.utilizationRate,
    required this.contributionValue,
  });


  /// Employee full name
  String employeeName;

  /// Human-readable role label
  String roleLabel;

  /// Average rating (0-5)
  num rating;

  /// Utilization rate percentage
  num utilizationRate;

  /// Contribution value in VND
  num contributionValue;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeePerformanceSummaryDto &&
    other.employeeName == employeeName &&
    other.roleLabel == roleLabel &&
    other.rating == rating &&
    other.utilizationRate == utilizationRate &&
    other.contributionValue == contributionValue;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (employeeName.hashCode) +
    (roleLabel.hashCode) +
    (rating.hashCode) +
    (utilizationRate.hashCode) +
    (contributionValue.hashCode);

  @override
  String toString() => 'EmployeePerformanceSummaryDto[employeeName=$employeeName, roleLabel=$roleLabel, rating=$rating, utilizationRate=$utilizationRate, contributionValue=$contributionValue]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'employeeName'] = this.employeeName;
      json[r'roleLabel'] = this.roleLabel;
      json[r'rating'] = this.rating;
      json[r'utilizationRate'] = this.utilizationRate;
      json[r'contributionValue'] = this.contributionValue;
    return json;
  }

  /// Returns a new [EmployeePerformanceSummaryDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeePerformanceSummaryDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeePerformanceSummaryDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeePerformanceSummaryDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeePerformanceSummaryDto(
        employeeName: mapValueOfType<String>(json, r'employeeName')!,
        roleLabel: mapValueOfType<String>(json, r'roleLabel')!,
        rating: num.parse('${json[r'rating']}'),
        utilizationRate: num.parse('${json[r'utilizationRate']}'),
        contributionValue: num.parse('${json[r'contributionValue']}'),
      );
    }
    return null;
  }

  static List<EmployeePerformanceSummaryDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeePerformanceSummaryDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeePerformanceSummaryDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeePerformanceSummaryDto> mapFromJson(dynamic json) {
    final map = <String, EmployeePerformanceSummaryDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeePerformanceSummaryDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeePerformanceSummaryDto-objects as value to a dart map
  static Map<String, List<EmployeePerformanceSummaryDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeePerformanceSummaryDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeePerformanceSummaryDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'employeeName',
    'roleLabel',
    'rating',
    'utilizationRate',
    'contributionValue',
  };
}

