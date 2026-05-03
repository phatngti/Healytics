//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BusinessInfo {
  /// Returns a new [BusinessInfo] instance.
  BusinessInfo({
    this.brandName,
    this.taxRegistrationCode,
    this.serviceTags,
    this.address,
    this.username,
    this.email,
    this.phoneNumber,
  });


  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? brandName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? taxRegistrationCode;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? serviceTags;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  AddressDto? address;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? username;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? email;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? phoneNumber;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BusinessInfo &&
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
    (brandName == null ? 0 : brandName!.hashCode) +
    (taxRegistrationCode == null ? 0 : taxRegistrationCode!.hashCode) +
    (serviceTags == null ? 0 : serviceTags!.hashCode) +
    (address == null ? 0 : address!.hashCode) +
    (username == null ? 0 : username!.hashCode) +
    (email == null ? 0 : email!.hashCode) +
    (phoneNumber == null ? 0 : phoneNumber!.hashCode);

  @override
  String toString() => 'BusinessInfo[brandName=$brandName, taxRegistrationCode=$taxRegistrationCode, serviceTags=$serviceTags, address=$address, username=$username, email=$email, phoneNumber=$phoneNumber]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.brandName != null) {
      json[r'brandName'] = this.brandName;
    } else {
      json[r'brandName'] = null;
    }
    if (this.taxRegistrationCode != null) {
      json[r'taxRegistrationCode'] = this.taxRegistrationCode;
    } else {
      json[r'taxRegistrationCode'] = null;
    }
    if (this.serviceTags != null) {
      json[r'serviceTags'] = this.serviceTags;
    } else {
      json[r'serviceTags'] = null;
    }
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

  /// Returns a new [BusinessInfo] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BusinessInfo? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BusinessInfo[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BusinessInfo[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BusinessInfo(
        brandName: mapValueOfType<Object>(json, r'brandName'),
        taxRegistrationCode: mapValueOfType<Object>(json, r'taxRegistrationCode'),
        serviceTags: mapValueOfType<Object>(json, r'serviceTags'),
        address: AddressDto.fromJson(json[r'address']),
        username: mapValueOfType<Object>(json, r'username'),
        email: mapValueOfType<Object>(json, r'email'),
        phoneNumber: mapValueOfType<Object>(json, r'phoneNumber'),
      );
    }
    return null;
  }

  static List<BusinessInfo> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BusinessInfo>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BusinessInfo.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BusinessInfo> mapFromJson(dynamic json) {
    final map = <String, BusinessInfo>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BusinessInfo.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BusinessInfo-objects as value to a dart map
  static Map<String, List<BusinessInfo>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BusinessInfo>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BusinessInfo.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

