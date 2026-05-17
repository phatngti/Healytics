//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of test_backdoor_api;

class SeedBookingDto {
  /// Returns a new [SeedBookingDto] instance.
  SeedBookingDto({
    this.key,
    this.userKey,
    this.userEmail,
    this.serviceKey,
    this.serviceSlug,
    this.employeeKey,
    this.employeeEmail,
    required this.startsAt,
    this.status,
    this.endsAt,
    this.paymentUrl,
    this.paymentExpiresAt,
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

  SeedBookingDtoStatusEnum? status;

  /// ISO 8601 end time
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? endsAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? paymentUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? paymentExpiresAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SeedBookingDto &&
    other.key == key &&
    other.userKey == userKey &&
    other.userEmail == userEmail &&
    other.serviceKey == serviceKey &&
    other.serviceSlug == serviceSlug &&
    other.employeeKey == employeeKey &&
    other.employeeEmail == employeeEmail &&
    other.startsAt == startsAt &&
    other.status == status &&
    other.endsAt == endsAt &&
    other.paymentUrl == paymentUrl &&
    other.paymentExpiresAt == paymentExpiresAt;

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
    (startsAt.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (endsAt == null ? 0 : endsAt!.hashCode) +
    (paymentUrl == null ? 0 : paymentUrl!.hashCode) +
    (paymentExpiresAt == null ? 0 : paymentExpiresAt!.hashCode);

  @override
  String toString() => 'SeedBookingDto[key=$key, userKey=$userKey, userEmail=$userEmail, serviceKey=$serviceKey, serviceSlug=$serviceSlug, employeeKey=$employeeKey, employeeEmail=$employeeEmail, startsAt=$startsAt, status=$status, endsAt=$endsAt, paymentUrl=$paymentUrl, paymentExpiresAt=$paymentExpiresAt]';

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
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
    if (this.endsAt != null) {
      json[r'endsAt'] = this.endsAt;
    } else {
      json[r'endsAt'] = null;
    }
    if (this.paymentUrl != null) {
      json[r'paymentUrl'] = this.paymentUrl;
    } else {
      json[r'paymentUrl'] = null;
    }
    if (this.paymentExpiresAt != null) {
      json[r'paymentExpiresAt'] = this.paymentExpiresAt;
    } else {
      json[r'paymentExpiresAt'] = null;
    }
    return json;
  }

  /// Returns a new [SeedBookingDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SeedBookingDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SeedBookingDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SeedBookingDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SeedBookingDto(
        key: mapValueOfType<String>(json, r'key'),
        userKey: mapValueOfType<String>(json, r'userKey'),
        userEmail: mapValueOfType<String>(json, r'userEmail'),
        serviceKey: mapValueOfType<String>(json, r'serviceKey'),
        serviceSlug: mapValueOfType<String>(json, r'serviceSlug'),
        employeeKey: mapValueOfType<String>(json, r'employeeKey'),
        employeeEmail: mapValueOfType<String>(json, r'employeeEmail'),
        startsAt: mapValueOfType<String>(json, r'startsAt')!,
        status: SeedBookingDtoStatusEnum.fromJson(json[r'status']),
        endsAt: mapValueOfType<String>(json, r'endsAt'),
        paymentUrl: mapValueOfType<String>(json, r'paymentUrl'),
        paymentExpiresAt: mapValueOfType<String>(json, r'paymentExpiresAt'),
      );
    }
    return null;
  }

  static List<SeedBookingDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SeedBookingDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SeedBookingDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SeedBookingDto> mapFromJson(dynamic json) {
    final map = <String, SeedBookingDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SeedBookingDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SeedBookingDto-objects as value to a dart map
  static Map<String, List<SeedBookingDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SeedBookingDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SeedBookingDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'startsAt',
  };
}


class SeedBookingDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const SeedBookingDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const PENDING_PAYMENT = SeedBookingDtoStatusEnum._(r'PENDING_PAYMENT');
  static const CONFIRMED = SeedBookingDtoStatusEnum._(r'CONFIRMED');
  static const IN_PROGRESS = SeedBookingDtoStatusEnum._(r'IN_PROGRESS');
  static const CANCELLED = SeedBookingDtoStatusEnum._(r'CANCELLED');
  static const COMPLETED = SeedBookingDtoStatusEnum._(r'COMPLETED');
  static const NO_SHOW = SeedBookingDtoStatusEnum._(r'NO_SHOW');

  /// List of all possible values in this [enum][SeedBookingDtoStatusEnum].
  static const values = <SeedBookingDtoStatusEnum>[
    PENDING_PAYMENT,
    CONFIRMED,
    IN_PROGRESS,
    CANCELLED,
    COMPLETED,
    NO_SHOW,
  ];

  static SeedBookingDtoStatusEnum? fromJson(dynamic value) => SeedBookingDtoStatusEnumTypeTransformer().decode(value);

  static List<SeedBookingDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SeedBookingDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SeedBookingDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [SeedBookingDtoStatusEnum] to String,
/// and [decode] dynamic data back to [SeedBookingDtoStatusEnum].
class SeedBookingDtoStatusEnumTypeTransformer {
  factory SeedBookingDtoStatusEnumTypeTransformer() => _instance ??= const SeedBookingDtoStatusEnumTypeTransformer._();

  const SeedBookingDtoStatusEnumTypeTransformer._();

  String encode(SeedBookingDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a SeedBookingDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  SeedBookingDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'PENDING_PAYMENT': return SeedBookingDtoStatusEnum.PENDING_PAYMENT;
        case r'CONFIRMED': return SeedBookingDtoStatusEnum.CONFIRMED;
        case r'IN_PROGRESS': return SeedBookingDtoStatusEnum.IN_PROGRESS;
        case r'CANCELLED': return SeedBookingDtoStatusEnum.CANCELLED;
        case r'COMPLETED': return SeedBookingDtoStatusEnum.COMPLETED;
        case r'NO_SHOW': return SeedBookingDtoStatusEnum.NO_SHOW;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [SeedBookingDtoStatusEnumTypeTransformer] instance.
  static SeedBookingDtoStatusEnumTypeTransformer? _instance;
}


