//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ServiceDetail {
  /// Returns a new [ServiceDetail] instance.
  ServiceDetail({
    required this.serviceId,
    required this.name,
    this.imageUrl,
    this.badge,
    this.bookedCount,
    this.price,
    this.staffName,
    this.rating,
    this.location,
    this.slots = const [],
  });

  String serviceId;

  String name;

  String? imageUrl;

  String? badge;

  int? bookedCount;

  PriceInfo? price;

  String? staffName;

  RatingInfo? rating;

  LocationInfo? location;

  List<String>? slots;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ServiceDetail &&
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
    (bookedCount == null ? 0 : bookedCount!.hashCode) +
    (price == null ? 0 : price!.hashCode) +
    (staffName == null ? 0 : staffName!.hashCode) +
    (rating == null ? 0 : rating!.hashCode) +
    (location == null ? 0 : location!.hashCode) +
    (slots == null ? 0 : slots!.hashCode);

  @override
  String toString() => 'ServiceDetail[serviceId=$serviceId, name=$name, imageUrl=$imageUrl, badge=$badge, bookedCount=$bookedCount, price=$price, staffName=$staffName, rating=$rating, location=$location, slots=$slots]';

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
    if (this.bookedCount != null) {
      json[r'booked_count'] = this.bookedCount;
    } else {
      json[r'booked_count'] = null;
    }
    if (this.price != null) {
      json[r'price'] = this.price;
    } else {
      json[r'price'] = null;
    }
    if (this.staffName != null) {
      json[r'staff_name'] = this.staffName;
    } else {
      json[r'staff_name'] = null;
    }
    if (this.rating != null) {
      json[r'rating'] = this.rating;
    } else {
      json[r'rating'] = null;
    }
    if (this.location != null) {
      json[r'location'] = this.location;
    } else {
      json[r'location'] = null;
    }
    if (this.slots != null) {
      json[r'slots'] = this.slots;
    } else {
      json[r'slots'] = null;
    }
    return json;
  }

  /// Returns a new [ServiceDetail] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ServiceDetail? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ServiceDetail[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ServiceDetail[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ServiceDetail(
        serviceId: mapValueOfType<String>(json, r'service_id')!,
        name: mapValueOfType<String>(json, r'name')!,
        imageUrl: mapValueOfType<String>(json, r'image_url'),
        badge: mapValueOfType<String>(json, r'badge'),
        bookedCount: mapValueOfType<int>(json, r'booked_count'),
        price: PriceInfo.fromJson(json[r'price']),
        staffName: mapValueOfType<String>(json, r'staff_name'),
        rating: RatingInfo.fromJson(json[r'rating']),
        location: LocationInfo.fromJson(json[r'location']),
        slots: json[r'slots'] is Iterable
            ? (json[r'slots'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<ServiceDetail> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ServiceDetail>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ServiceDetail.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ServiceDetail> mapFromJson(dynamic json) {
    final map = <String, ServiceDetail>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ServiceDetail.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ServiceDetail-objects as value to a dart map
  static Map<String, List<ServiceDetail>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ServiceDetail>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ServiceDetail.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'service_id',
    'name',
  };
}

