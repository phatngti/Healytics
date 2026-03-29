//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ServiceManualResponseDto {
  /// Returns a new [ServiceManualResponseDto] instance.
  ServiceManualResponseDto({
    required this.serviceName,
    required this.vendorName,
    required this.imageUrl,
    this.preServiceGuidelines = const [],
    this.serviceRules = const [],
    this.procedureSteps = const [],
    this.facilities = const [],
    this.review,
  });

  String serviceName;

  String vendorName;

  String imageUrl;

  List<String> preServiceGuidelines;

  List<ServiceRuleDto> serviceRules;

  List<ProcedureStepDto> procedureSteps;

  List<FacilityDto> facilities;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ReviewSummaryDto? review;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ServiceManualResponseDto &&
    other.serviceName == serviceName &&
    other.vendorName == vendorName &&
    other.imageUrl == imageUrl &&
    _deepEquality.equals(other.preServiceGuidelines, preServiceGuidelines) &&
    _deepEquality.equals(other.serviceRules, serviceRules) &&
    _deepEquality.equals(other.procedureSteps, procedureSteps) &&
    _deepEquality.equals(other.facilities, facilities) &&
    other.review == review;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (serviceName.hashCode) +
    (vendorName.hashCode) +
    (imageUrl.hashCode) +
    (preServiceGuidelines.hashCode) +
    (serviceRules.hashCode) +
    (procedureSteps.hashCode) +
    (facilities.hashCode) +
    (review == null ? 0 : review!.hashCode);

  @override
  String toString() => 'ServiceManualResponseDto[serviceName=$serviceName, vendorName=$vendorName, imageUrl=$imageUrl, preServiceGuidelines=$preServiceGuidelines, serviceRules=$serviceRules, procedureSteps=$procedureSteps, facilities=$facilities, review=$review]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'serviceName'] = this.serviceName;
      json[r'vendorName'] = this.vendorName;
      json[r'imageUrl'] = this.imageUrl;
      json[r'preServiceGuidelines'] = this.preServiceGuidelines;
      json[r'serviceRules'] = this.serviceRules;
      json[r'procedureSteps'] = this.procedureSteps;
      json[r'facilities'] = this.facilities;
    if (this.review != null) {
      json[r'review'] = this.review;
    } else {
      json[r'review'] = null;
    }
    return json;
  }

  /// Returns a new [ServiceManualResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ServiceManualResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ServiceManualResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ServiceManualResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ServiceManualResponseDto(
        serviceName: mapValueOfType<String>(json, r'serviceName')!,
        vendorName: mapValueOfType<String>(json, r'vendorName')!,
        imageUrl: mapValueOfType<String>(json, r'imageUrl')!,
        preServiceGuidelines: json[r'preServiceGuidelines'] is Iterable
            ? (json[r'preServiceGuidelines'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        serviceRules: ServiceRuleDto.listFromJson(json[r'serviceRules']),
        procedureSteps: ProcedureStepDto.listFromJson(json[r'procedureSteps']),
        facilities: FacilityDto.listFromJson(json[r'facilities']),
        review: ReviewSummaryDto.fromJson(json[r'review']),
      );
    }
    return null;
  }

  static List<ServiceManualResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ServiceManualResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ServiceManualResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ServiceManualResponseDto> mapFromJson(dynamic json) {
    final map = <String, ServiceManualResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ServiceManualResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ServiceManualResponseDto-objects as value to a dart map
  static Map<String, List<ServiceManualResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ServiceManualResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ServiceManualResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'serviceName',
    'vendorName',
    'imageUrl',
    'preServiceGuidelines',
    'serviceRules',
    'procedureSteps',
    'facilities',
  };
}

