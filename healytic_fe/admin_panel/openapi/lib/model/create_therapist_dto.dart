//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateTherapistDto {
  /// Returns a new [CreateTherapistDto] instance.
  CreateTherapistDto({
    this.authId,
    required this.employeeCode,
    required this.fullName,
    this.displayName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.dob,
    this.gender,
    this.status,
    this.branchId,
    required this.profile,
  });

  /// Authentication ID from external provider
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? authId;

  /// Unique employee code
  String employeeCode;

  /// Full name of the therapist
  String fullName;

  /// Display name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? displayName;

  /// Email address
  String email;

  /// Phone number
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? phone;

  /// Avatar URL
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? avatarUrl;

  /// Date of birth
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? dob;

  /// Gender
  CreateTherapistDtoGenderEnum? gender;

  /// Status of the employee
  CreateTherapistDtoStatusEnum? status;

  /// Branch ID the employee belongs to
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? branchId;

  /// Therapist profile information
  TherapistProfileDto profile;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateTherapistDto &&
    other.authId == authId &&
    other.employeeCode == employeeCode &&
    other.fullName == fullName &&
    other.displayName == displayName &&
    other.email == email &&
    other.phone == phone &&
    other.avatarUrl == avatarUrl &&
    other.dob == dob &&
    other.gender == gender &&
    other.status == status &&
    other.branchId == branchId &&
    other.profile == profile;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (authId == null ? 0 : authId!.hashCode) +
    (employeeCode.hashCode) +
    (fullName.hashCode) +
    (displayName == null ? 0 : displayName!.hashCode) +
    (email.hashCode) +
    (phone == null ? 0 : phone!.hashCode) +
    (avatarUrl == null ? 0 : avatarUrl!.hashCode) +
    (dob == null ? 0 : dob!.hashCode) +
    (gender == null ? 0 : gender!.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (branchId == null ? 0 : branchId!.hashCode) +
    (profile.hashCode);

  @override
  String toString() => 'CreateTherapistDto[authId=$authId, employeeCode=$employeeCode, fullName=$fullName, displayName=$displayName, email=$email, phone=$phone, avatarUrl=$avatarUrl, dob=$dob, gender=$gender, status=$status, branchId=$branchId, profile=$profile]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.authId != null) {
      json[r'authId'] = this.authId;
    } else {
      json[r'authId'] = null;
    }
      json[r'employeeCode'] = this.employeeCode;
      json[r'fullName'] = this.fullName;
    if (this.displayName != null) {
      json[r'displayName'] = this.displayName;
    } else {
      json[r'displayName'] = null;
    }
      json[r'email'] = this.email;
    if (this.phone != null) {
      json[r'phone'] = this.phone;
    } else {
      json[r'phone'] = null;
    }
    if (this.avatarUrl != null) {
      json[r'avatarUrl'] = this.avatarUrl;
    } else {
      json[r'avatarUrl'] = null;
    }
    if (this.dob != null) {
      json[r'dob'] = this.dob;
    } else {
      json[r'dob'] = null;
    }
    if (this.gender != null) {
      json[r'gender'] = this.gender;
    } else {
      json[r'gender'] = null;
    }
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
    if (this.branchId != null) {
      json[r'branchId'] = this.branchId;
    } else {
      json[r'branchId'] = null;
    }
      json[r'profile'] = this.profile;
    return json;
  }

  /// Returns a new [CreateTherapistDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateTherapistDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateTherapistDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateTherapistDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateTherapistDto(
        authId: mapValueOfType<String>(json, r'authId'),
        employeeCode: mapValueOfType<String>(json, r'employeeCode')!,
        fullName: mapValueOfType<String>(json, r'fullName')!,
        displayName: mapValueOfType<String>(json, r'displayName'),
        email: mapValueOfType<String>(json, r'email')!,
        phone: mapValueOfType<String>(json, r'phone'),
        avatarUrl: mapValueOfType<String>(json, r'avatarUrl'),
        dob: mapValueOfType<String>(json, r'dob'),
        gender: CreateTherapistDtoGenderEnum.fromJson(json[r'gender']),
        status: CreateTherapistDtoStatusEnum.fromJson(json[r'status']),
        branchId: mapValueOfType<String>(json, r'branchId'),
        profile: TherapistProfileDto.fromJson(json[r'profile'])!,
      );
    }
    return null;
  }

  static List<CreateTherapistDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateTherapistDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateTherapistDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateTherapistDto> mapFromJson(dynamic json) {
    final map = <String, CreateTherapistDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateTherapistDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateTherapistDto-objects as value to a dart map
  static Map<String, List<CreateTherapistDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateTherapistDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateTherapistDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'employeeCode',
    'fullName',
    'email',
    'profile',
  };
}

