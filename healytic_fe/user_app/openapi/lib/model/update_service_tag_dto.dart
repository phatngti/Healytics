//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdateServiceTagDto {
  /// Returns a new [UpdateServiceTagDto] instance.
  UpdateServiceTagDto({
    this.name,
    this.description,
    this.colorValue,
    this.isActive,
    this.sortOrder,
  });

  /// Tag name
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  /// Color value as hex string
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? colorValue;

  /// Whether the tag is active
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isActive;

  /// Sort order for display
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? sortOrder;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateServiceTagDto &&
    other.name == name &&
    other.description == description &&
    other.colorValue == colorValue &&
    other.isActive == isActive &&
    other.sortOrder == sortOrder;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name == null ? 0 : name!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (colorValue == null ? 0 : colorValue!.hashCode) +
    (isActive == null ? 0 : isActive!.hashCode) +
    (sortOrder == null ? 0 : sortOrder!.hashCode);

  @override
  String toString() => 'UpdateServiceTagDto[name=$name, description=$description, colorValue=$colorValue, isActive=$isActive, sortOrder=$sortOrder]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.colorValue != null) {
      json[r'colorValue'] = this.colorValue;
    } else {
      json[r'colorValue'] = null;
    }
    if (this.isActive != null) {
      json[r'isActive'] = this.isActive;
    } else {
      json[r'isActive'] = null;
    }
    if (this.sortOrder != null) {
      json[r'sortOrder'] = this.sortOrder;
    } else {
      json[r'sortOrder'] = null;
    }
    return json;
  }

  /// Returns a new [UpdateServiceTagDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdateServiceTagDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdateServiceTagDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdateServiceTagDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdateServiceTagDto(
        name: mapValueOfType<String>(json, r'name'),
        description: mapValueOfType<String>(json, r'description'),
        colorValue: mapValueOfType<String>(json, r'colorValue'),
        isActive: mapValueOfType<bool>(json, r'isActive'),
        sortOrder: num.parse('${json[r'sortOrder']}'),
      );
    }
    return null;
  }

  static List<UpdateServiceTagDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateServiceTagDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateServiceTagDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateServiceTagDto> mapFromJson(dynamic json) {
    final map = <String, UpdateServiceTagDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateServiceTagDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateServiceTagDto-objects as value to a dart map
  static Map<String, List<UpdateServiceTagDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateServiceTagDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateServiceTagDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

