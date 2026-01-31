//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RegisterPartnerResponseDto {
  /// Returns a new [RegisterPartnerResponseDto] instance.
  RegisterPartnerResponseDto({
    required this.accountId,
    required this.businessEntityId,
    required this.status,
    required this.message,
    required this.accessToken,
    required this.accessExpiresIn,
    required this.refreshToken,
    required this.refreshExpiresIn,
  });

  /// ID of the created partner account
  String accountId;

  /// ID of the created business entity
  String businessEntityId;

  /// Registration status
  String status;

  /// Message
  String message;

  /// JWT access token for immediate authentication
  String accessToken;

  /// Access token expiration time
  String accessExpiresIn;

  /// JWT refresh token for obtaining new access tokens
  String refreshToken;

  /// Refresh token expiration time
  String refreshExpiresIn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RegisterPartnerResponseDto &&
    other.accountId == accountId &&
    other.businessEntityId == businessEntityId &&
    other.status == status &&
    other.message == message &&
    other.accessToken == accessToken &&
    other.accessExpiresIn == accessExpiresIn &&
    other.refreshToken == refreshToken &&
    other.refreshExpiresIn == refreshExpiresIn;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (accountId.hashCode) +
    (businessEntityId.hashCode) +
    (status.hashCode) +
    (message.hashCode) +
    (accessToken.hashCode) +
    (accessExpiresIn.hashCode) +
    (refreshToken.hashCode) +
    (refreshExpiresIn.hashCode);

  @override
  String toString() => 'RegisterPartnerResponseDto[accountId=$accountId, businessEntityId=$businessEntityId, status=$status, message=$message, accessToken=$accessToken, accessExpiresIn=$accessExpiresIn, refreshToken=$refreshToken, refreshExpiresIn=$refreshExpiresIn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'accountId'] = this.accountId;
      json[r'businessEntityId'] = this.businessEntityId;
      json[r'status'] = this.status;
      json[r'message'] = this.message;
      json[r'access_token'] = this.accessToken;
      json[r'access_expires_in'] = this.accessExpiresIn;
      json[r'refresh_token'] = this.refreshToken;
      json[r'refresh_expires_in'] = this.refreshExpiresIn;
    return json;
  }

  /// Returns a new [RegisterPartnerResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RegisterPartnerResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RegisterPartnerResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RegisterPartnerResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RegisterPartnerResponseDto(
        accountId: mapValueOfType<String>(json, r'accountId')!,
        businessEntityId: mapValueOfType<String>(json, r'businessEntityId')!,
        status: mapValueOfType<String>(json, r'status')!,
        message: mapValueOfType<String>(json, r'message')!,
        accessToken: mapValueOfType<String>(json, r'access_token')!,
        accessExpiresIn: mapValueOfType<String>(json, r'access_expires_in')!,
        refreshToken: mapValueOfType<String>(json, r'refresh_token')!,
        refreshExpiresIn: mapValueOfType<String>(json, r'refresh_expires_in')!,
      );
    }
    return null;
  }

  static List<RegisterPartnerResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RegisterPartnerResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RegisterPartnerResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RegisterPartnerResponseDto> mapFromJson(dynamic json) {
    final map = <String, RegisterPartnerResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RegisterPartnerResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RegisterPartnerResponseDto-objects as value to a dart map
  static Map<String, List<RegisterPartnerResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RegisterPartnerResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RegisterPartnerResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'accountId',
    'businessEntityId',
    'status',
    'message',
    'access_token',
    'access_expires_in',
    'refresh_token',
    'refresh_expires_in',
  };
}

