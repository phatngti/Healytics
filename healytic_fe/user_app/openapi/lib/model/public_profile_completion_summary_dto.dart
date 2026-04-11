//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicProfileCompletionSummaryDto {
  /// Returns a new [PublicProfileCompletionSummaryDto] instance.
  PublicProfileCompletionSummaryDto({
    this.checklist = const [],
    required this.completionPercent,
    required this.isCompleted,
  });

  List<PublicProfileChecklistItemDto> checklist;

  num completionPercent;

  bool isCompleted;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicProfileCompletionSummaryDto &&
    _deepEquality.equals(other.checklist, checklist) &&
    other.completionPercent == completionPercent &&
    other.isCompleted == isCompleted;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (checklist.hashCode) +
    (completionPercent.hashCode) +
    (isCompleted.hashCode);

  @override
  String toString() => 'PublicProfileCompletionSummaryDto[checklist=$checklist, completionPercent=$completionPercent, isCompleted=$isCompleted]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'checklist'] = this.checklist;
      json[r'completionPercent'] = this.completionPercent;
      json[r'isCompleted'] = this.isCompleted;
    return json;
  }

  /// Returns a new [PublicProfileCompletionSummaryDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicProfileCompletionSummaryDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicProfileCompletionSummaryDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicProfileCompletionSummaryDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicProfileCompletionSummaryDto(
        checklist: PublicProfileChecklistItemDto.listFromJson(json[r'checklist']),
        completionPercent: num.parse('${json[r'completionPercent']}'),
        isCompleted: mapValueOfType<bool>(json, r'isCompleted')!,
      );
    }
    return null;
  }

  static List<PublicProfileCompletionSummaryDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicProfileCompletionSummaryDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicProfileCompletionSummaryDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicProfileCompletionSummaryDto> mapFromJson(dynamic json) {
    final map = <String, PublicProfileCompletionSummaryDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicProfileCompletionSummaryDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicProfileCompletionSummaryDto-objects as value to a dart map
  static Map<String, List<PublicProfileCompletionSummaryDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicProfileCompletionSummaryDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicProfileCompletionSummaryDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'checklist',
    'completionPercent',
    'isCompleted',
  };
}

