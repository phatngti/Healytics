//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateSpecialistReviewDto {
  /// Returns a new [CreateSpecialistReviewDto] instance.
  CreateSpecialistReviewDto({
    required this.appointmentId,
    required this.specialistId,
    required this.rating,
    this.comment,
    this.tags = const [],
    required this.wouldRecommend,
  });

  /// ID of the completed appointment
  String appointmentId;

  /// ID of the specialist/employee who performed the service
  String specialistId;

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

  /// Whether the user would recommend this specialist
  bool wouldRecommend;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateSpecialistReviewDto &&
    other.appointmentId == appointmentId &&
    other.specialistId == specialistId &&
    other.rating == rating &&
    other.comment == comment &&
    _deepEquality.equals(other.tags, tags) &&
    other.wouldRecommend == wouldRecommend;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (appointmentId.hashCode) +
    (specialistId.hashCode) +
    (rating.hashCode) +
    (comment == null ? 0 : comment!.hashCode) +
    (tags.hashCode) +
    (wouldRecommend.hashCode);

  @override
  String toString() => 'CreateSpecialistReviewDto[appointmentId=$appointmentId, specialistId=$specialistId, rating=$rating, comment=$comment, tags=$tags, wouldRecommend=$wouldRecommend]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'appointmentId'] = this.appointmentId;
      json[r'specialistId'] = this.specialistId;
      json[r'rating'] = this.rating;
    if (this.comment != null) {
      json[r'comment'] = this.comment;
    } else {
      json[r'comment'] = null;
    }
      json[r'tags'] = this.tags;
      json[r'wouldRecommend'] = this.wouldRecommend;
    return json;
  }

  /// Returns a new [CreateSpecialistReviewDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateSpecialistReviewDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateSpecialistReviewDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateSpecialistReviewDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateSpecialistReviewDto(
        appointmentId: mapValueOfType<String>(json, r'appointmentId')!,
        specialistId: mapValueOfType<String>(json, r'specialistId')!,
        rating: num.parse('${json[r'rating']}'),
        comment: mapValueOfType<String>(json, r'comment'),
        tags: json[r'tags'] is Iterable
            ? (json[r'tags'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        wouldRecommend: mapValueOfType<bool>(json, r'wouldRecommend')!,
      );
    }
    return null;
  }

  static List<CreateSpecialistReviewDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateSpecialistReviewDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateSpecialistReviewDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateSpecialistReviewDto> mapFromJson(dynamic json) {
    final map = <String, CreateSpecialistReviewDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateSpecialistReviewDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateSpecialistReviewDto-objects as value to a dart map
  static Map<String, List<CreateSpecialistReviewDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateSpecialistReviewDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateSpecialistReviewDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'appointmentId',
    'specialistId',
    'rating',
    'wouldRecommend',
  };
}

