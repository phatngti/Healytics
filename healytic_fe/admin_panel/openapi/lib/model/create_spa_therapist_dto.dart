//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateSpaTherapistDto {
  /// Returns a new [CreateSpaTherapistDto] instance.
  CreateSpaTherapistDto({
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
    this.therapistLevel,
    this.commissionRate,
    this.healthCheckDate,
    this.skills = const [],
    this.deviceProficiency = const [],
    this.licenseUrl,
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
  CreateSpaTherapistDtoGenderEnum? gender;

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
  CreateSpaTherapistDtoStatusEnum? status;

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

  /// Therapist level
  CreateSpaTherapistDtoTherapistLevelEnum? therapistLevel;

  /// Commission rate percentage
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? commissionRate;

  /// Last health check date
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? healthCheckDate;

  /// Skills
  List<String> skills;

  /// Device proficiency
  List<String> deviceProficiency;

  /// License URL
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? licenseUrl;

  /// Partner ID (auto-injected)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? partnerId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateSpaTherapistDto &&
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
    other.therapistLevel == therapistLevel &&
    other.commissionRate == commissionRate &&
    other.healthCheckDate == healthCheckDate &&
    _deepEquality.equals(other.skills, skills) &&
    _deepEquality.equals(other.deviceProficiency, deviceProficiency) &&
    other.licenseUrl == licenseUrl &&
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
    (therapistLevel == null ? 0 : therapistLevel!.hashCode) +
    (commissionRate == null ? 0 : commissionRate!.hashCode) +
    (healthCheckDate == null ? 0 : healthCheckDate!.hashCode) +
    (skills.hashCode) +
    (deviceProficiency.hashCode) +
    (licenseUrl == null ? 0 : licenseUrl!.hashCode) +
    (partnerId == null ? 0 : partnerId!.hashCode);

  @override
  String toString() => 'CreateSpaTherapistDto[firstName=$firstName, lastName=$lastName, email=$email, phone=$phone, dateOfBirth=$dateOfBirth, gender=$gender, emergencyContactName=$emergencyContactName, emergencyContactPhone=$emergencyContactPhone, employeeId=$employeeId, employmentType=$employmentType, startDate=$startDate, schedule=$schedule, avatar=$avatar, idCardUrl=$idCardUrl, status=$status, branch=$branch, password=$password, description=$description, jobTitle=$jobTitle, therapistLevel=$therapistLevel, commissionRate=$commissionRate, healthCheckDate=$healthCheckDate, skills=$skills, deviceProficiency=$deviceProficiency, licenseUrl=$licenseUrl, partnerId=$partnerId]';

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
    if (this.therapistLevel != null) {
      json[r'therapistLevel'] = this.therapistLevel;
    } else {
      json[r'therapistLevel'] = null;
    }
    if (this.commissionRate != null) {
      json[r'commissionRate'] = this.commissionRate;
    } else {
      json[r'commissionRate'] = null;
    }
    if (this.healthCheckDate != null) {
      json[r'healthCheckDate'] = this.healthCheckDate;
    } else {
      json[r'healthCheckDate'] = null;
    }
      json[r'skills'] = this.skills;
      json[r'deviceProficiency'] = this.deviceProficiency;
    if (this.licenseUrl != null) {
      json[r'licenseUrl'] = this.licenseUrl;
    } else {
      json[r'licenseUrl'] = null;
    }
    if (this.partnerId != null) {
      json[r'partnerId'] = this.partnerId;
    } else {
      json[r'partnerId'] = null;
    }
    return json;
  }

  /// Returns a new [CreateSpaTherapistDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateSpaTherapistDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateSpaTherapistDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateSpaTherapistDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateSpaTherapistDto(
        firstName: mapValueOfType<String>(json, r'firstName')!,
        lastName: mapValueOfType<String>(json, r'lastName')!,
        email: mapValueOfType<String>(json, r'email')!,
        phone: mapValueOfType<String>(json, r'phone'),
        dateOfBirth: mapValueOfType<String>(json, r'dateOfBirth'),
        gender: CreateSpaTherapistDtoGenderEnum.fromJson(json[r'gender']),
        emergencyContactName: mapValueOfType<String>(json, r'emergencyContactName'),
        emergencyContactPhone: mapValueOfType<String>(json, r'emergencyContactPhone'),
        employeeId: mapValueOfType<String>(json, r'employeeId')!,
        employmentType: mapValueOfType<String>(json, r'employmentType'),
        startDate: mapValueOfType<String>(json, r'startDate'),
        schedule: WorkScheduleEntryDto.listFromJson(json[r'schedule']),
        avatar: mapValueOfType<String>(json, r'avatar'),
        idCardUrl: mapValueOfType<String>(json, r'idCardUrl'),
        status: CreateSpaTherapistDtoStatusEnum.fromJson(json[r'status']),
        branch: mapValueOfType<String>(json, r'branch'),
        password: mapValueOfType<String>(json, r'password'),
        description: mapValueOfType<String>(json, r'description'),
        jobTitle: mapValueOfType<String>(json, r'jobTitle'),
        therapistLevel: CreateSpaTherapistDtoTherapistLevelEnum.fromJson(json[r'therapistLevel']),
        commissionRate: num.parse('${json[r'commissionRate']}'),
        healthCheckDate: mapValueOfType<String>(json, r'healthCheckDate'),
        skills: json[r'skills'] is Iterable
            ? (json[r'skills'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        deviceProficiency: json[r'deviceProficiency'] is Iterable
            ? (json[r'deviceProficiency'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        licenseUrl: mapValueOfType<String>(json, r'licenseUrl'),
        partnerId: mapValueOfType<String>(json, r'partnerId'),
      );
    }
    return null;
  }

  static List<CreateSpaTherapistDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateSpaTherapistDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateSpaTherapistDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateSpaTherapistDto> mapFromJson(dynamic json) {
    final map = <String, CreateSpaTherapistDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateSpaTherapistDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateSpaTherapistDto-objects as value to a dart map
  static Map<String, List<CreateSpaTherapistDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateSpaTherapistDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateSpaTherapistDto.listFromJson(entry.value, growable: growable,);
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
class CreateSpaTherapistDtoGenderEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateSpaTherapistDtoGenderEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MALE = CreateSpaTherapistDtoGenderEnum._(r'MALE');
  static const FEMALE = CreateSpaTherapistDtoGenderEnum._(r'FEMALE');
  static const OTHER = CreateSpaTherapistDtoGenderEnum._(r'OTHER');

  /// List of all possible values in this [enum][CreateSpaTherapistDtoGenderEnum].
  static const values = <CreateSpaTherapistDtoGenderEnum>[
    MALE,
    FEMALE,
    OTHER,
  ];

  static CreateSpaTherapistDtoGenderEnum? fromJson(dynamic value) => CreateSpaTherapistDtoGenderEnumTypeTransformer().decode(value);

  static List<CreateSpaTherapistDtoGenderEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateSpaTherapistDtoGenderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateSpaTherapistDtoGenderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateSpaTherapistDtoGenderEnum] to String,
/// and [decode] dynamic data back to [CreateSpaTherapistDtoGenderEnum].
class CreateSpaTherapistDtoGenderEnumTypeTransformer {
  factory CreateSpaTherapistDtoGenderEnumTypeTransformer() => _instance ??= const CreateSpaTherapistDtoGenderEnumTypeTransformer._();

  const CreateSpaTherapistDtoGenderEnumTypeTransformer._();

  String encode(CreateSpaTherapistDtoGenderEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateSpaTherapistDtoGenderEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateSpaTherapistDtoGenderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MALE': return CreateSpaTherapistDtoGenderEnum.MALE;
        case r'FEMALE': return CreateSpaTherapistDtoGenderEnum.FEMALE;
        case r'OTHER': return CreateSpaTherapistDtoGenderEnum.OTHER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateSpaTherapistDtoGenderEnumTypeTransformer] instance.
  static CreateSpaTherapistDtoGenderEnumTypeTransformer? _instance;
}


/// Employee status
class CreateSpaTherapistDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateSpaTherapistDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const ACTIVE = CreateSpaTherapistDtoStatusEnum._(r'ACTIVE');
  static const INACTIVE = CreateSpaTherapistDtoStatusEnum._(r'INACTIVE');
  static const ON_LEAVE = CreateSpaTherapistDtoStatusEnum._(r'ON_LEAVE');

  /// List of all possible values in this [enum][CreateSpaTherapistDtoStatusEnum].
  static const values = <CreateSpaTherapistDtoStatusEnum>[
    ACTIVE,
    INACTIVE,
    ON_LEAVE,
  ];

  static CreateSpaTherapistDtoStatusEnum? fromJson(dynamic value) => CreateSpaTherapistDtoStatusEnumTypeTransformer().decode(value);

  static List<CreateSpaTherapistDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateSpaTherapistDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateSpaTherapistDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateSpaTherapistDtoStatusEnum] to String,
/// and [decode] dynamic data back to [CreateSpaTherapistDtoStatusEnum].
class CreateSpaTherapistDtoStatusEnumTypeTransformer {
  factory CreateSpaTherapistDtoStatusEnumTypeTransformer() => _instance ??= const CreateSpaTherapistDtoStatusEnumTypeTransformer._();

  const CreateSpaTherapistDtoStatusEnumTypeTransformer._();

  String encode(CreateSpaTherapistDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateSpaTherapistDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateSpaTherapistDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'ACTIVE': return CreateSpaTherapistDtoStatusEnum.ACTIVE;
        case r'INACTIVE': return CreateSpaTherapistDtoStatusEnum.INACTIVE;
        case r'ON_LEAVE': return CreateSpaTherapistDtoStatusEnum.ON_LEAVE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateSpaTherapistDtoStatusEnumTypeTransformer] instance.
  static CreateSpaTherapistDtoStatusEnumTypeTransformer? _instance;
}


/// Therapist level
class CreateSpaTherapistDtoTherapistLevelEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateSpaTherapistDtoTherapistLevelEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const JUNIOR = CreateSpaTherapistDtoTherapistLevelEnum._(r'JUNIOR');
  static const SENIOR = CreateSpaTherapistDtoTherapistLevelEnum._(r'SENIOR');
  static const MASTER = CreateSpaTherapistDtoTherapistLevelEnum._(r'MASTER');

  /// List of all possible values in this [enum][CreateSpaTherapistDtoTherapistLevelEnum].
  static const values = <CreateSpaTherapistDtoTherapistLevelEnum>[
    JUNIOR,
    SENIOR,
    MASTER,
  ];

  static CreateSpaTherapistDtoTherapistLevelEnum? fromJson(dynamic value) => CreateSpaTherapistDtoTherapistLevelEnumTypeTransformer().decode(value);

  static List<CreateSpaTherapistDtoTherapistLevelEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateSpaTherapistDtoTherapistLevelEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateSpaTherapistDtoTherapistLevelEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateSpaTherapistDtoTherapistLevelEnum] to String,
/// and [decode] dynamic data back to [CreateSpaTherapistDtoTherapistLevelEnum].
class CreateSpaTherapistDtoTherapistLevelEnumTypeTransformer {
  factory CreateSpaTherapistDtoTherapistLevelEnumTypeTransformer() => _instance ??= const CreateSpaTherapistDtoTherapistLevelEnumTypeTransformer._();

  const CreateSpaTherapistDtoTherapistLevelEnumTypeTransformer._();

  String encode(CreateSpaTherapistDtoTherapistLevelEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateSpaTherapistDtoTherapistLevelEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateSpaTherapistDtoTherapistLevelEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'JUNIOR': return CreateSpaTherapistDtoTherapistLevelEnum.JUNIOR;
        case r'SENIOR': return CreateSpaTherapistDtoTherapistLevelEnum.SENIOR;
        case r'MASTER': return CreateSpaTherapistDtoTherapistLevelEnum.MASTER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateSpaTherapistDtoTherapistLevelEnumTypeTransformer] instance.
  static CreateSpaTherapistDtoTherapistLevelEnumTypeTransformer? _instance;
}


