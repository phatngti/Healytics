//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TherapistProfileDto {
  /// Returns a new [TherapistProfileDto] instance.
  TherapistProfileDto({
    this.level,
    this.type,
    this.strengthLevel,
    this.commissionRate,
    this.healthCheckDate,
    this.skills = const [],
  });

  /// Therapist level
  TherapistProfileDtoLevelEnum? level;

  /// Type of therapist (SPA, MASSAGE)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? type;

  /// Therapist strength level for massage
  TherapistProfileDtoStrengthLevelEnum? strengthLevel;

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

  @override
  bool operator ==(Object other) => identical(this, other) || other is TherapistProfileDto &&
    other.level == level &&
    other.type == type &&
    other.strengthLevel == strengthLevel &&
    other.commissionRate == commissionRate &&
    other.healthCheckDate == healthCheckDate &&
    _deepEquality.equals(other.skills, skills);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (level == null ? 0 : level!.hashCode) +
    (type == null ? 0 : type!.hashCode) +
    (strengthLevel == null ? 0 : strengthLevel!.hashCode) +
    (commissionRate == null ? 0 : commissionRate!.hashCode) +
    (healthCheckDate == null ? 0 : healthCheckDate!.hashCode) +
    (skills.hashCode);

  @override
  String toString() => 'TherapistProfileDto[level=$level, type=$type, strengthLevel=$strengthLevel, commissionRate=$commissionRate, healthCheckDate=$healthCheckDate, skills=$skills]';

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
    return json;
  }

  /// Returns a new [TherapistProfileDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TherapistProfileDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TherapistProfileDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TherapistProfileDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TherapistProfileDto(
        level: TherapistProfileDtoLevelEnum.fromJson(json[r'level']),
        type: mapValueOfType<String>(json, r'type'),
        strengthLevel: TherapistProfileDtoStrengthLevelEnum.fromJson(json[r'strengthLevel']),
        commissionRate: num.parse('${json[r'commissionRate']}'),
        healthCheckDate: mapValueOfType<String>(json, r'healthCheckDate'),
        skills: json[r'skills'] is Iterable
            ? (json[r'skills'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<TherapistProfileDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TherapistProfileDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TherapistProfileDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TherapistProfileDto> mapFromJson(dynamic json) {
    final map = <String, TherapistProfileDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TherapistProfileDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TherapistProfileDto-objects as value to a dart map
  static Map<String, List<TherapistProfileDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TherapistProfileDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TherapistProfileDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

/// Therapist level
class TherapistProfileDtoLevelEnum {
  /// Instantiate a new enum with the provided [value].
  const TherapistProfileDtoLevelEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const JUNIOR = TherapistProfileDtoLevelEnum._(r'JUNIOR');
  static const SENIOR = TherapistProfileDtoLevelEnum._(r'SENIOR');
  static const MASTER = TherapistProfileDtoLevelEnum._(r'MASTER');

  /// List of all possible values in this [enum][TherapistProfileDtoLevelEnum].
  static const values = <TherapistProfileDtoLevelEnum>[
    JUNIOR,
    SENIOR,
    MASTER,
  ];

  static TherapistProfileDtoLevelEnum? fromJson(dynamic value) => TherapistProfileDtoLevelEnumTypeTransformer().decode(value);

  static List<TherapistProfileDtoLevelEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TherapistProfileDtoLevelEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TherapistProfileDtoLevelEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TherapistProfileDtoLevelEnum] to String,
/// and [decode] dynamic data back to [TherapistProfileDtoLevelEnum].
class TherapistProfileDtoLevelEnumTypeTransformer {
  factory TherapistProfileDtoLevelEnumTypeTransformer() => _instance ??= const TherapistProfileDtoLevelEnumTypeTransformer._();

  const TherapistProfileDtoLevelEnumTypeTransformer._();

  String encode(TherapistProfileDtoLevelEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a TherapistProfileDtoLevelEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TherapistProfileDtoLevelEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'JUNIOR': return TherapistProfileDtoLevelEnum.JUNIOR;
        case r'SENIOR': return TherapistProfileDtoLevelEnum.SENIOR;
        case r'MASTER': return TherapistProfileDtoLevelEnum.MASTER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TherapistProfileDtoLevelEnumTypeTransformer] instance.
  static TherapistProfileDtoLevelEnumTypeTransformer? _instance;
}


/// Therapist strength level for massage
class TherapistProfileDtoStrengthLevelEnum {
  /// Instantiate a new enum with the provided [value].
  const TherapistProfileDtoStrengthLevelEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const SOFT = TherapistProfileDtoStrengthLevelEnum._(r'SOFT');
  static const MEDIUM = TherapistProfileDtoStrengthLevelEnum._(r'MEDIUM');
  static const STRONG = TherapistProfileDtoStrengthLevelEnum._(r'STRONG');

  /// List of all possible values in this [enum][TherapistProfileDtoStrengthLevelEnum].
  static const values = <TherapistProfileDtoStrengthLevelEnum>[
    SOFT,
    MEDIUM,
    STRONG,
  ];

  static TherapistProfileDtoStrengthLevelEnum? fromJson(dynamic value) => TherapistProfileDtoStrengthLevelEnumTypeTransformer().decode(value);

  static List<TherapistProfileDtoStrengthLevelEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TherapistProfileDtoStrengthLevelEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TherapistProfileDtoStrengthLevelEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TherapistProfileDtoStrengthLevelEnum] to String,
/// and [decode] dynamic data back to [TherapistProfileDtoStrengthLevelEnum].
class TherapistProfileDtoStrengthLevelEnumTypeTransformer {
  factory TherapistProfileDtoStrengthLevelEnumTypeTransformer() => _instance ??= const TherapistProfileDtoStrengthLevelEnumTypeTransformer._();

  const TherapistProfileDtoStrengthLevelEnumTypeTransformer._();

  String encode(TherapistProfileDtoStrengthLevelEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a TherapistProfileDtoStrengthLevelEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TherapistProfileDtoStrengthLevelEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'SOFT': return TherapistProfileDtoStrengthLevelEnum.SOFT;
        case r'MEDIUM': return TherapistProfileDtoStrengthLevelEnum.MEDIUM;
        case r'STRONG': return TherapistProfileDtoStrengthLevelEnum.STRONG;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TherapistProfileDtoStrengthLevelEnumTypeTransformer] instance.
  static TherapistProfileDtoStrengthLevelEnumTypeTransformer? _instance;
}


