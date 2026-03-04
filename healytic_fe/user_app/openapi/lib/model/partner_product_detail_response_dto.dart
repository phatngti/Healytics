//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerProductDetailResponseDto {
  /// Returns a new [PartnerProductDetailResponseDto] instance.
  PartnerProductDetailResponseDto({
    required this.id,
    required this.title,
    required this.categoryLabel,
    this.images = const [],
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.isVerified,
    this.description,
    required this.duration,
    this.featureTags = const [],
    required this.clinic,
    this.specialists = const [],
    this.daySchedules = const [],
    this.facilityImages = const [],
    this.reviews = const [],
    this.recommendedServices = const [],
  });

  String id;

  String title;

  String categoryLabel;

  List<String> images;

  num rating;

  num reviewCount;

  String price;

  bool isVerified;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? description;

  num duration;

  List<PartnerFeatureTagDto> featureTags;

  PartnerClinicDto clinic;

  List<PartnerSpecialistDto> specialists;

  List<PartnerDayScheduleDto> daySchedules;

  List<PartnerFacilityImageDto> facilityImages;

  List<PartnerReviewDto> reviews;

  List<PartnerRecommendedServiceDto> recommendedServices;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerProductDetailResponseDto &&
    other.id == id &&
    other.title == title &&
    other.categoryLabel == categoryLabel &&
    _deepEquality.equals(other.images, images) &&
    other.rating == rating &&
    other.reviewCount == reviewCount &&
    other.price == price &&
    other.isVerified == isVerified &&
    other.description == description &&
    other.duration == duration &&
    _deepEquality.equals(other.featureTags, featureTags) &&
    other.clinic == clinic &&
    _deepEquality.equals(other.specialists, specialists) &&
    _deepEquality.equals(other.daySchedules, daySchedules) &&
    _deepEquality.equals(other.facilityImages, facilityImages) &&
    _deepEquality.equals(other.reviews, reviews) &&
    _deepEquality.equals(other.recommendedServices, recommendedServices);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (categoryLabel.hashCode) +
    (images.hashCode) +
    (rating.hashCode) +
    (reviewCount.hashCode) +
    (price.hashCode) +
    (isVerified.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (duration.hashCode) +
    (featureTags.hashCode) +
    (clinic.hashCode) +
    (specialists.hashCode) +
    (daySchedules.hashCode) +
    (facilityImages.hashCode) +
    (reviews.hashCode) +
    (recommendedServices.hashCode);

  @override
  String toString() => 'PartnerProductDetailResponseDto[id=$id, title=$title, categoryLabel=$categoryLabel, images=$images, rating=$rating, reviewCount=$reviewCount, price=$price, isVerified=$isVerified, description=$description, duration=$duration, featureTags=$featureTags, clinic=$clinic, specialists=$specialists, daySchedules=$daySchedules, facilityImages=$facilityImages, reviews=$reviews, recommendedServices=$recommendedServices]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'categoryLabel'] = this.categoryLabel;
      json[r'images'] = this.images;
      json[r'rating'] = this.rating;
      json[r'reviewCount'] = this.reviewCount;
      json[r'price'] = this.price;
      json[r'isVerified'] = this.isVerified;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'duration'] = this.duration;
      json[r'featureTags'] = this.featureTags;
      json[r'clinic'] = this.clinic;
      json[r'specialists'] = this.specialists;
      json[r'daySchedules'] = this.daySchedules;
      json[r'facilityImages'] = this.facilityImages;
      json[r'reviews'] = this.reviews;
      json[r'recommendedServices'] = this.recommendedServices;
    return json;
  }

  /// Returns a new [PartnerProductDetailResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerProductDetailResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerProductDetailResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerProductDetailResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerProductDetailResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        categoryLabel: mapValueOfType<String>(json, r'categoryLabel')!,
        images: json[r'images'] is Iterable
            ? (json[r'images'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        rating: num.parse('${json[r'rating']}'),
        reviewCount: num.parse('${json[r'reviewCount']}'),
        price: mapValueOfType<String>(json, r'price')!,
        isVerified: mapValueOfType<bool>(json, r'isVerified')!,
        description: mapValueOfType<Object>(json, r'description'),
        duration: num.parse('${json[r'duration']}'),
        featureTags: PartnerFeatureTagDto.listFromJson(json[r'featureTags']),
        clinic: PartnerClinicDto.fromJson(json[r'clinic'])!,
        specialists: PartnerSpecialistDto.listFromJson(json[r'specialists']),
        daySchedules: PartnerDayScheduleDto.listFromJson(json[r'daySchedules']),
        facilityImages: PartnerFacilityImageDto.listFromJson(json[r'facilityImages']),
        reviews: PartnerReviewDto.listFromJson(json[r'reviews']),
        recommendedServices: PartnerRecommendedServiceDto.listFromJson(json[r'recommendedServices']),
      );
    }
    return null;
  }

  static List<PartnerProductDetailResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerProductDetailResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerProductDetailResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerProductDetailResponseDto> mapFromJson(dynamic json) {
    final map = <String, PartnerProductDetailResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerProductDetailResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerProductDetailResponseDto-objects as value to a dart map
  static Map<String, List<PartnerProductDetailResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerProductDetailResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerProductDetailResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'categoryLabel',
    'images',
    'rating',
    'reviewCount',
    'price',
    'isVerified',
    'duration',
    'featureTags',
    'clinic',
    'specialists',
    'daySchedules',
    'facilityImages',
    'reviews',
    'recommendedServices',
  };
}

