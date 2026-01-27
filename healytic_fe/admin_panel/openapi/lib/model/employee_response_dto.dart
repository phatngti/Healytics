//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmployeeResponseDto {
  /// Returns a new [EmployeeResponseDto] instance.
  EmployeeResponseDto({
    required this.id,
    required this.employeeCode,
    required this.fullName,
    this.displayName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.jobTitle,
    this.startDate,
    this.employmentType,
    this.description,
    this.dob,
    this.gender,
    required this.role,
    required this.status,
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
    this.doctorProfile,
    this.therapistProfile,
  });

  /// Unique employee identifier
  String id;

  /// Employee code
  String employeeCode;

  /// Full name
  String fullName;

  /// Display name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? displayName;

  /// Email address
  String email;

  /// Phone number
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? phone;

  /// Avatar URL
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? avatarUrl;

  /// Job title
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? jobTitle;

  /// Start date
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? startDate;

  /// Employment type
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? employmentType;

  /// Description/bio
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? description;

  /// Date of birth
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? dob;

  /// Gender
  EmployeeResponseDtoGenderEnum? gender;

  /// Employee role
  EmployeeResponseDtoRoleEnum role;

  /// Employee status
  EmployeeResponseDtoStatusEnum status;

  /// Rating (0-5)
  num rating;

  /// Number of reviews
  num reviewCount;

  /// Creation timestamp
  DateTime createdAt;

  /// Last update timestamp
  DateTime updatedAt;

  /// Doctor profile
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DoctorProfileDto? doctorProfile;

  /// Therapist profile
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TherapistProfileDto? therapistProfile;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeResponseDto &&
    other.id == id &&
    other.employeeCode == employeeCode &&
    other.fullName == fullName &&
    other.displayName == displayName &&
    other.email == email &&
    other.phone == phone &&
    other.avatarUrl == avatarUrl &&
    other.jobTitle == jobTitle &&
    other.startDate == startDate &&
    other.employmentType == employmentType &&
    other.description == description &&
    other.dob == dob &&
    other.gender == gender &&
    other.role == role &&
    other.status == status &&
    other.rating == rating &&
    other.reviewCount == reviewCount &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt &&
    other.doctorProfile == doctorProfile &&
    other.therapistProfile == therapistProfile;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (employeeCode.hashCode) +
    (fullName.hashCode) +
    (displayName == null ? 0 : displayName!.hashCode) +
    (email.hashCode) +
    (phone == null ? 0 : phone!.hashCode) +
    (avatarUrl == null ? 0 : avatarUrl!.hashCode) +
    (jobTitle == null ? 0 : jobTitle!.hashCode) +
    (startDate == null ? 0 : startDate!.hashCode) +
    (employmentType == null ? 0 : employmentType!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (dob == null ? 0 : dob!.hashCode) +
    (gender == null ? 0 : gender!.hashCode) +
    (role.hashCode) +
    (status.hashCode) +
    (rating.hashCode) +
    (reviewCount.hashCode) +
    (createdAt.hashCode) +
    (updatedAt.hashCode) +
    (doctorProfile == null ? 0 : doctorProfile!.hashCode) +
    (therapistProfile == null ? 0 : therapistProfile!.hashCode);

  @override
  String toString() => 'EmployeeResponseDto[id=$id, employeeCode=$employeeCode, fullName=$fullName, displayName=$displayName, email=$email, phone=$phone, avatarUrl=$avatarUrl, jobTitle=$jobTitle, startDate=$startDate, employmentType=$employmentType, description=$description, dob=$dob, gender=$gender, role=$role, status=$status, rating=$rating, reviewCount=$reviewCount, createdAt=$createdAt, updatedAt=$updatedAt, doctorProfile=$doctorProfile, therapistProfile=$therapistProfile]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
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
    if (this.jobTitle != null) {
      json[r'jobTitle'] = this.jobTitle;
    } else {
      json[r'jobTitle'] = null;
    }
    if (this.startDate != null) {
      json[r'startDate'] = this.startDate;
    } else {
      json[r'startDate'] = null;
    }
    if (this.employmentType != null) {
      json[r'employmentType'] = this.employmentType;
    } else {
      json[r'employmentType'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
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
      json[r'role'] = this.role;
      json[r'status'] = this.status;
      json[r'rating'] = this.rating;
      json[r'reviewCount'] = this.reviewCount;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'updatedAt'] = this.updatedAt.toUtc().toIso8601String();
    if (this.doctorProfile != null) {
      json[r'doctorProfile'] = this.doctorProfile;
    } else {
      json[r'doctorProfile'] = null;
    }
    if (this.therapistProfile != null) {
      json[r'therapistProfile'] = this.therapistProfile;
    } else {
      json[r'therapistProfile'] = null;
    }
    return json;
  }

  /// Returns a new [EmployeeResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmployeeResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmployeeResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmployeeResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmployeeResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        employeeCode: mapValueOfType<String>(json, r'employeeCode')!,
        fullName: mapValueOfType<String>(json, r'fullName')!,
        displayName: mapValueOfType<Object>(json, r'displayName'),
        email: mapValueOfType<String>(json, r'email')!,
        phone: mapValueOfType<Object>(json, r'phone'),
        avatarUrl: mapValueOfType<Object>(json, r'avatarUrl'),
        jobTitle: mapValueOfType<Object>(json, r'jobTitle'),
        startDate: mapValueOfType<Object>(json, r'startDate'),
        employmentType: mapValueOfType<Object>(json, r'employmentType'),
        description: mapValueOfType<Object>(json, r'description'),
        dob: mapValueOfType<Object>(json, r'dob'),
        gender: EmployeeResponseDtoGenderEnum.fromJson(json[r'gender']),
        role: EmployeeResponseDtoRoleEnum.fromJson(json[r'role'])!,
        status: EmployeeResponseDtoStatusEnum.fromJson(json[r'status'])!,
        rating: num.parse('${json[r'rating']}'),
        reviewCount: num.parse('${json[r'reviewCount']}'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        updatedAt: mapDateTime(json, r'updatedAt', r'')!,
        doctorProfile: DoctorProfileDto.fromJson(json[r'doctorProfile']),
        therapistProfile: TherapistProfileDto.fromJson(json[r'therapistProfile']),
      );
    }
    return null;
  }

  static List<EmployeeResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmployeeResponseDto> mapFromJson(dynamic json) {
    final map = <String, EmployeeResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmployeeResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmployeeResponseDto-objects as value to a dart map
  static Map<String, List<EmployeeResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmployeeResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmployeeResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'employeeCode',
    'fullName',
    'email',
    'role',
    'status',
    'rating',
    'reviewCount',
    'createdAt',
    'updatedAt',
  };
}

