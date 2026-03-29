//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerDetailServiceManualDto {
  /// Returns a new [PartnerDetailServiceManualDto] instance.
  PartnerDetailServiceManualDto({
    this.preServiceGuidelines = const [],
    this.serviceRules = const [],
    this.procedureSteps = const [],
  });

  List<String> preServiceGuidelines;

  List<PartnerDetailServiceRuleDto> serviceRules;

  List<PartnerDetailProcedureStepDto> procedureSteps;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerDetailServiceManualDto &&
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
  String toString() => 'PartnerDetailServiceManualDto[preServiceGuidelines=$preServiceGuidelines, serviceRules=$serviceRules, procedureSteps=$procedureSteps]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'preServiceGuidelines'] = this.preServiceGuidelines;
      json[r'serviceRules'] = this.serviceRules;
      json[r'procedureSteps'] = this.procedureSteps;
    return json;
  }

  /// Returns a new [PartnerDetailServiceManualDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerDetailServiceManualDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerDetailServiceManualDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerDetailServiceManualDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerDetailServiceManualDto(
        preServiceGuidelines: json[r'preServiceGuidelines'] is Iterable
            ? (json[r'preServiceGuidelines'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        serviceRules: PartnerDetailServiceRuleDto.listFromJson(json[r'serviceRules']),
        procedureSteps: PartnerDetailProcedureStepDto.listFromJson(json[r'procedureSteps']),
      );
    }
    return null;
  }

  static List<PartnerDetailServiceManualDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerDetailServiceManualDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerDetailServiceManualDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerDetailServiceManualDto> mapFromJson(dynamic json) {
    final map = <String, PartnerDetailServiceManualDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerDetailServiceManualDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerDetailServiceManualDto-objects as value to a dart map
  static Map<String, List<PartnerDetailServiceManualDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerDetailServiceManualDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerDetailServiceManualDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