/// Gender
class CreateTherapistDtoGenderEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateTherapistDtoGenderEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MALE = CreateTherapistDtoGenderEnum._(r'MALE');
  static const FEMALE = CreateTherapistDtoGenderEnum._(r'FEMALE');
  static const OTHER = CreateTherapistDtoGenderEnum._(r'OTHER');

  /// List of all possible values in this [enum][CreateTherapistDtoGenderEnum].
  static const values = <CreateTherapistDtoGenderEnum>[
    MALE,
    FEMALE,
    OTHER,
  ];

  static CreateTherapistDtoGenderEnum? fromJson(dynamic value) => CreateTherapistDtoGenderEnumTypeTransformer().decode(value);

  static List<CreateTherapistDtoGenderEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateTherapistDtoGenderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateTherapistDtoGenderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateTherapistDtoGenderEnum] to String,
/// and [decode] dynamic data back to [CreateTherapistDtoGenderEnum].
class CreateTherapistDtoGenderEnumTypeTransformer {
  factory CreateTherapistDtoGenderEnumTypeTransformer() => _instance ??= const CreateTherapistDtoGenderEnumTypeTransformer._();

  const CreateTherapistDtoGenderEnumTypeTransformer._();

  String encode(CreateTherapistDtoGenderEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateTherapistDtoGenderEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateTherapistDtoGenderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MALE': return CreateTherapistDtoGenderEnum.MALE;
        case r'FEMALE': return CreateTherapistDtoGenderEnum.FEMALE;
        case r'OTHER': return CreateTherapistDtoGenderEnum.OTHER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateTherapistDtoGenderEnumTypeTransformer] instance.
  static CreateTherapistDtoGenderEnumTypeTransformer? _instance;
}


/// Status of the employee
class CreateTherapistDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateTherapistDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const ACTIVE = CreateTherapistDtoStatusEnum._(r'ACTIVE');
  static const INACTIVE = CreateTherapistDtoStatusEnum._(r'INACTIVE');
  static const ON_LEAVE = CreateTherapistDtoStatusEnum._(r'ON_LEAVE');

  /// List of all possible values in this [enum][CreateTherapistDtoStatusEnum].
  static const values = <CreateTherapistDtoStatusEnum>[
    ACTIVE,
    INACTIVE,
    ON_LEAVE,
  ];

  static CreateTherapistDtoStatusEnum? fromJson(dynamic value) => CreateTherapistDtoStatusEnumTypeTransformer().decode(value);

  static List<CreateTherapistDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateTherapistDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateTherapistDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateTherapistDtoStatusEnum] to String,
/// and [decode] dynamic data back to [CreateTherapistDtoStatusEnum].
class CreateTherapistDtoStatusEnumTypeTransformer {
  factory CreateTherapistDtoStatusEnumTypeTransformer() => _instance ??= const CreateTherapistDtoStatusEnumTypeTransformer._();

  const CreateTherapistDtoStatusEnumTypeTransformer._();

  String encode(CreateTherapistDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateTherapistDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateTherapistDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'ACTIVE': return CreateTherapistDtoStatusEnum.ACTIVE;
        case r'INACTIVE': return CreateTherapistDtoStatusEnum.INACTIVE;
        case r'ON_LEAVE': return CreateTherapistDtoStatusEnum.ON_LEAVE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateTherapistDtoStatusEnumTypeTransformer] instance.
  static CreateTherapistDtoStatusEnumTypeTransformer? _instance;
}


