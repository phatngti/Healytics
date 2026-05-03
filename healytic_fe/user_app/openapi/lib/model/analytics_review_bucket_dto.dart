//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AnalyticsReviewBucketDto {
  /// Returns a new [AnalyticsReviewBucketDto] instance.
  AnalyticsReviewBucketDto({
    required this.stars,
    required this.count,
  });


  /// Star rating (1-5)
  num stars;

  /// Number of reviews with this rating
  num count;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AnalyticsReviewBucketDto &&
    other.stars == stars &&
    other.count == count;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (stars.hashCode) +
    (count.hashCode);

  @override
  String toString() => 'AnalyticsReviewBucketDto[stars=$stars, count=$count]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'stars'] = this.stars;
      json[r'count'] = this.count;
    return json;
  }

  /// Returns a new [AnalyticsReviewBucketDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AnalyticsReviewBucketDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AnalyticsReviewBucketDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AnalyticsReviewBucketDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AnalyticsReviewBucketDto(
        stars: num.parse('${json[r'stars']}'),
        count: num.parse('${json[r'count']}'),
      );
    }
    return null;
  }

  static List<AnalyticsReviewBucketDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AnalyticsReviewBucketDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AnalyticsReviewBucketDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AnalyticsReviewBucketDto> mapFromJson(dynamic json) {
    final map = <String, AnalyticsReviewBucketDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AnalyticsReviewBucketDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AnalyticsReviewBucketDto-objects as value to a dart map
  static Map<String, List<AnalyticsReviewBucketDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AnalyticsReviewBucketDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AnalyticsReviewBucketDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'stars',
    'count',
  };
}

