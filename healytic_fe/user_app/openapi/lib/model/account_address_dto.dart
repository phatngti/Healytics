//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AccountAddressDto {
  /// Returns a new [AccountAddressDto] instance.
  AccountAddressDto({
    required this.street,
    required this.ward,
    required this.district,
    required this.cityOrProvince,
    this.provinceId,
    this.districtId,
    this.wardId,
    this.latitude,
    this.longitude,
  });


  /// Street address
  String street;

  /// Ward or commune
  String ward;

  /// District
  String district;

  /// City or province
  String cityOrProvince;

  /// Province/city Location UUID
  String? provinceId;

  /// District Location UUID
  String? districtId;

  /// Ward/commune Location UUID
  String? wardId;

  /// Resolved latitude
  num? latitude;

  /// Resolved longitude
  num? longitude;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AccountAddressDto &&
    other.street == street &&
    other.ward == ward &&
    other.district == district &&
    other.cityOrProvince == cityOrProvince &&
    other.provinceId == provinceId &&
    other.districtId == districtId &&
    other.wardId == wardId &&
    other.latitude == latitude &&
    other.longitude == longitude;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (street.hashCode) +
    (ward.hashCode) +
    (district.hashCode) +
    (cityOrProvince.hashCode) +
    (provinceId == null ? 0 : provinceId!.hashCode) +
    (districtId == null ? 0 : districtId!.hashCode) +
    (wardId == null ? 0 : wardId!.hashCode) +
    (latitude == null ? 0 : latitude!.hashCode) +
    (longitude == null ? 0 : longitude!.hashCode);

  @override
  String toString() => 'AccountAddressDto[street=$street, ward=$ward, district=$district, cityOrProvince=$cityOrProvince, provinceId=$provinceId, districtId=$districtId, wardId=$wardId, latitude=$latitude, longitude=$longitude]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'street'] = this.street;
      json[r'ward'] = this.ward;
      json[r'district'] = this.district;
      json[r'cityOrProvince'] = this.cityOrProvince;
    if (this.provinceId != null) {
      json[r'provinceId'] = this.provinceId;
    } else {
      json[r'provinceId'] = null;
    }
    if (this.districtId != null) {
      json[r'districtId'] = this.districtId;
    } else {
      json[r'districtId'] = null;
    }
    if (this.wardId != null) {
      json[r'wardId'] = this.wardId;
    } else {
      json[r'wardId'] = null;
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
    return json;
  }

  /// Returns a new [AccountAddressDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AccountAddressDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AccountAddressDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AccountAddressDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AccountAddressDto(
        street: mapValueOfType<String>(json, r'street')!,
        ward: mapValueOfType<String>(json, r'ward')!,
        district: mapValueOfType<String>(json, r'district')!,
        cityOrProvince: mapValueOfType<String>(json, r'cityOrProvince')!,
        provinceId: mapValueOfType<String>(json, r'provinceId'),
        districtId: mapValueOfType<String>(json, r'districtId'),
        wardId: mapValueOfType<String>(json, r'wardId'),
        latitude: json[r'latitude'] == null
            ? null
            : num.parse('${json[r'latitude']}'),
        longitude: json[r'longitude'] == null
            ? null
            : num.parse('${json[r'longitude']}'),
      );
    }
    return null;
  }

  static List<AccountAddressDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AccountAddressDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AccountAddressDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AccountAddressDto> mapFromJson(dynamic json) {
    final map = <String, AccountAddressDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AccountAddressDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AccountAddressDto-objects as value to a dart map
  static Map<String, List<AccountAddressDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AccountAddressDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AccountAddressDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'street',
    'ward',
    'district',
    'cityOrProvince',
  };
}

