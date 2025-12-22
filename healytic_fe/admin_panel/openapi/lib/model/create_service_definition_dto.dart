//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateServiceDefinitionDto {
  /// Returns a new [CreateServiceDefinitionDto] instance.
  CreateServiceDefinitionDto({
    required this.durationMinutes,
    this.bufferMinutes,
    this.maxCapacity,
    this.minLeadTimeHours,
    this.availabilityMode,
    this.staffAssignmentType,
  });

  /// Duration in minutes
  num durationMinutes;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? bufferMinutes;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? maxCapacity;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? minLeadTimeHours;

  CreateServiceDefinitionDtoAvailabilityModeEnum? availabilityMode;

  CreateServiceDefinitionDtoStaffAssignmentTypeEnum? staffAssignmentType;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateServiceDefinitionDto &&
    other.durationMinutes == durationMinutes &&
    other.bufferMinutes == bufferMinutes &&
    other.maxCapacity == maxCapacity &&
    other.minLeadTimeHours == minLeadTimeHours &&
    other.availabilityMode == availabilityMode &&
    other.staffAssignmentType == staffAssignmentType;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (durationMinutes.hashCode) +
    (bufferMinutes == null ? 0 : bufferMinutes!.hashCode) +
    (maxCapacity == null ? 0 : maxCapacity!.hashCode) +
    (minLeadTimeHours == null ? 0 : minLeadTimeHours!.hashCode) +
    (availabilityMode == null ? 0 : availabilityMode!.hashCode) +
    (staffAssignmentType == null ? 0 : staffAssignmentType!.hashCode);

  @override
  String toString() => 'CreateServiceDefinitionDto[durationMinutes=$durationMinutes, bufferMinutes=$bufferMinutes, maxCapacity=$maxCapacity, minLeadTimeHours=$minLeadTimeHours, availabilityMode=$availabilityMode, staffAssignmentType=$staffAssignmentType]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'durationMinutes'] = this.durationMinutes;
    if (this.bufferMinutes != null) {
      json[r'bufferMinutes'] = this.bufferMinutes;
    } else {
      json[r'bufferMinutes'] = null;
    }
    if (this.maxCapacity != null) {
      json[r'maxCapacity'] = this.maxCapacity;
    } else {
      json[r'maxCapacity'] = null;
    }
    if (this.minLeadTimeHours != null) {
      json[r'minLeadTimeHours'] = this.minLeadTimeHours;
    } else {
      json[r'minLeadTimeHours'] = null;
    }
    if (this.availabilityMode != null) {
      json[r'availabilityMode'] = this.availabilityMode;
    } else {
      json[r'availabilityMode'] = null;
    }
    if (this.staffAssignmentType != null) {
      json[r'staffAssignmentType'] = this.staffAssignmentType;
    } else {
      json[r'staffAssignmentType'] = null;
    }
    return json;
  }

  /// Returns a new [CreateServiceDefinitionDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateServiceDefinitionDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateServiceDefinitionDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateServiceDefinitionDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateServiceDefinitionDto(
        durationMinutes: num.parse('${json[r'durationMinutes']}'),
        bufferMinutes: num.parse('${json[r'bufferMinutes']}'),
        maxCapacity: num.parse('${json[r'maxCapacity']}'),
        minLeadTimeHours: num.parse('${json[r'minLeadTimeHours']}'),
        availabilityMode: CreateServiceDefinitionDtoAvailabilityModeEnum.fromJson(json[r'availabilityMode']),
        staffAssignmentType: CreateServiceDefinitionDtoStaffAssignmentTypeEnum.fromJson(json[r'staffAssignmentType']),
      );
    }
    return null;
  }

  static List<CreateServiceDefinitionDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateServiceDefinitionDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateServiceDefinitionDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateServiceDefinitionDto> mapFromJson(dynamic json) {
    final map = <String, CreateServiceDefinitionDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateServiceDefinitionDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateServiceDefinitionDto-objects as value to a dart map
  static Map<String, List<CreateServiceDefinitionDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateServiceDefinitionDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateServiceDefinitionDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'durationMinutes',
  };
}


