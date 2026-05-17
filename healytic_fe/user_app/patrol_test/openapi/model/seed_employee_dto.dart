//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of test_backdoor_api;

class SeedEmployeeDto {
  /// Returns a new [SeedEmployeeDto] instance.
  SeedEmployeeDto({
    this.key,
    this.partnerKey,
    this.partnerBrandName,
    this.email,
    this.employeeCode,
    this.firstName,
    this.lastName,
    required this.displayName,
    this.phone,
    this.role,
    this.status,
  });


  /// Unique lookup key
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? key;

  /// Key of a previously seeded partner
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? partnerKey;

  /// Brand name to look up the partner
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? partnerBrandName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? email;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? employeeCode;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? firstName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? lastName;

  String displayName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? phone;

  SeedEmployeeDtoRoleEnum? role;

  SeedEmployeeDtoStatusEnum? status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SeedEmployeeDto &&
    other.key == key &&
    other.partnerKey == partnerKey &&
    other.partnerBrandName == partnerBrandName &&
    other.email == email &&
    other.employeeCode == employeeCode &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.displayName == displayName &&
    other.phone == phone &&
    other.role == role &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (key == null ? 0 : key!.hashCode) +
    (partnerKey == null ? 0 : partnerKey!.hashCode) +
    (partnerBrandName == null ? 0 : partnerBrandName!.hashCode) +
    (email == null ? 0 : email!.hashCode) +
    (employeeCode == null ? 0 : employeeCode!.hashCode) +
    (firstName == null ? 0 : firstName!.hashCode) +
    (lastName == null ? 0 : lastName!.hashCode) +
    (displayName.hashCode) +
    (phone == null ? 0 : phone!.hashCode) +
    (role == null ? 0 : role!.hashCode) +
    (status == null ? 0 : status!.hashCode);

  @override
  String toString() => 'SeedEmployeeDto[key=$key, partnerKey=$partnerKey, partnerBrandName=$partnerBrandName, email=$email, employeeCode=$employeeCode, firstName=$firstName, lastName=$lastName, displayName=$displayName, phone=$phone, role=$role, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.key != null) {
      json[r'key'] = this.key;
    } else {
      json[r'key'] = null;
    }
    if (this.partnerKey != null) {
      json[r'partnerKey'] = this.partnerKey;
    } else {
      json[r'partnerKey'] = null;
    }
    if (this.partnerBrandName != null) {
      json[r'partnerBrandName'] = this.partnerBrandName;
    } else {
      json[r'partnerBrandName'] = null;
    }
    if (this.email != null) {
      json[r'email'] = this.email;
    } else {
      json[r'email'] = null;
    }
    if (this.employeeCode != null) {
      json[r'employeeCode'] = this.employeeCode;
    } else {
      json[r'employeeCode'] = null;
    }
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
      json[r'displayName'] = this.displayName;
    if (this.phone != null) {
      json[r'phone'] = this.phone;
    } else {
      json[r'phone'] = null;
    }
    if (this.role != null) {
      json[r'role'] = this.role;
    } else {
      json[r'role'] = null;
    }
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
    return json;
  }

  /// Returns a new [SeedEmployeeDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SeedEmployeeDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SeedEmployeeDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SeedEmployeeDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SeedEmployeeDto(
        key: mapValueOfType<String>(json, r'key'),
        partnerKey: mapValueOfType<String>(json, r'partnerKey'),
        partnerBrandName: mapValueOfType<String>(json, r'partnerBrandName'),
        email: mapValueOfType<String>(json, r'email'),
        employeeCode: mapValueOfType<String>(json, r'employeeCode'),
        firstName: mapValueOfType<String>(json, r'firstName'),
        lastName: mapValueOfType<String>(json, r'lastName'),
        displayName: mapValueOfType<String>(json, r'displayName')!,
        phone: mapValueOfType<String>(json, r'phone'),
        role: SeedEmployeeDtoRoleEnum.fromJson(json[r'role']),
        status: SeedEmployeeDtoStatusEnum.fromJson(json[r'status']),
      );
    }
    return null;
  }

  static List<SeedEmployeeDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SeedEmployeeDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SeedEmployeeDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SeedEmployeeDto> mapFromJson(dynamic json) {
    final map = <String, SeedEmployeeDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SeedEmployeeDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SeedEmployeeDto-objects as value to a dart map
  static Map<String, List<SeedEmployeeDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SeedEmployeeDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SeedEmployeeDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'displayName',
  };
}


