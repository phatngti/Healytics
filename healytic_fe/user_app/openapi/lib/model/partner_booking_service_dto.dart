//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerBookingServiceDto {
  /// Returns a new [PartnerBookingServiceDto] instance.
  PartnerBookingServiceDto({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.price,
    required this.currencyCode,
  });


  String id;

  String name;

  String categoryName;

  num price;

  String currencyCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerBookingServiceDto &&
    other.id == id &&
    other.name == name &&
    other.categoryName == categoryName &&
    other.price == price &&
    other.currencyCode == currencyCode;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (categoryName.hashCode) +
    (price.hashCode) +
    (currencyCode.hashCode);

  @override
  String toString() => 'PartnerBookingServiceDto[id=$id, name=$name, categoryName=$categoryName, price=$price, currencyCode=$currencyCode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'categoryName'] = this.categoryName;
      json[r'price'] = this.price;
      json[r'currencyCode'] = this.currencyCode;
    return json;
  }

  /// Returns a new [PartnerBookingServiceDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerBookingServiceDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerBookingServiceDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerBookingServiceDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerBookingServiceDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        categoryName: mapValueOfType<String>(json, r'categoryName')!,
        price: num.parse('${json[r'price']}'),
        currencyCode: mapValueOfType<String>(json, r'currencyCode')!,
      );
    }
    return null;
  }

  static List<PartnerBookingServiceDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerBookingServiceDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerBookingServiceDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerBookingServiceDto> mapFromJson(dynamic json) {
    final map = <String, PartnerBookingServiceDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerBookingServiceDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerBookingServiceDto-objects as value to a dart map
  static Map<String, List<PartnerBookingServiceDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerBookingServiceDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerBookingServiceDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'categoryName',
    'price',
    'currencyCode',
  };
}

