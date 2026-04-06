//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ClinicReviewSummaryDto {
  /// Returns a new [ClinicReviewSummaryDto] instance.
  ClinicReviewSummaryDto({
    required this.averageRating,
    required this.totalReviewCount,
    required this.ratingLabel,
    required this.starDistribution,
  });

  num averageRating;

  num totalReviewCount;

  String ratingLabel;

  Object starDistribution;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ClinicReviewSummaryDto &&
    other.averageRating == averageRating &&
    other.totalReviewCount == totalReviewCount &&
    other.ratingLabel == ratingLabel &&
    other.starDistribution == starDistribution;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (averageRating.hashCode) +
    (totalReviewCount.hashCode) +
    (ratingLabel.hashCode) +
    (starDistribution.hashCode);

  @override
  String toString() => 'ClinicReviewSummaryDto[averageRating=$averageRating, totalReviewCount=$totalReviewCount, ratingLabel=$ratingLabel, starDistribution=$starDistribution]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'averageRating'] = this.averageRating;
      json[r'totalReviewCount'] = this.totalReviewCount;
      json[r'ratingLabel'] = this.ratingLabel;
      json[r'starDistribution'] = this.starDistribution;
    return json;
  }

  /// Returns a new [ClinicReviewSummaryDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ClinicReviewSummaryDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ClinicReviewSummaryDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ClinicReviewSummaryDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ClinicReviewSummaryDto(
        averageRating: num.parse('${json[r'averageRating']}'),
        totalReviewCount: num.parse('${json[r'totalReviewCount']}'),
        ratingLabel: mapValueOfType<String>(json, r'ratingLabel')!,
        starDistribution: mapValueOfType<Object>(json, r'starDistribution')!,
      );
    }
    return null;
  }

  static List<ClinicReviewSummaryDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ClinicReviewSummaryDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ClinicReviewSummaryDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ClinicReviewSummaryDto> mapFromJson(dynamic json) {
    final map = <String, ClinicReviewSummaryDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ClinicReviewSummaryDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ClinicReviewSummaryDto-objects as value to a dart map
  static Map<String, List<ClinicReviewSummaryDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ClinicReviewSummaryDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ClinicReviewSummaryDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'averageRating',
    'totalReviewCount',
    'ratingLabel',
    'starDistribution',
  };
}

