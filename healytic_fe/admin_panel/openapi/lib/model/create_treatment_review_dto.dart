//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateTreatmentReviewDto {
  /// Returns a new [CreateTreatmentReviewDto] instance.
  CreateTreatmentReviewDto({
    required this.appointmentId,
    required this.rating,
    this.comment,
    this.tags = const [],
    this.photoKeys = const [],
  });

  /// ID of the completed appointment to review
  String appointmentId;

  /// Rating from 1 to 5
  num rating;

  /// Free-text comment (max 2000 chars)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? comment;

  /// Feedback tags (max 10)
  List<String> tags;

  /// S3 keys of uploaded photos (max 5). Upload via POST /v1/s3/presign first.
  List<String> photoKeys;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateTreatmentReviewDto &&
    other.appointmentId == appointmentId &&
    other.rating == rating &&
    other.comment == comment &&
    _deepEquality.equals(other.tags, tags) &&
    _deepEquality.equals(other.photoKeys, photoKeys);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (appointmentId.hashCode) +
    (rating.hashCode) +
    (comment == null ? 0 : comment!.hashCode) +
    (tags.hashCode) +
    (photoKeys.hashCode);

  @override
  String toString() => 'CreateTreatmentReviewDto[appointmentId=$appointmentId, rating=$rating, comment=$comment, tags=$tags, photoKeys=$photoKeys]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'appointmentId'] = this.appointmentId;
      json[r'rating'] = this.rating;
    if (this.comment != null) {
      json[r'comment'] = this.comment;
    } else {
      json[r'comment'] = null;
    }
      json[r'tags'] = this.tags;
      json[r'photoKeys'] = this.photoKeys;
    return json;
  }

  /// Returns a new [CreateTreatmentReviewDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateTreatmentReviewDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateTreatmentReviewDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateTreatmentReviewDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateTreatmentReviewDto(
        appointmentId: mapValueOfType<String>(json, r'appointmentId')!,
        rating: num.parse('${json[r'rating']}'),
        comment: mapValueOfType<String>(json, r'comment'),
        tags: json[r'tags'] is Iterable
            ? (json[r'tags'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        photoKeys: json[r'photoKeys'] is Iterable
            ? (json[r'photoKeys'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<CreateTreatmentReviewDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateTreatmentReviewDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateTreatmentReviewDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateTreatmentReviewDto> mapFromJson(dynamic json) {
    final map = <String, CreateTreatmentReviewDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateTreatmentReviewDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateTreatmentReviewDto-objects as value to a dart map
  static Map<String, List<CreateTreatmentReviewDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateTreatmentReviewDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateTreatmentReviewDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'appointmentId',
    'rating',
  };
}

