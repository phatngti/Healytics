//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SavedPaymentCardDto {
  /// Returns a new [SavedPaymentCardDto] instance.
  SavedPaymentCardDto({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    this.funding,
    this.country,
    required this.isDefault,
  });


  String id;

  String brand;

  String last4;

  num expMonth;

  num expYear;

  String? funding;

  String? country;

  bool isDefault;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SavedPaymentCardDto &&
    other.id == id &&
    other.brand == brand &&
    other.last4 == last4 &&
    other.expMonth == expMonth &&
    other.expYear == expYear &&
    other.funding == funding &&
    other.country == country &&
    other.isDefault == isDefault;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (brand.hashCode) +
    (last4.hashCode) +
    (expMonth.hashCode) +
    (expYear.hashCode) +
    (funding == null ? 0 : funding!.hashCode) +
    (country == null ? 0 : country!.hashCode) +
    (isDefault.hashCode);

  @override
  String toString() => 'SavedPaymentCardDto[id=$id, brand=$brand, last4=$last4, expMonth=$expMonth, expYear=$expYear, funding=$funding, country=$country, isDefault=$isDefault]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'brand'] = this.brand;
      json[r'last4'] = this.last4;
      json[r'expMonth'] = this.expMonth;
      json[r'expYear'] = this.expYear;
    if (this.funding != null) {
      json[r'funding'] = this.funding;
    } else {
      json[r'funding'] = null;
    }
    if (this.country != null) {
      json[r'country'] = this.country;
    } else {
      json[r'country'] = null;
    }
      json[r'isDefault'] = this.isDefault;
    return json;
  }

  /// Returns a new [SavedPaymentCardDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SavedPaymentCardDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SavedPaymentCardDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SavedPaymentCardDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SavedPaymentCardDto(
        id: mapValueOfType<String>(json, r'id')!,
        brand: mapValueOfType<String>(json, r'brand')!,
        last4: mapValueOfType<String>(json, r'last4')!,
        expMonth: num.parse('${json[r'expMonth']}'),
        expYear: num.parse('${json[r'expYear']}'),
        funding: mapValueOfType<String>(json, r'funding'),
        country: mapValueOfType<String>(json, r'country'),
        isDefault: mapValueOfType<bool>(json, r'isDefault')!,
      );
    }
    return null;
  }

  static List<SavedPaymentCardDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SavedPaymentCardDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SavedPaymentCardDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SavedPaymentCardDto> mapFromJson(dynamic json) {
    final map = <String, SavedPaymentCardDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SavedPaymentCardDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SavedPaymentCardDto-objects as value to a dart map
  static Map<String, List<SavedPaymentCardDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SavedPaymentCardDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SavedPaymentCardDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'brand',
    'last4',
    'expMonth',
    'expYear',
    'isDefault',
  };
}

