//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of test_backdoor_api;

class SeedPayloadDto {
  /// Returns a new [SeedPayloadDto] instance.
  SeedPayloadDto({
    this.users = const [],
    this.categories = const [],
    this.partners = const [],
    this.employees = const [],
    this.services = const [],
    this.coupons = const [],
    this.cartItems = const [],
    this.bookings = const [],
    this.notifications = const [],
  });


  List<SeedUserDto> users;

  List<SeedCategoryDto> categories;

  List<SeedPartnerDto> partners;

  List<SeedEmployeeDto> employees;

  List<SeedServiceDto> services;

  List<SeedCouponDto> coupons;

  List<SeedCartItemDto> cartItems;

  List<SeedBookingDto> bookings;

  List<SeedNotificationDto> notifications;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SeedPayloadDto &&
    _deepEquality.equals(other.users, users) &&
    _deepEquality.equals(other.categories, categories) &&
    _deepEquality.equals(other.partners, partners) &&
    _deepEquality.equals(other.employees, employees) &&
    _deepEquality.equals(other.services, services) &&
    _deepEquality.equals(other.coupons, coupons) &&
    _deepEquality.equals(other.cartItems, cartItems) &&
    _deepEquality.equals(other.bookings, bookings) &&
    _deepEquality.equals(other.notifications, notifications);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (users.hashCode) +
    (categories.hashCode) +
    (partners.hashCode) +
    (employees.hashCode) +
    (services.hashCode) +
    (coupons.hashCode) +
    (cartItems.hashCode) +
    (bookings.hashCode) +
    (notifications.hashCode);

  @override
  String toString() => 'SeedPayloadDto[users=$users, categories=$categories, partners=$partners, employees=$employees, services=$services, coupons=$coupons, cartItems=$cartItems, bookings=$bookings, notifications=$notifications]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'users'] = this.users;
      json[r'categories'] = this.categories;
      json[r'partners'] = this.partners;
      json[r'employees'] = this.employees;
      json[r'services'] = this.services;
      json[r'coupons'] = this.coupons;
      json[r'cartItems'] = this.cartItems;
      json[r'bookings'] = this.bookings;
      json[r'notifications'] = this.notifications;
    return json;
  }

  /// Returns a new [SeedPayloadDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SeedPayloadDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SeedPayloadDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SeedPayloadDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SeedPayloadDto(
        users: SeedUserDto.listFromJson(json[r'users']),
        categories: SeedCategoryDto.listFromJson(json[r'categories']),
        partners: SeedPartnerDto.listFromJson(json[r'partners']),
        employees: SeedEmployeeDto.listFromJson(json[r'employees']),
        services: SeedServiceDto.listFromJson(json[r'services']),
        coupons: SeedCouponDto.listFromJson(json[r'coupons']),
        cartItems: SeedCartItemDto.listFromJson(json[r'cartItems']),
        bookings: SeedBookingDto.listFromJson(json[r'bookings']),
        notifications: SeedNotificationDto.listFromJson(json[r'notifications']),
      );
    }
    return null;
  }

  static List<SeedPayloadDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SeedPayloadDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SeedPayloadDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SeedPayloadDto> mapFromJson(dynamic json) {
    final map = <String, SeedPayloadDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SeedPayloadDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SeedPayloadDto-objects as value to a dart map
  static Map<String, List<SeedPayloadDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SeedPayloadDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SeedPayloadDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