class CreateServiceDefinitionDtoAvailabilityModeEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateServiceDefinitionDtoAvailabilityModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const businessHours = CreateServiceDefinitionDtoAvailabilityModeEnum._(r'business_hours');
  static const custom = CreateServiceDefinitionDtoAvailabilityModeEnum._(r'custom');

  /// List of all possible values in this [enum][CreateServiceDefinitionDtoAvailabilityModeEnum].
  static const values = <CreateServiceDefinitionDtoAvailabilityModeEnum>[
    businessHours,
    custom,
  ];

  static CreateServiceDefinitionDtoAvailabilityModeEnum? fromJson(dynamic value) => CreateServiceDefinitionDtoAvailabilityModeEnumTypeTransformer().decode(value);

  static List<CreateServiceDefinitionDtoAvailabilityModeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateServiceDefinitionDtoAvailabilityModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateServiceDefinitionDtoAvailabilityModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateServiceDefinitionDtoAvailabilityModeEnum] to String,
/// and [decode] dynamic data back to [CreateServiceDefinitionDtoAvailabilityModeEnum].
class CreateServiceDefinitionDtoAvailabilityModeEnumTypeTransformer {
  factory CreateServiceDefinitionDtoAvailabilityModeEnumTypeTransformer() => _instance ??= const CreateServiceDefinitionDtoAvailabilityModeEnumTypeTransformer._();

  const CreateServiceDefinitionDtoAvailabilityModeEnumTypeTransformer._();

  String encode(CreateServiceDefinitionDtoAvailabilityModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateServiceDefinitionDtoAvailabilityModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateServiceDefinitionDtoAvailabilityModeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'business_hours': return CreateServiceDefinitionDtoAvailabilityModeEnum.businessHours;
        case r'custom': return CreateServiceDefinitionDtoAvailabilityModeEnum.custom;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateServiceDefinitionDtoAvailabilityModeEnumTypeTransformer] instance.
  static CreateServiceDefinitionDtoAvailabilityModeEnumTypeTransformer? _instance;
}



class CreateServiceDefinitionDtoStaffAssignmentTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateServiceDefinitionDtoStaffAssignmentTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const any = CreateServiceDefinitionDtoStaffAssignmentTypeEnum._(r'any');
  static const specific = CreateServiceDefinitionDtoStaffAssignmentTypeEnum._(r'specific');

  /// List of all possible values in this [enum][CreateServiceDefinitionDtoStaffAssignmentTypeEnum].
  static const values = <CreateServiceDefinitionDtoStaffAssignmentTypeEnum>[
    any,
    specific,
  ];

  static CreateServiceDefinitionDtoStaffAssignmentTypeEnum? fromJson(dynamic value) => CreateServiceDefinitionDtoStaffAssignmentTypeEnumTypeTransformer().decode(value);

  static List<CreateServiceDefinitionDtoStaffAssignmentTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateServiceDefinitionDtoStaffAssignmentTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateServiceDefinitionDtoStaffAssignmentTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateServiceDefinitionDtoStaffAssignmentTypeEnum] to String,
/// and [decode] dynamic data back to [CreateServiceDefinitionDtoStaffAssignmentTypeEnum].
class CreateServiceDefinitionDtoStaffAssignmentTypeEnumTypeTransformer {
  factory CreateServiceDefinitionDtoStaffAssignmentTypeEnumTypeTransformer() => _instance ??= const CreateServiceDefinitionDtoStaffAssignmentTypeEnumTypeTransformer._();

  const CreateServiceDefinitionDtoStaffAssignmentTypeEnumTypeTransformer._();

  String encode(CreateServiceDefinitionDtoStaffAssignmentTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateServiceDefinitionDtoStaffAssignmentTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateServiceDefinitionDtoStaffAssignmentTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'any': return CreateServiceDefinitionDtoStaffAssignmentTypeEnum.any;
        case r'specific': return CreateServiceDefinitionDtoStaffAssignmentTypeEnum.specific;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateServiceDefinitionDtoStaffAssignmentTypeEnumTypeTransformer] instance.
  static CreateServiceDefinitionDtoStaffAssignmentTypeEnumTypeTransformer? _instance;
}


