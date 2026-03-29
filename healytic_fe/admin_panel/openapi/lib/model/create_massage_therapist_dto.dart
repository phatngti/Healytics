//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateMassageTherapistDto {
  /// Returns a new [CreateMassageTherapistDto] instance.
  CreateMassageTherapistDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.dateOfBirth,
    this.gender,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.employeeId,
    this.employmentType,
    required this.startDate,
    this.schedule = const [],
    this.workHistory = const [],
    this.avatar,
    this.verificationDocuments = const [],
    this.status,
    required this.description,
    this.jobTitle,
    this.therapistLevel,
    this.strengthLevel,
    this.commissionRate,
    this.healthCheckDate,
    this.skills = const [],
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
  CreateMassageTherapistDtoGenderEnum? gender;

  /// Emergency contact name
  String emergencyContactName;

  /// Emergency contact phone
  String emergencyContactPhone;

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
  String startDate;

  /// Weekly work schedule
  List<WorkScheduleEntryDto> schedule;

  /// Work history entries
  List<WorkHistoryEntryDto> workHistory;

  /// Avatar URL
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? avatar;

  /// Verification documents (ID card, licenses, etc.)
  List<VerificationDocumentEntryDto> verificationDocuments;

  /// Employee status
  CreateMassageTherapistDtoStatusEnum? status;

  /// Bio / description
  String description;

  /// Job title
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? jobTitle;

  /// Therapist level
  CreateMassageTherapistDtoTherapistLevelEnum? therapistLevel;

  /// Strength level
  CreateMassageTherapistDtoStrengthLevelEnum? strengthLevel;

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

  /// Partner ID (auto-injected)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? partnerId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateMassageTherapistDto &&
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
    _deepEquality.equals(other.workHistory, workHistory) &&
    other.avatar == avatar &&
    _deepEquality.equals(other.verificationDocuments, verificationDocuments) &&
    other.status == status &&
    other.description == description &&
    other.jobTitle == jobTitle &&
    other.therapistLevel == therapistLevel &&
    other.strengthLevel == strengthLevel &&
    other.commissionRate == commissionRate &&
    other.healthCheckDate == healthCheckDate &&
    _deepEquality.equals(other.skills, skills) &&
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
    (emergencyContactName.hashCode) +
    (emergencyContactPhone.hashCode) +
    (employeeId.hashCode) +
    (employmentType == null ? 0 : employmentType!.hashCode) +
    (startDate.hashCode) +
    (schedule.hashCode) +
    (workHistory.hashCode) +
    (avatar == null ? 0 : avatar!.hashCode) +
    (verificationDocuments.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (description.hashCode) +
    (jobTitle == null ? 0 : jobTitle!.hashCode) +
    (therapistLevel == null ? 0 : therapistLevel!.hashCode) +
    (strengthLevel == null ? 0 : strengthLevel!.hashCode) +
    (commissionRate == null ? 0 : commissionRate!.hashCode) +
    (healthCheckDate == null ? 0 : healthCheckDate!.hashCode) +
    (skills.hashCode) +
    (partnerId == null ? 0 : partnerId!.hashCode);

  @override
  String toString() => 'CreateMassageTherapistDto[firstName=$firstName, lastName=$lastName, email=$email, phone=$phone, dateOfBirth=$dateOfBirth, gender=$gender, emergencyContactName=$emergencyContactName, emergencyContactPhone=$emergencyContactPhone, employeeId=$employeeId, employmentType=$employmentType, startDate=$startDate, schedule=$schedule, workHistory=$workHistory, avatar=$avatar, verificationDocuments=$verificationDocuments, status=$status, description=$description, jobTitle=$jobTitle, therapistLevel=$therapistLevel, strengthLevel=$strengthLevel, commissionRate=$commissionRate, healthCheckDate=$healthCheckDate, skills=$skills, partnerId=$partnerId]';

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
      json[r'emergencyContactName'] = this.emergencyContactName;
      json[r'emergencyContactPhone'] = this.emergencyContactPhone;
      json[r'employeeId'] = this.employeeId;
    if (this.employmentType != null) {
      json[r'employmentType'] = this.employmentType;
    } else {
      json[r'employmentType'] = null;
    }
      json[r'startDate'] = this.startDate;
      json[r'schedule'] = this.schedule;
      json[r'workHistory'] = this.workHistory;
    if (this.avatar != null) {
      json[r'avatar'] = this.avatar;
    } else {
      json[r'avatar'] = null;
    }
      json[r'verificationDocuments'] = this.verificationDocuments;
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
      json[r'description'] = this.description;
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
    if (this.strengthLevel != null) {
      json[r'strengthLevel'] = this.strengthLevel;
    } else {
      json[r'strengthLevel'] = null;
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
    if (this.partnerId != null) {
      json[r'partnerId'] = this.partnerId;
    } else {
      json[r'partnerId'] = null;
    }
    return json;
  }

  /// Returns a new [CreateMassageTherapistDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateMassageTherapistDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateMassageTherapistDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateMassageTherapistDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateMassageTherapistDto(
        firstName: mapValueOfType<String>(json, r'firstName')!,
        lastName: mapValueOfType<String>(json, r'lastName')!,
        email: mapValueOfType<String>(json, r'email')!,
        phone: mapValueOfType<String>(json, r'phone'),
        dateOfBirth: mapValueOfType<String>(json, r'dateOfBirth'),
        gender: CreateMassageTherapistDtoGenderEnum.fromJson(json[r'gender']),
        emergencyContactName: mapValueOfType<String>(json, r'emergencyContactName')!,
        emergencyContactPhone: mapValueOfType<String>(json, r'emergencyContactPhone')!,
        employeeId: mapValueOfType<String>(json, r'employeeId')!,
        employmentType: mapValueOfType<String>(json, r'employmentType'),
        startDate: mapValueOfType<String>(json, r'startDate')!,
        schedule: WorkScheduleEntryDto.listFromJson(json[r'schedule']),
        workHistory: WorkHistoryEntryDto.listFromJson(json[r'workHistory']),
        avatar: mapValueOfType<String>(json, r'avatar'),
        verificationDocuments: VerificationDocumentEntryDto.listFromJson(json[r'verificationDocuments']),
        status: CreateMassageTherapistDtoStatusEnum.fromJson(json[r'status']),
        description: mapValueOfType<String>(json, r'description')!,
        jobTitle: mapValueOfType<String>(json, r'jobTitle'),
        therapistLevel: CreateMassageTherapistDtoTherapistLevelEnum.fromJson(json[r'therapistLevel']),
        strengthLevel: CreateMassageTherapistDtoStrengthLevelEnum.fromJson(json[r'strengthLevel']),
        commissionRate: num.parse('${json[r'commissionRate']}'),
        healthCheckDate: mapValueOfType<String>(json, r'healthCheckDate'),
        skills: json[r'skills'] is Iterable
            ? (json[r'skills'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        partnerId: mapValueOfType<String>(json, r'partnerId'),
      );
    }
    return null;
  }

  static List<CreateMassageTherapistDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateMassageTherapistDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateMassageTherapistDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateMassageTherapistDto> mapFromJson(dynamic json) {
    final map = <String, CreateMassageTherapistDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateMassageTherapistDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateMassageTherapistDto-objects as value to a dart map
  static Map<String, List<CreateMassageTherapistDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateMassageTherapistDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateMassageTherapistDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'firstName',
    'lastName',
    'email',
    'emergencyContactName',
    'emergencyContactPhone',
    'employeeId',
    'startDate',
    'schedule',
    'description',
  };
}

