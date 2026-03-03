//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateDoctorDto {
  /// Returns a new [CreateDoctorDto] instance.
  CreateDoctorDto({
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
    this.partnerId,
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

  /// Full name of the doctor
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
  CreateDoctorDtoGenderEnum? gender;

  /// Status of the employee
  CreateDoctorDtoStatusEnum? status;

  /// Branch ID the employee belongs to
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? branchId;

  /// Partner ID the employee belongs to
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? partnerId;

  /// Doctor profile information
  DoctorProfileDto profile;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateDoctorDto &&
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
    other.partnerId == partnerId &&
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
    (partnerId == null ? 0 : partnerId!.hashCode) +
    (profile.hashCode);

  @override
  String toString() => 'CreateDoctorDto[authId=$authId, employeeCode=$employeeCode, fullName=$fullName, displayName=$displayName, email=$email, phone=$phone, avatarUrl=$avatarUrl, dob=$dob, gender=$gender, status=$status, branchId=$branchId, partnerId=$partnerId, profile=$profile]';

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
    if (this.partnerId != null) {
      json[r'partnerId'] = this.partnerId;
    } else {
      json[r'partnerId'] = null;
    }
      json[r'profile'] = this.profile;
    return json;
  }

  /// Returns a new [CreateDoctorDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateDoctorDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateDoctorDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateDoctorDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateDoctorDto(
        authId: mapValueOfType<String>(json, r'authId'),
        employeeCode: mapValueOfType<String>(json, r'employeeCode')!,
        fullName: mapValueOfType<String>(json, r'fullName')!,
        displayName: mapValueOfType<String>(json, r'displayName'),
        email: mapValueOfType<String>(json, r'email')!,
        phone: mapValueOfType<String>(json, r'phone'),
        avatarUrl: mapValueOfType<String>(json, r'avatarUrl'),
        dob: mapValueOfType<String>(json, r'dob'),
        gender: CreateDoctorDtoGenderEnum.fromJson(json[r'gender']),
        status: CreateDoctorDtoStatusEnum.fromJson(json[r'status']),
        branchId: mapValueOfType<String>(json, r'branchId'),
        partnerId: mapValueOfType<String>(json, r'partnerId'),
        profile: DoctorProfileDto.fromJson(json[r'profile'])!,
      );
    }
    return null;
  }

  static List<CreateDoctorDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateDoctorDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateDoctorDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateDoctorDto> mapFromJson(dynamic json) {
    final map = <String, CreateDoctorDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateDoctorDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateDoctorDto-objects as value to a dart map
  static Map<String, List<CreateDoctorDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateDoctorDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateDoctorDto.listFromJson(entry.value, growable: growable,);
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
class CreateDoctorDtoGenderEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateDoctorDtoGenderEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MALE = CreateDoctorDtoGenderEnum._(r'MALE');
  static const FEMALE = CreateDoctorDtoGenderEnum._(r'FEMALE');
  static const OTHER = CreateDoctorDtoGenderEnum._(r'OTHER');

  /// List of all possible values in this [enum][CreateDoctorDtoGenderEnum].
  static const values = <CreateDoctorDtoGenderEnum>[
    MALE,
    FEMALE,
    OTHER,
  ];

  static CreateDoctorDtoGenderEnum? fromJson(dynamic value) => CreateDoctorDtoGenderEnumTypeTransformer().decode(value);

  static List<CreateDoctorDtoGenderEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateDoctorDtoGenderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateDoctorDtoGenderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateDoctorDtoGenderEnum] to String,
/// and [decode] dynamic data back to [CreateDoctorDtoGenderEnum].
class CreateDoctorDtoGenderEnumTypeTransformer {
  factory CreateDoctorDtoGenderEnumTypeTransformer() => _instance ??= const CreateDoctorDtoGenderEnumTypeTransformer._();

  const CreateDoctorDtoGenderEnumTypeTransformer._();

  String encode(CreateDoctorDtoGenderEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateDoctorDtoGenderEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateDoctorDtoGenderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MALE': return CreateDoctorDtoGenderEnum.MALE;
        case r'FEMALE': return CreateDoctorDtoGenderEnum.FEMALE;
        case r'OTHER': return CreateDoctorDtoGenderEnum.OTHER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateDoctorDtoGenderEnumTypeTransformer] instance.
  static CreateDoctorDtoGenderEnumTypeTransformer? _instance;
}


/// Status of the employee
class CreateDoctorDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateDoctorDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const ACTIVE = CreateDoctorDtoStatusEnum._(r'ACTIVE');
  static const INACTIVE = CreateDoctorDtoStatusEnum._(r'INACTIVE');
  static const ON_LEAVE = CreateDoctorDtoStatusEnum._(r'ON_LEAVE');

  /// List of all possible values in this [enum][CreateDoctorDtoStatusEnum].
  static const values = <CreateDoctorDtoStatusEnum>[
    ACTIVE,
    INACTIVE,
    ON_LEAVE,
  ];

  static CreateDoctorDtoStatusEnum? fromJson(dynamic value) => CreateDoctorDtoStatusEnumTypeTransformer().decode(value);

  static List<CreateDoctorDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateDoctorDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateDoctorDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateDoctorDtoStatusEnum] to String,
/// and [decode] dynamic data back to [CreateDoctorDtoStatusEnum].
class CreateDoctorDtoStatusEnumTypeTransformer {
  factory CreateDoctorDtoStatusEnumTypeTransformer() => _instance ??= const CreateDoctorDtoStatusEnumTypeTransformer._();

  const CreateDoctorDtoStatusEnumTypeTransformer._();

  String encode(CreateDoctorDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateDoctorDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateDoctorDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'ACTIVE': return CreateDoctorDtoStatusEnum.ACTIVE;
        case r'INACTIVE': return CreateDoctorDtoStatusEnum.INACTIVE;
        case r'ON_LEAVE': return CreateDoctorDtoStatusEnum.ON_LEAVE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateDoctorDtoStatusEnumTypeTransformer] instance.
  static CreateDoctorDtoStatusEnumTypeTransformer? _instance;
}


