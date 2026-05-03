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
    this.serviceId,
    this.name,
    this.slug,
    this.imageUrl,
    this.category,
    this.duration,
    this.price,
    this.rating,
    this.vendorName,
    this.location,
    this.staffAvatars = const [],
    this.type,
  });


  String? serviceId;

  String? name;

  String? slug;

  String? imageUrl;

  String? category;

  String? duration;

  String? price;

  String? rating;

  String? vendorName;

  String? location;

  List<String>? staffAvatars;

  String? type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AiRecommendationItemDto &&
    other.serviceId == serviceId &&
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
    (serviceId == null ? 0 : serviceId!.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (slug == null ? 0 : slug!.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (category == null ? 0 : category!.hashCode) +
    (duration == null ? 0 : duration!.hashCode) +
    (price == null ? 0 : price!.hashCode) +
    (rating == null ? 0 : rating!.hashCode) +
    (vendorName == null ? 0 : vendorName!.hashCode) +
    (location == null ? 0 : location!.hashCode) +
    (staffAvatars == null ? 0 : staffAvatars!.hashCode) +
    (type == null ? 0 : type!.hashCode);

  @override
  String toString() => 'AiRecommendationItemDto[serviceId=$serviceId, name=$name, slug=$slug, imageUrl=$imageUrl, category=$category, duration=$duration, price=$price, rating=$rating, vendorName=$vendorName, location=$location, staffAvatars=$staffAvatars, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.serviceId != null) {
      json[r'service_id'] = this.serviceId;
    } else {
      json[r'service_id'] = null;
    }
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.slug != null) {
      json[r'slug'] = this.slug;
    } else {
      json[r'slug'] = null;
    }
    if (this.imageUrl != null) {
      json[r'imageUrl'] = this.imageUrl;
    } else {
      json[r'imageUrl'] = null;
    }
    if (this.category != null) {
      json[r'category'] = this.category;
    } else {
      json[r'category'] = null;
    }
    if (this.duration != null) {
      json[r'duration'] = this.duration;
    } else {
      json[r'duration'] = null;
    }
    if (this.price != null) {
      json[r'price'] = this.price;
    } else {
      json[r'price'] = null;
    }
    if (this.rating != null) {
      json[r'rating'] = this.rating;
    } else {
      json[r'rating'] = null;
    }
    if (this.vendorName != null) {
      json[r'vendorName'] = this.vendorName;
    } else {
      json[r'vendorName'] = null;
    }
    if (this.location != null) {
      json[r'location'] = this.location;
    } else {
      json[r'location'] = null;
    }
    if (this.staffAvatars != null) {
      json[r'staffAvatars'] = this.staffAvatars;
    } else {
      json[r'staffAvatars'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
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
        serviceId: mapValueOfType<String>(json, r'service_id'),
        name: mapValueOfType<String>(json, r'name'),
        slug: mapValueOfType<String>(json, r'slug'),
        imageUrl: mapValueOfType<String>(json, r'imageUrl'),
        category: mapValueOfType<String>(json, r'category'),
        duration: mapValueOfType<String>(json, r'duration'),
        price: mapValueOfType<String>(json, r'price'),
        rating: mapValueOfType<String>(json, r'rating'),
        vendorName: mapValueOfType<String>(json, r'vendorName'),
        location: mapValueOfType<String>(json, r'location'),
        staffAvatars: json[r'staffAvatars'] is Iterable
            ? (json[r'staffAvatars'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        type: mapValueOfType<String>(json, r'type'),
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
  };
}

