//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerRecommendedServiceDto {
  /// Returns a new [PartnerRecommendedServiceDto] instance.
  PartnerRecommendedServiceDto({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.price,
  });


  String id;

  String title;

  String? imageUrl;

  num rating;

  num reviewCount;

  String price;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerRecommendedServiceDto &&
    other.id == id &&
    other.title == title &&
    other.imageUrl == imageUrl &&
    other.rating == rating &&
    other.reviewCount == reviewCount &&
    other.price == price;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (rating.hashCode) +
    (reviewCount.hashCode) +
    (price.hashCode);

  @override
  String toString() => 'PartnerRecommendedServiceDto[id=$id, title=$title, imageUrl=$imageUrl, rating=$rating, reviewCount=$reviewCount, price=$price]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
    if (this.imageUrl != null) {
      json[r'imageUrl'] = this.imageUrl;
    } else {
      json[r'imageUrl'] = null;
    }
      json[r'rating'] = this.rating;
      json[r'reviewCount'] = this.reviewCount;
      json[r'price'] = this.price;
    return json;
  }

  /// Returns a new [PartnerRecommendedServiceDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerRecommendedServiceDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerRecommendedServiceDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerRecommendedServiceDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerRecommendedServiceDto(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        imageUrl: mapValueOfType<String>(json, r'imageUrl'),
        rating: num.parse('${json[r'rating']}'),
        reviewCount: num.parse('${json[r'reviewCount']}'),
        price: mapValueOfType<String>(json, r'price')!,
      );
    }
    return null;
  }

  static List<PartnerRecommendedServiceDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerRecommendedServiceDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerRecommendedServiceDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerRecommendedServiceDto> mapFromJson(dynamic json) {
    final map = <String, PartnerRecommendedServiceDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerRecommendedServiceDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerRecommendedServiceDto-objects as value to a dart map
  static Map<String, List<PartnerRecommendedServiceDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerRecommendedServiceDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerRecommendedServiceDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'rating',
    'reviewCount',
    'price',
  };
}

