//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ClinicReviewsResponseDto {
  /// Returns a new [ClinicReviewsResponseDto] instance.
  ClinicReviewsResponseDto({
    required this.summary,
    this.filters = const [],
    this.reviews = const [],
    required this.totalCount,
    required this.hasMore,
  });

  ClinicReviewSummaryDto summary;

  List<ClinicReviewFilterDto> filters;

  List<ClinicReviewDto> reviews;

  num totalCount;

  bool hasMore;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ClinicReviewsResponseDto &&
    other.summary == summary &&
    _deepEquality.equals(other.filters, filters) &&
    _deepEquality.equals(other.reviews, reviews) &&
    other.totalCount == totalCount &&
    other.hasMore == hasMore;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (summary.hashCode) +
    (filters.hashCode) +
    (reviews.hashCode) +
    (totalCount.hashCode) +
    (hasMore.hashCode);

  @override
  String toString() => 'ClinicReviewsResponseDto[summary=$summary, filters=$filters, reviews=$reviews, totalCount=$totalCount, hasMore=$hasMore]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'summary'] = this.summary;
      json[r'filters'] = this.filters;
      json[r'reviews'] = this.reviews;
      json[r'totalCount'] = this.totalCount;
      json[r'hasMore'] = this.hasMore;
    return json;
  }

  /// Returns a new [ClinicReviewsResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ClinicReviewsResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ClinicReviewsResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ClinicReviewsResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ClinicReviewsResponseDto(
        summary: ClinicReviewSummaryDto.fromJson(json[r'summary'])!,
        filters: ClinicReviewFilterDto.listFromJson(json[r'filters']),
        reviews: ClinicReviewDto.listFromJson(json[r'reviews']),
        totalCount: num.parse('${json[r'totalCount']}'),
        hasMore: mapValueOfType<bool>(json, r'hasMore')!,
      );
    }
    return null;
  }

  static List<ClinicReviewsResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ClinicReviewsResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ClinicReviewsResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ClinicReviewsResponseDto> mapFromJson(dynamic json) {
    final map = <String, ClinicReviewsResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ClinicReviewsResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ClinicReviewsResponseDto-objects as value to a dart map
  static Map<String, List<ClinicReviewsResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ClinicReviewsResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ClinicReviewsResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'summary',
    'filters',
    'reviews',
    'totalCount',
    'hasMore',
  };
}

