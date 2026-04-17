//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicProfileBusinessInfoDto {
  /// Returns a new [PublicProfileBusinessInfoDto] instance.
  PublicProfileBusinessInfoDto({
    required this.brandName,
    required this.legalName,
    required this.taxCode,
    this.businessType = const [],
    this.phoneNumber,
    this.email,
    this.username,
  });


  String brandName;

  String legalName;

  String taxCode;

  List<String> businessType;

  Object? phoneNumber;

  Object? email;

  Object? username;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicProfileBusinessInfoDto &&
    other.brandName == brandName &&
    other.legalName == legalName &&
    other.taxCode == taxCode &&
    _deepEquality.equals(other.businessType, businessType) &&
    other.phoneNumber == phoneNumber &&
    other.email == email &&
    other.username == username;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (brandName.hashCode) +
    (legalName.hashCode) +
    (taxCode.hashCode) +
    (businessType.hashCode) +
    (phoneNumber == null ? 0 : phoneNumber!.hashCode) +
    (email == null ? 0 : email!.hashCode) +
    (username == null ? 0 : username!.hashCode);

  @override
  String toString() => 'PublicProfileBusinessInfoDto[brandName=$brandName, legalName=$legalName, taxCode=$taxCode, businessType=$businessType, phoneNumber=$phoneNumber, email=$email, username=$username]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'brandName'] = this.brandName;
      json[r'legalName'] = this.legalName;
      json[r'taxCode'] = this.taxCode;
      json[r'businessType'] = this.businessType;
    if (this.phoneNumber != null) {
      json[r'phoneNumber'] = this.phoneNumber;
    } else {
      json[r'phoneNumber'] = null;
    }
    if (this.email != null) {
      json[r'email'] = this.email;
    } else {
      json[r'email'] = null;
    }
    if (this.username != null) {
      json[r'username'] = this.username;
    } else {
      json[r'username'] = null;
    }
    return json;
  }

  /// Returns a new [PublicProfileBusinessInfoDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicProfileBusinessInfoDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicProfileBusinessInfoDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicProfileBusinessInfoDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicProfileBusinessInfoDto(
        brandName: mapValueOfType<String>(json, r'brandName')!,
        legalName: mapValueOfType<String>(json, r'legalName')!,
        taxCode: mapValueOfType<String>(json, r'taxCode')!,
        businessType: json[r'businessType'] is Iterable
            ? (json[r'businessType'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        phoneNumber: mapValueOfType<Object>(json, r'phoneNumber'),
        email: mapValueOfType<Object>(json, r'email'),
        username: mapValueOfType<Object>(json, r'username'),
      );
    }
    return null;
  }

  static List<PublicProfileBusinessInfoDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicProfileBusinessInfoDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicProfileBusinessInfoDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicProfileBusinessInfoDto> mapFromJson(dynamic json) {
    final map = <String, PublicProfileBusinessInfoDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicProfileBusinessInfoDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicProfileBusinessInfoDto-objects as value to a dart map
  static Map<String, List<PublicProfileBusinessInfoDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicProfileBusinessInfoDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicProfileBusinessInfoDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'brandName',
    'legalName',
    'taxCode',
    'businessType',
  };
}