/// Gender
class CreateMassageTherapistDtoGenderEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateMassageTherapistDtoGenderEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MALE = CreateMassageTherapistDtoGenderEnum._(r'MALE');
  static const FEMALE = CreateMassageTherapistDtoGenderEnum._(r'FEMALE');
  static const OTHER = CreateMassageTherapistDtoGenderEnum._(r'OTHER');

  /// List of all possible values in this [enum][CreateMassageTherapistDtoGenderEnum].
  static const values = <CreateMassageTherapistDtoGenderEnum>[
    MALE,
    FEMALE,
    OTHER,
  ];

  static CreateMassageTherapistDtoGenderEnum? fromJson(dynamic value) => CreateMassageTherapistDtoGenderEnumTypeTransformer().decode(value);

  static List<CreateMassageTherapistDtoGenderEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateMassageTherapistDtoGenderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateMassageTherapistDtoGenderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateMassageTherapistDtoGenderEnum] to String,
/// and [decode] dynamic data back to [CreateMassageTherapistDtoGenderEnum].
class CreateMassageTherapistDtoGenderEnumTypeTransformer {
  factory CreateMassageTherapistDtoGenderEnumTypeTransformer() => _instance ??= const CreateMassageTherapistDtoGenderEnumTypeTransformer._();

