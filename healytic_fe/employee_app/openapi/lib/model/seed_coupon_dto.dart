//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SeedCouponDto {
  /// Returns a new [SeedCouponDto] instance.
  SeedCouponDto({
    this.key,
    required this.code,
    required this.discountPercent,
    this.maxDiscountAmount,
    this.usageLimit,
    this.serviceKey,
    this.serviceSlug,
    this.categoryName,
    this.expiresAt,
  });


  /// Unique lookup key
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? key;

  String code;

  num discountPercent;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? maxDiscountAmount;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? usageLimit;

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

  /// Category name (auto-created if missing)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? categoryName;

  /// ISO 8601 expiry
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? expiresAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SeedCouponDto &&
    other.key == key &&
    other.code == code &&
    other.discountPercent == discountPercent &&
    other.maxDiscountAmount == maxDiscountAmount &&
    other.usageLimit == usageLimit &&
    other.serviceKey == serviceKey &&
    other.serviceSlug == serviceSlug &&
    other.categoryName == categoryName &&
    other.expiresAt == expiresAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (key == null ? 0 : key!.hashCode) +
    (code.hashCode) +
    (discountPercent.hashCode) +
    (maxDiscountAmount == null ? 0 : maxDiscountAmount!.hashCode) +
    (usageLimit == null ? 0 : usageLimit!.hashCode) +
    (serviceKey == null ? 0 : serviceKey!.hashCode) +
    (serviceSlug == null ? 0 : serviceSlug!.hashCode) +
    (categoryName == null ? 0 : categoryName!.hashCode) +
    (expiresAt == null ? 0 : expiresAt!.hashCode);

  @override
  String toString() => 'SeedCouponDto[key=$key, code=$code, discountPercent=$discountPercent, maxDiscountAmount=$maxDiscountAmount, usageLimit=$usageLimit, serviceKey=$serviceKey, serviceSlug=$serviceSlug, categoryName=$categoryName, expiresAt=$expiresAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.key != null) {
      json[r'key'] = this.key;
    } else {
      json[r'key'] = null;
    }
      json[r'code'] = this.code;
      json[r'discountPercent'] = this.discountPercent;
    if (this.maxDiscountAmount != null) {
      json[r'maxDiscountAmount'] = this.maxDiscountAmount;
    } else {
      json[r'maxDiscountAmount'] = null;
    }
    if (this.usageLimit != null) {
      json[r'usageLimit'] = this.usageLimit;
    } else {
      json[r'usageLimit'] = null;
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
    if (this.categoryName != null) {
      json[r'categoryName'] = this.categoryName;
    } else {
      json[r'categoryName'] = null;
    }
    if (this.expiresAt != null) {
      json[r'expiresAt'] = this.expiresAt;
    } else {
      json[r'expiresAt'] = null;
    }
    return json;
  }

  /// Returns a new [SeedCouponDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SeedCouponDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SeedCouponDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SeedCouponDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SeedCouponDto(
        key: mapValueOfType<String>(json, r'key'),
        code: mapValueOfType<String>(json, r'code')!,
        discountPercent: num.parse('${json[r'discountPercent']}'),
        maxDiscountAmount: num.parse('${json[r'maxDiscountAmount']}'),
        usageLimit: num.parse('${json[r'usageLimit']}'),
        serviceKey: mapValueOfType<String>(json, r'serviceKey'),
        serviceSlug: mapValueOfType<String>(json, r'serviceSlug'),
        categoryName: mapValueOfType<String>(json, r'categoryName'),
        expiresAt: mapValueOfType<String>(json, r'expiresAt'),
      );
    }
    return null;
  }

  static List<SeedCouponDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SeedCouponDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SeedCouponDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SeedCouponDto> mapFromJson(dynamic json) {
    final map = <String, SeedCouponDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SeedCouponDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SeedCouponDto-objects as value to a dart map
  static Map<String, List<SeedCouponDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SeedCouponDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SeedCouponDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'code',
    'discountPercent',
  };
}

