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
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.emergencyContactName,
    this.emergencyContactPhone,
    required this.employeeId,
    this.employmentType,
    this.startDate,
    this.schedule = const [],
    this.avatar,
    this.idCardUrl,
    this.status,
    this.branch,
    this.password,
    this.description,
    this.jobTitle,
    this.medicalTitles = const [],
    this.medicalLicenses = const [],
    this.experienceYears,
    this.consultationFee,
    this.specializations = const [],
    this.education = const [],
    this.certifications = const [],
    this.partnerId,
  });

  /// First name
  String firstName;

  /// Last name
  String lastName;

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

  /// Date of birth
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? dateOfBirth;

  /// Gender
  CreateDoctorDtoGenderEnum? gender;

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

  /// Unique employee identifier code
  String employeeId;

  /// Employment type
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? employmentType;

  /// Start date
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? startDate;

  /// Weekly work schedule
  List<WorkScheduleEntryDto> schedule;

  /// Avatar URL
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? avatar;

  /// ID card URL
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? idCardUrl;

  /// Employee status
  CreateDoctorDtoStatusEnum? status;

  /// Branch ID or name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? branch;

  /// Account password
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? password;

  /// Bio / description
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  /// Job title
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? jobTitle;

  /// Medical titles
  List<String> medicalTitles;

  /// Medical license numbers
  List<String> medicalLicenses;

  /// Years of experience
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? experienceYears;

  /// Consultation fee
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? consultationFee;

  /// Specializations
  List<String> specializations;

  /// Education history
  List<String> education;

  /// Certifications
  List<String> certifications;

  /// Partner ID (auto-injected)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? partnerId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateDoctorDto &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.email == email &&
    other.phone == phone &&
    other.dateOfBirth == dateOfBirth &&
    other.gender == gender &&
    other.emergencyContactName == emergencyContactName &&
    other.emergencyContactPhone == emergencyContactPhone &&
    other.employeeId == employeeId &&
    other.employmentType == employmentType &&
    other.startDate == startDate &&
    _deepEquality.equals(other.schedule, schedule) &&
    other.avatar == avatar &&
    other.idCardUrl == idCardUrl &&
    other.status == status &&
    other.branch == branch &&
    other.password == password &&
    other.description == description &&
    other.jobTitle == jobTitle &&
    _deepEquality.equals(other.medicalTitles, medicalTitles) &&
    _deepEquality.equals(other.medicalLicenses, medicalLicenses) &&
    other.experienceYears == experienceYears &&
    other.consultationFee == consultationFee &&
    _deepEquality.equals(other.specializations, specializations) &&
    _deepEquality.equals(other.education, education) &&
    _deepEquality.equals(other.certifications, certifications) &&
    other.partnerId == partnerId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (firstName.hashCode) +
    (lastName.hashCode) +
    (email.hashCode) +
    (phone == null ? 0 : phone!.hashCode) +
    (dateOfBirth == null ? 0 : dateOfBirth!.hashCode) +
    (gender == null ? 0 : gender!.hashCode) +
    (emergencyContactName == null ? 0 : emergencyContactName!.hashCode) +
    (emergencyContactPhone == null ? 0 : emergencyContactPhone!.hashCode) +
    (employeeId.hashCode) +
    (employmentType == null ? 0 : employmentType!.hashCode) +
    (startDate == null ? 0 : startDate!.hashCode) +
    (schedule.hashCode) +
    (avatar == null ? 0 : avatar!.hashCode) +
    (idCardUrl == null ? 0 : idCardUrl!.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (branch == null ? 0 : branch!.hashCode) +
    (password == null ? 0 : password!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (jobTitle == null ? 0 : jobTitle!.hashCode) +
    (medicalTitles.hashCode) +
    (medicalLicenses.hashCode) +
    (experienceYears == null ? 0 : experienceYears!.hashCode) +
    (consultationFee == null ? 0 : consultationFee!.hashCode) +
    (specializations.hashCode) +
    (education.hashCode) +
    (certifications.hashCode) +
    (partnerId == null ? 0 : partnerId!.hashCode);

  @override
  String toString() => 'CreateDoctorDto[firstName=$firstName, lastName=$lastName, email=$email, phone=$phone, dateOfBirth=$dateOfBirth, gender=$gender, emergencyContactName=$emergencyContactName, emergencyContactPhone=$emergencyContactPhone, employeeId=$employeeId, employmentType=$employmentType, startDate=$startDate, schedule=$schedule, avatar=$avatar, idCardUrl=$idCardUrl, status=$status, branch=$branch, password=$password, description=$description, jobTitle=$jobTitle, medicalTitles=$medicalTitles, medicalLicenses=$medicalLicenses, experienceYears=$experienceYears, consultationFee=$consultationFee, specializations=$specializations, education=$education, certifications=$certifications, partnerId=$partnerId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'firstName'] = this.firstName;
      json[r'lastName'] = this.lastName;
      json[r'email'] = this.email;
    if (this.phone != null) {
      json[r'phone'] = this.phone;
    } else {
      json[r'phone'] = null;
    }
    if (this.dateOfBirth != null) {
      json[r'dateOfBirth'] = this.dateOfBirth;
    } else {
      json[r'dateOfBirth'] = null;
    }
    if (this.gender != null) {
      json[r'gender'] = this.gender;
    } else {
      json[r'gender'] = null;
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
      json[r'employeeId'] = this.employeeId;
    if (this.employmentType != null) {
      json[r'employmentType'] = this.employmentType;
    } else {
      json[r'employmentType'] = null;
    }
    if (this.startDate != null) {
      json[r'startDate'] = this.startDate;
    } else {
      json[r'startDate'] = null;
    }
      json[r'schedule'] = this.schedule;
    if (this.avatar != null) {
      json[r'avatar'] = this.avatar;
    } else {
      json[r'avatar'] = null;
    }
    if (this.idCardUrl != null) {
      json[r'idCardUrl'] = this.idCardUrl;
    } else {
      json[r'idCardUrl'] = null;
    }
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
    if (this.branch != null) {
      json[r'branch'] = this.branch;
    } else {
      json[r'branch'] = null;
    }
    if (this.password != null) {
      json[r'password'] = this.password;
    } else {
      json[r'password'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.jobTitle != null) {
      json[r'jobTitle'] = this.jobTitle;
    } else {
      json[r'jobTitle'] = null;
    }
      json[r'medicalTitles'] = this.medicalTitles;
      json[r'medicalLicenses'] = this.medicalLicenses;
    if (this.experienceYears != null) {
      json[r'experienceYears'] = this.experienceYears;
    } else {
      json[r'experienceYears'] = null;
    }
    if (this.consultationFee != null) {
      json[r'consultationFee'] = this.consultationFee;
    } else {
      json[r'consultationFee'] = null;
    }
      json[r'specializations'] = this.specializations;
      json[r'education'] = this.education;
      json[r'certifications'] = this.certifications;
    if (this.partnerId != null) {
      json[r'partnerId'] = this.partnerId;
    } else {
      json[r'partnerId'] = null;
    }
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
        firstName: mapValueOfType<String>(json, r'firstName')!,
        lastName: mapValueOfType<String>(json, r'lastName')!,
        email: mapValueOfType<String>(json, r'email')!,
        phone: mapValueOfType<String>(json, r'phone'),
        dateOfBirth: mapValueOfType<String>(json, r'dateOfBirth'),
        gender: CreateDoctorDtoGenderEnum.fromJson(json[r'gender']),
        emergencyContactName: mapValueOfType<String>(json, r'emergencyContactName'),
        emergencyContactPhone: mapValueOfType<String>(json, r'emergencyContactPhone'),
        employeeId: mapValueOfType<String>(json, r'employeeId')!,
        employmentType: mapValueOfType<String>(json, r'employmentType'),
        startDate: mapValueOfType<String>(json, r'startDate'),
        schedule: WorkScheduleEntryDto.listFromJson(json[r'schedule']),
        avatar: mapValueOfType<String>(json, r'avatar'),
        idCardUrl: mapValueOfType<String>(json, r'idCardUrl'),
        status: CreateDoctorDtoStatusEnum.fromJson(json[r'status']),
        branch: mapValueOfType<String>(json, r'branch'),
        password: mapValueOfType<String>(json, r'password'),
        description: mapValueOfType<String>(json, r'description'),
        jobTitle: mapValueOfType<String>(json, r'jobTitle'),
        medicalTitles: json[r'medicalTitles'] is Iterable
            ? (json[r'medicalTitles'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        medicalLicenses: json[r'medicalLicenses'] is Iterable
            ? (json[r'medicalLicenses'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        experienceYears: num.parse('${json[r'experienceYears']}'),
        consultationFee: num.parse('${json[r'consultationFee']}'),
        specializations: json[r'specializations'] is Iterable
            ? (json[r'specializations'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        education: json[r'education'] is Iterable
            ? (json[r'education'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        certifications: json[r'certifications'] is Iterable
            ? (json[r'certifications'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        partnerId: mapValueOfType<String>(json, r'partnerId'),
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
    'firstName',
    'lastName',
    'email',
    'employeeId',
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


/// Employee status
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


