//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReviewSummaryDto {
  /// Returns a new [ReviewSummaryDto] instance.
  ReviewSummaryDto({
    required this.averageRating,
    required this.reviewerName,
    required this.reviewText,
    required this.starCount,
  });

  num averageRating;

  String reviewerName;

  String reviewText;

  num starCount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReviewSummaryDto &&
    other.averageRating == averageRating &&
    other.reviewerName == reviewerName &&
    other.reviewText == reviewText &&
    other.starCount == starCount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (averageRating.hashCode) +
    (reviewerName.hashCode) +
    (reviewText.hashCode) +
    (starCount.hashCode);

  @override
  String toString() => 'ReviewSummaryDto[averageRating=$averageRating, reviewerName=$reviewerName, reviewText=$reviewText, starCount=$starCount]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'averageRating'] = this.averageRating;
      json[r'reviewerName'] = this.reviewerName;
      json[r'reviewText'] = this.reviewText;
      json[r'starCount'] = this.starCount;
    return json;
  }

  /// Returns a new [ReviewSummaryDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReviewSummaryDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ReviewSummaryDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ReviewSummaryDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ReviewSummaryDto(
        averageRating: num.parse('${json[r'averageRating']}'),
        reviewerName: mapValueOfType<String>(json, r'reviewerName')!,
        reviewText: mapValueOfType<String>(json, r'reviewText')!,
        starCount: num.parse('${json[r'starCount']}'),
      );
    }
    return null;
  }

  static List<ReviewSummaryDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReviewSummaryDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReviewSummaryDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReviewSummaryDto> mapFromJson(dynamic json) {
    final map = <String, ReviewSummaryDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReviewSummaryDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReviewSummaryDto-objects as value to a dart map
  static Map<String, List<ReviewSummaryDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReviewSummaryDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReviewSummaryDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'averageRating',
    'reviewerName',
    'reviewText',
    'starCount',
  };
}

