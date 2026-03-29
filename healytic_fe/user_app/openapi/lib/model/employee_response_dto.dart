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
    this.firstName,
    this.lastName,
    required this.fullName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.jobTitle,
    this.startDate,
    this.employmentType,
    this.description,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.verificationDocuments = const [],
    this.schedule = const [],
    this.workHistory = const [],
    this.dob,
    this.gender,
    required this.role,
    required this.status,
    required this.rating,
    required this.reviewCount,
    this.partnerId,
    required this.createdAt,
    required this.updatedAt,
    this.doctorProfile,
    this.therapistProfile,
  });

  /// Unique employee identifier
  String id;

  /// Employee code
  String employeeCode;

  /// First name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? firstName;

  /// Last name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? lastName;

  /// Full name
  String fullName;

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

  /// Emergency contact name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? emergencyContactName;

  /// Emergency contact phone
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? emergencyContactPhone;

  /// Verification documents
  List<VerificationDocumentEntryDto> verificationDocuments;

  /// Work schedule
  List<WorkScheduleEntryDto> schedule;

  /// Work history
  List<WorkHistoryEntryDto> workHistory;

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

  /// Partner ID the employee belongs to
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? partnerId;

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
  DoctorProfileResponseDto? doctorProfile;

  /// Therapist profile
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TherapistProfileResponseDto? therapistProfile;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmployeeResponseDto &&
    other.id == id &&
    other.employeeCode == employeeCode &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.fullName == fullName &&
    other.email == email &&
    other.phone == phone &&
    other.avatarUrl == avatarUrl &&
    other.jobTitle == jobTitle &&
    other.startDate == startDate &&
    other.employmentType == employmentType &&
    other.description == description &&
    other.emergencyContactName == emergencyContactName &&
    other.emergencyContactPhone == emergencyContactPhone &&
    _deepEquality.equals(other.verificationDocuments, verificationDocuments) &&
    _deepEquality.equals(other.schedule, schedule) &&
    _deepEquality.equals(other.workHistory, workHistory) &&
    other.dob == dob &&
    other.gender == gender &&
    other.role == role &&
    other.status == status &&
    other.rating == rating &&
    other.reviewCount == reviewCount &&
    other.partnerId == partnerId &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt &&
    other.doctorProfile == doctorProfile &&
    other.therapistProfile == therapistProfile;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (employeeCode.hashCode) +
    (firstName == null ? 0 : firstName!.hashCode) +
    (lastName == null ? 0 : lastName!.hashCode) +
    (fullName.hashCode) +
    (email.hashCode) +
    (phone == null ? 0 : phone!.hashCode) +
    (avatarUrl == null ? 0 : avatarUrl!.hashCode) +
    (jobTitle == null ? 0 : jobTitle!.hashCode) +
    (startDate == null ? 0 : startDate!.hashCode) +
    (employmentType == null ? 0 : employmentType!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (emergencyContactName == null ? 0 : emergencyContactName!.hashCode) +
    (emergencyContactPhone == null ? 0 : emergencyContactPhone!.hashCode) +
    (verificationDocuments.hashCode) +
    (schedule.hashCode) +
    (workHistory.hashCode) +
    (dob == null ? 0 : dob!.hashCode) +
    (gender == null ? 0 : gender!.hashCode) +
    (role.hashCode) +
    (status.hashCode) +
    (rating.hashCode) +
    (reviewCount.hashCode) +
    (partnerId == null ? 0 : partnerId!.hashCode) +
    (createdAt.hashCode) +
    (updatedAt.hashCode) +
    (doctorProfile == null ? 0 : doctorProfile!.hashCode) +
    (therapistProfile == null ? 0 : therapistProfile!.hashCode);

  @override
  String toString() => 'EmployeeResponseDto[id=$id, employeeCode=$employeeCode, firstName=$firstName, lastName=$lastName, fullName=$fullName, email=$email, phone=$phone, avatarUrl=$avatarUrl, jobTitle=$jobTitle, startDate=$startDate, employmentType=$employmentType, description=$description, emergencyContactName=$emergencyContactName, emergencyContactPhone=$emergencyContactPhone, verificationDocuments=$verificationDocuments, schedule=$schedule, workHistory=$workHistory, dob=$dob, gender=$gender, role=$role, status=$status, rating=$rating, reviewCount=$reviewCount, partnerId=$partnerId, createdAt=$createdAt, updatedAt=$updatedAt, doctorProfile=$doctorProfile, therapistProfile=$therapistProfile]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'employeeCode'] = this.employeeCode;
    if (this.firstName != null) {
      json[r'firstName'] = this.firstName;
    } else {
      json[r'firstName'] = null;
    }
    if (this.lastName != null) {
      json[r'lastName'] = this.lastName;
    } else {
      json[r'lastName'] = null;
    }
      json[r'fullName'] = this.fullName;
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
    if (this.emergencyContactName != null) {
      json[r'emergencyContactName'] = this.emergencyContactName;
    } else {
      json[r'emergencyContactName'] = null;
    }
    if (this.emergencyContactPhone != null) {
      json[r'emergencyContactPhone'] = this.emergencyContactPhone;
    } else {
      json[r'emergencyContactPhone'] = null;
    }
      json[r'verificationDocuments'] = this.verificationDocuments;
      json[r'schedule'] = this.schedule;
      json[r'workHistory'] = this.workHistory;
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
    if (this.partnerId != null) {
      json[r'partnerId'] = this.partnerId;
    } else {
      json[r'partnerId'] = null;
    }
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
        firstName: mapValueOfType<Object>(json, r'firstName'),
        lastName: mapValueOfType<Object>(json, r'lastName'),
        fullName: mapValueOfType<String>(json, r'fullName')!,
        email: mapValueOfType<String>(json, r'email')!,
        phone: mapValueOfType<Object>(json, r'phone'),
        avatarUrl: mapValueOfType<Object>(json, r'avatarUrl'),
        jobTitle: mapValueOfType<Object>(json, r'jobTitle'),
        startDate: mapValueOfType<Object>(json, r'startDate'),
        employmentType: mapValueOfType<Object>(json, r'employmentType'),
        description: mapValueOfType<Object>(json, r'description'),
        emergencyContactName: mapValueOfType<Object>(json, r'emergencyContactName'),
        emergencyContactPhone: mapValueOfType<Object>(json, r'emergencyContactPhone'),
        verificationDocuments: VerificationDocumentEntryDto.listFromJson(json[r'verificationDocuments']),
        schedule: WorkScheduleEntryDto.listFromJson(json[r'schedule']),
        workHistory: WorkHistoryEntryDto.listFromJson(json[r'workHistory']),
        dob: mapValueOfType<Object>(json, r'dob'),
        gender: EmployeeResponseDtoGenderEnum.fromJson(json[r'gender']),
        role: EmployeeResponseDtoRoleEnum.fromJson(json[r'role'])!,
        status: EmployeeResponseDtoStatusEnum.fromJson(json[r'status'])!,
        rating: num.parse('${json[r'rating']}'),
        reviewCount: num.parse('${json[r'reviewCount']}'),
        partnerId: mapValueOfType<Object>(json, r'partnerId'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        updatedAt: mapDateTime(json, r'updatedAt', r'')!,
        doctorProfile: DoctorProfileResponseDto.fromJson(json[r'doctorProfile']),
        therapistProfile: TherapistProfileResponseDto.fromJson(json[r'therapistProfile']),
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