class SeedEmployeeDtoRoleEnum {
  /// Instantiate a new enum with the provided [value].
  const SeedEmployeeDtoRoleEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const DOCTOR = SeedEmployeeDtoRoleEnum._(r'DOCTOR');
  static const THERAPIST = SeedEmployeeDtoRoleEnum._(r'THERAPIST');
  static const RECEPTIONIST = SeedEmployeeDtoRoleEnum._(r'RECEPTIONIST');
  static const MANAGER = SeedEmployeeDtoRoleEnum._(r'MANAGER');

  /// List of all possible values in this [enum][SeedEmployeeDtoRoleEnum].
  static const values = <SeedEmployeeDtoRoleEnum>[
    DOCTOR,
    THERAPIST,
    RECEPTIONIST,
    MANAGER,
  ];

  static SeedEmployeeDtoRoleEnum? fromJson(dynamic value) => SeedEmployeeDtoRoleEnumTypeTransformer().decode(value);

  static List<SeedEmployeeDtoRoleEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SeedEmployeeDtoRoleEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SeedEmployeeDtoRoleEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [SeedEmployeeDtoRoleEnum] to String,
/// and [decode] dynamic data back to [SeedEmployeeDtoRoleEnum].
class SeedEmployeeDtoRoleEnumTypeTransformer {
  factory SeedEmployeeDtoRoleEnumTypeTransformer() => _instance ??= const SeedEmployeeDtoRoleEnumTypeTransformer._();

  const SeedEmployeeDtoRoleEnumTypeTransformer._();

  String encode(SeedEmployeeDtoRoleEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a SeedEmployeeDtoRoleEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  SeedEmployeeDtoRoleEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'DOCTOR': return SeedEmployeeDtoRoleEnum.DOCTOR;
        case r'THERAPIST': return SeedEmployeeDtoRoleEnum.THERAPIST;
        case r'RECEPTIONIST': return SeedEmployeeDtoRoleEnum.RECEPTIONIST;
        case r'MANAGER': return SeedEmployeeDtoRoleEnum.MANAGER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [SeedEmployeeDtoRoleEnumTypeTransformer] instance.
  static SeedEmployeeDtoRoleEnumTypeTransformer? _instance;
}



class SeedEmployeeDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const SeedEmployeeDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const ACTIVE = SeedEmployeeDtoStatusEnum._(r'ACTIVE');
  static const INACTIVE = SeedEmployeeDtoStatusEnum._(r'INACTIVE');
  static const ON_LEAVE = SeedEmployeeDtoStatusEnum._(r'ON_LEAVE');

  /// List of all possible values in this [enum][SeedEmployeeDtoStatusEnum].
  static const values = <SeedEmployeeDtoStatusEnum>[
    ACTIVE,
    INACTIVE,
    ON_LEAVE,
  ];

  static SeedEmployeeDtoStatusEnum? fromJson(dynamic value) => SeedEmployeeDtoStatusEnumTypeTransformer().decode(value);

  static List<SeedEmployeeDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SeedEmployeeDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SeedEmployeeDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [SeedEmployeeDtoStatusEnum] to String,
/// and [decode] dynamic data back to [SeedEmployeeDtoStatusEnum].
class SeedEmployeeDtoStatusEnumTypeTransformer {
  factory SeedEmployeeDtoStatusEnumTypeTransformer() => _instance ??= const SeedEmployeeDtoStatusEnumTypeTransformer._();

  const SeedEmployeeDtoStatusEnumTypeTransformer._();

  String encode(SeedEmployeeDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a SeedEmployeeDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  SeedEmployeeDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'ACTIVE': return SeedEmployeeDtoStatusEnum.ACTIVE;
        case r'INACTIVE': return SeedEmployeeDtoStatusEnum.INACTIVE;
        case r'ON_LEAVE': return SeedEmployeeDtoStatusEnum.ON_LEAVE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [SeedEmployeeDtoStatusEnumTypeTransformer] instance.
  static SeedEmployeeDtoStatusEnumTypeTransformer? _instance;
}


