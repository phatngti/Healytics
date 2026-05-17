//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicEmployeeReviewResponseDto {
  /// Returns a new [PublicEmployeeReviewResponseDto] instance.
  PublicEmployeeReviewResponseDto({
    required this.id,
    required this.reviewerName,
    this.avatarUrl,
    required this.rating,
    this.comment,
    this.tags = const [],
    required this.wouldRecommend,
    required this.createdAt,
  });


  String id;

  String reviewerName;

  String? avatarUrl;

  num rating;

  String? comment;

  List<String> tags;

  bool wouldRecommend;

  String createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicEmployeeReviewResponseDto &&
    other.id == id &&
    other.reviewerName == reviewerName &&
    other.avatarUrl == avatarUrl &&
    other.rating == rating &&
    other.comment == comment &&
    _deepEquality.equals(other.tags, tags) &&
    other.wouldRecommend == wouldRecommend &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (reviewerName.hashCode) +
    (avatarUrl == null ? 0 : avatarUrl!.hashCode) +
    (rating.hashCode) +
    (comment == null ? 0 : comment!.hashCode) +
    (tags.hashCode) +
    (wouldRecommend.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'PublicEmployeeReviewResponseDto[id=$id, reviewerName=$reviewerName, avatarUrl=$avatarUrl, rating=$rating, comment=$comment, tags=$tags, wouldRecommend=$wouldRecommend, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'reviewerName'] = this.reviewerName;
    if (this.avatarUrl != null) {
      json[r'avatarUrl'] = this.avatarUrl;
    } else {
      json[r'avatarUrl'] = null;
    }
      json[r'rating'] = this.rating;
    if (this.comment != null) {
      json[r'comment'] = this.comment;
    } else {
      json[r'comment'] = null;
    }
      json[r'tags'] = this.tags;
      json[r'wouldRecommend'] = this.wouldRecommend;
      json[r'createdAt'] = this.createdAt;
    return json;
  }

  /// Returns a new [PublicEmployeeReviewResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicEmployeeReviewResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicEmployeeReviewResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicEmployeeReviewResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicEmployeeReviewResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        reviewerName: mapValueOfType<String>(json, r'reviewerName')!,
        avatarUrl: mapValueOfType<String>(json, r'avatarUrl'),
        rating: num.parse('${json[r'rating']}'),
        comment: mapValueOfType<String>(json, r'comment'),
        tags: json[r'tags'] is Iterable
            ? (json[r'tags'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        wouldRecommend: mapValueOfType<bool>(json, r'wouldRecommend')!,
        createdAt: mapValueOfType<String>(json, r'createdAt')!,
      );
    }
    return null;
  }

  static List<PublicEmployeeReviewResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicEmployeeReviewResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicEmployeeReviewResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicEmployeeReviewResponseDto> mapFromJson(dynamic json) {
    final map = <String, PublicEmployeeReviewResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicEmployeeReviewResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicEmployeeReviewResponseDto-objects as value to a dart map
  static Map<String, List<PublicEmployeeReviewResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicEmployeeReviewResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicEmployeeReviewResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'reviewerName',
    'rating',
    'tags',
    'wouldRecommend',
    'createdAt',
  };
}

