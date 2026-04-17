//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RegisterDeviceDto {
  /// Returns a new [RegisterDeviceDto] instance.
  RegisterDeviceDto({
    required this.token,
    required this.platform,
  });


  /// FCM or APNs device token
  String token;

  /// Device platform
  RegisterDeviceDtoPlatformEnum platform;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RegisterDeviceDto &&
    other.token == token &&
    other.platform == platform;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (token.hashCode) +
    (platform.hashCode);

  @override
  String toString() => 'RegisterDeviceDto[token=$token, platform=$platform]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'token'] = this.token;
      json[r'platform'] = this.platform;
    return json;
  }

  /// Returns a new [RegisterDeviceDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RegisterDeviceDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RegisterDeviceDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RegisterDeviceDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RegisterDeviceDto(
        token: mapValueOfType<String>(json, r'token')!,
        platform: RegisterDeviceDtoPlatformEnum.fromJson(json[r'platform'])!,
      );
    }
    return null;
  }

  static List<RegisterDeviceDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RegisterDeviceDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RegisterDeviceDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RegisterDeviceDto> mapFromJson(dynamic json) {
    final map = <String, RegisterDeviceDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RegisterDeviceDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RegisterDeviceDto-objects as value to a dart map
  static Map<String, List<RegisterDeviceDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RegisterDeviceDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RegisterDeviceDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'token',
    'platform',
  };
}

/// Device platform
class RegisterDeviceDtoPlatformEnum {
  /// Instantiate a new enum with the provided [value].
  const RegisterDeviceDtoPlatformEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const ios = RegisterDeviceDtoPlatformEnum._(r'ios');
  static const android = RegisterDeviceDtoPlatformEnum._(r'android');

  /// List of all possible values in this [enum][RegisterDeviceDtoPlatformEnum].
  static const values = <RegisterDeviceDtoPlatformEnum>[
    ios,
    android,
  ];

  static RegisterDeviceDtoPlatformEnum? fromJson(dynamic value) => RegisterDeviceDtoPlatformEnumTypeTransformer().decode(value);

  static List<RegisterDeviceDtoPlatformEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RegisterDeviceDtoPlatformEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RegisterDeviceDtoPlatformEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RegisterDeviceDtoPlatformEnum] to String,
/// and [decode] dynamic data back to [RegisterDeviceDtoPlatformEnum].
class RegisterDeviceDtoPlatformEnumTypeTransformer {
  factory RegisterDeviceDtoPlatformEnumTypeTransformer() => _instance ??= const RegisterDeviceDtoPlatformEnumTypeTransformer._();

  const RegisterDeviceDtoPlatformEnumTypeTransformer._();

  String encode(RegisterDeviceDtoPlatformEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a RegisterDeviceDtoPlatformEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RegisterDeviceDtoPlatformEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'ios': return RegisterDeviceDtoPlatformEnum.ios;
        case r'android': return RegisterDeviceDtoPlatformEnum.android;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [RegisterDeviceDtoPlatformEnumTypeTransformer] instance.
  static RegisterDeviceDtoPlatformEnumTypeTransformer? _instance;
}


