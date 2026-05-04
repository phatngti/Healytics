//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdatePartnerProfileCompletionDto {
  /// Returns a new [UpdatePartnerProfileCompletionDto] instance.
  UpdatePartnerProfileCompletionDto({
    required this.coverImageUrl,
    required this.logoImageUrl,
    required this.description,
    this.gallery = const [],
    this.certifications = const [],
  });


  /// Public clinic cover image URL (required to complete your profile)
  String coverImageUrl;

  /// Public clinic logo image URL (required to complete your profile)
  String logoImageUrl;

  /// Public clinic profile description (min 120 characters, required to complete your profile)
  String description;

  /// Gallery image URLs shown on the clinic profile (min 3, required to complete your profile)
  List<String> gallery;

  /// Optional trust badges/certifications shown on the clinic
  List<UpdatePartnerCertificationDto> certifications;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdatePartnerProfileCompletionDto &&
    other.coverImageUrl == coverImageUrl &&
    other.logoImageUrl == logoImageUrl &&
    other.description == description &&
    _deepEquality.equals(other.gallery, gallery) &&
    _deepEquality.equals(other.certifications, certifications);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (coverImageUrl.hashCode) +
    (logoImageUrl.hashCode) +
    (description.hashCode) +
    (gallery.hashCode) +
    (certifications.hashCode);

  @override
  String toString() => 'UpdatePartnerProfileCompletionDto[coverImageUrl=$coverImageUrl, logoImageUrl=$logoImageUrl, description=$description, gallery=$gallery, certifications=$certifications]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'coverImageUrl'] = this.coverImageUrl;
      json[r'logoImageUrl'] = this.logoImageUrl;
      json[r'description'] = this.description;
      json[r'gallery'] = this.gallery;
      json[r'certifications'] = this.certifications;
    return json;
  }

  /// Returns a new [UpdatePartnerProfileCompletionDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdatePartnerProfileCompletionDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdatePartnerProfileCompletionDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdatePartnerProfileCompletionDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdatePartnerProfileCompletionDto(
        coverImageUrl: mapValueOfType<String>(json, r'coverImageUrl')!,
        logoImageUrl: mapValueOfType<String>(json, r'logoImageUrl')!,
        description: mapValueOfType<String>(json, r'description')!,
        gallery: json[r'gallery'] is Iterable
            ? (json[r'gallery'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        certifications: UpdatePartnerCertificationDto.listFromJson(json[r'certifications']),
      );
    }
    return null;
  }

  static List<UpdatePartnerProfileCompletionDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdatePartnerProfileCompletionDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdatePartnerProfileCompletionDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdatePartnerProfileCompletionDto> mapFromJson(dynamic json) {
    final map = <String, UpdatePartnerProfileCompletionDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdatePartnerProfileCompletionDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdatePartnerProfileCompletionDto-objects as value to a dart map
  static Map<String, List<UpdatePartnerProfileCompletionDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdatePartnerProfileCompletionDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdatePartnerProfileCompletionDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'coverImageUrl',
    'logoImageUrl',
    'description',
    'gallery',
  };
}

