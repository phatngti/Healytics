//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FeaturedSpecialistResponseDto {
  /// Returns a new [FeaturedSpecialistResponseDto] instance.
  FeaturedSpecialistResponseDto({
    required this.id,
    required this.name,
    required this.specialty,
    this.avatarUrl,
    required this.rating,
    required this.soldCount,
    required this.clinicName,
  });

  /// UUID of the specialist
  String id;

  /// Display name
  String name;

  /// Short specialty label
  String specialty;

  /// Profile image URL (nullable)
  Object? avatarUrl;

  /// Average rating 0.0–5.0
  num rating;

  /// Total completed appointments
  num soldCount;

  /// Associated clinic name
  String clinicName;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FeaturedSpecialistResponseDto &&
    other.id == id &&
    other.name == name &&
    other.specialty == specialty &&
    other.avatarUrl == avatarUrl &&
    other.rating == rating &&
    other.soldCount == soldCount &&
    other.clinicName == clinicName;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (specialty.hashCode) +
    (avatarUrl == null ? 0 : avatarUrl!.hashCode) +
    (rating.hashCode) +
    (soldCount.hashCode) +
    (clinicName.hashCode);

  @override
  String toString() => 'FeaturedSpecialistResponseDto[id=$id, name=$name, specialty=$specialty, avatarUrl=$avatarUrl, rating=$rating, soldCount=$soldCount, clinicName=$clinicName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'specialty'] = this.specialty;
    if (this.avatarUrl != null) {
      json[r'avatarUrl'] = this.avatarUrl;
    } else {
      json[r'avatarUrl'] = null;
    }
      json[r'rating'] = this.rating;
      json[r'soldCount'] = this.soldCount;
      json[r'clinicName'] = this.clinicName;
    return json;
  }

  /// Returns a new [FeaturedSpecialistResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FeaturedSpecialistResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "FeaturedSpecialistResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "FeaturedSpecialistResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FeaturedSpecialistResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        specialty: mapValueOfType<String>(json, r'specialty')!,
        avatarUrl: mapValueOfType<Object>(json, r'avatarUrl'),
        rating: num.parse('${json[r'rating']}'),
        soldCount: num.parse('${json[r'soldCount']}'),
        clinicName: mapValueOfType<String>(json, r'clinicName')!,
      );
    }
    return null;
  }

  static List<FeaturedSpecialistResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FeaturedSpecialistResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FeaturedSpecialistResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FeaturedSpecialistResponseDto> mapFromJson(dynamic json) {
    final map = <String, FeaturedSpecialistResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FeaturedSpecialistResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FeaturedSpecialistResponseDto-objects as value to a dart map
  static Map<String, List<FeaturedSpecialistResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FeaturedSpecialistResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FeaturedSpecialistResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'specialty',
    'rating',
    'soldCount',
    'clinicName',
  };
}

