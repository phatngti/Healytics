//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class VerificationOptionalStringFieldDto {
  /// Returns a new [VerificationOptionalStringFieldDto] instance.
  VerificationOptionalStringFieldDto({
    this.value,
    this.displayValue,
    required this.requiresUpdate,
    this.adminFeedback,
    this.isVerified,
  });

  Object? value;

  Object? displayValue;

  bool requiresUpdate;

  Object? adminFeedback;

  /// Whether this field was verified by admin (from partner_review_log)
  Object? isVerified;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VerificationOptionalStringFieldDto &&
    other.value == value &&
    other.displayValue == displayValue &&
    other.requiresUpdate == requiresUpdate &&
    other.adminFeedback == adminFeedback &&
    other.isVerified == isVerified;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (value == null ? 0 : value!.hashCode) +
    (displayValue == null ? 0 : displayValue!.hashCode) +
    (requiresUpdate.hashCode) +
    (adminFeedback == null ? 0 : adminFeedback!.hashCode) +
    (isVerified == null ? 0 : isVerified!.hashCode);

  @override
  String toString() => 'VerificationOptionalStringFieldDto[value=$value, displayValue=$displayValue, requiresUpdate=$requiresUpdate, adminFeedback=$adminFeedback, isVerified=$isVerified]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.value != null) {
      json[r'value'] = this.value;
    } else {
      json[r'value'] = null;
    }
    if (this.displayValue != null) {
      json[r'displayValue'] = this.displayValue;
    } else {
      json[r'displayValue'] = null;
    }
      json[r'requiresUpdate'] = this.requiresUpdate;
    if (this.adminFeedback != null) {
      json[r'adminFeedback'] = this.adminFeedback;
    } else {
      json[r'adminFeedback'] = null;
    }
    if (this.isVerified != null) {
      json[r'isVerified'] = this.isVerified;
    } else {
      json[r'isVerified'] = null;
    }
    return json;
  }

  /// Returns a new [VerificationOptionalStringFieldDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VerificationOptionalStringFieldDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "VerificationOptionalStringFieldDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "VerificationOptionalStringFieldDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return VerificationOptionalStringFieldDto(
        value: mapValueOfType<Object>(json, r'value'),
        displayValue: mapValueOfType<Object>(json, r'displayValue'),
        requiresUpdate: mapValueOfType<bool>(json, r'requiresUpdate')!,
        adminFeedback: mapValueOfType<Object>(json, r'adminFeedback'),
        isVerified: mapValueOfType<Object>(json, r'isVerified'),
      );
    }
    return null;
  }

  static List<VerificationOptionalStringFieldDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VerificationOptionalStringFieldDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VerificationOptionalStringFieldDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VerificationOptionalStringFieldDto> mapFromJson(dynamic json) {
    final map = <String, VerificationOptionalStringFieldDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VerificationOptionalStringFieldDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VerificationOptionalStringFieldDto-objects as value to a dart map
  static Map<String, List<VerificationOptionalStringFieldDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VerificationOptionalStringFieldDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VerificationOptionalStringFieldDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'requiresUpdate',
  };
}

