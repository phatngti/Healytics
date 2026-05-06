//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class VerifiedField {
  /// Returns a new [VerifiedField] instance.
  VerifiedField({
    required this.fieldKey,
    required this.value,
    required this.isVerified,
    this.feedback,
  });


  String fieldKey;

  Object value;

  bool isVerified;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? feedback;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VerifiedField &&
    other.fieldKey == fieldKey &&
    other.value == value &&
    other.isVerified == isVerified &&
    other.feedback == feedback;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fieldKey.hashCode) +
    (value.hashCode) +
    (isVerified.hashCode) +
    (feedback == null ? 0 : feedback!.hashCode);

  @override
  String toString() => 'VerifiedField[fieldKey=$fieldKey, value=$value, isVerified=$isVerified, feedback=$feedback]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fieldKey'] = this.fieldKey;
      json[r'value'] = this.value;
      json[r'isVerified'] = this.isVerified;
    if (this.feedback != null) {
      json[r'feedback'] = this.feedback;
    } else {
      json[r'feedback'] = null;
    }
    return json;
  }

  /// Returns a new [VerifiedField] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VerifiedField? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "VerifiedField[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "VerifiedField[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return VerifiedField(
        fieldKey: mapValueOfType<String>(json, r'fieldKey')!,
        value: mapValueOfType<Object>(json, r'value')!,
        isVerified: mapValueOfType<bool>(json, r'isVerified')!,
        feedback: mapValueOfType<String>(json, r'feedback'),
      );
    }
    return null;
  }

  static List<VerifiedField> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VerifiedField>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VerifiedField.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VerifiedField> mapFromJson(dynamic json) {
    final map = <String, VerifiedField>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VerifiedField.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VerifiedField-objects as value to a dart map
  static Map<String, List<VerifiedField>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VerifiedField>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VerifiedField.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fieldKey',
    'value',
    'isVerified',
  };
}

