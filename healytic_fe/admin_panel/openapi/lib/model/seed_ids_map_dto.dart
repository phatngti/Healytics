//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SeedIdsMapDto {
  /// Returns a new [SeedIdsMapDto] instance.
  SeedIdsMapDto({
    this.users = const {},
    this.categories = const {},
    this.partners = const {},
    this.employees = const {},
    this.services = const {},
    this.cartItems = const {},
    this.bookings = const {},
    this.coupons = const {},
  });


  /// user key → account UUID
  Map<String, String> users;

  Map<String, String> categories;

  Map<String, String> partners;

  Map<String, String> employees;

  Map<String, String> services;

  Map<String, String> cartItems;

  Map<String, String> bookings;

  Map<String, String> coupons;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SeedIdsMapDto &&
    _deepEquality.equals(other.users, users) &&
    _deepEquality.equals(other.categories, categories) &&
    _deepEquality.equals(other.partners, partners) &&
    _deepEquality.equals(other.employees, employees) &&
    _deepEquality.equals(other.services, services) &&
    _deepEquality.equals(other.cartItems, cartItems) &&
    _deepEquality.equals(other.bookings, bookings) &&
    _deepEquality.equals(other.coupons, coupons);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (users.hashCode) +
    (categories.hashCode) +
    (partners.hashCode) +
    (employees.hashCode) +
    (services.hashCode) +
    (cartItems.hashCode) +
    (bookings.hashCode) +
    (coupons.hashCode);

  @override
  String toString() => 'SeedIdsMapDto[users=$users, categories=$categories, partners=$partners, employees=$employees, services=$services, cartItems=$cartItems, bookings=$bookings, coupons=$coupons]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'users'] = this.users;
      json[r'categories'] = this.categories;
      json[r'partners'] = this.partners;
      json[r'employees'] = this.employees;
      json[r'services'] = this.services;
      json[r'cartItems'] = this.cartItems;
      json[r'bookings'] = this.bookings;
      json[r'coupons'] = this.coupons;
    return json;
  }

  /// Returns a new [SeedIdsMapDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SeedIdsMapDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SeedIdsMapDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SeedIdsMapDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SeedIdsMapDto(
        users: mapCastOfType<String, String>(json, r'users') ?? const {},
        categories: mapCastOfType<String, String>(json, r'categories') ?? const {},
        partners: mapCastOfType<String, String>(json, r'partners') ?? const {},
        employees: mapCastOfType<String, String>(json, r'employees') ?? const {},
        services: mapCastOfType<String, String>(json, r'services') ?? const {},
        cartItems: mapCastOfType<String, String>(json, r'cartItems') ?? const {},
        bookings: mapCastOfType<String, String>(json, r'bookings') ?? const {},
        coupons: mapCastOfType<String, String>(json, r'coupons') ?? const {},
      );
    }
    return null;
  }

  static List<SeedIdsMapDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SeedIdsMapDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SeedIdsMapDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SeedIdsMapDto> mapFromJson(dynamic json) {
    final map = <String, SeedIdsMapDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SeedIdsMapDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SeedIdsMapDto-objects as value to a dart map
  static Map<String, List<SeedIdsMapDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SeedIdsMapDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SeedIdsMapDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

