//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ForgotPasswordDto {
  /// Returns a new [ForgotPasswordDto] instance.
  ForgotPasswordDto({
    required this.email,
  });


  /// Email address for the account requesting password reset
  String email;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ForgotPasswordDto &&
    other.email == email;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (email.hashCode);

  @override
  String toString() => 'ForgotPasswordDto[email=$email]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'email'] = this.email;
    return json;
  }

  /// Returns a new [ForgotPasswordDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ForgotPasswordDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ForgotPasswordDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ForgotPasswordDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ForgotPasswordDto(
        email: mapValueOfType<String>(json, r'email')!,
      );
    }
    return null;
  }

  static List<ForgotPasswordDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ForgotPasswordDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ForgotPasswordDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ForgotPasswordDto> mapFromJson(dynamic json) {
    final map = <String, ForgotPasswordDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ForgotPasswordDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ForgotPasswordDto-objects as value to a dart map
  static Map<String, List<ForgotPasswordDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ForgotPasswordDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ForgotPasswordDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'email',
  };
}

