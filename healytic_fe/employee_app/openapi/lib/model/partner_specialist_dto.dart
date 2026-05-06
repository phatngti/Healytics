//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerSpecialistDto {
  /// Returns a new [PartnerSpecialistDto] instance.
  PartnerSpecialistDto({
    required this.id,
    required this.name,
    required this.role,
    this.imageUrl,
    this.degrees,
    this.experience,
    this.specializations = const [],
    this.bio,
    this.quote,
    this.languages = const [],
  });


  String id;

  String name;

  String role;

  String? imageUrl;

  String? degrees;

  String? experience;

  List<String> specializations;

  String? bio;

  String? quote;

  List<String> languages;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerSpecialistDto &&
    other.id == id &&
    other.name == name &&
    other.role == role &&
    other.imageUrl == imageUrl &&
    other.degrees == degrees &&
    other.experience == experience &&
    _deepEquality.equals(other.specializations, specializations) &&
    other.bio == bio &&
    other.quote == quote &&
    _deepEquality.equals(other.languages, languages);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (role.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (degrees == null ? 0 : degrees!.hashCode) +
    (experience == null ? 0 : experience!.hashCode) +
    (specializations.hashCode) +
    (bio == null ? 0 : bio!.hashCode) +
    (quote == null ? 0 : quote!.hashCode) +
    (languages.hashCode);

  @override
  String toString() => 'PartnerSpecialistDto[id=$id, name=$name, role=$role, imageUrl=$imageUrl, degrees=$degrees, experience=$experience, specializations=$specializations, bio=$bio, quote=$quote, languages=$languages]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'role'] = this.role;
    if (this.imageUrl != null) {
      json[r'imageUrl'] = this.imageUrl;
    } else {
      json[r'imageUrl'] = null;
    }
    if (this.degrees != null) {
      json[r'degrees'] = this.degrees;
    } else {
      json[r'degrees'] = null;
    }
    if (this.experience != null) {
      json[r'experience'] = this.experience;
    } else {
      json[r'experience'] = null;
    }
      json[r'specializations'] = this.specializations;
    if (this.bio != null) {
      json[r'bio'] = this.bio;
    } else {
      json[r'bio'] = null;
    }
    if (this.quote != null) {
      json[r'quote'] = this.quote;
    } else {
      json[r'quote'] = null;
    }
      json[r'languages'] = this.languages;
    return json;
  }

  /// Returns a new [PartnerSpecialistDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerSpecialistDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerSpecialistDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerSpecialistDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerSpecialistDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        role: mapValueOfType<String>(json, r'role')!,
        imageUrl: mapValueOfType<String>(json, r'imageUrl'),
        degrees: mapValueOfType<String>(json, r'degrees'),
        experience: mapValueOfType<String>(json, r'experience'),
        specializations: json[r'specializations'] is Iterable
            ? (json[r'specializations'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        bio: mapValueOfType<String>(json, r'bio'),
        quote: mapValueOfType<String>(json, r'quote'),
        languages: json[r'languages'] is Iterable
            ? (json[r'languages'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<PartnerSpecialistDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerSpecialistDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerSpecialistDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerSpecialistDto> mapFromJson(dynamic json) {
    final map = <String, PartnerSpecialistDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerSpecialistDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerSpecialistDto-objects as value to a dart map
  static Map<String, List<PartnerSpecialistDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerSpecialistDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerSpecialistDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'role',
  };
}

