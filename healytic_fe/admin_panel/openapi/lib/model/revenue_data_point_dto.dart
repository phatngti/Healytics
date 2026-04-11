//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RevenueDataPointDto {
  /// Returns a new [RevenueDataPointDto] instance.
  RevenueDataPointDto({
    required this.date,
    required this.revenue,
  });

  String date;

  /// Revenue amount in VND
  num revenue;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RevenueDataPointDto &&
    other.date == date &&
    other.revenue == revenue;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (date.hashCode) +
    (revenue.hashCode);

  @override
  String toString() => 'RevenueDataPointDto[date=$date, revenue=$revenue]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'date'] = this.date;
      json[r'revenue'] = this.revenue;
    return json;
  }

  /// Returns a new [RevenueDataPointDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RevenueDataPointDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RevenueDataPointDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RevenueDataPointDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RevenueDataPointDto(
        date: mapValueOfType<String>(json, r'date')!,
        revenue: num.parse('${json[r'revenue']}'),
      );
    }
    return null;
  }

  static List<RevenueDataPointDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RevenueDataPointDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RevenueDataPointDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RevenueDataPointDto> mapFromJson(dynamic json) {
    final map = <String, RevenueDataPointDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RevenueDataPointDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RevenueDataPointDto-objects as value to a dart map
  static Map<String, List<RevenueDataPointDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RevenueDataPointDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RevenueDataPointDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'date',
    'revenue',
  };
}

