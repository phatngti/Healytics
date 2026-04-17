//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicClinicInfoResponseDto {
  /// Returns a new [PublicClinicInfoResponseDto] instance.
  PublicClinicInfoResponseDto({
    required this.id,
    required this.name,
    required this.address,
    required this.isVerified,
    this.coverImageUrl,
    this.logoImageUrl,
    this.gallery = const [],
    required this.rating,
    required this.reviewCount,
    required this.followersLabel,
    this.phone,
    this.coordinates,
    this.chatPartnerId,
    this.description,
    required this.trustMetrics,
    this.certifications = const [],
    this.specialists = const [],
    this.facilityImages = const [],
    this.featuredServices = const [],
  });


  String id;

  String name;

  String address;

  bool isVerified;

  String? coverImageUrl;

  String? logoImageUrl;

  List<String> gallery;

  num rating;

  num reviewCount;

  String followersLabel;

  String? phone;

  String? coordinates;

  String? chatPartnerId;

  String? description;

  PublicClinicTrustMetricsDto trustMetrics;

  List<PublicClinicCertificationDto> certifications;

  List<PublicClinicSpecialistPreviewDto> specialists;

  List<PublicClinicFacilityImageDto> facilityImages;

  List<PublicClinicFeaturedServiceDto> featuredServices;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicClinicInfoResponseDto &&
    other.id == id &&
    other.name == name &&
    other.address == address &&
    other.isVerified == isVerified &&
    other.coverImageUrl == coverImageUrl &&
    other.logoImageUrl == logoImageUrl &&
    _deepEquality.equals(other.gallery, gallery) &&
    other.rating == rating &&
    other.reviewCount == reviewCount &&
    other.followersLabel == followersLabel &&
    other.phone == phone &&
    other.coordinates == coordinates &&
    other.chatPartnerId == chatPartnerId &&
    other.description == description &&
    other.trustMetrics == trustMetrics &&
    _deepEquality.equals(other.certifications, certifications) &&
    _deepEquality.equals(other.specialists, specialists) &&
    _deepEquality.equals(other.facilityImages, facilityImages) &&
    _deepEquality.equals(other.featuredServices, featuredServices);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (address.hashCode) +
    (isVerified.hashCode) +
    (coverImageUrl == null ? 0 : coverImageUrl!.hashCode) +
    (logoImageUrl == null ? 0 : logoImageUrl!.hashCode) +
    (gallery.hashCode) +
    (rating.hashCode) +
    (reviewCount.hashCode) +
    (followersLabel.hashCode) +
    (phone == null ? 0 : phone!.hashCode) +
    (coordinates == null ? 0 : coordinates!.hashCode) +
    (chatPartnerId == null ? 0 : chatPartnerId!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (trustMetrics.hashCode) +
    (certifications.hashCode) +
    (specialists.hashCode) +
    (facilityImages.hashCode) +
    (featuredServices.hashCode);

  @override
  String toString() => 'PublicClinicInfoResponseDto[id=$id, name=$name, address=$address, isVerified=$isVerified, coverImageUrl=$coverImageUrl, logoImageUrl=$logoImageUrl, gallery=$gallery, rating=$rating, reviewCount=$reviewCount, followersLabel=$followersLabel, phone=$phone, coordinates=$coordinates, chatPartnerId=$chatPartnerId, description=$description, trustMetrics=$trustMetrics, certifications=$certifications, specialists=$specialists, facilityImages=$facilityImages, featuredServices=$featuredServices]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'address'] = this.address;
      json[r'isVerified'] = this.isVerified;
    if (this.coverImageUrl != null) {
      json[r'coverImageUrl'] = this.coverImageUrl;
    } else {
      json[r'coverImageUrl'] = null;
    }
    if (this.logoImageUrl != null) {
      json[r'logoImageUrl'] = this.logoImageUrl;
    } else {
      json[r'logoImageUrl'] = null;
    }
      json[r'gallery'] = this.gallery;
      json[r'rating'] = this.rating;
      json[r'reviewCount'] = this.reviewCount;
      json[r'followersLabel'] = this.followersLabel;
    if (this.phone != null) {
      json[r'phone'] = this.phone;
    } else {
      json[r'phone'] = null;
    }
    if (this.coordinates != null) {
      json[r'coordinates'] = this.coordinates;
    } else {
      json[r'coordinates'] = null;
    }
    if (this.chatPartnerId != null) {
      json[r'chatPartnerId'] = this.chatPartnerId;
    } else {
      json[r'chatPartnerId'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'trustMetrics'] = this.trustMetrics;
      json[r'certifications'] = this.certifications;
      json[r'specialists'] = this.specialists;
      json[r'facilityImages'] = this.facilityImages;
      json[r'featuredServices'] = this.featuredServices;
    return json;
  }

  /// Returns a new [PublicClinicInfoResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicClinicInfoResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicClinicInfoResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicClinicInfoResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicClinicInfoResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        address: mapValueOfType<String>(json, r'address')!,
        isVerified: mapValueOfType<bool>(json, r'isVerified')!,
        coverImageUrl: mapValueOfType<String>(json, r'coverImageUrl'),
        logoImageUrl: mapValueOfType<String>(json, r'logoImageUrl'),
        gallery: json[r'gallery'] is Iterable
            ? (json[r'gallery'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        rating: num.parse('${json[r'rating']}'),
        reviewCount: num.parse('${json[r'reviewCount']}'),
        followersLabel: mapValueOfType<String>(json, r'followersLabel')!,
        phone: mapValueOfType<String>(json, r'phone'),
        coordinates: mapValueOfType<String>(json, r'coordinates'),
        chatPartnerId: mapValueOfType<String>(json, r'chatPartnerId'),
        description: mapValueOfType<String>(json, r'description'),
        trustMetrics: PublicClinicTrustMetricsDto.fromJson(json[r'trustMetrics'])!,
        certifications: PublicClinicCertificationDto.listFromJson(json[r'certifications']),
        specialists: PublicClinicSpecialistPreviewDto.listFromJson(json[r'specialists']),
        facilityImages: PublicClinicFacilityImageDto.listFromJson(json[r'facilityImages']),
        featuredServices: PublicClinicFeaturedServiceDto.listFromJson(json[r'featuredServices']),
      );
    }
    return null;
  }

  static List<PublicClinicInfoResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicClinicInfoResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicClinicInfoResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicClinicInfoResponseDto> mapFromJson(dynamic json) {
    final map = <String, PublicClinicInfoResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicClinicInfoResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicClinicInfoResponseDto-objects as value to a dart map
  static Map<String, List<PublicClinicInfoResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicClinicInfoResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicClinicInfoResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'address',
    'isVerified',
    'gallery',
    'rating',
    'reviewCount',
    'followersLabel',
    'trustMetrics',
    'certifications',
    'specialists',
    'facilityImages',
    'featuredServices',
  };
}

