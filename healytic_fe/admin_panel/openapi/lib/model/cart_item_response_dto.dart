//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CartItemResponseDto {
  /// Returns a new [CartItemResponseDto] instance.
  CartItemResponseDto({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.serviceImageUrl,
    required this.price,
    required this.priceAmount,
    required this.clinicId,
    required this.clinicName,
    required this.clinicAddress,
    this.clinicImageUrl,
    this.couponCode,
    this.couponDiscountPercent,
    this.couponDiscountAmount,
    required this.createdAt,
  });

  String id;

  String serviceId;

  String serviceName;

  String serviceImageUrl;

  String price;

  num priceAmount;

  String clinicId;

  String clinicName;

  String clinicAddress;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? clinicImageUrl;

  Object? couponCode;

  Object? couponDiscountPercent;

  Object? couponDiscountAmount;

  DateTime createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CartItemResponseDto &&
    other.id == id &&
    other.serviceId == serviceId &&
    other.serviceName == serviceName &&
    other.serviceImageUrl == serviceImageUrl &&
    other.price == price &&
    other.priceAmount == priceAmount &&
    other.clinicId == clinicId &&
    other.clinicName == clinicName &&
    other.clinicAddress == clinicAddress &&
    other.clinicImageUrl == clinicImageUrl &&
    other.couponCode == couponCode &&
    other.couponDiscountPercent == couponDiscountPercent &&
    other.couponDiscountAmount == couponDiscountAmount &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (serviceId.hashCode) +
    (serviceName.hashCode) +
    (serviceImageUrl.hashCode) +
    (price.hashCode) +
    (priceAmount.hashCode) +
    (clinicId.hashCode) +
    (clinicName.hashCode) +
    (clinicAddress.hashCode) +
    (clinicImageUrl == null ? 0 : clinicImageUrl!.hashCode) +
    (couponCode == null ? 0 : couponCode!.hashCode) +
    (couponDiscountPercent == null ? 0 : couponDiscountPercent!.hashCode) +
    (couponDiscountAmount == null ? 0 : couponDiscountAmount!.hashCode) +
    (createdAt.hashCode);

  @override
  String toString() => 'CartItemResponseDto[id=$id, serviceId=$serviceId, serviceName=$serviceName, serviceImageUrl=$serviceImageUrl, price=$price, priceAmount=$priceAmount, clinicId=$clinicId, clinicName=$clinicName, clinicAddress=$clinicAddress, clinicImageUrl=$clinicImageUrl, couponCode=$couponCode, couponDiscountPercent=$couponDiscountPercent, couponDiscountAmount=$couponDiscountAmount, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'serviceId'] = this.serviceId;
      json[r'serviceName'] = this.serviceName;
      json[r'serviceImageUrl'] = this.serviceImageUrl;
      json[r'price'] = this.price;
      json[r'priceAmount'] = this.priceAmount;
      json[r'clinicId'] = this.clinicId;
      json[r'clinicName'] = this.clinicName;
      json[r'clinicAddress'] = this.clinicAddress;
    if (this.clinicImageUrl != null) {
      json[r'clinicImageUrl'] = this.clinicImageUrl;
    } else {
      json[r'clinicImageUrl'] = null;
    }
    if (this.couponCode != null) {
      json[r'couponCode'] = this.couponCode;
    } else {
      json[r'couponCode'] = null;
    }
    if (this.couponDiscountPercent != null) {
      json[r'couponDiscountPercent'] = this.couponDiscountPercent;
    } else {
      json[r'couponDiscountPercent'] = null;
    }
    if (this.couponDiscountAmount != null) {
      json[r'couponDiscountAmount'] = this.couponDiscountAmount;
    } else {
      json[r'couponDiscountAmount'] = null;
    }
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [CartItemResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CartItemResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CartItemResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CartItemResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CartItemResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        serviceId: mapValueOfType<String>(json, r'serviceId')!,
        serviceName: mapValueOfType<String>(json, r'serviceName')!,
        serviceImageUrl: mapValueOfType<String>(json, r'serviceImageUrl')!,
        price: mapValueOfType<String>(json, r'price')!,
        priceAmount: num.parse('${json[r'priceAmount']}'),
        clinicId: mapValueOfType<String>(json, r'clinicId')!,
        clinicName: mapValueOfType<String>(json, r'clinicName')!,
        clinicAddress: mapValueOfType<String>(json, r'clinicAddress')!,
        clinicImageUrl: mapValueOfType<Object>(json, r'clinicImageUrl'),
        couponCode: mapValueOfType<Object>(json, r'couponCode'),
        couponDiscountPercent: mapValueOfType<Object>(json, r'couponDiscountPercent'),
        couponDiscountAmount: mapValueOfType<Object>(json, r'couponDiscountAmount'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
      );
    }
    return null;
  }

  static List<CartItemResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CartItemResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CartItemResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CartItemResponseDto> mapFromJson(dynamic json) {
    final map = <String, CartItemResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CartItemResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CartItemResponseDto-objects as value to a dart map
  static Map<String, List<CartItemResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CartItemResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CartItemResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'serviceId',
    'serviceName',
    'serviceImageUrl',
    'price',
    'priceAmount',
    'clinicId',
    'clinicName',
    'clinicAddress',
    'createdAt',
  };
}

