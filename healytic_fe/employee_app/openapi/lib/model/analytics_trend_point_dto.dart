//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AnalyticsTrendPointDto {
  /// Returns a new [AnalyticsTrendPointDto] instance.
  AnalyticsTrendPointDto({
    required this.label,
    required this.bookings,
    required this.revenue,
  });


  /// Human-readable x-axis label
  String label;

  /// Completed bookings in this time bucket
  num bookings;

  /// Revenue in VND for this time bucket
  num revenue;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AnalyticsTrendPointDto &&
    other.label == label &&
    other.bookings == bookings &&
    other.revenue == revenue;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (label.hashCode) +
    (bookings.hashCode) +
    (revenue.hashCode);

  @override
  String toString() => 'AnalyticsTrendPointDto[label=$label, bookings=$bookings, revenue=$revenue]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'label'] = this.label;
      json[r'bookings'] = this.bookings;
      json[r'revenue'] = this.revenue;
    return json;
  }

  /// Returns a new [AnalyticsTrendPointDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AnalyticsTrendPointDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AnalyticsTrendPointDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AnalyticsTrendPointDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AnalyticsTrendPointDto(
        label: mapValueOfType<String>(json, r'label')!,
        bookings: num.parse('${json[r'bookings']}'),
        revenue: num.parse('${json[r'revenue']}'),
      );
    }
    return null;
  }

  static List<AnalyticsTrendPointDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnalyticsTrendPointDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnalyticsTrendPointDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AnalyticsTrendPointDto> mapFromJson(dynamic json) {
    final map = <String, AnalyticsTrendPointDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AnalyticsTrendPointDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AnalyticsTrendPointDto-objects as value to a dart map
  static Map<String, List<AnalyticsTrendPointDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AnalyticsTrendPointDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AnalyticsTrendPointDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'label',
    'bookings',
    'revenue',
  };
}

