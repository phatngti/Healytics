//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WorkHistoryEntryDto {
  /// Returns a new [WorkHistoryEntryDto] instance.
  WorkHistoryEntryDto({
    required this.facility,
    required this.position,
    required this.period,
    required this.isCurrent,
  });

  /// Facility or organization name
  String facility;

  /// Position or role held
  String position;

  /// Employment period
  String period;

  /// Whether this is the current position
  bool isCurrent;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WorkHistoryEntryDto &&
    other.facility == facility &&
    other.position == position &&
    other.period == period &&
    other.isCurrent == isCurrent;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (facility.hashCode) +
    (position.hashCode) +
    (period.hashCode) +
    (isCurrent.hashCode);

  @override
  String toString() => 'WorkHistoryEntryDto[facility=$facility, position=$position, period=$period, isCurrent=$isCurrent]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'facility'] = this.facility;
      json[r'position'] = this.position;
      json[r'period'] = this.period;
      json[r'isCurrent'] = this.isCurrent;
    return json;
  }

  /// Returns a new [WorkHistoryEntryDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WorkHistoryEntryDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "WorkHistoryEntryDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "WorkHistoryEntryDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return WorkHistoryEntryDto(
        facility: mapValueOfType<String>(json, r'facility')!,
        position: mapValueOfType<String>(json, r'position')!,
        period: mapValueOfType<String>(json, r'period')!,
        isCurrent: mapValueOfType<bool>(json, r'isCurrent')!,
      );
    }
    return null;
  }

  static List<WorkHistoryEntryDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WorkHistoryEntryDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WorkHistoryEntryDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WorkHistoryEntryDto> mapFromJson(dynamic json) {
    final map = <String, WorkHistoryEntryDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WorkHistoryEntryDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WorkHistoryEntryDto-objects as value to a dart map
  static Map<String, List<WorkHistoryEntryDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WorkHistoryEntryDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WorkHistoryEntryDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'facility',
    'position',
    'period',
    'isCurrent',
  };
}

