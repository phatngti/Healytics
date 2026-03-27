//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BusinessServiceDto {
  /// Returns a new [BusinessServiceDto] instance.
  BusinessServiceDto({
    required this.value,
    required this.label,
    this.description,
  });

  /// Business type enum value
  String value;

  /// Vietnamese label for display
  String label;

  /// English description
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BusinessServiceDto &&
    other.value == value &&
    other.label == label &&
    other.description == description;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (value.hashCode) +
    (label.hashCode) +
    (description == null ? 0 : description!.hashCode);

  @override
  String toString() => 'BusinessServiceDto[value=$value, label=$label, description=$description]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'value'] = this.value;
      json[r'label'] = this.label;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    return json;
  }

  /// Returns a new [BusinessServiceDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BusinessServiceDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BusinessServiceDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BusinessServiceDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BusinessServiceDto(
        value: mapValueOfType<String>(json, r'value')!,
        label: mapValueOfType<String>(json, r'label')!,
        description: mapValueOfType<String>(json, r'description'),
      );
    }
    return null;
  }

  static List<BusinessServiceDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BusinessServiceDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BusinessServiceDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BusinessServiceDto> mapFromJson(dynamic json) {
    final map = <String, BusinessServiceDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BusinessServiceDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BusinessServiceDto-objects as value to a dart map
  static Map<String, List<BusinessServiceDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BusinessServiceDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BusinessServiceDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'value',
    'label',
  };
}

