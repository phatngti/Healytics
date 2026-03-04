//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerDayScheduleDto {
  /// Returns a new [PartnerDayScheduleDto] instance.
  PartnerDayScheduleDto({
    required this.day,
    required this.date,
    this.slots = const [],
  });

  String day;

  String date;

  List<PartnerTimeSlotDto> slots;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerDayScheduleDto &&
    other.day == day &&
    other.date == date &&
    _deepEquality.equals(other.slots, slots);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (day.hashCode) +
    (date.hashCode) +
    (slots.hashCode);

  @override
  String toString() => 'PartnerDayScheduleDto[day=$day, date=$date, slots=$slots]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'day'] = this.day;
      json[r'date'] = this.date;
      json[r'slots'] = this.slots;
    return json;
  }

  /// Returns a new [PartnerDayScheduleDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerDayScheduleDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerDayScheduleDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerDayScheduleDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerDayScheduleDto(
        day: mapValueOfType<String>(json, r'day')!,
        date: mapValueOfType<String>(json, r'date')!,
        slots: PartnerTimeSlotDto.listFromJson(json[r'slots']),
      );
    }
    return null;
  }

  static List<PartnerDayScheduleDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerDayScheduleDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerDayScheduleDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerDayScheduleDto> mapFromJson(dynamic json) {
    final map = <String, PartnerDayScheduleDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerDayScheduleDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerDayScheduleDto-objects as value to a dart map
  static Map<String, List<PartnerDayScheduleDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerDayScheduleDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerDayScheduleDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'day',
    'date',
    'slots',
  };
}