/// Gender
class EmployeeResponseDtoGenderEnum {
  /// Instantiate a new enum with the provided [value].
  const EmployeeResponseDtoGenderEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MALE = EmployeeResponseDtoGenderEnum._(r'MALE');
  static const FEMALE = EmployeeResponseDtoGenderEnum._(r'FEMALE');
  static const OTHER = EmployeeResponseDtoGenderEnum._(r'OTHER');

  /// List of all possible values in this [enum][EmployeeResponseDtoGenderEnum].
  static const values = <EmployeeResponseDtoGenderEnum>[
    MALE,
    FEMALE,
    OTHER,
  ];

  static EmployeeResponseDtoGenderEnum? fromJson(dynamic value) => EmployeeResponseDtoGenderEnumTypeTransformer().decode(value);

  static List<EmployeeResponseDtoGenderEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeResponseDtoGenderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeResponseDtoGenderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [EmployeeResponseDtoGenderEnum] to String,
/// and [decode] dynamic data back to [EmployeeResponseDtoGenderEnum].
class EmployeeResponseDtoGenderEnumTypeTransformer {
  factory EmployeeResponseDtoGenderEnumTypeTransformer() => _instance ??= const EmployeeResponseDtoGenderEnumTypeTransformer._();

  const EmployeeResponseDtoGenderEnumTypeTransformer._();

  String encode(EmployeeResponseDtoGenderEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a EmployeeResponseDtoGenderEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  EmployeeResponseDtoGenderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MALE': return EmployeeResponseDtoGenderEnum.MALE;
        case r'FEMALE': return EmployeeResponseDtoGenderEnum.FEMALE;
        case r'OTHER': return EmployeeResponseDtoGenderEnum.OTHER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [EmployeeResponseDtoGenderEnumTypeTransformer] instance.
  static EmployeeResponseDtoGenderEnumTypeTransformer? _instance;
}


/// Employee role
class EmployeeResponseDtoRoleEnum {
  /// Instantiate a new enum with the provided [value].
  const EmployeeResponseDtoRoleEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const DOCTOR = EmployeeResponseDtoRoleEnum._(r'DOCTOR');
  static const THERAPIST = EmployeeResponseDtoRoleEnum._(r'THERAPIST');
  static const RECEPTIONIST = EmployeeResponseDtoRoleEnum._(r'RECEPTIONIST');
  static const MANAGER = EmployeeResponseDtoRoleEnum._(r'MANAGER');

  /// List of all possible values in this [enum][EmployeeResponseDtoRoleEnum].
  static const values = <EmployeeResponseDtoRoleEnum>[
    DOCTOR,
    THERAPIST,
    RECEPTIONIST,
    MANAGER,
  ];

  static EmployeeResponseDtoRoleEnum? fromJson(dynamic value) => EmployeeResponseDtoRoleEnumTypeTransformer().decode(value);

  static List<EmployeeResponseDtoRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeResponseDtoRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeResponseDtoRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [EmployeeResponseDtoRoleEnum] to String,
/// and [decode] dynamic data back to [EmployeeResponseDtoRoleEnum].
class EmployeeResponseDtoRoleEnumTypeTransformer {
  factory EmployeeResponseDtoRoleEnumTypeTransformer() => _instance ??= const EmployeeResponseDtoRoleEnumTypeTransformer._();

  const EmployeeResponseDtoRoleEnumTypeTransformer._();

  String encode(EmployeeResponseDtoRoleEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a EmployeeResponseDtoRoleEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  EmployeeResponseDtoRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'DOCTOR': return EmployeeResponseDtoRoleEnum.DOCTOR;
        case r'THERAPIST': return EmployeeResponseDtoRoleEnum.THERAPIST;
        case r'RECEPTIONIST': return EmployeeResponseDtoRoleEnum.RECEPTIONIST;
        case r'MANAGER': return EmployeeResponseDtoRoleEnum.MANAGER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [EmployeeResponseDtoRoleEnumTypeTransformer] instance.
  static EmployeeResponseDtoRoleEnumTypeTransformer? _instance;
}


/// Employee status
class EmployeeResponseDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const EmployeeResponseDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const ACTIVE = EmployeeResponseDtoStatusEnum._(r'ACTIVE');
  static const INACTIVE = EmployeeResponseDtoStatusEnum._(r'INACTIVE');
  static const ON_LEAVE = EmployeeResponseDtoStatusEnum._(r'ON_LEAVE');

  /// List of all possible values in this [enum][EmployeeResponseDtoStatusEnum].
  static const values = <EmployeeResponseDtoStatusEnum>[
    ACTIVE,
    INACTIVE,
    ON_LEAVE,
  ];

  static EmployeeResponseDtoStatusEnum? fromJson(dynamic value) => EmployeeResponseDtoStatusEnumTypeTransformer().decode(value);

  static List<EmployeeResponseDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeResponseDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeResponseDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [EmployeeResponseDtoStatusEnum] to String,
/// and [decode] dynamic data back to [EmployeeResponseDtoStatusEnum].
class EmployeeResponseDtoStatusEnumTypeTransformer {
  factory EmployeeResponseDtoStatusEnumTypeTransformer() => _instance ??= const EmployeeResponseDtoStatusEnumTypeTransformer._();

  const EmployeeResponseDtoStatusEnumTypeTransformer._();

  String encode(EmployeeResponseDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a EmployeeResponseDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  EmployeeResponseDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'ACTIVE': return EmployeeResponseDtoStatusEnum.ACTIVE;
        case r'INACTIVE': return EmployeeResponseDtoStatusEnum.INACTIVE;
        case r'ON_LEAVE': return EmployeeResponseDtoStatusEnum.ON_LEAVE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [EmployeeResponseDtoStatusEnumTypeTransformer] instance.
  static EmployeeResponseDtoStatusEnumTypeTransformer? _instance;
}


