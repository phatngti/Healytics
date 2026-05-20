//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BookingSpecialistResponseDto {
  /// Returns a new [BookingSpecialistResponseDto] instance.
  BookingSpecialistResponseDto({
    required this.id,
    required this.eligibilityId,
    required this.name,
    required this.specialty,
    this.avatarUrl,
  });


  /// Unique specialist/employee ID
  String id;

  /// product_employee_eligibility surrogate PK
  String eligibilityId;

  /// Full display name
  String name;

  /// Short specialty label
  String specialty;

  /// URL to avatar image
  Object? avatarUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BookingSpecialistResponseDto &&
    other.id == id &&
    other.eligibilityId == eligibilityId &&
    other.name == name &&
    other.specialty == specialty &&
    other.avatarUrl == avatarUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (eligibilityId.hashCode) +
    (name.hashCode) +
    (specialty.hashCode) +
    (avatarUrl == null ? 0 : avatarUrl!.hashCode);

  @override
  String toString() => 'BookingSpecialistResponseDto[id=$id, eligibilityId=$eligibilityId, name=$name, specialty=$specialty, avatarUrl=$avatarUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'eligibilityId'] = this.eligibilityId;
      json[r'name'] = this.name;
      json[r'specialty'] = this.specialty;
    if (this.avatarUrl != null) {
      json[r'avatarUrl'] = this.avatarUrl;
    } else {
      json[r'avatarUrl'] = null;
    }
    return json;
  }

  /// Returns a new [BookingSpecialistResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BookingSpecialistResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BookingSpecialistResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BookingSpecialistResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BookingSpecialistResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        eligibilityId: mapValueOfType<String>(json, r'eligibilityId')!,
        name: mapValueOfType<String>(json, r'name')!,
        specialty: mapValueOfType<String>(json, r'specialty')!,
        avatarUrl: mapValueOfType<Object>(json, r'avatarUrl'),
      );
    }
    return null;
  }

  static List<BookingSpecialistResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BookingSpecialistResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BookingSpecialistResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BookingSpecialistResponseDto> mapFromJson(dynamic json) {
    final map = <String, BookingSpecialistResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BookingSpecialistResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BookingSpecialistResponseDto-objects as value to a dart map
  static Map<String, List<BookingSpecialistResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BookingSpecialistResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BookingSpecialistResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'eligibilityId',
    'name',
    'specialty',
  };
}

