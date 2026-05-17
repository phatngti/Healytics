//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of test_backdoor_api;

class SeedCartItemDto {
  /// Returns a new [SeedCartItemDto] instance.
  SeedCartItemDto({
    this.key,
    this.userKey,
    this.userEmail,
    this.serviceKey,
    this.serviceSlug,
    this.employeeKey,
    this.employeeEmail,
    required this.startsAt,
  });


  /// Unique lookup key
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? key;

  /// Key of a previously seeded user
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? userKey;

  /// Email to look up the user
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? userEmail;

  /// Key of a previously seeded service
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? serviceKey;

  /// Slug to look up the service
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? serviceSlug;

  /// Key of a previously seeded employee
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? employeeKey;

  /// Email to look up the employee
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? employeeEmail;

  /// ISO 8601 start time
  String startsAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SeedCartItemDto &&
    other.key == key &&
    other.userKey == userKey &&
    other.userEmail == userEmail &&
    other.serviceKey == serviceKey &&
    other.serviceSlug == serviceSlug &&
    other.employeeKey == employeeKey &&
    other.employeeEmail == employeeEmail &&
    other.startsAt == startsAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (key == null ? 0 : key!.hashCode) +
    (userKey == null ? 0 : userKey!.hashCode) +
    (userEmail == null ? 0 : userEmail!.hashCode) +
    (serviceKey == null ? 0 : serviceKey!.hashCode) +
    (serviceSlug == null ? 0 : serviceSlug!.hashCode) +
    (employeeKey == null ? 0 : employeeKey!.hashCode) +
    (employeeEmail == null ? 0 : employeeEmail!.hashCode) +
    (startsAt.hashCode);

  @override
  String toString() => 'SeedCartItemDto[key=$key, userKey=$userKey, userEmail=$userEmail, serviceKey=$serviceKey, serviceSlug=$serviceSlug, employeeKey=$employeeKey, employeeEmail=$employeeEmail, startsAt=$startsAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.key != null) {
      json[r'key'] = this.key;
    } else {
      json[r'key'] = null;
    }
    if (this.userKey != null) {
      json[r'userKey'] = this.userKey;
    } else {
      json[r'userKey'] = null;
    }
    if (this.userEmail != null) {
      json[r'userEmail'] = this.userEmail;
    } else {
      json[r'userEmail'] = null;
    }
    if (this.serviceKey != null) {
      json[r'serviceKey'] = this.serviceKey;
    } else {
      json[r'serviceKey'] = null;
    }
    if (this.serviceSlug != null) {
      json[r'serviceSlug'] = this.serviceSlug;
    } else {
      json[r'serviceSlug'] = null;
    }
    if (this.employeeKey != null) {
      json[r'employeeKey'] = this.employeeKey;
    } else {
      json[r'employeeKey'] = null;
    }
    if (this.employeeEmail != null) {
      json[r'employeeEmail'] = this.employeeEmail;
    } else {
      json[r'employeeEmail'] = null;
    }
      json[r'startsAt'] = this.startsAt;
    return json;
  }

  /// Returns a new [SeedCartItemDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SeedCartItemDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SeedCartItemDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SeedCartItemDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SeedCartItemDto(
        key: mapValueOfType<String>(json, r'key'),
        userKey: mapValueOfType<String>(json, r'userKey'),
        userEmail: mapValueOfType<String>(json, r'userEmail'),
        serviceKey: mapValueOfType<String>(json, r'serviceKey'),
        serviceSlug: mapValueOfType<String>(json, r'serviceSlug'),
        employeeKey: mapValueOfType<String>(json, r'employeeKey'),
        employeeEmail: mapValueOfType<String>(json, r'employeeEmail'),
        startsAt: mapValueOfType<String>(json, r'startsAt')!,
      );
    }
    return null;
  }

  static List<SeedCartItemDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SeedCartItemDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SeedCartItemDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SeedCartItemDto> mapFromJson(dynamic json) {
    final map = <String, SeedCartItemDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SeedCartItemDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SeedCartItemDto-objects as value to a dart map
  static Map<String, List<SeedCartItemDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SeedCartItemDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SeedCartItemDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'startsAt',
  };
}

