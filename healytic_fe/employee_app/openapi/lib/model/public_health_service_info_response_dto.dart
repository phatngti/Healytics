//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicHealthServiceInfoResponseDto {
  /// Returns a new [PublicHealthServiceInfoResponseDto] instance.
  PublicHealthServiceInfoResponseDto({
    required this.id,
    required this.title,
    required this.category,
    this.images = const [],
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.isVerified,
    required this.isWishlisted,
    this.description,
    this.featureTags = const [],
    required this.clinic,
    this.facilityImages = const [],
    this.serviceTags = const [],
  });


  String id;

  String title;

  PublicCategoryDto category;

  List<String> images;

  num rating;

  num reviewCount;

  String price;

  bool isVerified;

  bool isWishlisted;

  String? description;

  List<PublicFeatureTagDto> featureTags;

  PublicClinicDto clinic;

  List<PublicFacilityImageDto> facilityImages;

  List<PublicServiceTagDto> serviceTags;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicHealthServiceInfoResponseDto &&
    other.id == id &&
    other.title == title &&
    other.category == category &&
    _deepEquality.equals(other.images, images) &&
    other.rating == rating &&
    other.reviewCount == reviewCount &&
    other.price == price &&
    other.isVerified == isVerified &&
    other.isWishlisted == isWishlisted &&
    other.description == description &&
    _deepEquality.equals(other.featureTags, featureTags) &&
    other.clinic == clinic &&
    _deepEquality.equals(other.facilityImages, facilityImages) &&
    _deepEquality.equals(other.serviceTags, serviceTags);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (category.hashCode) +
    (images.hashCode) +
    (rating.hashCode) +
    (reviewCount.hashCode) +
    (price.hashCode) +
    (isVerified.hashCode) +
    (isWishlisted.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (featureTags.hashCode) +
    (clinic.hashCode) +
    (facilityImages.hashCode) +
    (serviceTags.hashCode);

  @override
  String toString() => 'PublicHealthServiceInfoResponseDto[id=$id, title=$title, category=$category, images=$images, rating=$rating, reviewCount=$reviewCount, price=$price, isVerified=$isVerified, isWishlisted=$isWishlisted, description=$description, featureTags=$featureTags, clinic=$clinic, facilityImages=$facilityImages, serviceTags=$serviceTags]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'category'] = this.category;
      json[r'images'] = this.images;
      json[r'rating'] = this.rating;
      json[r'reviewCount'] = this.reviewCount;
      json[r'price'] = this.price;
      json[r'isVerified'] = this.isVerified;
      json[r'isWishlisted'] = this.isWishlisted;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'featureTags'] = this.featureTags;
      json[r'clinic'] = this.clinic;
      json[r'facilityImages'] = this.facilityImages;
      json[r'serviceTags'] = this.serviceTags;
    return json;
  }

  /// Returns a new [PublicHealthServiceInfoResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicHealthServiceInfoResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicHealthServiceInfoResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicHealthServiceInfoResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicHealthServiceInfoResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        category: PublicCategoryDto.fromJson(json[r'category'])!,
        images: json[r'images'] is Iterable
            ? (json[r'images'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        rating: num.parse('${json[r'rating']}'),
        reviewCount: num.parse('${json[r'reviewCount']}'),
        price: mapValueOfType<String>(json, r'price')!,
        isVerified: mapValueOfType<bool>(json, r'isVerified')!,
        isWishlisted: mapValueOfType<bool>(json, r'isWishlisted')!,
        description: mapValueOfType<String>(json, r'description'),
        featureTags: PublicFeatureTagDto.listFromJson(json[r'featureTags']),
        clinic: PublicClinicDto.fromJson(json[r'clinic'])!,
        facilityImages: PublicFacilityImageDto.listFromJson(json[r'facilityImages']),
        serviceTags: PublicServiceTagDto.listFromJson(json[r'serviceTags']),
      );
    }
    return null;
  }

  static List<PublicHealthServiceInfoResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicHealthServiceInfoResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicHealthServiceInfoResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicHealthServiceInfoResponseDto> mapFromJson(dynamic json) {
    final map = <String, PublicHealthServiceInfoResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicHealthServiceInfoResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicHealthServiceInfoResponseDto-objects as value to a dart map
  static Map<String, List<PublicHealthServiceInfoResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicHealthServiceInfoResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicHealthServiceInfoResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'category',
    'images',
    'rating',
    'reviewCount',
    'price',
    'isVerified',
    'isWishlisted',
    'featureTags',
    'clinic',
    'facilityImages',
    'serviceTags',
  };
}

