//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdateEmployeeDto {
  /// Returns a new [UpdateEmployeeDto] instance.
  UpdateEmployeeDto({
    this.authId,
    this.employeeCode,
    this.firstName,
    this.lastName,
    this.fullName,
    this.displayName,
    this.email,
    this.phone,
    this.avatarUrl,
    this.dob,
    this.gender,
    this.role,
    this.status,
    this.branchId,
    this.partnerId,
    this.jobTitle,
    this.startDate,
    this.employmentType,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.idCardUrl,
    this.description,
    this.password,
    this.schedule = const [],
    this.doctorProfile,
    this.therapistProfile,
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
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? employeeCode;

  /// First name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? firstName;

  /// Last name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? lastName;

  /// Full name of the employee
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? fullName;

  /// Display name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? displayName;

  /// Email address
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? email;

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
  UpdateEmployeeDtoGenderEnum? gender;

  /// Role of the employee
  UpdateEmployeeDtoRoleEnum? role;

  /// Status of the employee
  UpdateEmployeeDtoStatusEnum? status;

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

  /// Job title
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? jobTitle;

  /// Start date
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? startDate;

  /// Employment type
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? employmentType;

  /// Emergency contact name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? emergencyContactName;

  /// Emergency contact phone
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? emergencyContactPhone;

  /// ID card URL
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? idCardUrl;

  /// Bio / description
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  /// Account password
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? password;

  /// Weekly work schedule
  List<WorkScheduleEntryDto> schedule;

  /// Doctor profile data if role is DOCTOR
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CreateDoctorProfileDto? doctorProfile;

  /// Therapist profile data if role is THERAPIST
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CreateTherapistProfileDto? therapistProfile;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateEmployeeDto &&
    other.authId == authId &&
    other.employeeCode == employeeCode &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.fullName == fullName &&
    other.displayName == displayName &&
    other.email == email &&
    other.phone == phone &&
    other.avatarUrl == avatarUrl &&
    other.dob == dob &&
    other.gender == gender &&
    other.role == role &&
    other.status == status &&
    other.branchId == branchId &&
    other.partnerId == partnerId &&
    other.jobTitle == jobTitle &&
    other.startDate == startDate &&
    other.employmentType == employmentType &&
    other.emergencyContactName == emergencyContactName &&
    other.emergencyContactPhone == emergencyContactPhone &&
    other.idCardUrl == idCardUrl &&
    other.description == description &&
    other.password == password &&
    _deepEquality.equals(other.schedule, schedule) &&
    other.doctorProfile == doctorProfile &&
    other.therapistProfile == therapistProfile;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (authId == null ? 0 : authId!.hashCode) +
    (employeeCode == null ? 0 : employeeCode!.hashCode) +
    (firstName == null ? 0 : firstName!.hashCode) +
    (lastName == null ? 0 : lastName!.hashCode) +
    (fullName == null ? 0 : fullName!.hashCode) +
    (displayName == null ? 0 : displayName!.hashCode) +
    (email == null ? 0 : email!.hashCode) +
    (phone == null ? 0 : phone!.hashCode) +
    (avatarUrl == null ? 0 : avatarUrl!.hashCode) +
    (dob == null ? 0 : dob!.hashCode) +
    (gender == null ? 0 : gender!.hashCode) +
    (role == null ? 0 : role!.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (branchId == null ? 0 : branchId!.hashCode) +
    (partnerId == null ? 0 : partnerId!.hashCode) +
    (jobTitle == null ? 0 : jobTitle!.hashCode) +
    (startDate == null ? 0 : startDate!.hashCode) +
    (employmentType == null ? 0 : employmentType!.hashCode) +
    (emergencyContactName == null ? 0 : emergencyContactName!.hashCode) +
    (emergencyContactPhone == null ? 0 : emergencyContactPhone!.hashCode) +
    (idCardUrl == null ? 0 : idCardUrl!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (password == null ? 0 : password!.hashCode) +
    (schedule.hashCode) +
    (doctorProfile == null ? 0 : doctorProfile!.hashCode) +
    (therapistProfile == null ? 0 : therapistProfile!.hashCode);

  @override
  String toString() => 'UpdateEmployeeDto[authId=$authId, employeeCode=$employeeCode, firstName=$firstName, lastName=$lastName, fullName=$fullName, displayName=$displayName, email=$email, phone=$phone, avatarUrl=$avatarUrl, dob=$dob, gender=$gender, role=$role, status=$status, branchId=$branchId, partnerId=$partnerId, jobTitle=$jobTitle, startDate=$startDate, employmentType=$employmentType, emergencyContactName=$emergencyContactName, emergencyContactPhone=$emergencyContactPhone, idCardUrl=$idCardUrl, description=$description, password=$password, schedule=$schedule, doctorProfile=$doctorProfile, therapistProfile=$therapistProfile]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.authId != null) {
      json[r'authId'] = this.authId;
    } else {
      json[r'authId'] = null;
    }
    if (this.employeeCode != null) {
      json[r'employeeCode'] = this.employeeCode;
    } else {
      json[r'employeeCode'] = null;
    }
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
    if (this.fullName != null) {
      json[r'fullName'] = this.fullName;
    } else {
      json[r'fullName'] = null;
    }
    if (this.displayName != null) {
      json[r'displayName'] = this.displayName;
    } else {
      json[r'displayName'] = null;
    }
    if (this.email != null) {
      json[r'email'] = this.email;
    } else {
      json[r'email'] = null;
    }
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
    if (this.role != null) {
      json[r'role'] = this.role;
    } else {
      json[r'role'] = null;
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
    if (this.idCardUrl != null) {
      json[r'idCardUrl'] = this.idCardUrl;
    } else {
      json[r'idCardUrl'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.password != null) {
      json[r'password'] = this.password;
    } else {
      json[r'password'] = null;
    }
      json[r'schedule'] = this.schedule;
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

  /// Returns a new [UpdateEmployeeDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdateEmployeeDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdateEmployeeDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdateEmployeeDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdateEmployeeDto(
        authId: mapValueOfType<String>(json, r'authId'),
        employeeCode: mapValueOfType<String>(json, r'employeeCode'),
        firstName: mapValueOfType<String>(json, r'firstName'),
        lastName: mapValueOfType<String>(json, r'lastName'),
        fullName: mapValueOfType<String>(json, r'fullName'),
        displayName: mapValueOfType<String>(json, r'displayName'),
        email: mapValueOfType<String>(json, r'email'),
        phone: mapValueOfType<String>(json, r'phone'),
        avatarUrl: mapValueOfType<String>(json, r'avatarUrl'),
        dob: mapValueOfType<String>(json, r'dob'),
        gender: UpdateEmployeeDtoGenderEnum.fromJson(json[r'gender']),
        role: UpdateEmployeeDtoRoleEnum.fromJson(json[r'role']),
        status: UpdateEmployeeDtoStatusEnum.fromJson(json[r'status']),
        branchId: mapValueOfType<String>(json, r'branchId'),
        partnerId: mapValueOfType<String>(json, r'partnerId'),
        jobTitle: mapValueOfType<String>(json, r'jobTitle'),
        startDate: mapValueOfType<String>(json, r'startDate'),
        employmentType: mapValueOfType<String>(json, r'employmentType'),
        emergencyContactName: mapValueOfType<String>(json, r'emergencyContactName'),
        emergencyContactPhone: mapValueOfType<String>(json, r'emergencyContactPhone'),
        idCardUrl: mapValueOfType<String>(json, r'idCardUrl'),
        description: mapValueOfType<String>(json, r'description'),
        password: mapValueOfType<String>(json, r'password'),
        schedule: WorkScheduleEntryDto.listFromJson(json[r'schedule']),
        doctorProfile: CreateDoctorProfileDto.fromJson(json[r'doctorProfile']),
        therapistProfile: CreateTherapistProfileDto.fromJson(json[r'therapistProfile']),
      );
    }
    return null;
  }

  static List<UpdateEmployeeDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateEmployeeDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateEmployeeDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateEmployeeDto> mapFromJson(dynamic json) {
    final map = <String, UpdateEmployeeDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateEmployeeDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateEmployeeDto-objects as value to a dart map
  static Map<String, List<UpdateEmployeeDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateEmployeeDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateEmployeeDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

/// Gender
class UpdateEmployeeDtoGenderEnum {
  /// Instantiate a new enum with the provided [value].
  const UpdateEmployeeDtoGenderEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MALE = UpdateEmployeeDtoGenderEnum._(r'MALE');
  static const FEMALE = UpdateEmployeeDtoGenderEnum._(r'FEMALE');
  static const OTHER = UpdateEmployeeDtoGenderEnum._(r'OTHER');

  /// List of all possible values in this [enum][UpdateEmployeeDtoGenderEnum].
  static const values = <UpdateEmployeeDtoGenderEnum>[
    MALE,
    FEMALE,
    OTHER,
  ];

  static UpdateEmployeeDtoGenderEnum? fromJson(dynamic value) => UpdateEmployeeDtoGenderEnumTypeTransformer().decode(value);

  static List<UpdateEmployeeDtoGenderEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateEmployeeDtoGenderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateEmployeeDtoGenderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UpdateEmployeeDtoGenderEnum] to String,
/// and [decode] dynamic data back to [UpdateEmployeeDtoGenderEnum].
class UpdateEmployeeDtoGenderEnumTypeTransformer {
  factory UpdateEmployeeDtoGenderEnumTypeTransformer() => _instance ??= const UpdateEmployeeDtoGenderEnumTypeTransformer._();

  const UpdateEmployeeDtoGenderEnumTypeTransformer._();

  String encode(UpdateEmployeeDtoGenderEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UpdateEmployeeDtoGenderEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UpdateEmployeeDtoGenderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MALE': return UpdateEmployeeDtoGenderEnum.MALE;
        case r'FEMALE': return UpdateEmployeeDtoGenderEnum.FEMALE;
        case r'OTHER': return UpdateEmployeeDtoGenderEnum.OTHER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UpdateEmployeeDtoGenderEnumTypeTransformer] instance.
  static UpdateEmployeeDtoGenderEnumTypeTransformer? _instance;
}


/// Role of the employee
class UpdateEmployeeDtoRoleEnum {
  /// Instantiate a new enum with the provided [value].
  const UpdateEmployeeDtoRoleEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const DOCTOR = UpdateEmployeeDtoRoleEnum._(r'DOCTOR');
  static const THERAPIST = UpdateEmployeeDtoRoleEnum._(r'THERAPIST');
  static const RECEPTIONIST = UpdateEmployeeDtoRoleEnum._(r'RECEPTIONIST');
  static const MANAGER = UpdateEmployeeDtoRoleEnum._(r'MANAGER');

  /// List of all possible values in this [enum][UpdateEmployeeDtoRoleEnum].
  static const values = <UpdateEmployeeDtoRoleEnum>[
    DOCTOR,
    THERAPIST,
    RECEPTIONIST,
    MANAGER,
  ];

  static UpdateEmployeeDtoRoleEnum? fromJson(dynamic value) => UpdateEmployeeDtoRoleEnumTypeTransformer().decode(value);

  static List<UpdateEmployeeDtoRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateEmployeeDtoRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateEmployeeDtoRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UpdateEmployeeDtoRoleEnum] to String,
/// and [decode] dynamic data back to [UpdateEmployeeDtoRoleEnum].
class UpdateEmployeeDtoRoleEnumTypeTransformer {
  factory UpdateEmployeeDtoRoleEnumTypeTransformer() => _instance ??= const UpdateEmployeeDtoRoleEnumTypeTransformer._();

  const UpdateEmployeeDtoRoleEnumTypeTransformer._();

  String encode(UpdateEmployeeDtoRoleEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UpdateEmployeeDtoRoleEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UpdateEmployeeDtoRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'DOCTOR': return UpdateEmployeeDtoRoleEnum.DOCTOR;
        case r'THERAPIST': return UpdateEmployeeDtoRoleEnum.THERAPIST;
        case r'RECEPTIONIST': return UpdateEmployeeDtoRoleEnum.RECEPTIONIST;
        case r'MANAGER': return UpdateEmployeeDtoRoleEnum.MANAGER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UpdateEmployeeDtoRoleEnumTypeTransformer] instance.
  static UpdateEmployeeDtoRoleEnumTypeTransformer? _instance;
}


/// Status of the employee
class UpdateEmployeeDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const UpdateEmployeeDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const ACTIVE = UpdateEmployeeDtoStatusEnum._(r'ACTIVE');
  static const INACTIVE = UpdateEmployeeDtoStatusEnum._(r'INACTIVE');
  static const ON_LEAVE = UpdateEmployeeDtoStatusEnum._(r'ON_LEAVE');

  /// List of all possible values in this [enum][UpdateEmployeeDtoStatusEnum].
  static const values = <UpdateEmployeeDtoStatusEnum>[
    ACTIVE,
    INACTIVE,
    ON_LEAVE,
  ];

  static UpdateEmployeeDtoStatusEnum? fromJson(dynamic value) => UpdateEmployeeDtoStatusEnumTypeTransformer().decode(value);

  static List<UpdateEmployeeDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateEmployeeDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateEmployeeDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UpdateEmployeeDtoStatusEnum] to String,
/// and [decode] dynamic data back to [UpdateEmployeeDtoStatusEnum].
class UpdateEmployeeDtoStatusEnumTypeTransformer {
  factory UpdateEmployeeDtoStatusEnumTypeTransformer() => _instance ??= const UpdateEmployeeDtoStatusEnumTypeTransformer._();

  const UpdateEmployeeDtoStatusEnumTypeTransformer._();

  String encode(UpdateEmployeeDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UpdateEmployeeDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UpdateEmployeeDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'ACTIVE': return UpdateEmployeeDtoStatusEnum.ACTIVE;
        case r'INACTIVE': return UpdateEmployeeDtoStatusEnum.INACTIVE;
        case r'ON_LEAVE': return UpdateEmployeeDtoStatusEnum.ON_LEAVE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UpdateEmployeeDtoStatusEnumTypeTransformer] instance.
  static UpdateEmployeeDtoStatusEnumTypeTransformer? _instance;
}


