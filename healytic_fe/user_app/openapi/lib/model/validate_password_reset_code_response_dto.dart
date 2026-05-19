//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ValidatePasswordResetCodeResponseDto {
  /// Returns a new [ValidatePasswordResetCodeResponseDto] instance.
  ValidatePasswordResetCodeResponseDto({
    required this.message,
    required this.resetToken,
  });


  /// Human-readable status message
  String message;

  /// Short-lived token required by the final reset-password endpoint
  String resetToken;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ValidatePasswordResetCodeResponseDto &&
    other.message == message &&
    other.resetToken == resetToken;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (message.hashCode) +
    (resetToken.hashCode);

  @override
  String toString() => 'ValidatePasswordResetCodeResponseDto[message=$message, resetToken=$resetToken]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'message'] = this.message;
      json[r'resetToken'] = this.resetToken;
    return json;
  }

  /// Returns a new [ValidatePasswordResetCodeResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ValidatePasswordResetCodeResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ValidatePasswordResetCodeResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ValidatePasswordResetCodeResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ValidatePasswordResetCodeResponseDto(
        message: mapValueOfType<String>(json, r'message')!,
        resetToken: mapValueOfType<String>(json, r'resetToken')!,
      );
    }
    return null;
  }

  static List<ValidatePasswordResetCodeResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ValidatePasswordResetCodeResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ValidatePasswordResetCodeResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ValidatePasswordResetCodeResponseDto> mapFromJson(dynamic json) {
    final map = <String, ValidatePasswordResetCodeResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ValidatePasswordResetCodeResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ValidatePasswordResetCodeResponseDto-objects as value to a dart map
  static Map<String, List<ValidatePasswordResetCodeResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ValidatePasswordResetCodeResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ValidatePasswordResetCodeResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'message',
    'resetToken',
  };
}

