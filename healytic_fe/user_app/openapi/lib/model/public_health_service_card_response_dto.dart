//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicHealthServiceCardResponseDto {
  /// Returns a new [PublicHealthServiceCardResponseDto] instance.
  PublicHealthServiceCardResponseDto({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
    required this.category,
    required this.duration,
    required this.price,
    required this.rating,
    required this.vendorName,
    required this.location,
    this.staffAvatars = const [],
    required this.type,
  });

  String id;

  String name;

  String slug;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? imageUrl;

  String category;

  String duration;

  String price;

  String rating;

  String vendorName;

  String location;

  List<String> staffAvatars;

  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicHealthServiceCardResponseDto &&
    other.id == id &&
    other.name == name &&
    other.slug == slug &&
    other.imageUrl == imageUrl &&
    other.category == category &&
    other.duration == duration &&
    other.price == price &&
    other.rating == rating &&
    other.vendorName == vendorName &&
    other.location == location &&
    _deepEquality.equals(other.staffAvatars, staffAvatars) &&
    other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (slug.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (category.hashCode) +
    (duration.hashCode) +
    (price.hashCode) +
    (rating.hashCode) +
    (vendorName.hashCode) +
    (location.hashCode) +
    (staffAvatars.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'PublicHealthServiceCardResponseDto[id=$id, name=$name, slug=$slug, imageUrl=$imageUrl, category=$category, duration=$duration, price=$price, rating=$rating, vendorName=$vendorName, location=$location, staffAvatars=$staffAvatars, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'slug'] = this.slug;
    if (this.imageUrl != null) {
      json[r'imageUrl'] = this.imageUrl;
    } else {
      json[r'imageUrl'] = null;
    }
      json[r'category'] = this.category;
      json[r'duration'] = this.duration;
      json[r'price'] = this.price;
      json[r'rating'] = this.rating;
      json[r'vendorName'] = this.vendorName;
      json[r'location'] = this.location;
      json[r'staffAvatars'] = this.staffAvatars;
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [PublicHealthServiceCardResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicHealthServiceCardResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicHealthServiceCardResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicHealthServiceCardResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicHealthServiceCardResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        slug: mapValueOfType<String>(json, r'slug')!,
        imageUrl: mapValueOfType<Object>(json, r'imageUrl'),
        category: mapValueOfType<String>(json, r'category')!,
        duration: mapValueOfType<String>(json, r'duration')!,
        price: mapValueOfType<String>(json, r'price')!,
        rating: mapValueOfType<String>(json, r'rating')!,
        vendorName: mapValueOfType<String>(json, r'vendorName')!,
        location: mapValueOfType<String>(json, r'location')!,
        staffAvatars: json[r'staffAvatars'] is Iterable
            ? (json[r'staffAvatars'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<PublicHealthServiceCardResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicHealthServiceCardResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicHealthServiceCardResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicHealthServiceCardResponseDto> mapFromJson(dynamic json) {
    final map = <String, PublicHealthServiceCardResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicHealthServiceCardResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicHealthServiceCardResponseDto-objects as value to a dart map
  static Map<String, List<PublicHealthServiceCardResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicHealthServiceCardResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicHealthServiceCardResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'slug',
    'category',
    'duration',
    'price',
    'rating',
    'vendorName',
    'location',
    'staffAvatars',
    'type',
  };
}

