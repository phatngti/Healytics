//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ProcedureStepDto {
  /// Returns a new [ProcedureStepDto] instance.
  ProcedureStepDto({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.isActive,
  });


  num stepNumber;

  String title;

  String description;

  bool isActive;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProcedureStepDto &&
    other.stepNumber == stepNumber &&
    other.title == title &&
    other.description == description &&
    other.isActive == isActive;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (stepNumber.hashCode) +
    (title.hashCode) +
    (description.hashCode) +
    (isActive.hashCode);

  @override
  String toString() => 'ProcedureStepDto[stepNumber=$stepNumber, title=$title, description=$description, isActive=$isActive]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'stepNumber'] = this.stepNumber;
      json[r'title'] = this.title;
      json[r'description'] = this.description;
      json[r'isActive'] = this.isActive;
    return json;
  }

  /// Returns a new [ProcedureStepDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProcedureStepDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ProcedureStepDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ProcedureStepDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProcedureStepDto(
        stepNumber: num.parse('${json[r'stepNumber']}'),
        title: mapValueOfType<String>(json, r'title')!,
        description: mapValueOfType<String>(json, r'description')!,
        isActive: mapValueOfType<bool>(json, r'isActive')!,
      );
    }
    return null;
  }

  static List<ProcedureStepDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProcedureStepDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProcedureStepDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProcedureStepDto> mapFromJson(dynamic json) {
    final map = <String, ProcedureStepDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProcedureStepDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProcedureStepDto-objects as value to a dart map
  static Map<String, List<ProcedureStepDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProcedureStepDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProcedureStepDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'stepNumber',
    'title',
    'description',
    'isActive',
  };
}

