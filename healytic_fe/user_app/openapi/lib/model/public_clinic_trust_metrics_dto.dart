//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicClinicTrustMetricsDto {
  /// Returns a new [PublicClinicTrustMetricsDto] instance.
  PublicClinicTrustMetricsDto({
    required this.experienceLabel,
    required this.specialistsCount,
    required this.certifiedLabel,
    required this.clientsLabel,
  });


  String experienceLabel;

  num specialistsCount;

  String certifiedLabel;

  String clientsLabel;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicClinicTrustMetricsDto &&
    other.experienceLabel == experienceLabel &&
    other.specialistsCount == specialistsCount &&
    other.certifiedLabel == certifiedLabel &&
    other.clientsLabel == clientsLabel;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (experienceLabel.hashCode) +
    (specialistsCount.hashCode) +
    (certifiedLabel.hashCode) +
    (clientsLabel.hashCode);

  @override
  String toString() => 'PublicClinicTrustMetricsDto[experienceLabel=$experienceLabel, specialistsCount=$specialistsCount, certifiedLabel=$certifiedLabel, clientsLabel=$clientsLabel]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'experienceLabel'] = this.experienceLabel;
      json[r'specialistsCount'] = this.specialistsCount;
      json[r'certifiedLabel'] = this.certifiedLabel;
      json[r'clientsLabel'] = this.clientsLabel;
    return json;
  }

  /// Returns a new [PublicClinicTrustMetricsDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicClinicTrustMetricsDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicClinicTrustMetricsDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicClinicTrustMetricsDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicClinicTrustMetricsDto(
        experienceLabel: mapValueOfType<String>(json, r'experienceLabel')!,
        specialistsCount: num.parse('${json[r'specialistsCount']}'),
        certifiedLabel: mapValueOfType<String>(json, r'certifiedLabel')!,
        clientsLabel: mapValueOfType<String>(json, r'clientsLabel')!,
      );
    }
    return null;
  }

  static List<PublicClinicTrustMetricsDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicClinicTrustMetricsDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicClinicTrustMetricsDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicClinicTrustMetricsDto> mapFromJson(dynamic json) {
    final map = <String, PublicClinicTrustMetricsDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicClinicTrustMetricsDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicClinicTrustMetricsDto-objects as value to a dart map
  static Map<String, List<PublicClinicTrustMetricsDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicClinicTrustMetricsDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicClinicTrustMetricsDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'experienceLabel',
    'specialistsCount',
    'certifiedLabel',
    'clientsLabel',
  };
}

