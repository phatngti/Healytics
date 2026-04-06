//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ClinicTrustMetricsDto {
  /// Returns a new [ClinicTrustMetricsDto] instance.
  ClinicTrustMetricsDto({
    required this.rating,
    required this.reviewCount,
    required this.experienceLabel,
    required this.clientsLabel,
  });

  num rating;

  num reviewCount;

  String experienceLabel;

  String clientsLabel;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ClinicTrustMetricsDto &&
    other.rating == rating &&
    other.reviewCount == reviewCount &&
    other.experienceLabel == experienceLabel &&
    other.clientsLabel == clientsLabel;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (rating.hashCode) +
    (reviewCount.hashCode) +
    (experienceLabel.hashCode) +
    (clientsLabel.hashCode);

  @override
  String toString() => 'ClinicTrustMetricsDto[rating=$rating, reviewCount=$reviewCount, experienceLabel=$experienceLabel, clientsLabel=$clientsLabel]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'rating'] = this.rating;
      json[r'reviewCount'] = this.reviewCount;
      json[r'experienceLabel'] = this.experienceLabel;
      json[r'clientsLabel'] = this.clientsLabel;
    return json;
  }

  /// Returns a new [ClinicTrustMetricsDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ClinicTrustMetricsDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ClinicTrustMetricsDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ClinicTrustMetricsDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ClinicTrustMetricsDto(
        rating: num.parse('${json[r'rating']}'),
        reviewCount: num.parse('${json[r'reviewCount']}'),
        experienceLabel: mapValueOfType<String>(json, r'experienceLabel')!,
        clientsLabel: mapValueOfType<String>(json, r'clientsLabel')!,
      );
    }
    return null;
  }

  static List<ClinicTrustMetricsDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ClinicTrustMetricsDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ClinicTrustMetricsDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ClinicTrustMetricsDto> mapFromJson(dynamic json) {
    final map = <String, ClinicTrustMetricsDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ClinicTrustMetricsDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ClinicTrustMetricsDto-objects as value to a dart map
  static Map<String, List<ClinicTrustMetricsDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ClinicTrustMetricsDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ClinicTrustMetricsDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'rating',
    'reviewCount',
    'experienceLabel',
    'clientsLabel',
  };
}

