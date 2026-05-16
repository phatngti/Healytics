//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of test_backdoor_api;

class SeedPartnerDto {
  /// Returns a new [SeedPartnerDto] instance.
  SeedPartnerDto({
    this.key,
    this.email,
    this.password,
    this.taxCode,
    this.legalName,
    required this.brandName,
    this.businessTypes = const [],
    this.streetAddress,
    this.phoneNumber,
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
  String? password;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? taxCode;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? legalName;

  String brandName;

  /// Business type categories
  List<String> businessTypes;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? streetAddress;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? phoneNumber;

  /// Verification status
  SeedPartnerDtoStatusEnum? status;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SeedPartnerDto &&
    other.key == key &&
    other.email == email &&
    other.password == password &&
    other.taxCode == taxCode &&
    other.legalName == legalName &&
    other.brandName == brandName &&
    _deepEquality.equals(other.businessTypes, businessTypes) &&
    other.streetAddress == streetAddress &&
    other.phoneNumber == phoneNumber &&
    other.status == status;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (key == null ? 0 : key!.hashCode) +
    (email == null ? 0 : email!.hashCode) +
    (password == null ? 0 : password!.hashCode) +
    (taxCode == null ? 0 : taxCode!.hashCode) +
    (legalName == null ? 0 : legalName!.hashCode) +
    (brandName.hashCode) +
    (businessTypes.hashCode) +
    (streetAddress == null ? 0 : streetAddress!.hashCode) +
    (phoneNumber == null ? 0 : phoneNumber!.hashCode) +
    (status == null ? 0 : status!.hashCode);

  @override
  String toString() => 'SeedPartnerDto[key=$key, email=$email, password=$password, taxCode=$taxCode, legalName=$legalName, brandName=$brandName, businessTypes=$businessTypes, streetAddress=$streetAddress, phoneNumber=$phoneNumber, status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.key != null) {
      json[r'key'] = this.key;
    } else {
      json[r'key'] = null;
    }
    if (this.email != null) {
      json[r'email'] = this.email;
    } else {
      json[r'email'] = null;
    }
    if (this.password != null) {
      json[r'password'] = this.password;
    } else {
      json[r'password'] = null;
    }
    if (this.taxCode != null) {
      json[r'taxCode'] = this.taxCode;
    } else {
      json[r'taxCode'] = null;
    }
    if (this.legalName != null) {
      json[r'legalName'] = this.legalName;
    } else {
      json[r'legalName'] = null;
    }
      json[r'brandName'] = this.brandName;
      json[r'businessTypes'] = this.businessTypes;
    if (this.streetAddress != null) {
      json[r'streetAddress'] = this.streetAddress;
    } else {
      json[r'streetAddress'] = null;
    }
    if (this.phoneNumber != null) {
      json[r'phoneNumber'] = this.phoneNumber;
    } else {
      json[r'phoneNumber'] = null;
    }
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
    return json;
  }

  /// Returns a new [SeedPartnerDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SeedPartnerDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SeedPartnerDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SeedPartnerDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SeedPartnerDto(
        key: mapValueOfType<String>(json, r'key'),
        email: mapValueOfType<String>(json, r'email'),
        password: mapValueOfType<String>(json, r'password'),
        taxCode: mapValueOfType<String>(json, r'taxCode'),
        legalName: mapValueOfType<String>(json, r'legalName'),
        brandName: mapValueOfType<String>(json, r'brandName')!,
        businessTypes: json[r'businessTypes'] is Iterable
            ? (json[r'businessTypes'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        streetAddress: mapValueOfType<String>(json, r'streetAddress'),
        phoneNumber: mapValueOfType<String>(json, r'phoneNumber'),
        status: SeedPartnerDtoStatusEnum.fromJson(json[r'status']),
      );
    }
    return null;
  }

  static List<SeedPartnerDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SeedPartnerDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SeedPartnerDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SeedPartnerDto> mapFromJson(dynamic json) {
    final map = <String, SeedPartnerDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SeedPartnerDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SeedPartnerDto-objects as value to a dart map
  static Map<String, List<SeedPartnerDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SeedPartnerDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SeedPartnerDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'brandName',
  };
}

/// Verification status
class SeedPartnerDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const SeedPartnerDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const PENDING = SeedPartnerDtoStatusEnum._(r'PENDING');
  static const APPROVED = SeedPartnerDtoStatusEnum._(r'APPROVED');
  static const REJECTED = SeedPartnerDtoStatusEnum._(r'REJECTED');
  static const REQUIRED_RESUBMIT = SeedPartnerDtoStatusEnum._(r'REQUIRED_RESUBMIT');

  /// List of all possible values in this [enum][SeedPartnerDtoStatusEnum].
  static const values = <SeedPartnerDtoStatusEnum>[
    PENDING,
    APPROVED,
    REJECTED,
    REQUIRED_RESUBMIT,
  ];

  static SeedPartnerDtoStatusEnum? fromJson(dynamic value) => SeedPartnerDtoStatusEnumTypeTransformer().decode(value);

  static List<SeedPartnerDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SeedPartnerDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SeedPartnerDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [SeedPartnerDtoStatusEnum] to String,
/// and [decode] dynamic data back to [SeedPartnerDtoStatusEnum].
class SeedPartnerDtoStatusEnumTypeTransformer {
  factory SeedPartnerDtoStatusEnumTypeTransformer() => _instance ??= const SeedPartnerDtoStatusEnumTypeTransformer._();

  const SeedPartnerDtoStatusEnumTypeTransformer._();

  String encode(SeedPartnerDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a SeedPartnerDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  SeedPartnerDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'PENDING': return SeedPartnerDtoStatusEnum.PENDING;
        case r'APPROVED': return SeedPartnerDtoStatusEnum.APPROVED;
        case r'REJECTED': return SeedPartnerDtoStatusEnum.REJECTED;
        case r'REQUIRED_RESUBMIT': return SeedPartnerDtoStatusEnum.REQUIRED_RESUBMIT;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [SeedPartnerDtoStatusEnumTypeTransformer] instance.
  static SeedPartnerDtoStatusEnumTypeTransformer? _instance;
}


