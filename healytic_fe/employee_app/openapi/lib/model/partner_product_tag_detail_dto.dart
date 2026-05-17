//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerProductTagDetailDto {
  /// Returns a new [PartnerProductTagDetailDto] instance.
  PartnerProductTagDetailDto({
    required this.id,
    required this.name,
    this.description,
    required this.colorValue,
  });


  String id;

  String name;

  String? description;

  String colorValue;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerProductTagDetailDto &&
    other.id == id &&
    other.name == name &&
    other.description == description &&
    other.colorValue == colorValue;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (colorValue.hashCode);

  @override
  String toString() => 'PartnerProductTagDetailDto[id=$id, name=$name, description=$description, colorValue=$colorValue]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'colorValue'] = this.colorValue;
    return json;
  }

  /// Returns a new [PartnerProductTagDetailDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerProductTagDetailDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerProductTagDetailDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerProductTagDetailDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerProductTagDetailDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        description: mapValueOfType<String>(json, r'description'),
        colorValue: mapValueOfType<String>(json, r'colorValue')!,
      );
    }
    return null;
  }

  static List<PartnerProductTagDetailDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerProductTagDetailDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerProductTagDetailDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerProductTagDetailDto> mapFromJson(dynamic json) {
    final map = <String, PartnerProductTagDetailDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerProductTagDetailDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerProductTagDetailDto-objects as value to a dart map
  static Map<String, List<PartnerProductTagDetailDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerProductTagDetailDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerProductTagDetailDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'colorValue',
  };
}

