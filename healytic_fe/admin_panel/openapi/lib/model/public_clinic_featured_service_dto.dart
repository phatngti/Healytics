//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicClinicFeaturedServiceDto {
  /// Returns a new [PublicClinicFeaturedServiceDto] instance.
  PublicClinicFeaturedServiceDto({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.price,
    required this.rating,
    required this.bookedLabel,
  });


  String id;

  String title;

  String? imageUrl;

  String price;

  num rating;

  String bookedLabel;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicClinicFeaturedServiceDto &&
    other.id == id &&
    other.title == title &&
    other.imageUrl == imageUrl &&
    other.price == price &&
    other.rating == rating &&
    other.bookedLabel == bookedLabel;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (price.hashCode) +
    (rating.hashCode) +
    (bookedLabel.hashCode);

  @override
  String toString() => 'PublicClinicFeaturedServiceDto[id=$id, title=$title, imageUrl=$imageUrl, price=$price, rating=$rating, bookedLabel=$bookedLabel]';

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
      json[r'rating'] = this.rating;
      json[r'bookedLabel'] = this.bookedLabel;
    return json;
  }

  /// Returns a new [PublicClinicFeaturedServiceDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicClinicFeaturedServiceDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicClinicFeaturedServiceDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicClinicFeaturedServiceDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicClinicFeaturedServiceDto(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        imageUrl: mapValueOfType<String>(json, r'imageUrl'),
        price: mapValueOfType<String>(json, r'price')!,
        rating: num.parse('${json[r'rating']}'),
        bookedLabel: mapValueOfType<String>(json, r'bookedLabel')!,
      );
    }
    return null;
  }

  static List<PublicClinicFeaturedServiceDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicClinicFeaturedServiceDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicClinicFeaturedServiceDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicClinicFeaturedServiceDto> mapFromJson(dynamic json) {
    final map = <String, PublicClinicFeaturedServiceDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicClinicFeaturedServiceDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicClinicFeaturedServiceDto-objects as value to a dart map
  static Map<String, List<PublicClinicFeaturedServiceDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicClinicFeaturedServiceDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicClinicFeaturedServiceDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'price',
    'rating',
    'bookedLabel',
  };
}

