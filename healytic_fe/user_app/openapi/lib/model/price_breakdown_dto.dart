//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PriceBreakdownDto {
  /// Returns a new [PriceBreakdownDto] instance.
  PriceBreakdownDto({
    required this.subTotal,
    required this.discount,
    required this.totalAmount,
    required this.currency,
  });

  num subTotal;

  num discount;

  num totalAmount;

  String currency;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PriceBreakdownDto &&
    other.subTotal == subTotal &&
    other.discount == discount &&
    other.totalAmount == totalAmount &&
    other.currency == currency;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (subTotal.hashCode) +
    (discount.hashCode) +
    (totalAmount.hashCode) +
    (currency.hashCode);

  @override
  String toString() => 'PriceBreakdownDto[subTotal=$subTotal, discount=$discount, totalAmount=$totalAmount, currency=$currency]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'subTotal'] = this.subTotal;
      json[r'discount'] = this.discount;
      json[r'totalAmount'] = this.totalAmount;
      json[r'currency'] = this.currency;
    return json;
  }

  /// Returns a new [PriceBreakdownDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PriceBreakdownDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PriceBreakdownDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PriceBreakdownDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PriceBreakdownDto(
        subTotal: num.parse('${json[r'subTotal']}'),
        discount: num.parse('${json[r'discount']}'),
        totalAmount: num.parse('${json[r'totalAmount']}'),
        currency: mapValueOfType<String>(json, r'currency')!,
      );
    }
    return null;
  }

  static List<PriceBreakdownDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PriceBreakdownDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PriceBreakdownDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PriceBreakdownDto> mapFromJson(dynamic json) {
    final map = <String, PriceBreakdownDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PriceBreakdownDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PriceBreakdownDto-objects as value to a dart map
  static Map<String, List<PriceBreakdownDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PriceBreakdownDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PriceBreakdownDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'subTotal',
    'discount',
    'totalAmount',
    'currency',
  };
}

