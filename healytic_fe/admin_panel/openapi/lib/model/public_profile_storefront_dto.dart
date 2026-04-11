//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicProfileStorefrontDto {
  /// Returns a new [PublicProfileStorefrontDto] instance.
  PublicProfileStorefrontDto({
    this.coverImageUrl,
    this.logoImageUrl,
    this.description,
    this.gallery = const [],
    this.certifications = const [],
  });

  Object? coverImageUrl;

  Object? logoImageUrl;

  Object? description;

  List<String> gallery;

  List<PublicProfileCertificationDto> certifications;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicProfileStorefrontDto &&
    other.coverImageUrl == coverImageUrl &&
    other.logoImageUrl == logoImageUrl &&
    other.description == description &&
    _deepEquality.equals(other.gallery, gallery) &&
    _deepEquality.equals(other.certifications, certifications);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (coverImageUrl == null ? 0 : coverImageUrl!.hashCode) +
    (logoImageUrl == null ? 0 : logoImageUrl!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (gallery.hashCode) +
    (certifications.hashCode);

  @override
  String toString() => 'PublicProfileStorefrontDto[coverImageUrl=$coverImageUrl, logoImageUrl=$logoImageUrl, description=$description, gallery=$gallery, certifications=$certifications]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
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
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'gallery'] = this.gallery;
      json[r'certifications'] = this.certifications;
    return json;
  }

  /// Returns a new [PublicProfileStorefrontDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicProfileStorefrontDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicProfileStorefrontDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicProfileStorefrontDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicProfileStorefrontDto(
        coverImageUrl: mapValueOfType<Object>(json, r'coverImageUrl'),
        logoImageUrl: mapValueOfType<Object>(json, r'logoImageUrl'),
        description: mapValueOfType<Object>(json, r'description'),
        gallery: json[r'gallery'] is Iterable
            ? (json[r'gallery'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        certifications: PublicProfileCertificationDto.listFromJson(json[r'certifications']),
      );
    }
    return null;
  }

  static List<PublicProfileStorefrontDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicProfileStorefrontDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicProfileStorefrontDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicProfileStorefrontDto> mapFromJson(dynamic json) {
    final map = <String, PublicProfileStorefrontDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicProfileStorefrontDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicProfileStorefrontDto-objects as value to a dart map
  static Map<String, List<PublicProfileStorefrontDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicProfileStorefrontDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicProfileStorefrontDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'gallery',
    'certifications',
  };
}

