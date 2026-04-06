//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ClinicInfoResponseDto {
  /// Returns a new [ClinicInfoResponseDto] instance.
  ClinicInfoResponseDto({
    required this.id,
    required this.name,
    this.coverImageUrl,
    this.logoImageUrl,
    this.gallery = const [],
    required this.followersLabel,
    required this.reviewsLabel,
    this.description,
    required this.trustMetrics,
    this.certifications = const [],
    this.specialists = const [],
    this.businessTypes = const [],
    this.address,
    this.phoneNumber,
  });

  String id;

  String name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? coverImageUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? logoImageUrl;

  List<String> gallery;

  String followersLabel;

  String reviewsLabel;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? description;

  ClinicTrustMetricsDto trustMetrics;

  List<ClinicCertificationDto> certifications;

  List<ClinicSpecialistPreviewDto> specialists;

  List<String> businessTypes;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? address;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? phoneNumber;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ClinicInfoResponseDto &&
    other.id == id &&
    other.name == name &&
    other.coverImageUrl == coverImageUrl &&
    other.logoImageUrl == logoImageUrl &&
    _deepEquality.equals(other.gallery, gallery) &&
    other.followersLabel == followersLabel &&
    other.reviewsLabel == reviewsLabel &&
    other.description == description &&
    other.trustMetrics == trustMetrics &&
    _deepEquality.equals(other.certifications, certifications) &&
    _deepEquality.equals(other.specialists, specialists) &&
    _deepEquality.equals(other.businessTypes, businessTypes) &&
    other.address == address &&
    other.phoneNumber == phoneNumber;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (coverImageUrl == null ? 0 : coverImageUrl!.hashCode) +
    (logoImageUrl == null ? 0 : logoImageUrl!.hashCode) +
    (gallery.hashCode) +
    (followersLabel.hashCode) +
    (reviewsLabel.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (trustMetrics.hashCode) +
    (certifications.hashCode) +
    (specialists.hashCode) +
    (businessTypes.hashCode) +
    (address == null ? 0 : address!.hashCode) +
    (phoneNumber == null ? 0 : phoneNumber!.hashCode);

  @override
  String toString() => 'ClinicInfoResponseDto[id=$id, name=$name, coverImageUrl=$coverImageUrl, logoImageUrl=$logoImageUrl, gallery=$gallery, followersLabel=$followersLabel, reviewsLabel=$reviewsLabel, description=$description, trustMetrics=$trustMetrics, certifications=$certifications, specialists=$specialists, businessTypes=$businessTypes, address=$address, phoneNumber=$phoneNumber]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
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
      json[r'followersLabel'] = this.followersLabel;
      json[r'reviewsLabel'] = this.reviewsLabel;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'trustMetrics'] = this.trustMetrics;
      json[r'certifications'] = this.certifications;
      json[r'specialists'] = this.specialists;
      json[r'businessTypes'] = this.businessTypes;
    if (this.address != null) {
      json[r'address'] = this.address;
    } else {
      json[r'address'] = null;
    }
    if (this.phoneNumber != null) {
      json[r'phoneNumber'] = this.phoneNumber;
    } else {
      json[r'phoneNumber'] = null;
    }
    return json;
  }

  /// Returns a new [ClinicInfoResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ClinicInfoResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ClinicInfoResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ClinicInfoResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ClinicInfoResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        coverImageUrl: mapValueOfType<Object>(json, r'coverImageUrl'),
        logoImageUrl: mapValueOfType<Object>(json, r'logoImageUrl'),
        gallery: json[r'gallery'] is Iterable
            ? (json[r'gallery'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        followersLabel: mapValueOfType<String>(json, r'followersLabel')!,
        reviewsLabel: mapValueOfType<String>(json, r'reviewsLabel')!,
        description: mapValueOfType<Object>(json, r'description'),
        trustMetrics: ClinicTrustMetricsDto.fromJson(json[r'trustMetrics'])!,
        certifications: ClinicCertificationDto.listFromJson(json[r'certifications']),
        specialists: ClinicSpecialistPreviewDto.listFromJson(json[r'specialists']),
        businessTypes: json[r'businessTypes'] is Iterable
            ? (json[r'businessTypes'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        address: mapValueOfType<Object>(json, r'address'),
        phoneNumber: mapValueOfType<Object>(json, r'phoneNumber'),
      );
    }
    return null;
  }

  static List<ClinicInfoResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ClinicInfoResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ClinicInfoResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ClinicInfoResponseDto> mapFromJson(dynamic json) {
    final map = <String, ClinicInfoResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ClinicInfoResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ClinicInfoResponseDto-objects as value to a dart map
  static Map<String, List<ClinicInfoResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ClinicInfoResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ClinicInfoResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'gallery',
    'followersLabel',
    'reviewsLabel',
    'trustMetrics',
    'certifications',
    'specialists',
    'businessTypes',
  };
}

