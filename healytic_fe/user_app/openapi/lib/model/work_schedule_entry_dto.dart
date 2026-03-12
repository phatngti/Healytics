//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WorkScheduleEntryDto {
  /// Returns a new [WorkScheduleEntryDto] instance.
  WorkScheduleEntryDto({
    required this.day,
    this.start,
    this.end,
    required this.isWorking,
  });

  /// Day of the week
  WorkScheduleEntryDtoDayEnum day;

  /// Work start time in HH:mm format. Empty string if not working.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? start;

  /// Work end time in HH:mm format. Empty string if not working.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? end;

  /// Whether the employee is working on this day.
  bool isWorking;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WorkScheduleEntryDto &&
    other.day == day &&
    other.start == start &&
    other.end == end &&
    other.isWorking == isWorking;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (day.hashCode) +
    (start == null ? 0 : start!.hashCode) +
    (end == null ? 0 : end!.hashCode) +
    (isWorking.hashCode);

  @override
  String toString() => 'WorkScheduleEntryDto[day=$day, start=$start, end=$end, isWorking=$isWorking]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'day'] = this.day;
    if (this.start != null) {
      json[r'start'] = this.start;
    } else {
      json[r'start'] = null;
    }
    if (this.end != null) {
      json[r'end'] = this.end;
    } else {
      json[r'end'] = null;
    }
      json[r'isWorking'] = this.isWorking;
    return json;
  }

  /// Returns a new [WorkScheduleEntryDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WorkScheduleEntryDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "WorkScheduleEntryDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "WorkScheduleEntryDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return WorkScheduleEntryDto(
        day: WorkScheduleEntryDtoDayEnum.fromJson(json[r'day'])!,
        start: mapValueOfType<String>(json, r'start'),
        end: mapValueOfType<String>(json, r'end'),
        isWorking: mapValueOfType<bool>(json, r'isWorking')!,
      );
    }
    return null;
  }

  static List<WorkScheduleEntryDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WorkScheduleEntryDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WorkScheduleEntryDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WorkScheduleEntryDto> mapFromJson(dynamic json) {
    final map = <String, WorkScheduleEntryDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WorkScheduleEntryDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WorkScheduleEntryDto-objects as value to a dart map
  static Map<String, List<WorkScheduleEntryDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WorkScheduleEntryDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WorkScheduleEntryDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'day',
    'isWorking',
  };
}

/// Day of the week
class WorkScheduleEntryDtoDayEnum {
  /// Instantiate a new enum with the provided [value].
  const WorkScheduleEntryDtoDayEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const monday = WorkScheduleEntryDtoDayEnum._(r'Monday');
  static const tuesday = WorkScheduleEntryDtoDayEnum._(r'Tuesday');
  static const wednesday = WorkScheduleEntryDtoDayEnum._(r'Wednesday');
  static const thursday = WorkScheduleEntryDtoDayEnum._(r'Thursday');
  static const friday = WorkScheduleEntryDtoDayEnum._(r'Friday');
  static const saturday = WorkScheduleEntryDtoDayEnum._(r'Saturday');
  static const sunday = WorkScheduleEntryDtoDayEnum._(r'Sunday');

  /// List of all possible values in this [enum][WorkScheduleEntryDtoDayEnum].
  static const values = <WorkScheduleEntryDtoDayEnum>[
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday,
  ];

  static WorkScheduleEntryDtoDayEnum? fromJson(dynamic value) => WorkScheduleEntryDtoDayEnumTypeTransformer().decode(value);

  static List<WorkScheduleEntryDtoDayEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WorkScheduleEntryDtoDayEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WorkScheduleEntryDtoDayEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [WorkScheduleEntryDtoDayEnum] to String,
/// and [decode] dynamic data back to [WorkScheduleEntryDtoDayEnum].
class WorkScheduleEntryDtoDayEnumTypeTransformer {
  factory WorkScheduleEntryDtoDayEnumTypeTransformer() => _instance ??= const WorkScheduleEntryDtoDayEnumTypeTransformer._();

  const WorkScheduleEntryDtoDayEnumTypeTransformer._();

  String encode(WorkScheduleEntryDtoDayEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a WorkScheduleEntryDtoDayEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  WorkScheduleEntryDtoDayEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'Monday': return WorkScheduleEntryDtoDayEnum.monday;
        case r'Tuesday': return WorkScheduleEntryDtoDayEnum.tuesday;
        case r'Wednesday': return WorkScheduleEntryDtoDayEnum.wednesday;
        case r'Thursday': return WorkScheduleEntryDtoDayEnum.thursday;
        case r'Friday': return WorkScheduleEntryDtoDayEnum.friday;
        case r'Saturday': return WorkScheduleEntryDtoDayEnum.saturday;
        case r'Sunday': return WorkScheduleEntryDtoDayEnum.sunday;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [WorkScheduleEntryDtoDayEnumTypeTransformer] instance.
  static WorkScheduleEntryDtoDayEnumTypeTransformer? _instance;
}


