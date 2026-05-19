//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerBookingSlotDto {
  /// Returns a new [PartnerBookingSlotDto] instance.
  PartnerBookingSlotDto({
    required this.start,
    required this.end,
  });


  DateTime start;

  DateTime end;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerBookingSlotDto &&
    other.start == start &&
    other.end == end;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (start.hashCode) +
    (end.hashCode);

  @override
  String toString() => 'PartnerBookingSlotDto[start=$start, end=$end]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'start'] = this.start.toUtc().toIso8601String();
      json[r'end'] = this.end.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [PartnerBookingSlotDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerBookingSlotDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerBookingSlotDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerBookingSlotDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerBookingSlotDto(
        start: mapDateTime(json, r'start', r'')!,
        end: mapDateTime(json, r'end', r'')!,
      );
    }
    return null;
  }

  static List<PartnerBookingSlotDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerBookingSlotDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerBookingSlotDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerBookingSlotDto> mapFromJson(dynamic json) {
    final map = <String, PartnerBookingSlotDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerBookingSlotDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerBookingSlotDto-objects as value to a dart map
  static Map<String, List<PartnerBookingSlotDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerBookingSlotDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerBookingSlotDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'start',
    'end',
  };
}

