//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ClinicProductDto {
  /// Returns a new [ClinicProductDto] instance.
  ClinicProductDto({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.price,
    required this.priceAmount,
    this.originalPrice,
    this.discountLabel,
    this.badgeLabel,
    this.durationLabel,
    this.specialistLabel,
    required this.categoryId,
    required this.soldCount,
    required this.createdAtMs,
  });


  String id;

  String title;

  String? imageUrl;

  String price;

  num priceAmount;

  String? originalPrice;

  String? discountLabel;

  String? badgeLabel;

  String? durationLabel;

  String? specialistLabel;

  String categoryId;

  num soldCount;

  num createdAtMs;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ClinicProductDto &&
    other.id == id &&
    other.title == title &&
    other.imageUrl == imageUrl &&
    other.price == price &&
    other.priceAmount == priceAmount &&
    other.originalPrice == originalPrice &&
    other.discountLabel == discountLabel &&
    other.badgeLabel == badgeLabel &&
    other.durationLabel == durationLabel &&
    other.specialistLabel == specialistLabel &&
    other.categoryId == categoryId &&
    other.soldCount == soldCount &&
    other.createdAtMs == createdAtMs;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (price.hashCode) +
    (priceAmount.hashCode) +
    (originalPrice == null ? 0 : originalPrice!.hashCode) +
    (discountLabel == null ? 0 : discountLabel!.hashCode) +
    (badgeLabel == null ? 0 : badgeLabel!.hashCode) +
    (durationLabel == null ? 0 : durationLabel!.hashCode) +
    (specialistLabel == null ? 0 : specialistLabel!.hashCode) +
    (categoryId.hashCode) +
    (soldCount.hashCode) +
    (createdAtMs.hashCode);

  @override
  String toString() => 'ClinicProductDto[id=$id, title=$title, imageUrl=$imageUrl, price=$price, priceAmount=$priceAmount, originalPrice=$originalPrice, discountLabel=$discountLabel, badgeLabel=$badgeLabel, durationLabel=$durationLabel, specialistLabel=$specialistLabel, categoryId=$categoryId, soldCount=$soldCount, createdAtMs=$createdAtMs]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
    if (this.imageUrl != null) {
      json[r'imageUrl'] = this.imageUrl;
    } else {
      json[r'imageUrl'] = null;
    }
      json[r'price'] = this.price;
      json[r'priceAmount'] = this.priceAmount;
    if (this.originalPrice != null) {
      json[r'originalPrice'] = this.originalPrice;
    } else {
      json[r'originalPrice'] = null;
    }
    if (this.discountLabel != null) {
      json[r'discountLabel'] = this.discountLabel;
    } else {
      json[r'discountLabel'] = null;
    }
    if (this.badgeLabel != null) {
      json[r'badgeLabel'] = this.badgeLabel;
    } else {
      json[r'badgeLabel'] = null;
    }
    if (this.durationLabel != null) {
      json[r'durationLabel'] = this.durationLabel;
    } else {
      json[r'durationLabel'] = null;
    }
    if (this.specialistLabel != null) {
      json[r'specialistLabel'] = this.specialistLabel;
    } else {
      json[r'specialistLabel'] = null;
    }
      json[r'categoryId'] = this.categoryId;
      json[r'soldCount'] = this.soldCount;
      json[r'createdAtMs'] = this.createdAtMs;
    return json;
  }

  /// Returns a new [ClinicProductDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ClinicProductDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ClinicProductDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ClinicProductDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ClinicProductDto(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        imageUrl: mapValueOfType<String>(json, r'imageUrl'),
        price: mapValueOfType<String>(json, r'price')!,
        priceAmount: num.parse('${json[r'priceAmount']}'),
        originalPrice: mapValueOfType<String>(json, r'originalPrice'),
        discountLabel: mapValueOfType<String>(json, r'discountLabel'),
        badgeLabel: mapValueOfType<String>(json, r'badgeLabel'),
        durationLabel: mapValueOfType<String>(json, r'durationLabel'),
        specialistLabel: mapValueOfType<String>(json, r'specialistLabel'),
        categoryId: mapValueOfType<String>(json, r'categoryId')!,
        soldCount: num.parse('${json[r'soldCount']}'),
        createdAtMs: num.parse('${json[r'createdAtMs']}'),
      );
    }
    return null;
  }

  static List<ClinicProductDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ClinicProductDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ClinicProductDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ClinicProductDto> mapFromJson(dynamic json) {
    final map = <String, ClinicProductDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ClinicProductDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ClinicProductDto-objects as value to a dart map
  static Map<String, List<ClinicProductDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ClinicProductDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ClinicProductDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'price',
    'priceAmount',
    'categoryId',
    'soldCount',
    'createdAtMs',
  };
}

