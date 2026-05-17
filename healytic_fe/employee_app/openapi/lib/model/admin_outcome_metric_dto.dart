//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminOutcomeMetricDto {
  /// Returns a new [AdminOutcomeMetricDto] instance.
  AdminOutcomeMetricDto({
    required this.count,
    required this.rate,
  });


  num count;

  num rate;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminOutcomeMetricDto &&
    other.count == count &&
    other.rate == rate;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (count.hashCode) +
    (rate.hashCode);

  @override
  String toString() => 'AdminOutcomeMetricDto[count=$count, rate=$rate]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'count'] = this.count;
      json[r'rate'] = this.rate;
    return json;
  }

  /// Returns a new [AdminOutcomeMetricDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminOutcomeMetricDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminOutcomeMetricDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminOutcomeMetricDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminOutcomeMetricDto(
        count: num.parse('${json[r'count']}'),
        rate: num.parse('${json[r'rate']}'),
      );
    }
    return null;
  }

  static List<AdminOutcomeMetricDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminOutcomeMetricDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminOutcomeMetricDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminOutcomeMetricDto> mapFromJson(dynamic json) {
    final map = <String, AdminOutcomeMetricDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminOutcomeMetricDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminOutcomeMetricDto-objects as value to a dart map
  static Map<String, List<AdminOutcomeMetricDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminOutcomeMetricDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminOutcomeMetricDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'count',
    'rate',
  };
}

