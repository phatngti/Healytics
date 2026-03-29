//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ProcedureStepInputDto {
  /// Returns a new [ProcedureStepInputDto] instance.
  ProcedureStepInputDto({
    required this.stepNumber,
    required this.title,
    required this.description,
  });

  num stepNumber;

  String title;

  String description;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProcedureStepInputDto &&
    other.stepNumber == stepNumber &&
    other.title == title &&
    other.description == description;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (stepNumber.hashCode) +
    (title.hashCode) +
    (description.hashCode);

  @override
  String toString() => 'ProcedureStepInputDto[stepNumber=$stepNumber, title=$title, description=$description]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'stepNumber'] = this.stepNumber;
      json[r'title'] = this.title;
      json[r'description'] = this.description;
    return json;
  }

  /// Returns a new [ProcedureStepInputDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProcedureStepInputDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ProcedureStepInputDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ProcedureStepInputDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProcedureStepInputDto(
        stepNumber: num.parse('${json[r'stepNumber']}'),
        title: mapValueOfType<String>(json, r'title')!,
        description: mapValueOfType<String>(json, r'description')!,
      );
    }
    return null;
  }

  static List<ProcedureStepInputDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProcedureStepInputDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProcedureStepInputDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProcedureStepInputDto> mapFromJson(dynamic json) {
    final map = <String, ProcedureStepInputDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProcedureStepInputDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProcedureStepInputDto-objects as value to a dart map
  static Map<String, List<ProcedureStepInputDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProcedureStepInputDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProcedureStepInputDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'stepNumber',
    'title',
    'description',
  };
}

