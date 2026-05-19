//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerBookingSpecialistDto {
  /// Returns a new [PartnerBookingSpecialistDto] instance.
  PartnerBookingSpecialistDto({
    required this.id,
    required this.fullName,
    required this.roleLabel,
    this.avatarUrl,
  });


  String id;

  String fullName;

  String roleLabel;

  Object? avatarUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerBookingSpecialistDto &&
    other.id == id &&
    other.fullName == fullName &&
    other.roleLabel == roleLabel &&
    other.avatarUrl == avatarUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (fullName.hashCode) +
    (roleLabel.hashCode) +
    (avatarUrl == null ? 0 : avatarUrl!.hashCode);

  @override
  String toString() => 'PartnerBookingSpecialistDto[id=$id, fullName=$fullName, roleLabel=$roleLabel, avatarUrl=$avatarUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'fullName'] = this.fullName;
      json[r'roleLabel'] = this.roleLabel;
    if (this.avatarUrl != null) {
      json[r'avatarUrl'] = this.avatarUrl;
    } else {
      json[r'avatarUrl'] = null;
    }
    return json;
  }

  /// Returns a new [PartnerBookingSpecialistDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerBookingSpecialistDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerBookingSpecialistDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerBookingSpecialistDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerBookingSpecialistDto(
        id: mapValueOfType<String>(json, r'id')!,
        fullName: mapValueOfType<String>(json, r'fullName')!,
        roleLabel: mapValueOfType<String>(json, r'roleLabel')!,
        avatarUrl: mapValueOfType<Object>(json, r'avatarUrl'),
      );
    }
    return null;
  }

  static List<PartnerBookingSpecialistDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerBookingSpecialistDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerBookingSpecialistDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerBookingSpecialistDto> mapFromJson(dynamic json) {
    final map = <String, PartnerBookingSpecialistDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerBookingSpecialistDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerBookingSpecialistDto-objects as value to a dart map
  static Map<String, List<PartnerBookingSpecialistDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerBookingSpecialistDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerBookingSpecialistDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'fullName',
    'roleLabel',
  };
}

