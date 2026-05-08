//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FlagReviewDto {
  /// Returns a new [FlagReviewDto] instance.
  FlagReviewDto({
    required this.flaggedForReview,
    this.note,
  });


  /// Whether to flag the transaction for review
  bool flaggedForReview;

  /// Audit note
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? note;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FlagReviewDto &&
    other.flaggedForReview == flaggedForReview &&
    other.note == note;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (flaggedForReview.hashCode) +
    (note == null ? 0 : note!.hashCode);

  @override
  String toString() => 'FlagReviewDto[flaggedForReview=$flaggedForReview, note=$note]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'flaggedForReview'] = this.flaggedForReview;
    if (this.note != null) {
      json[r'note'] = this.note;
    } else {
      json[r'note'] = null;
    }
    return json;
  }

  /// Returns a new [FlagReviewDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FlagReviewDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "FlagReviewDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "FlagReviewDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FlagReviewDto(
        flaggedForReview: mapValueOfType<bool>(json, r'flaggedForReview')!,
        note: mapValueOfType<String>(json, r'note'),
      );
    }
    return null;
  }

  static List<FlagReviewDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FlagReviewDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FlagReviewDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FlagReviewDto> mapFromJson(dynamic json) {
    final map = <String, FlagReviewDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FlagReviewDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FlagReviewDto-objects as value to a dart map
  static Map<String, List<FlagReviewDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FlagReviewDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FlagReviewDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'flaggedForReview',
  };
}

