//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateProductReviewDto {
  /// Returns a new [CreateProductReviewDto] instance.
  CreateProductReviewDto({
    required this.reviewerName,
    this.avatarUrl,
    required this.rating,
    this.status,
    required this.date,
    required this.text,
    this.imageUrls = const [],
  });

  String reviewerName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? avatarUrl;

  /// Rating from 1 to 5
  num rating;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? status;

  String date;

  String text;

  List<String> imageUrls;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateProductReviewDto &&
    other.reviewerName == reviewerName &&
    other.avatarUrl == avatarUrl &&
    other.rating == rating &&
    other.status == status &&
    other.date == date &&
    other.text == text &&
    _deepEquality.equals(other.imageUrls, imageUrls);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (reviewerName.hashCode) +
    (avatarUrl == null ? 0 : avatarUrl!.hashCode) +
    (rating.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (date.hashCode) +
    (text.hashCode) +
    (imageUrls.hashCode);

  @override
  String toString() => 'CreateProductReviewDto[reviewerName=$reviewerName, avatarUrl=$avatarUrl, rating=$rating, status=$status, date=$date, text=$text, imageUrls=$imageUrls]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'reviewerName'] = this.reviewerName;
    if (this.avatarUrl != null) {
      json[r'avatarUrl'] = this.avatarUrl;
    } else {
      json[r'avatarUrl'] = null;
    }
      json[r'rating'] = this.rating;
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
      json[r'date'] = this.date;
      json[r'text'] = this.text;
      json[r'imageUrls'] = this.imageUrls;
    return json;
  }

  /// Returns a new [CreateProductReviewDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateProductReviewDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateProductReviewDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateProductReviewDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateProductReviewDto(
        reviewerName: mapValueOfType<String>(json, r'reviewerName')!,
        avatarUrl: mapValueOfType<String>(json, r'avatarUrl'),
        rating: num.parse('${json[r'rating']}'),
        status: mapValueOfType<String>(json, r'status'),
        date: mapValueOfType<String>(json, r'date')!,
        text: mapValueOfType<String>(json, r'text')!,
        imageUrls: json[r'imageUrls'] is Iterable
            ? (json[r'imageUrls'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<CreateProductReviewDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateProductReviewDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateProductReviewDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateProductReviewDto> mapFromJson(dynamic json) {
    final map = <String, CreateProductReviewDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateProductReviewDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateProductReviewDto-objects as value to a dart map
  static Map<String, List<CreateProductReviewDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateProductReviewDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateProductReviewDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'reviewerName',
    'rating',
    'date',
    'text',
  };
}

