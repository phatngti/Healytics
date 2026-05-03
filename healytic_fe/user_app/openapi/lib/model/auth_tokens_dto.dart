//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AuthTokensDto {
  /// Returns a new [AuthTokensDto] instance.
  AuthTokensDto({
    required this.accessToken,
    required this.refreshToken,
    required this.accessExpiresIn,
    required this.refreshExpiresIn,
  });


  String accessToken;

  String refreshToken;

  /// Access token TTL as configured
  String accessExpiresIn;

  /// Refresh token TTL as configured
  String refreshExpiresIn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AuthTokensDto &&
    other.accessToken == accessToken &&
    other.refreshToken == refreshToken &&
    other.accessExpiresIn == accessExpiresIn &&
    other.refreshExpiresIn == refreshExpiresIn;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (accessToken.hashCode) +
    (refreshToken.hashCode) +
    (accessExpiresIn.hashCode) +
    (refreshExpiresIn.hashCode);

  @override
  String toString() => 'AuthTokensDto[accessToken=$accessToken, refreshToken=$refreshToken, accessExpiresIn=$accessExpiresIn, refreshExpiresIn=$refreshExpiresIn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'access_token'] = this.accessToken;
      json[r'refresh_token'] = this.refreshToken;
      json[r'access_expires_in'] = this.accessExpiresIn;
      json[r'refresh_expires_in'] = this.refreshExpiresIn;
    return json;
  }

  /// Returns a new [AuthTokensDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AuthTokensDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AuthTokensDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AuthTokensDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AuthTokensDto(
        accessToken: mapValueOfType<String>(json, r'access_token')!,
        refreshToken: mapValueOfType<String>(json, r'refresh_token')!,
        accessExpiresIn: mapValueOfType<String>(json, r'access_expires_in')!,
        refreshExpiresIn: mapValueOfType<String>(json, r'refresh_expires_in')!,
      );
    }
    return null;
  }

  static List<AuthTokensDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AuthTokensDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AuthTokensDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AuthTokensDto> mapFromJson(dynamic json) {
    final map = <String, AuthTokensDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AuthTokensDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AuthTokensDto-objects as value to a dart map
  static Map<String, List<AuthTokensDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AuthTokensDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AuthTokensDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'access_token',
    'refresh_token',
    'access_expires_in',
    'refresh_expires_in',
  };
}

