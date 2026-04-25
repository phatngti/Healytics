//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AnalyticsServicePerformanceDto {
  /// Returns a new [AnalyticsServicePerformanceDto] instance.
  AnalyticsServicePerformanceDto({
    required this.name,
    required this.categoryName,
    required this.bookings,
    required this.revenue,
    required this.averageRating,
  });


  String name;

  String categoryName;

  num bookings;

  /// Revenue in VND
  num revenue;

  num averageRating;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AnalyticsServicePerformanceDto &&
    other.name == name &&
    other.categoryName == categoryName &&
    other.bookings == bookings &&
    other.revenue == revenue &&
    other.averageRating == averageRating;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (categoryName.hashCode) +
    (bookings.hashCode) +
    (revenue.hashCode) +
    (averageRating.hashCode);

  @override
  String toString() => 'AnalyticsServicePerformanceDto[name=$name, categoryName=$categoryName, bookings=$bookings, revenue=$revenue, averageRating=$averageRating]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'categoryName'] = this.categoryName;
      json[r'bookings'] = this.bookings;
      json[r'revenue'] = this.revenue;
      json[r'averageRating'] = this.averageRating;
    return json;
  }

  /// Returns a new [AnalyticsServicePerformanceDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AnalyticsServicePerformanceDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AnalyticsServicePerformanceDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AnalyticsServicePerformanceDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AnalyticsServicePerformanceDto(
        name: mapValueOfType<String>(json, r'name')!,
        categoryName: mapValueOfType<String>(json, r'categoryName')!,
        bookings: num.parse('${json[r'bookings']}'),
        revenue: num.parse('${json[r'revenue']}'),
        averageRating: num.parse('${json[r'averageRating']}'),
      );
    }
    return null;
  }

  static List<AnalyticsServicePerformanceDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnalyticsServicePerformanceDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnalyticsServicePerformanceDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AnalyticsServicePerformanceDto> mapFromJson(dynamic json) {
    final map = <String, AnalyticsServicePerformanceDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AnalyticsServicePerformanceDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AnalyticsServicePerformanceDto-objects as value to a dart map
  static Map<String, List<AnalyticsServicePerformanceDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AnalyticsServicePerformanceDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AnalyticsServicePerformanceDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'categoryName',
    'bookings',
    'revenue',
    'averageRating',
  };
}

