//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BookingScheduleDto {
  /// Returns a new [BookingScheduleDto] instance.
  BookingScheduleDto({
    this.date,
    this.timeSlotLabel,
  });


  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? date;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? timeSlotLabel;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BookingScheduleDto &&
    other.date == date &&
    other.timeSlotLabel == timeSlotLabel;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (date == null ? 0 : date!.hashCode) +
    (timeSlotLabel == null ? 0 : timeSlotLabel!.hashCode);

  @override
  String toString() => 'BookingScheduleDto[date=$date, timeSlotLabel=$timeSlotLabel]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.date != null) {
      json[r'date'] = this.date;
    } else {
      json[r'date'] = null;
    }
    if (this.timeSlotLabel != null) {
      json[r'timeSlotLabel'] = this.timeSlotLabel;
    } else {
      json[r'timeSlotLabel'] = null;
    }
    return json;
  }

  /// Returns a new [BookingScheduleDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BookingScheduleDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BookingScheduleDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BookingScheduleDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BookingScheduleDto(
        date: mapValueOfType<Object>(json, r'date'),
        timeSlotLabel: mapValueOfType<Object>(json, r'timeSlotLabel'),
      );
    }
    return null;
  }

  static List<BookingScheduleDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BookingScheduleDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BookingScheduleDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BookingScheduleDto> mapFromJson(dynamic json) {
    final map = <String, BookingScheduleDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BookingScheduleDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BookingScheduleDto-objects as value to a dart map
  static Map<String, List<BookingScheduleDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BookingScheduleDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BookingScheduleDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