  const CreateMassageTherapistDtoGenderEnumTypeTransformer._();

  String encode(CreateMassageTherapistDtoGenderEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateMassageTherapistDtoGenderEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateMassageTherapistDtoGenderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MALE': return CreateMassageTherapistDtoGenderEnum.MALE;
        case r'FEMALE': return CreateMassageTherapistDtoGenderEnum.FEMALE;
        case r'OTHER': return CreateMassageTherapistDtoGenderEnum.OTHER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateMassageTherapistDtoGenderEnumTypeTransformer] instance.
  static CreateMassageTherapistDtoGenderEnumTypeTransformer? _instance;
}


/// Employee status
class CreateMassageTherapistDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateMassageTherapistDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const ACTIVE = CreateMassageTherapistDtoStatusEnum._(r'ACTIVE');
  static const INACTIVE = CreateMassageTherapistDtoStatusEnum._(r'INACTIVE');
  static const ON_LEAVE = CreateMassageTherapistDtoStatusEnum._(r'ON_LEAVE');

  /// List of all possible values in this [enum][CreateMassageTherapistDtoStatusEnum].
  static const values = <CreateMassageTherapistDtoStatusEnum>[
    ACTIVE,
    INACTIVE,
    ON_LEAVE,
  ];

  static CreateMassageTherapistDtoStatusEnum? fromJson(dynamic value) => CreateMassageTherapistDtoStatusEnumTypeTransformer().decode(value);

  static List<CreateMassageTherapistDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateMassageTherapistDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateMassageTherapistDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateMassageTherapistDtoStatusEnum] to String,
/// and [decode] dynamic data back to [CreateMassageTherapistDtoStatusEnum].
class CreateMassageTherapistDtoStatusEnumTypeTransformer {
  factory CreateMassageTherapistDtoStatusEnumTypeTransformer() => _instance ??= const CreateMassageTherapistDtoStatusEnumTypeTransformer._();

  const CreateMassageTherapistDtoStatusEnumTypeTransformer._();

  String encode(CreateMassageTherapistDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateMassageTherapistDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateMassageTherapistDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'ACTIVE': return CreateMassageTherapistDtoStatusEnum.ACTIVE;
        case r'INACTIVE': return CreateMassageTherapistDtoStatusEnum.INACTIVE;
        case r'ON_LEAVE': return CreateMassageTherapistDtoStatusEnum.ON_LEAVE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateMassageTherapistDtoStatusEnumTypeTransformer] instance.
  static CreateMassageTherapistDtoStatusEnumTypeTransformer? _instance;
}


