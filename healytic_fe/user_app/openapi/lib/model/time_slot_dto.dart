//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TimeSlotDto {
  /// Returns a new [TimeSlotDto] instance.
  TimeSlotDto({
    required this.label,
    required this.time,
    required this.isBusy,
  });


  /// Human-readable label in 12h format
  String label;

  /// Slot start time in HH:mm (24h) format
  String time;

  /// Whether the slot is free or busy
  TimeSlotDtoIsBusyEnum isBusy;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TimeSlotDto &&
    other.label == label &&
    other.time == time &&
    other.isBusy == isBusy;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (label.hashCode) +
    (time.hashCode) +
    (isBusy.hashCode);

  @override
  String toString() => 'TimeSlotDto[label=$label, time=$time, isBusy=$isBusy]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'label'] = this.label;
      json[r'time'] = this.time;
      json[r'isBusy'] = this.isBusy;
    return json;
  }

  /// Returns a new [TimeSlotDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TimeSlotDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TimeSlotDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TimeSlotDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TimeSlotDto(
        label: mapValueOfType<String>(json, r'label')!,
        time: mapValueOfType<String>(json, r'time')!,
        isBusy: TimeSlotDtoIsBusyEnum.fromJson(json[r'isBusy'])!,
      );
    }
    return null;
  }

  static List<TimeSlotDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TimeSlotDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TimeSlotDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TimeSlotDto> mapFromJson(dynamic json) {
    final map = <String, TimeSlotDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TimeSlotDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TimeSlotDto-objects as value to a dart map
  static Map<String, List<TimeSlotDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TimeSlotDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TimeSlotDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'label',
    'time',
    'isBusy',
  };
}

/// Whether the slot is free or busy
class TimeSlotDtoIsBusyEnum {
  /// Instantiate a new enum with the provided [value].
  const TimeSlotDtoIsBusyEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const free = TimeSlotDtoIsBusyEnum._(r'free');
  static const busy = TimeSlotDtoIsBusyEnum._(r'busy');

  /// List of all possible values in this [enum][TimeSlotDtoIsBusyEnum].
  static const values = <TimeSlotDtoIsBusyEnum>[
    free,
    busy,
  ];

  static TimeSlotDtoIsBusyEnum? fromJson(dynamic value) => TimeSlotDtoIsBusyEnumTypeTransformer().decode(value);

  static List<TimeSlotDtoIsBusyEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TimeSlotDtoIsBusyEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TimeSlotDtoIsBusyEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TimeSlotDtoIsBusyEnum] to String,
/// and [decode] dynamic data back to [TimeSlotDtoIsBusyEnum].
class TimeSlotDtoIsBusyEnumTypeTransformer {
  factory TimeSlotDtoIsBusyEnumTypeTransformer() => _instance ??= const TimeSlotDtoIsBusyEnumTypeTransformer._();

  const TimeSlotDtoIsBusyEnumTypeTransformer._();

  String encode(TimeSlotDtoIsBusyEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a TimeSlotDtoIsBusyEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TimeSlotDtoIsBusyEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'free': return TimeSlotDtoIsBusyEnum.free;
        case r'busy': return TimeSlotDtoIsBusyEnum.busy;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TimeSlotDtoIsBusyEnumTypeTransformer] instance.
  static TimeSlotDtoIsBusyEnumTypeTransformer? _instance;
}


