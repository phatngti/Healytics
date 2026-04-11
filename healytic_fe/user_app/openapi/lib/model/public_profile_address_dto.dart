//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicProfileAddressDto {
  /// Returns a new [PublicProfileAddressDto] instance.
  PublicProfileAddressDto({
    required this.streetAddress,
    this.ward,
    this.district,
    this.province,
    this.latitude,
    this.longitude,
    this.formattedAddress,
  });

  String streetAddress;

  Object? ward;

  Object? district;

  Object? province;

  num? latitude;

  num? longitude;

  Object? formattedAddress;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicProfileAddressDto &&
    other.streetAddress == streetAddress &&
    other.ward == ward &&
    other.district == district &&
    other.province == province &&
    other.latitude == latitude &&
    other.longitude == longitude &&
    other.formattedAddress == formattedAddress;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (streetAddress.hashCode) +
    (ward == null ? 0 : ward!.hashCode) +
    (district == null ? 0 : district!.hashCode) +
    (province == null ? 0 : province!.hashCode) +
    (latitude == null ? 0 : latitude!.hashCode) +
    (longitude == null ? 0 : longitude!.hashCode) +
    (formattedAddress == null ? 0 : formattedAddress!.hashCode);

  @override
  String toString() => 'PublicProfileAddressDto[streetAddress=$streetAddress, ward=$ward, district=$district, province=$province, latitude=$latitude, longitude=$longitude, formattedAddress=$formattedAddress]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'streetAddress'] = this.streetAddress;
    if (this.ward != null) {
      json[r'ward'] = this.ward;
    } else {
      json[r'ward'] = null;
    }
    if (this.district != null) {
      json[r'district'] = this.district;
    } else {
      json[r'district'] = null;
    }
    if (this.province != null) {
      json[r'province'] = this.province;
    } else {
      json[r'province'] = null;
    }
    if (this.latitude != null) {
      json[r'latitude'] = this.latitude;
    } else {
      json[r'latitude'] = null;
    }
    if (this.longitude != null) {
      json[r'longitude'] = this.longitude;
    } else {
      json[r'longitude'] = null;
    }
    if (this.formattedAddress != null) {
      json[r'formattedAddress'] = this.formattedAddress;
    } else {
      json[r'formattedAddress'] = null;
    }
    return json;
  }

  /// Returns a new [PublicProfileAddressDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicProfileAddressDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicProfileAddressDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicProfileAddressDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicProfileAddressDto(
        streetAddress: mapValueOfType<String>(json, r'streetAddress')!,
        ward: mapValueOfType<Object>(json, r'ward'),
        district: mapValueOfType<Object>(json, r'district'),
        province: mapValueOfType<Object>(json, r'province'),
        latitude: json[r'latitude'] == null
            ? null
            : num.parse('${json[r'latitude']}'),
        longitude: json[r'longitude'] == null
            ? null
            : num.parse('${json[r'longitude']}'),
        formattedAddress: mapValueOfType<Object>(json, r'formattedAddress'),
      );
    }
    return null;
  }

  static List<PublicProfileAddressDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicProfileAddressDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicProfileAddressDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicProfileAddressDto> mapFromJson(dynamic json) {
    final map = <String, PublicProfileAddressDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicProfileAddressDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicProfileAddressDto-objects as value to a dart map
  static Map<String, List<PublicProfileAddressDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicProfileAddressDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicProfileAddressDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'streetAddress',
  };
}

