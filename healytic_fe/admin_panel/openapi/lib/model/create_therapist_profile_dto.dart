//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateTherapistProfileDto {
  /// Returns a new [CreateTherapistProfileDto] instance.
  CreateTherapistProfileDto({
    this.level,
    this.type,
    this.strengthLevel,
    this.commissionRate,
    this.healthCheckDate,
    this.skills = const [],
    this.deviceProficiency = const [],
    this.licenseUrl,
  });

  /// Therapist level
  CreateTherapistProfileDtoLevelEnum? level;

  /// Type of therapist
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? type;

  /// Therapist strength level
  CreateTherapistProfileDtoStrengthLevelEnum? strengthLevel;

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

  /// Therapist skills
  List<String> skills;

  /// Device proficiency list
  List<String> deviceProficiency;

  /// License URL
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? licenseUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateTherapistProfileDto &&
    other.level == level &&
    other.type == type &&
    other.strengthLevel == strengthLevel &&
    other.commissionRate == commissionRate &&
    other.healthCheckDate == healthCheckDate &&
    _deepEquality.equals(other.skills, skills) &&
    _deepEquality.equals(other.deviceProficiency, deviceProficiency) &&
    other.licenseUrl == licenseUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (level == null ? 0 : level!.hashCode) +
    (type == null ? 0 : type!.hashCode) +
    (strengthLevel == null ? 0 : strengthLevel!.hashCode) +
    (commissionRate == null ? 0 : commissionRate!.hashCode) +
    (healthCheckDate == null ? 0 : healthCheckDate!.hashCode) +
    (skills.hashCode) +
    (deviceProficiency.hashCode) +
    (licenseUrl == null ? 0 : licenseUrl!.hashCode);

  @override
  String toString() => 'CreateTherapistProfileDto[level=$level, type=$type, strengthLevel=$strengthLevel, commissionRate=$commissionRate, healthCheckDate=$healthCheckDate, skills=$skills, deviceProficiency=$deviceProficiency, licenseUrl=$licenseUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.level != null) {
      json[r'level'] = this.level;
    } else {
      json[r'level'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
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
      json[r'deviceProficiency'] = this.deviceProficiency;
    if (this.licenseUrl != null) {
      json[r'licenseUrl'] = this.licenseUrl;
    } else {
      json[r'licenseUrl'] = null;
    }
    return json;
  }

  /// Returns a new [CreateTherapistProfileDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateTherapistProfileDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateTherapistProfileDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateTherapistProfileDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateTherapistProfileDto(
        level: CreateTherapistProfileDtoLevelEnum.fromJson(json[r'level']),
        type: mapValueOfType<String>(json, r'type'),
        strengthLevel: CreateTherapistProfileDtoStrengthLevelEnum.fromJson(json[r'strengthLevel']),
        commissionRate: num.parse('${json[r'commissionRate']}'),
        healthCheckDate: mapValueOfType<String>(json, r'healthCheckDate'),
        skills: json[r'skills'] is Iterable
            ? (json[r'skills'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        deviceProficiency: json[r'deviceProficiency'] is Iterable
            ? (json[r'deviceProficiency'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        licenseUrl: mapValueOfType<String>(json, r'licenseUrl'),
      );
    }
    return null;
  }

  static List<CreateTherapistProfileDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateTherapistProfileDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateTherapistProfileDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateTherapistProfileDto> mapFromJson(dynamic json) {
    final map = <String, CreateTherapistProfileDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateTherapistProfileDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateTherapistProfileDto-objects as value to a dart map
  static Map<String, List<CreateTherapistProfileDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateTherapistProfileDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateTherapistProfileDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

/// Therapist level
class CreateTherapistProfileDtoLevelEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateTherapistProfileDtoLevelEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const JUNIOR = CreateTherapistProfileDtoLevelEnum._(r'JUNIOR');
  static const SENIOR = CreateTherapistProfileDtoLevelEnum._(r'SENIOR');
  static const MASTER = CreateTherapistProfileDtoLevelEnum._(r'MASTER');

  /// List of all possible values in this [enum][CreateTherapistProfileDtoLevelEnum].
  static const values = <CreateTherapistProfileDtoLevelEnum>[
    JUNIOR,
    SENIOR,
    MASTER,
  ];

  static CreateTherapistProfileDtoLevelEnum? fromJson(dynamic value) => CreateTherapistProfileDtoLevelEnumTypeTransformer().decode(value);

  static List<CreateTherapistProfileDtoLevelEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateTherapistProfileDtoLevelEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateTherapistProfileDtoLevelEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateTherapistProfileDtoLevelEnum] to String,
/// and [decode] dynamic data back to [CreateTherapistProfileDtoLevelEnum].
class CreateTherapistProfileDtoLevelEnumTypeTransformer {
  factory CreateTherapistProfileDtoLevelEnumTypeTransformer() => _instance ??= const CreateTherapistProfileDtoLevelEnumTypeTransformer._();

  const CreateTherapistProfileDtoLevelEnumTypeTransformer._();

  String encode(CreateTherapistProfileDtoLevelEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateTherapistProfileDtoLevelEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateTherapistProfileDtoLevelEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'JUNIOR': return CreateTherapistProfileDtoLevelEnum.JUNIOR;
        case r'SENIOR': return CreateTherapistProfileDtoLevelEnum.SENIOR;
        case r'MASTER': return CreateTherapistProfileDtoLevelEnum.MASTER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateTherapistProfileDtoLevelEnumTypeTransformer] instance.
  static CreateTherapistProfileDtoLevelEnumTypeTransformer? _instance;
}


/// Therapist strength level
class CreateTherapistProfileDtoStrengthLevelEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateTherapistProfileDtoStrengthLevelEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const SOFT = CreateTherapistProfileDtoStrengthLevelEnum._(r'SOFT');
  static const MEDIUM = CreateTherapistProfileDtoStrengthLevelEnum._(r'MEDIUM');
  static const STRONG = CreateTherapistProfileDtoStrengthLevelEnum._(r'STRONG');

  /// List of all possible values in this [enum][CreateTherapistProfileDtoStrengthLevelEnum].
  static const values = <CreateTherapistProfileDtoStrengthLevelEnum>[
    SOFT,
    MEDIUM,
    STRONG,
  ];

  static CreateTherapistProfileDtoStrengthLevelEnum? fromJson(dynamic value) => CreateTherapistProfileDtoStrengthLevelEnumTypeTransformer().decode(value);

  static List<CreateTherapistProfileDtoStrengthLevelEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateTherapistProfileDtoStrengthLevelEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateTherapistProfileDtoStrengthLevelEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateTherapistProfileDtoStrengthLevelEnum] to String,
/// and [decode] dynamic data back to [CreateTherapistProfileDtoStrengthLevelEnum].
class CreateTherapistProfileDtoStrengthLevelEnumTypeTransformer {
  factory CreateTherapistProfileDtoStrengthLevelEnumTypeTransformer() => _instance ??= const CreateTherapistProfileDtoStrengthLevelEnumTypeTransformer._();

  const CreateTherapistProfileDtoStrengthLevelEnumTypeTransformer._();

  String encode(CreateTherapistProfileDtoStrengthLevelEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateTherapistProfileDtoStrengthLevelEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateTherapistProfileDtoStrengthLevelEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'SOFT': return CreateTherapistProfileDtoStrengthLevelEnum.SOFT;
        case r'MEDIUM': return CreateTherapistProfileDtoStrengthLevelEnum.MEDIUM;
        case r'STRONG': return CreateTherapistProfileDtoStrengthLevelEnum.STRONG;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateTherapistProfileDtoStrengthLevelEnumTypeTransformer] instance.
  static CreateTherapistProfileDtoStrengthLevelEnumTypeTransformer? _instance;
}


