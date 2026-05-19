//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdatePartnerHealthServiceDefinitionDto {
  /// Returns a new [UpdatePartnerHealthServiceDefinitionDto] instance.
  UpdatePartnerHealthServiceDefinitionDto({
    this.durationMinutes,
    this.bufferMinutes,
    this.maxCapacity,
    this.minLeadTimeHours,
    this.staffAssignmentType,
  });


  /// Duration in minutes
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? durationMinutes;

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

  UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum? staffAssignmentType;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdatePartnerHealthServiceDefinitionDto &&
    other.durationMinutes == durationMinutes &&
    other.bufferMinutes == bufferMinutes &&
    other.maxCapacity == maxCapacity &&
    other.minLeadTimeHours == minLeadTimeHours &&
    other.staffAssignmentType == staffAssignmentType;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (durationMinutes == null ? 0 : durationMinutes!.hashCode) +
    (bufferMinutes == null ? 0 : bufferMinutes!.hashCode) +
    (maxCapacity == null ? 0 : maxCapacity!.hashCode) +
    (minLeadTimeHours == null ? 0 : minLeadTimeHours!.hashCode) +
    (staffAssignmentType == null ? 0 : staffAssignmentType!.hashCode);

  @override
  String toString() => 'UpdatePartnerHealthServiceDefinitionDto[durationMinutes=$durationMinutes, bufferMinutes=$bufferMinutes, maxCapacity=$maxCapacity, minLeadTimeHours=$minLeadTimeHours, staffAssignmentType=$staffAssignmentType]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.durationMinutes != null) {
      json[r'durationMinutes'] = this.durationMinutes;
    } else {
      json[r'durationMinutes'] = null;
    }
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
    if (this.staffAssignmentType != null) {
      json[r'staffAssignmentType'] = this.staffAssignmentType;
    } else {
      json[r'staffAssignmentType'] = null;
    }
    return json;
  }

  /// Returns a new [UpdatePartnerHealthServiceDefinitionDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdatePartnerHealthServiceDefinitionDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdatePartnerHealthServiceDefinitionDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdatePartnerHealthServiceDefinitionDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdatePartnerHealthServiceDefinitionDto(
        durationMinutes: num.parse('${json[r'durationMinutes']}'),
        bufferMinutes: num.parse('${json[r'bufferMinutes']}'),
        maxCapacity: num.parse('${json[r'maxCapacity']}'),
        minLeadTimeHours: num.parse('${json[r'minLeadTimeHours']}'),
        staffAssignmentType: UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum.fromJson(json[r'staffAssignmentType']),
      );
    }
    return null;
  }

  static List<UpdatePartnerHealthServiceDefinitionDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdatePartnerHealthServiceDefinitionDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdatePartnerHealthServiceDefinitionDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdatePartnerHealthServiceDefinitionDto> mapFromJson(dynamic json) {
    final map = <String, UpdatePartnerHealthServiceDefinitionDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdatePartnerHealthServiceDefinitionDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdatePartnerHealthServiceDefinitionDto-objects as value to a dart map
  static Map<String, List<UpdatePartnerHealthServiceDefinitionDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdatePartnerHealthServiceDefinitionDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdatePartnerHealthServiceDefinitionDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const any = UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum._(r'any');
  static const specific = UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum._(r'specific');

  /// List of all possible values in this [enum][UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum].
  static const values = <UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum>[
    any,
    specific,
  ];

  static UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum? fromJson(dynamic value) => UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnumTypeTransformer().decode(value);

  static List<UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum] to String,
/// and [decode] dynamic data back to [UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum].
class UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnumTypeTransformer {
  factory UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnumTypeTransformer() => _instance ??= const UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnumTypeTransformer._();

  const UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnumTypeTransformer._();

  String encode(UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'any': return UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum.any;
        case r'specific': return UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum.specific;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnumTypeTransformer] instance.
  static UpdatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnumTypeTransformer? _instance;
}


