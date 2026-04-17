//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RatingInfo {
  /// Returns a new [RatingInfo] instance.
  RatingInfo({
    required this.average,
    required this.totalReviews,
  });


  num average;

  int totalReviews;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RatingInfo &&
    other.average == average &&
    other.totalReviews == totalReviews;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (average.hashCode) +
    (totalReviews.hashCode);

  @override
  String toString() => 'RatingInfo[average=$average, totalReviews=$totalReviews]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'average'] = this.average;
      json[r'total_reviews'] = this.totalReviews;
    return json;
  }

  /// Returns a new [RatingInfo] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RatingInfo? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RatingInfo[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RatingInfo[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RatingInfo(
        average: num.parse('${json[r'average']}'),
        totalReviews: mapValueOfType<int>(json, r'total_reviews')!,
      );
    }
    return null;
  }

  static List<RatingInfo> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RatingInfo>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RatingInfo.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RatingInfo> mapFromJson(dynamic json) {
    final map = <String, RatingInfo>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RatingInfo.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RatingInfo-objects as value to a dart map
  static Map<String, List<RatingInfo>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RatingInfo>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RatingInfo.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'average',
    'total_reviews',
  };
}

