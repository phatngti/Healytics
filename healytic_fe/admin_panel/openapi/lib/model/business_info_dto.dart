//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BusinessInfoDto {
  /// Returns a new [BusinessInfoDto] instance.
  BusinessInfoDto({
    required this.brandName,
    this.taxRegistrationCode,
    required this.serviceTags,
    this.address,
    this.username,
    this.email,
    this.phoneNumber,
  });

  VerifiedField brandName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  VerifiedField? taxRegistrationCode;

  VerifiedField serviceTags;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  AddressInfoDto? address;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  VerifiedField? username;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  VerifiedField? email;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  VerifiedField? phoneNumber;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BusinessInfoDto &&
    other.brandName == brandName &&
    other.taxRegistrationCode == taxRegistrationCode &&
    other.serviceTags == serviceTags &&
    other.address == address &&
    other.username == username &&
    other.email == email &&
    other.phoneNumber == phoneNumber;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (brandName.hashCode) +
    (taxRegistrationCode == null ? 0 : taxRegistrationCode!.hashCode) +
    (serviceTags.hashCode) +
    (address == null ? 0 : address!.hashCode) +
    (username == null ? 0 : username!.hashCode) +
    (email == null ? 0 : email!.hashCode) +
    (phoneNumber == null ? 0 : phoneNumber!.hashCode);

  @override
  String toString() => 'BusinessInfoDto[brandName=$brandName, taxRegistrationCode=$taxRegistrationCode, serviceTags=$serviceTags, address=$address, username=$username, email=$email, phoneNumber=$phoneNumber]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'brandName'] = this.brandName;
    if (this.taxRegistrationCode != null) {
      json[r'taxRegistrationCode'] = this.taxRegistrationCode;
    } else {
      json[r'taxRegistrationCode'] = null;
    }
      json[r'serviceTags'] = this.serviceTags;
    if (this.address != null) {
      json[r'address'] = this.address;
    } else {
      json[r'address'] = null;
    }
    if (this.username != null) {
      json[r'username'] = this.username;
    } else {
      json[r'username'] = null;
    }
    if (this.email != null) {
      json[r'email'] = this.email;
    } else {
      json[r'email'] = null;
    }
    if (this.phoneNumber != null) {
      json[r'phoneNumber'] = this.phoneNumber;
    } else {
      json[r'phoneNumber'] = null;
    }
    return json;
  }

  /// Returns a new [BusinessInfoDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BusinessInfoDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BusinessInfoDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BusinessInfoDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BusinessInfoDto(
        brandName: VerifiedField.fromJson(json[r'brandName'])!,
        taxRegistrationCode: VerifiedField.fromJson(json[r'taxRegistrationCode']),
        serviceTags: VerifiedField.fromJson(json[r'serviceTags'])!,
        address: AddressInfoDto.fromJson(json[r'address']),
        username: VerifiedField.fromJson(json[r'username']),
        email: VerifiedField.fromJson(json[r'email']),
        phoneNumber: VerifiedField.fromJson(json[r'phoneNumber']),
      );
    }
    return null;
  }

  static List<BusinessInfoDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BusinessInfoDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BusinessInfoDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BusinessInfoDto> mapFromJson(dynamic json) {
    final map = <String, BusinessInfoDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BusinessInfoDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BusinessInfoDto-objects as value to a dart map
  static Map<String, List<BusinessInfoDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BusinessInfoDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BusinessInfoDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'brandName',
    'serviceTags',
  };
}

