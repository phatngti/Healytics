//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GeocodeResultDto {
  /// Returns a new [GeocodeResultDto] instance.
  GeocodeResultDto({
    required this.lat,
    required this.lng,
    required this.formattedAddress,
    this.placeId,
  });

  num lat;

  num lng;

  String formattedAddress;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? placeId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GeocodeResultDto &&
    other.lat == lat &&
    other.lng == lng &&
    other.formattedAddress == formattedAddress &&
    other.placeId == placeId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (lat.hashCode) +
    (lng.hashCode) +
    (formattedAddress.hashCode) +
    (placeId == null ? 0 : placeId!.hashCode);

  @override
  String toString() => 'GeocodeResultDto[lat=$lat, lng=$lng, formattedAddress=$formattedAddress, placeId=$placeId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'lat'] = this.lat;
      json[r'lng'] = this.lng;
      json[r'formattedAddress'] = this.formattedAddress;
    if (this.placeId != null) {
      json[r'placeId'] = this.placeId;
    } else {
      json[r'placeId'] = null;
    }
    return json;
  }

  /// Returns a new [GeocodeResultDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GeocodeResultDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GeocodeResultDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GeocodeResultDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GeocodeResultDto(
        lat: num.parse('${json[r'lat']}'),
        lng: num.parse('${json[r'lng']}'),
        formattedAddress: mapValueOfType<String>(json, r'formattedAddress')!,
        placeId: mapValueOfType<String>(json, r'placeId'),
      );
    }
    return null;
  }

  static List<GeocodeResultDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GeocodeResultDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GeocodeResultDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GeocodeResultDto> mapFromJson(dynamic json) {
    final map = <String, GeocodeResultDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GeocodeResultDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GeocodeResultDto-objects as value to a dart map
  static Map<String, List<GeocodeResultDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GeocodeResultDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GeocodeResultDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'lat',
    'lng',
    'formattedAddress',
  };
}

