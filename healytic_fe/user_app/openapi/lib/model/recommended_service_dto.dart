//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RecommendedServiceDto {
  /// Returns a new [RecommendedServiceDto] instance.
  RecommendedServiceDto({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.price,
  });

  String id;

  String title;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? imageUrl;

  num rating;

  num reviewCount;

  String price;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RecommendedServiceDto &&
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
  String toString() => 'RecommendedServiceDto[id=$id, title=$title, imageUrl=$imageUrl, rating=$rating, reviewCount=$reviewCount, price=$price]';

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

  /// Returns a new [RecommendedServiceDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RecommendedServiceDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RecommendedServiceDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RecommendedServiceDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RecommendedServiceDto(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        imageUrl: mapValueOfType<Object>(json, r'imageUrl'),
        rating: num.parse('${json[r'rating']}'),
        reviewCount: num.parse('${json[r'reviewCount']}'),
        price: mapValueOfType<String>(json, r'price')!,
      );
    }
    return null;
  }

  static List<RecommendedServiceDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RecommendedServiceDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RecommendedServiceDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RecommendedServiceDto> mapFromJson(dynamic json) {
    final map = <String, RecommendedServiceDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RecommendedServiceDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RecommendedServiceDto-objects as value to a dart map
  static Map<String, List<RecommendedServiceDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RecommendedServiceDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RecommendedServiceDto.listFromJson(entry.value, growable: growable,);
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

