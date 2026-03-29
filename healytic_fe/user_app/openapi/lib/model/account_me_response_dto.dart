//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AccountMeResponseDto {
  /// Returns a new [AccountMeResponseDto] instance.
  AccountMeResponseDto({
    required this.id,
    required this.email,
    this.username,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.userProfile,
  });

  /// Account ID
  String id;

  /// Email address
  String email;

  /// Username
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? username;

  /// Account role
  AccountMeResponseDtoRoleEnum role;

  /// Whether the account is active
  bool isActive;

  /// Account creation date
  DateTime createdAt;

  /// Last update date
  DateTime updatedAt;

  /// User profile data
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserProfileDto? userProfile;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AccountMeResponseDto &&
    other.id == id &&
    other.email == email &&
    other.username == username &&
    other.role == role &&
    other.isActive == isActive &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt &&
    other.userProfile == userProfile;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (email.hashCode) +
    (username == null ? 0 : username!.hashCode) +
    (role.hashCode) +
    (isActive.hashCode) +
    (createdAt.hashCode) +
    (updatedAt.hashCode) +
    (userProfile == null ? 0 : userProfile!.hashCode);

  @override
  String toString() => 'AccountMeResponseDto[id=$id, email=$email, username=$username, role=$role, isActive=$isActive, createdAt=$createdAt, updatedAt=$updatedAt, userProfile=$userProfile]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'email'] = this.email;
    if (this.username != null) {
      json[r'username'] = this.username;
    } else {
      json[r'username'] = null;
    }
      json[r'role'] = this.role;
      json[r'isActive'] = this.isActive;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'updatedAt'] = this.updatedAt.toUtc().toIso8601String();
    if (this.userProfile != null) {
      json[r'userProfile'] = this.userProfile;
    } else {
      json[r'userProfile'] = null;
    }
    return json;
  }

  /// Returns a new [AccountMeResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AccountMeResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AccountMeResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AccountMeResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AccountMeResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        email: mapValueOfType<String>(json, r'email')!,
        username: mapValueOfType<String>(json, r'username'),
        role: AccountMeResponseDtoRoleEnum.fromJson(json[r'role'])!,
        isActive: mapValueOfType<bool>(json, r'isActive')!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        updatedAt: mapDateTime(json, r'updatedAt', r'')!,
        userProfile: UserProfileDto.fromJson(json[r'userProfile']),
      );
    }
    return null;
  }

  static List<AccountMeResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AccountMeResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AccountMeResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AccountMeResponseDto> mapFromJson(dynamic json) {
    final map = <String, AccountMeResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AccountMeResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AccountMeResponseDto-objects as value to a dart map
  static Map<String, List<AccountMeResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AccountMeResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AccountMeResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'email',
    'role',
    'isActive',
    'createdAt',
    'updatedAt',
  };
}

/// Account role
class AccountMeResponseDtoRoleEnum {
  /// Instantiate a new enum with the provided [value].
  const AccountMeResponseDtoRoleEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const user = AccountMeResponseDtoRoleEnum._(r'user');
  static const employee = AccountMeResponseDtoRoleEnum._(r'employee');
  static const healthPartner = AccountMeResponseDtoRoleEnum._(r'health_partner');
  static const admin = AccountMeResponseDtoRoleEnum._(r'admin');

  /// List of all possible values in this [enum][AccountMeResponseDtoRoleEnum].
  static const values = <AccountMeResponseDtoRoleEnum>[
    user,
    employee,
    healthPartner,
    admin,
  ];

  static AccountMeResponseDtoRoleEnum? fromJson(dynamic value) => AccountMeResponseDtoRoleEnumTypeTransformer().decode(value);

  static List<AccountMeResponseDtoRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AccountMeResponseDtoRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AccountMeResponseDtoRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AccountMeResponseDtoRoleEnum] to String,
/// and [decode] dynamic data back to [AccountMeResponseDtoRoleEnum].
class AccountMeResponseDtoRoleEnumTypeTransformer {
  factory AccountMeResponseDtoRoleEnumTypeTransformer() => _instance ??= const AccountMeResponseDtoRoleEnumTypeTransformer._();

  const AccountMeResponseDtoRoleEnumTypeTransformer._();

  String encode(AccountMeResponseDtoRoleEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a AccountMeResponseDtoRoleEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AccountMeResponseDtoRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'user': return AccountMeResponseDtoRoleEnum.user;
        case r'employee': return AccountMeResponseDtoRoleEnum.employee;
        case r'health_partner': return AccountMeResponseDtoRoleEnum.healthPartner;
        case r'admin': return AccountMeResponseDtoRoleEnum.admin;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AccountMeResponseDtoRoleEnumTypeTransformer] instance.
  static AccountMeResponseDtoRoleEnumTypeTransformer? _instance;
}


