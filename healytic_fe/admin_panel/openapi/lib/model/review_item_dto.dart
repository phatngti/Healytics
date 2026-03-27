//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReviewItemDto {
  /// Returns a new [ReviewItemDto] instance.
  ReviewItemDto({
    this.fieldKey,
    this.feedback,
  });

  /// Key of the field being reviewed
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? fieldKey;

  /// Reason for rejection or feedback
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? feedback;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReviewItemDto &&
    other.fieldKey == fieldKey &&
    other.feedback == feedback;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fieldKey == null ? 0 : fieldKey!.hashCode) +
    (feedback == null ? 0 : feedback!.hashCode);

  @override
  String toString() => 'ReviewItemDto[fieldKey=$fieldKey, feedback=$feedback]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.fieldKey != null) {
      json[r'fieldKey'] = this.fieldKey;
    } else {
      json[r'fieldKey'] = null;
    }
    if (this.feedback != null) {
      json[r'feedback'] = this.feedback;
    } else {
      json[r'feedback'] = null;
    }
    return json;
  }

  /// Returns a new [ReviewItemDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReviewItemDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ReviewItemDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ReviewItemDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ReviewItemDto(
        fieldKey: mapValueOfType<String>(json, r'fieldKey'),
        feedback: mapValueOfType<String>(json, r'feedback'),
      );
    }
    return null;
  }

  static List<ReviewItemDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReviewItemDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReviewItemDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReviewItemDto> mapFromJson(dynamic json) {
    final map = <String, ReviewItemDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReviewItemDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReviewItemDto-objects as value to a dart map
  static Map<String, List<ReviewItemDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReviewItemDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReviewItemDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

