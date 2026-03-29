//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AiRecommendationItemDto {
  /// Returns a new [AiRecommendationItemDto] instance.
  AiRecommendationItemDto({
    required this.serviceId,
    required this.name,
    this.imageUrl,
    this.badge,
    required this.bookedCount,
    required this.price,
    this.staffName,
    required this.rating,
    required this.location,
    this.slots = const [],
  });

  String serviceId;

  String name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? imageUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? badge;

  num bookedCount;

  AiPriceDto price;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? staffName;

  AiRatingDto rating;

  AiLocationDto location;

  List<String> slots;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AiRecommendationItemDto &&
    other.serviceId == serviceId &&
    other.name == name &&
    other.imageUrl == imageUrl &&
    other.badge == badge &&
    other.bookedCount == bookedCount &&
    other.price == price &&
    other.staffName == staffName &&
    other.rating == rating &&
    other.location == location &&
    _deepEquality.equals(other.slots, slots);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (serviceId.hashCode) +
    (name.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (badge == null ? 0 : badge!.hashCode) +
    (bookedCount.hashCode) +
    (price.hashCode) +
    (staffName == null ? 0 : staffName!.hashCode) +
    (rating.hashCode) +
    (location.hashCode) +
    (slots.hashCode);

  @override
  String toString() => 'AiRecommendationItemDto[serviceId=$serviceId, name=$name, imageUrl=$imageUrl, badge=$badge, bookedCount=$bookedCount, price=$price, staffName=$staffName, rating=$rating, location=$location, slots=$slots]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'service_id'] = this.serviceId;
      json[r'name'] = this.name;
    if (this.imageUrl != null) {
      json[r'image_url'] = this.imageUrl;
    } else {
      json[r'image_url'] = null;
    }
    if (this.badge != null) {
      json[r'badge'] = this.badge;
    } else {
      json[r'badge'] = null;
    }
      json[r'booked_count'] = this.bookedCount;
      json[r'price'] = this.price;
    if (this.staffName != null) {
      json[r'staff_name'] = this.staffName;
    } else {
      json[r'staff_name'] = null;
    }
      json[r'rating'] = this.rating;
      json[r'location'] = this.location;
      json[r'slots'] = this.slots;
    return json;
  }

  /// Returns a new [AiRecommendationItemDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AiRecommendationItemDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AiRecommendationItemDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AiRecommendationItemDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AiRecommendationItemDto(
        serviceId: mapValueOfType<String>(json, r'service_id')!,
        name: mapValueOfType<String>(json, r'name')!,
        imageUrl: mapValueOfType<Object>(json, r'image_url'),
        badge: mapValueOfType<Object>(json, r'badge'),
        bookedCount: num.parse('${json[r'booked_count']}'),
        price: AiPriceDto.fromJson(json[r'price'])!,
        staffName: mapValueOfType<Object>(json, r'staff_name'),
        rating: AiRatingDto.fromJson(json[r'rating'])!,
        location: AiLocationDto.fromJson(json[r'location'])!,
        slots: json[r'slots'] is Iterable
            ? (json[r'slots'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<AiRecommendationItemDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AiRecommendationItemDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AiRecommendationItemDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AiRecommendationItemDto> mapFromJson(dynamic json) {
    final map = <String, AiRecommendationItemDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AiRecommendationItemDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AiRecommendationItemDto-objects as value to a dart map
  static Map<String, List<AiRecommendationItemDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AiRecommendationItemDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AiRecommendationItemDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'service_id',
    'name',
    'booked_count',
    'price',
    'rating',
    'location',
    'slots',
  };
}

