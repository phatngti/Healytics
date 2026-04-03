//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class HomeRecommenderRequest {
  /// Returns a new [HomeRecommenderRequest] instance.
  HomeRecommenderRequest({
    required this.userId,
    this.topK = 5,
  });

  String userId;

  /// Minimum value: 1
  /// Maximum value: 20
  int topK;

  @override
  bool operator ==(Object other) => identical(this, other) || other is HomeRecommenderRequest &&
    other.userId == userId &&
    other.topK == topK;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (userId.hashCode) +
    (topK.hashCode);

  @override
  String toString() => 'HomeRecommenderRequest[userId=$userId, topK=$topK]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'user_id'] = this.userId;
      json[r'top_k'] = this.topK;
    return json;
  }

  /// Returns a new [HomeRecommenderRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static HomeRecommenderRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "HomeRecommenderRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "HomeRecommenderRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return HomeRecommenderRequest(
        userId: mapValueOfType<String>(json, r'user_id')!,
        topK: mapValueOfType<int>(json, r'top_k') ?? 5,
      );
    }
    return null;
  }

  static List<HomeRecommenderRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <HomeRecommenderRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = HomeRecommenderRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, HomeRecommenderRequest> mapFromJson(dynamic json) {
    final map = <String, HomeRecommenderRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = HomeRecommenderRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of HomeRecommenderRequest-objects as value to a dart map
  static Map<String, List<HomeRecommenderRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<HomeRecommenderRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = HomeRecommenderRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'user_id',
  };
}

