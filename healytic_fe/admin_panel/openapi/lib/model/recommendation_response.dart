//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RecommendationResponse {
  /// Returns a new [RecommendationResponse] instance.
  RecommendationResponse({
    this.recommendations = const [],
    required this.total,
    required this.timestamp,
  });

  List<ServiceDetail> recommendations;

  int total;

  String timestamp;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RecommendationResponse &&
    _deepEquality.equals(other.recommendations, recommendations) &&
    other.total == total &&
    other.timestamp == timestamp;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (recommendations.hashCode) +
    (total.hashCode) +
    (timestamp.hashCode);

  @override
  String toString() => 'RecommendationResponse[recommendations=$recommendations, total=$total, timestamp=$timestamp]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'recommendations'] = this.recommendations;
      json[r'total'] = this.total;
      json[r'timestamp'] = this.timestamp;
    return json;
  }

  /// Returns a new [RecommendationResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RecommendationResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RecommendationResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RecommendationResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RecommendationResponse(
        recommendations: ServiceDetail.listFromJson(json[r'recommendations']),
        total: mapValueOfType<int>(json, r'total')!,
        timestamp: mapValueOfType<String>(json, r'timestamp')!,
      );
    }
    return null;
  }

  static List<RecommendationResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RecommendationResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RecommendationResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RecommendationResponse> mapFromJson(dynamic json) {
    final map = <String, RecommendationResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RecommendationResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RecommendationResponse-objects as value to a dart map
  static Map<String, List<RecommendationResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RecommendationResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RecommendationResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'recommendations',
    'total',
    'timestamp',
  };
}

