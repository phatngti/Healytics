//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicHealthServiceRecommendedResponseDto {
  /// Returns a new [PublicHealthServiceRecommendedResponseDto] instance.
  PublicHealthServiceRecommendedResponseDto({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.rating,
    required this.reviewLabel,
    required this.bookedLabel,
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

  String reviewLabel;

  String bookedLabel;

  String price;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicHealthServiceRecommendedResponseDto &&
    other.id == id &&
    other.title == title &&
    other.imageUrl == imageUrl &&
    other.rating == rating &&
    other.reviewLabel == reviewLabel &&
    other.bookedLabel == bookedLabel &&
    other.price == price;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (rating.hashCode) +
    (reviewLabel.hashCode) +
    (bookedLabel.hashCode) +
    (price.hashCode);

  @override
  String toString() => 'PublicHealthServiceRecommendedResponseDto[id=$id, title=$title, imageUrl=$imageUrl, rating=$rating, reviewLabel=$reviewLabel, bookedLabel=$bookedLabel, price=$price]';

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
      json[r'reviewLabel'] = this.reviewLabel;
      json[r'bookedLabel'] = this.bookedLabel;
      json[r'price'] = this.price;
    return json;
  }

  /// Returns a new [PublicHealthServiceRecommendedResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicHealthServiceRecommendedResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicHealthServiceRecommendedResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicHealthServiceRecommendedResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicHealthServiceRecommendedResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        imageUrl: mapValueOfType<Object>(json, r'imageUrl'),
        rating: num.parse('${json[r'rating']}'),
        reviewLabel: mapValueOfType<String>(json, r'reviewLabel')!,
        bookedLabel: mapValueOfType<String>(json, r'bookedLabel')!,
        price: mapValueOfType<String>(json, r'price')!,
      );
    }
    return null;
  }

  static List<PublicHealthServiceRecommendedResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicHealthServiceRecommendedResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicHealthServiceRecommendedResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicHealthServiceRecommendedResponseDto> mapFromJson(dynamic json) {
    final map = <String, PublicHealthServiceRecommendedResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicHealthServiceRecommendedResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicHealthServiceRecommendedResponseDto-objects as value to a dart map
  static Map<String, List<PublicHealthServiceRecommendedResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicHealthServiceRecommendedResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicHealthServiceRecommendedResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'rating',
    'reviewLabel',
    'bookedLabel',
    'price',
  };
}

