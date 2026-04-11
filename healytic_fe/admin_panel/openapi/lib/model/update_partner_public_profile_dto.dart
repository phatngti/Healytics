//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdatePartnerPublicProfileDto {
  /// Returns a new [UpdatePartnerPublicProfileDto] instance.
  UpdatePartnerPublicProfileDto({
    this.coverImageUrl,
    this.logoImageUrl,
    this.description,
    this.gallery = const [],
    this.certifications = const [],
  });

  /// Public clinic cover image URL
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? coverImageUrl;

  /// Public clinic logo image URL
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? logoImageUrl;

  /// Public clinic profile description (120–1000 chars recommended)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  /// Gallery image URLs shown on the clinic profile (max 8)
  List<String> gallery;

  /// Trust badges and certifications shown on the clinic profile
  List<UpdatePartnerCertificationDto> certifications;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdatePartnerPublicProfileDto &&
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
  String toString() => 'UpdatePartnerPublicProfileDto[coverImageUrl=$coverImageUrl, logoImageUrl=$logoImageUrl, description=$description, gallery=$gallery, certifications=$certifications]';

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

  /// Returns a new [UpdatePartnerPublicProfileDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdatePartnerPublicProfileDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdatePartnerPublicProfileDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdatePartnerPublicProfileDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdatePartnerPublicProfileDto(
        coverImageUrl: mapValueOfType<String>(json, r'coverImageUrl'),
        logoImageUrl: mapValueOfType<String>(json, r'logoImageUrl'),
        description: mapValueOfType<String>(json, r'description'),
        gallery: json[r'gallery'] is Iterable
            ? (json[r'gallery'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        certifications: UpdatePartnerCertificationDto.listFromJson(json[r'certifications']),
      );
    }
    return null;
  }

  static List<UpdatePartnerPublicProfileDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdatePartnerPublicProfileDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdatePartnerPublicProfileDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdatePartnerPublicProfileDto> mapFromJson(dynamic json) {
    final map = <String, UpdatePartnerPublicProfileDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdatePartnerPublicProfileDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdatePartnerPublicProfileDto-objects as value to a dart map
  static Map<String, List<UpdatePartnerPublicProfileDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdatePartnerPublicProfileDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdatePartnerPublicProfileDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

