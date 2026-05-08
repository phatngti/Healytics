//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeMixMetricDto {
  /// Returns a new [EmployeeMixMetricDto] instance.
  EmployeeMixMetricDto({
    required this.label,
    required this.value,
    required this.share,
  });


  /// Service category or product name
  String label;

  /// Number of completed sessions for this category
  num value;

  /// Proportion share (0-1) relative to total sessions
  num share;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeMixMetricDto &&
    other.label == label &&
    other.value == value &&
    other.share == share;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (label.hashCode) +
    (value.hashCode) +
    (share.hashCode);

  @override
  String toString() => 'EmployeeMixMetricDto[label=$label, value=$value, share=$share]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'label'] = this.label;
      json[r'value'] = this.value;
      json[r'share'] = this.share;
    return json;
  }

  /// Returns a new [EmployeeMixMetricDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeMixMetricDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeMixMetricDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeMixMetricDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeMixMetricDto(
        label: mapValueOfType<String>(json, r'label')!,
        value: num.parse('${json[r'value']}'),
        share: num.parse('${json[r'share']}'),
      );
    }
    return null;
  }

  static List<EmployeeMixMetricDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeMixMetricDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeMixMetricDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeMixMetricDto> mapFromJson(dynamic json) {
    final map = <String, EmployeeMixMetricDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeMixMetricDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeMixMetricDto-objects as value to a dart map
  static Map<String, List<EmployeeMixMetricDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeMixMetricDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeMixMetricDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'label',
    'value',
    'share',
  };
}

