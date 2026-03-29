//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TreatmentReviewResponseDto {
  /// Returns a new [TreatmentReviewResponseDto] instance.
  TreatmentReviewResponseDto({
    required this.id,
    required this.appointmentId,
    required this.rating,
    this.comment,
    this.tags = const [],
    this.photoUrls = const [],
    required this.createdAt,
  });

  String id;

  String appointmentId;

  num rating;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? comment;

  List<String> tags;

  List<String> photoUrls;

  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TreatmentReviewResponseDto &&
    other.id == id &&
    other.appointmentId == appointmentId &&
    other.rating == rating &&
    other.comment == comment &&
    _deepEquality.equals(other.tags, tags) &&
    _deepEquality.equals(other.photoUrls, photoUrls) &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (appointmentId.hashCode) +
    (rating.hashCode) +
    (comment == null ? 0 : comment!.hashCode) +
    (tags.hashCode) +
    (photoUrls.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'TreatmentReviewResponseDto[id=$id, appointmentId=$appointmentId, rating=$rating, comment=$comment, tags=$tags, photoUrls=$photoUrls, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'appointmentId'] = this.appointmentId;
      json[r'rating'] = this.rating;
    if (this.comment != null) {
      json[r'comment'] = this.comment;
    } else {
      json[r'comment'] = null;
    }
      json[r'tags'] = this.tags;
      json[r'photoUrls'] = this.photoUrls;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [TreatmentReviewResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TreatmentReviewResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TreatmentReviewResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TreatmentReviewResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TreatmentReviewResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        appointmentId: mapValueOfType<String>(json, r'appointmentId')!,
        rating: num.parse('${json[r'rating']}'),
        comment: mapValueOfType<Object>(json, r'comment'),
        tags: json[r'tags'] is Iterable
            ? (json[r'tags'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        photoUrls: json[r'photoUrls'] is Iterable
            ? (json[r'photoUrls'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        createdAt: mapDateTime(json, r'createdAt', r'')!,
      );
    }
    return null;
  }

  static List<TreatmentReviewResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TreatmentReviewResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TreatmentReviewResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TreatmentReviewResponseDto> mapFromJson(dynamic json) {
    final map = <String, TreatmentReviewResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TreatmentReviewResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TreatmentReviewResponseDto-objects as value to a dart map
  static Map<String, List<TreatmentReviewResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TreatmentReviewResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TreatmentReviewResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'appointmentId',
    'rating',
    'tags',
    'photoUrls',
    'createdAt',
  };
}

