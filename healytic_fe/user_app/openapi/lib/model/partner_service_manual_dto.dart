//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerServiceManualDto {
  /// Returns a new [PartnerServiceManualDto] instance.
  PartnerServiceManualDto({
    this.preServiceGuidelines = const [],
    this.serviceRules = const [],
    this.procedureSteps = const [],
  });


  List<String> preServiceGuidelines;

  List<PartnerServiceRuleDto> serviceRules;

  List<PartnerProcedureStepDto> procedureSteps;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerServiceManualDto &&
    _deepEquality.equals(other.preServiceGuidelines, preServiceGuidelines) &&
    _deepEquality.equals(other.serviceRules, serviceRules) &&
    _deepEquality.equals(other.procedureSteps, procedureSteps);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (preServiceGuidelines.hashCode) +
    (serviceRules.hashCode) +
    (procedureSteps.hashCode);

  @override
  String toString() => 'PartnerServiceManualDto[preServiceGuidelines=$preServiceGuidelines, serviceRules=$serviceRules, procedureSteps=$procedureSteps]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'preServiceGuidelines'] = this.preServiceGuidelines;
      json[r'serviceRules'] = this.serviceRules;
      json[r'procedureSteps'] = this.procedureSteps;
    return json;
  }

  /// Returns a new [PartnerServiceManualDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerServiceManualDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerServiceManualDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerServiceManualDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerServiceManualDto(
        preServiceGuidelines: json[r'preServiceGuidelines'] is Iterable
            ? (json[r'preServiceGuidelines'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        serviceRules: PartnerServiceRuleDto.listFromJson(json[r'serviceRules']),
        procedureSteps: PartnerProcedureStepDto.listFromJson(json[r'procedureSteps']),
      );
    }
    return null;
  }

  static List<PartnerServiceManualDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerServiceManualDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerServiceManualDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerServiceManualDto> mapFromJson(dynamic json) {
    final map = <String, PartnerServiceManualDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerServiceManualDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerServiceManualDto-objects as value to a dart map
  static Map<String, List<PartnerServiceManualDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerServiceManualDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerServiceManualDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

