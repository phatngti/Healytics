//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BookingServiceResponseDto {
  /// Returns a new [BookingServiceResponseDto] instance.
  BookingServiceResponseDto({
    required this.id,
    this.imageUrl,
    required this.title,
    required this.duration,
    required this.price,
    this.clinicName,
    this.clinicId,
    this.clinicAddress,
    this.location,
    this.distance,
    this.durationMinutes,
    this.priceVnd,
    this.categoryId,
    this.categoryName,
    this.parentCategoryId,
    this.parentCategoryName,
  });


  /// Service/Product UUID
  String id;

  /// Service image URL
  Object? imageUrl;

  /// Service name
  String title;

  /// Formatted duration
  String duration;

  /// Formatted price
  String price;

  /// Clinic or facility name
  Object? clinicName;

  /// Clinic or facility ID
  Object? clinicId;

  /// Clinic street address
  Object? clinicAddress;

  /// Clinic location label
  Object? location;

  /// Distance from user (e.g. \"1.2 km\")
  Object? distance;

  /// Duration in minutes
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? durationMinutes;

  /// Raw price in VND
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? priceVnd;

  /// Sub-category ID
  Object? categoryId;

  /// Sub-category name
  Object? categoryName;

  /// Root category ID
  Object? parentCategoryId;

  /// Root category name
  Object? parentCategoryName;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BookingServiceResponseDto &&
    other.id == id &&
    other.imageUrl == imageUrl &&
    other.title == title &&
    other.duration == duration &&
    other.price == price &&
    other.clinicName == clinicName &&
    other.clinicId == clinicId &&
    other.clinicAddress == clinicAddress &&
    other.location == location &&
    other.distance == distance &&
    other.durationMinutes == durationMinutes &&
    other.priceVnd == priceVnd &&
    other.categoryId == categoryId &&
    other.categoryName == categoryName &&
    other.parentCategoryId == parentCategoryId &&
    other.parentCategoryName == parentCategoryName;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (title.hashCode) +
    (duration.hashCode) +
    (price.hashCode) +
    (clinicName == null ? 0 : clinicName!.hashCode) +
    (clinicId == null ? 0 : clinicId!.hashCode) +
    (clinicAddress == null ? 0 : clinicAddress!.hashCode) +
    (location == null ? 0 : location!.hashCode) +
    (distance == null ? 0 : distance!.hashCode) +
    (durationMinutes == null ? 0 : durationMinutes!.hashCode) +
    (priceVnd == null ? 0 : priceVnd!.hashCode) +
    (categoryId == null ? 0 : categoryId!.hashCode) +
    (categoryName == null ? 0 : categoryName!.hashCode) +
    (parentCategoryId == null ? 0 : parentCategoryId!.hashCode) +
    (parentCategoryName == null ? 0 : parentCategoryName!.hashCode);

  @override
  String toString() => 'BookingServiceResponseDto[id=$id, imageUrl=$imageUrl, title=$title, duration=$duration, price=$price, clinicName=$clinicName, clinicId=$clinicId, clinicAddress=$clinicAddress, location=$location, distance=$distance, durationMinutes=$durationMinutes, priceVnd=$priceVnd, categoryId=$categoryId, categoryName=$categoryName, parentCategoryId=$parentCategoryId, parentCategoryName=$parentCategoryName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    if (this.imageUrl != null) {
      json[r'imageUrl'] = this.imageUrl;
    } else {
      json[r'imageUrl'] = null;
    }
      json[r'title'] = this.title;
      json[r'duration'] = this.duration;
      json[r'price'] = this.price;
    if (this.clinicName != null) {
      json[r'clinicName'] = this.clinicName;
    } else {
      json[r'clinicName'] = null;
    }
    if (this.clinicId != null) {
      json[r'clinicId'] = this.clinicId;
    } else {
      json[r'clinicId'] = null;
    }
    if (this.clinicAddress != null) {
      json[r'clinicAddress'] = this.clinicAddress;
    } else {
      json[r'clinicAddress'] = null;
    }
    if (this.location != null) {
      json[r'location'] = this.location;
    } else {
      json[r'location'] = null;
    }
    if (this.distance != null) {
      json[r'distance'] = this.distance;
    } else {
      json[r'distance'] = null;
    }
    if (this.durationMinutes != null) {
      json[r'durationMinutes'] = this.durationMinutes;
    } else {
      json[r'durationMinutes'] = null;
    }
    if (this.priceVnd != null) {
      json[r'priceVnd'] = this.priceVnd;
    } else {
      json[r'priceVnd'] = null;
    }
    if (this.categoryId != null) {
      json[r'categoryId'] = this.categoryId;
    } else {
      json[r'categoryId'] = null;
    }
    if (this.categoryName != null) {
      json[r'categoryName'] = this.categoryName;
    } else {
      json[r'categoryName'] = null;
    }
    if (this.parentCategoryId != null) {
      json[r'parentCategoryId'] = this.parentCategoryId;
    } else {
      json[r'parentCategoryId'] = null;
    }
    if (this.parentCategoryName != null) {
      json[r'parentCategoryName'] = this.parentCategoryName;
    } else {
      json[r'parentCategoryName'] = null;
    }
    return json;
  }

  /// Returns a new [BookingServiceResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BookingServiceResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BookingServiceResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BookingServiceResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BookingServiceResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        imageUrl: mapValueOfType<Object>(json, r'imageUrl'),
        title: mapValueOfType<String>(json, r'title')!,
        duration: mapValueOfType<String>(json, r'duration')!,
        price: mapValueOfType<String>(json, r'price')!,
        clinicName: mapValueOfType<Object>(json, r'clinicName'),
        clinicId: mapValueOfType<Object>(json, r'clinicId'),
        clinicAddress: mapValueOfType<Object>(json, r'clinicAddress'),
        location: mapValueOfType<Object>(json, r'location'),
        distance: mapValueOfType<Object>(json, r'distance'),
        durationMinutes: mapValueOfType<Object>(json, r'durationMinutes'),
        priceVnd: mapValueOfType<Object>(json, r'priceVnd'),
        categoryId: mapValueOfType<Object>(json, r'categoryId'),
        categoryName: mapValueOfType<Object>(json, r'categoryName'),
        parentCategoryId: mapValueOfType<Object>(json, r'parentCategoryId'),
        parentCategoryName: mapValueOfType<Object>(json, r'parentCategoryName'),
      );
    }
    return null;
  }

  static List<BookingServiceResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BookingServiceResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BookingServiceResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BookingServiceResponseDto> mapFromJson(dynamic json) {
    final map = <String, BookingServiceResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BookingServiceResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BookingServiceResponseDto-objects as value to a dart map
  static Map<String, List<BookingServiceResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BookingServiceResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BookingServiceResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'duration',
    'price',
  };
}

