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
    this.employeeCode,
    this.fullName,
    this.email,
    this.password,
    this.role,
    this.status,
    this.firstName,
    this.lastName,
    this.phone,
    this.avatarUrl,
    this.dob,
    this.gender,
    this.partnerId,
    this.jobTitle,
    this.startDate,
    this.employmentType,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.description,
    this.verificationDocuments = const [],
    this.schedule = const [],
    this.workHistory = const [],
    this.doctorProfile,
    this.therapistProfile,
  });


  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? employeeCode;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? fullName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? email;

  /// New employee account password
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? password;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  EmployeeRole? role;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  EmployeeStatus? status;

  String? firstName;

  String? lastName;

  String? phone;

  String? avatarUrl;

  String? dob;

  UpdateEmployeeDtoGenderEnum? gender;

  String? partnerId;

  String? jobTitle;

  String? startDate;

  String? employmentType;

  String? emergencyContactName;

  String? emergencyContactPhone;

  String? description;

  List<VerificationDocumentEntryDto>? verificationDocuments;

  List<WorkScheduleEntryDto>? schedule;

  List<WorkHistoryEntryDto>? workHistory;

  CreateDoctorProfileDto? doctorProfile;

  CreateTherapistProfileDto? therapistProfile;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateEmployeeDto &&
    other.employeeCode == employeeCode &&
    other.fullName == fullName &&
    other.email == email &&
    other.password == password &&
    other.role == role &&
    other.status == status &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.phone == phone &&
    other.avatarUrl == avatarUrl &&
    other.dob == dob &&
    other.gender == gender &&
    other.partnerId == partnerId &&
    other.jobTitle == jobTitle &&
    other.startDate == startDate &&
    other.employmentType == employmentType &&
    other.emergencyContactName == emergencyContactName &&
    other.emergencyContactPhone == emergencyContactPhone &&
    other.description == description &&
    _deepEquality.equals(other.verificationDocuments, verificationDocuments) &&
    _deepEquality.equals(other.schedule, schedule) &&
    _deepEquality.equals(other.workHistory, workHistory) &&
    other.doctorProfile == doctorProfile &&
    other.therapistProfile == therapistProfile;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (employeeCode == null ? 0 : employeeCode!.hashCode) +
    (fullName == null ? 0 : fullName!.hashCode) +
    (email == null ? 0 : email!.hashCode) +
    (password == null ? 0 : password!.hashCode) +
    (role == null ? 0 : role!.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (firstName == null ? 0 : firstName!.hashCode) +
    (lastName == null ? 0 : lastName!.hashCode) +
    (phone == null ? 0 : phone!.hashCode) +
    (avatarUrl == null ? 0 : avatarUrl!.hashCode) +
    (dob == null ? 0 : dob!.hashCode) +
    (gender == null ? 0 : gender!.hashCode) +
    (partnerId == null ? 0 : partnerId!.hashCode) +
    (jobTitle == null ? 0 : jobTitle!.hashCode) +
    (startDate == null ? 0 : startDate!.hashCode) +
    (employmentType == null ? 0 : employmentType!.hashCode) +
    (emergencyContactName == null ? 0 : emergencyContactName!.hashCode) +
    (emergencyContactPhone == null ? 0 : emergencyContactPhone!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (verificationDocuments == null ? 0 : verificationDocuments!.hashCode) +
    (schedule == null ? 0 : schedule!.hashCode) +
    (workHistory == null ? 0 : workHistory!.hashCode) +
    (doctorProfile == null ? 0 : doctorProfile!.hashCode) +
    (therapistProfile == null ? 0 : therapistProfile!.hashCode);

  @override
  String toString() => 'UpdateEmployeeDto[employeeCode=$employeeCode, fullName=$fullName, email=$email, password=$password, role=$role, status=$status, firstName=$firstName, lastName=$lastName, phone=$phone, avatarUrl=$avatarUrl, dob=$dob, gender=$gender, partnerId=$partnerId, jobTitle=$jobTitle, startDate=$startDate, employmentType=$employmentType, emergencyContactName=$emergencyContactName, emergencyContactPhone=$emergencyContactPhone, description=$description, verificationDocuments=$verificationDocuments, schedule=$schedule, workHistory=$workHistory, doctorProfile=$doctorProfile, therapistProfile=$therapistProfile]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.employeeCode != null) {
      json[r'employeeCode'] = this.employeeCode;
    } else {
      json[r'employeeCode'] = null;
    }
    if (this.fullName != null) {
      json[r'fullName'] = this.fullName;
    } else {
      json[r'fullName'] = null;
    }
    if (this.email != null) {
      json[r'email'] = this.email;
    } else {
      json[r'email'] = null;
    }
    if (this.password != null) {
      json[r'password'] = this.password;
    } else {
      json[r'password'] = null;
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
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.verificationDocuments != null) {
      json[r'verificationDocuments'] = this.verificationDocuments;
    } else {
      json[r'verificationDocuments'] = null;
    }
    if (this.schedule != null) {
      json[r'schedule'] = this.schedule;
    } else {
      json[r'schedule'] = null;
    }
    if (this.workHistory != null) {
      json[r'workHistory'] = this.workHistory;
    } else {
      json[r'workHistory'] = null;
    }
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
        employeeCode: mapValueOfType<String>(json, r'employeeCode'),
        fullName: mapValueOfType<String>(json, r'fullName'),
        email: mapValueOfType<String>(json, r'email'),
        password: mapValueOfType<String>(json, r'password'),
        role: EmployeeRole.fromJson(json[r'role']),
        status: EmployeeStatus.fromJson(json[r'status']),
        firstName: mapValueOfType<String>(json, r'firstName'),
        lastName: mapValueOfType<String>(json, r'lastName'),
        phone: mapValueOfType<String>(json, r'phone'),
        avatarUrl: mapValueOfType<String>(json, r'avatarUrl'),
        dob: mapValueOfType<String>(json, r'dob'),
        gender: UpdateEmployeeDtoGenderEnum.fromJson(json[r'gender']),
        partnerId: mapValueOfType<String>(json, r'partnerId'),
        jobTitle: mapValueOfType<String>(json, r'jobTitle'),
        startDate: mapValueOfType<String>(json, r'startDate'),
        employmentType: mapValueOfType<String>(json, r'employmentType'),
        emergencyContactName: mapValueOfType<String>(json, r'emergencyContactName'),
        emergencyContactPhone: mapValueOfType<String>(json, r'emergencyContactPhone'),
        description: mapValueOfType<String>(json, r'description'),
        verificationDocuments: VerificationDocumentEntryDto.listFromJson(json[r'verificationDocuments']),
        schedule: WorkScheduleEntryDto.listFromJson(json[r'schedule']),
        workHistory: WorkHistoryEntryDto.listFromJson(json[r'workHistory']),
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