/// Therapist level
class CreateMassageTherapistDtoTherapistLevelEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateMassageTherapistDtoTherapistLevelEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const JUNIOR = CreateMassageTherapistDtoTherapistLevelEnum._(r'JUNIOR');
  static const SENIOR = CreateMassageTherapistDtoTherapistLevelEnum._(r'SENIOR');
  static const MASTER = CreateMassageTherapistDtoTherapistLevelEnum._(r'MASTER');

  /// List of all possible values in this [enum][CreateMassageTherapistDtoTherapistLevelEnum].
  static const values = <CreateMassageTherapistDtoTherapistLevelEnum>[
    JUNIOR,
    SENIOR,
    MASTER,
  ];

  static CreateMassageTherapistDtoTherapistLevelEnum? fromJson(dynamic value) => CreateMassageTherapistDtoTherapistLevelEnumTypeTransformer().decode(value);

  static List<CreateMassageTherapistDtoTherapistLevelEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateMassageTherapistDtoTherapistLevelEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateMassageTherapistDtoTherapistLevelEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateMassageTherapistDtoTherapistLevelEnum] to String,
/// and [decode] dynamic data back to [CreateMassageTherapistDtoTherapistLevelEnum].
class CreateMassageTherapistDtoTherapistLevelEnumTypeTransformer {
  factory CreateMassageTherapistDtoTherapistLevelEnumTypeTransformer() => _instance ??= const CreateMassageTherapistDtoTherapistLevelEnumTypeTransformer._();

  const CreateMassageTherapistDtoTherapistLevelEnumTypeTransformer._();

  String encode(CreateMassageTherapistDtoTherapistLevelEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateMassageTherapistDtoTherapistLevelEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateMassageTherapistDtoTherapistLevelEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'JUNIOR': return CreateMassageTherapistDtoTherapistLevelEnum.JUNIOR;
        case r'SENIOR': return CreateMassageTherapistDtoTherapistLevelEnum.SENIOR;
        case r'MASTER': return CreateMassageTherapistDtoTherapistLevelEnum.MASTER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateMassageTherapistDtoTherapistLevelEnumTypeTransformer] instance.
  static CreateMassageTherapistDtoTherapistLevelEnumTypeTransformer? _instance;
}


/// Strength level
class CreateMassageTherapistDtoStrengthLevelEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateMassageTherapistDtoStrengthLevelEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const SOFT = CreateMassageTherapistDtoStrengthLevelEnum._(r'SOFT');
  static const MEDIUM = CreateMassageTherapistDtoStrengthLevelEnum._(r'MEDIUM');
  static const STRONG = CreateMassageTherapistDtoStrengthLevelEnum._(r'STRONG');

  /// List of all possible values in this [enum][CreateMassageTherapistDtoStrengthLevelEnum].
  static const values = <CreateMassageTherapistDtoStrengthLevelEnum>[
    SOFT,
    MEDIUM,
    STRONG,
  ];

  static CreateMassageTherapistDtoStrengthLevelEnum? fromJson(dynamic value) => CreateMassageTherapistDtoStrengthLevelEnumTypeTransformer().decode(value);

  static List<CreateMassageTherapistDtoStrengthLevelEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateMassageTherapistDtoStrengthLevelEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateMassageTherapistDtoStrengthLevelEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateMassageTherapistDtoStrengthLevelEnum] to String,
/// and [decode] dynamic data back to [CreateMassageTherapistDtoStrengthLevelEnum].
class CreateMassageTherapistDtoStrengthLevelEnumTypeTransformer {
  factory CreateMassageTherapistDtoStrengthLevelEnumTypeTransformer() => _instance ??= const CreateMassageTherapistDtoStrengthLevelEnumTypeTransformer._();

  const CreateMassageTherapistDtoStrengthLevelEnumTypeTransformer._();

  String encode(CreateMassageTherapistDtoStrengthLevelEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateMassageTherapistDtoStrengthLevelEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateMassageTherapistDtoStrengthLevelEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'SOFT': return CreateMassageTherapistDtoStrengthLevelEnum.SOFT;
        case r'MEDIUM': return CreateMassageTherapistDtoStrengthLevelEnum.MEDIUM;
        case r'STRONG': return CreateMassageTherapistDtoStrengthLevelEnum.STRONG;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateMassageTherapistDtoStrengthLevelEnumTypeTransformer] instance.
  static CreateMassageTherapistDtoStrengthLevelEnumTypeTransformer? _instance;
}


