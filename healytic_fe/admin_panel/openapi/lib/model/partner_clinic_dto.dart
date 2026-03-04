//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerClinicDto {
  /// Returns a new [PartnerClinicDto] instance.
  PartnerClinicDto({
    required this.name,
    required this.address,
    this.isVerified,
  });

  String name;

  String address;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isVerified;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerClinicDto &&
    other.name == name &&
    other.address == address &&
    other.isVerified == isVerified;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (address.hashCode) +
    (isVerified == null ? 0 : isVerified!.hashCode);

  @override
  String toString() => 'PartnerClinicDto[name=$name, address=$address, isVerified=$isVerified]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'address'] = this.address;
    if (this.isVerified != null) {
      json[r'isVerified'] = this.isVerified;
    } else {
      json[r'isVerified'] = null;
    }
    return json;
  }

  /// Returns a new [PartnerClinicDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerClinicDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerClinicDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerClinicDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerClinicDto(
        name: mapValueOfType<String>(json, r'name')!,
        address: mapValueOfType<String>(json, r'address')!,
        isVerified: mapValueOfType<bool>(json, r'isVerified'),
      );
    }
    return null;
  }

  static List<PartnerClinicDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerClinicDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerClinicDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerClinicDto> mapFromJson(dynamic json) {
    final map = <String, PartnerClinicDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerClinicDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerClinicDto-objects as value to a dart map
  static Map<String, List<PartnerClinicDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerClinicDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerClinicDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'address',
  };
}

