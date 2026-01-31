//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LocationDetailsInfoDto {
  /// Returns a new [LocationDetailsInfoDto] instance.
  LocationDetailsInfoDto({
    required this.provinceId,
    required this.districtId,
    required this.wardId,
    required this.streetAddress,
  });

  VerificationStringFieldDto provinceId;

  VerificationStringFieldDto districtId;

  VerificationStringFieldDto wardId;

  VerificationStringFieldDto streetAddress;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LocationDetailsInfoDto &&
    other.provinceId == provinceId &&
    other.districtId == districtId &&
    other.wardId == wardId &&
    other.streetAddress == streetAddress;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (provinceId.hashCode) +
    (districtId.hashCode) +
    (wardId.hashCode) +
    (streetAddress.hashCode);

  @override
  String toString() => 'LocationDetailsInfoDto[provinceId=$provinceId, districtId=$districtId, wardId=$wardId, streetAddress=$streetAddress]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'provinceId'] = this.provinceId;
      json[r'districtId'] = this.districtId;
      json[r'wardId'] = this.wardId;
      json[r'streetAddress'] = this.streetAddress;
    return json;
  }

  /// Returns a new [LocationDetailsInfoDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LocationDetailsInfoDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "LocationDetailsInfoDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "LocationDetailsInfoDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LocationDetailsInfoDto(
        provinceId: VerificationStringFieldDto.fromJson(json[r'provinceId'])!,
        districtId: VerificationStringFieldDto.fromJson(json[r'districtId'])!,
        wardId: VerificationStringFieldDto.fromJson(json[r'wardId'])!,
        streetAddress: VerificationStringFieldDto.fromJson(json[r'streetAddress'])!,
      );
    }
    return null;
  }

  static List<LocationDetailsInfoDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LocationDetailsInfoDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LocationDetailsInfoDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LocationDetailsInfoDto> mapFromJson(dynamic json) {
    final map = <String, LocationDetailsInfoDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LocationDetailsInfoDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LocationDetailsInfoDto-objects as value to a dart map
  static Map<String, List<LocationDetailsInfoDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LocationDetailsInfoDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LocationDetailsInfoDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'provinceId',
    'districtId',
    'wardId',
    'streetAddress',
  };
}

