//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserProfileDto {
  /// Returns a new [UserProfileDto] instance.
  UserProfileDto({
    required this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.bio,
    this.dateOfBirth,
    this.avatarUrl,
    required this.profileCompleted,
  });

  /// Profile ID
  String id;

  /// First name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? firstName;

  /// Last name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? lastName;

  /// Phone number
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? phone;

  /// Bio
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? bio;

  /// Date of birth
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? dateOfBirth;

  /// Avatar image URL
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? avatarUrl;

  /// Whether the profile is completed
  bool profileCompleted;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileDto &&
          other.id == id &&
          other.firstName == firstName &&
          other.lastName == lastName &&
          other.phone == phone &&
          other.bio == bio &&
          other.dateOfBirth == dateOfBirth &&
          other.avatarUrl == avatarUrl &&
          other.profileCompleted == profileCompleted;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (id.hashCode) +
      (firstName == null ? 0 : firstName!.hashCode) +
      (lastName == null ? 0 : lastName!.hashCode) +
      (phone == null ? 0 : phone!.hashCode) +
      (bio == null ? 0 : bio!.hashCode) +
      (dateOfBirth == null ? 0 : dateOfBirth!.hashCode) +
      (avatarUrl == null ? 0 : avatarUrl!.hashCode) +
      (profileCompleted.hashCode);

  @override
  String toString() =>
      'UserProfileDto[id=$id, firstName=$firstName, lastName=$lastName, phone=$phone, bio=$bio, dateOfBirth=$dateOfBirth, avatarUrl=$avatarUrl, profileCompleted=$profileCompleted]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'id'] = this.id;
    if (this.firstName != null) {
      json[r'firstName'] = this.firstName;
    } else {
      json[r'firstName'] = null;
    }
    if (this.lastName != null) {
      json[r'lastName'] = this.lastName;
    } else {
      json[r'lastName'] = null;
    }
    if (this.phone != null) {
      json[r'phone'] = this.phone;
    } else {
      json[r'phone'] = null;
    }
    if (this.bio != null) {
      json[r'bio'] = this.bio;
    } else {
      json[r'bio'] = null;
    }
    if (this.dateOfBirth != null) {
      json[r'dateOfBirth'] = this.dateOfBirth;
    } else {
      json[r'dateOfBirth'] = null;
    }
    if (this.avatarUrl != null) {
      json[r'avatarUrl'] = this.avatarUrl;
    } else {
      json[r'avatarUrl'] = null;
    }
    json[r'profileCompleted'] = this.profileCompleted;
    return json;
  }

  /// Returns a new [UserProfileDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserProfileDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "UserProfileDto[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "UserProfileDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserProfileDto(
        id: mapValueOfType<String>(json, r'id')!,
        firstName: mapValueOfType<String>(json, r'firstName'),
        lastName: mapValueOfType<String>(json, r'lastName'),
        phone: mapValueOfType<String>(json, r'phone'),
        bio: mapValueOfType<Object>(json, r'bio'),
        dateOfBirth: mapValueOfType<String>(json, r'dateOfBirth'),
        avatarUrl: mapValueOfType<Object>(json, r'avatarUrl'),
        profileCompleted: mapValueOfType<bool>(json, r'profileCompleted')!,
      );
    }
    return null;
  }

  static List<UserProfileDto> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <UserProfileDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserProfileDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserProfileDto> mapFromJson(dynamic json) {
    final map = <String, UserProfileDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserProfileDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserProfileDto-objects as value to a dart map
  static Map<String, List<UserProfileDto>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<UserProfileDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserProfileDto.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'profileCompleted',
  };
}
