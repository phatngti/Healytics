//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SeedCategoryDto {
  /// Returns a new [SeedCategoryDto] instance.
  SeedCategoryDto({
    this.key,
    required this.name,
    this.slug,
    this.description,
    this.iconName,
    this.colorValue,
    this.sortOrder,
  });


  /// Unique lookup key
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? key;

  String name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? slug;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? iconName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? colorValue;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? sortOrder;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SeedCategoryDto &&
    other.key == key &&
    other.name == name &&
    other.slug == slug &&
    other.description == description &&
    other.iconName == iconName &&
    other.colorValue == colorValue &&
    other.sortOrder == sortOrder;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (key == null ? 0 : key!.hashCode) +
    (name.hashCode) +
    (slug == null ? 0 : slug!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (iconName == null ? 0 : iconName!.hashCode) +
    (colorValue == null ? 0 : colorValue!.hashCode) +
    (sortOrder == null ? 0 : sortOrder!.hashCode);

  @override
  String toString() => 'SeedCategoryDto[key=$key, name=$name, slug=$slug, description=$description, iconName=$iconName, colorValue=$colorValue, sortOrder=$sortOrder]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.key != null) {
      json[r'key'] = this.key;
    } else {
      json[r'key'] = null;
    }
      json[r'name'] = this.name;
    if (this.slug != null) {
      json[r'slug'] = this.slug;
    } else {
      json[r'slug'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.iconName != null) {
      json[r'iconName'] = this.iconName;
    } else {
      json[r'iconName'] = null;
    }
    if (this.colorValue != null) {
      json[r'colorValue'] = this.colorValue;
    } else {
      json[r'colorValue'] = null;
    }
    if (this.sortOrder != null) {
      json[r'sortOrder'] = this.sortOrder;
    } else {
      json[r'sortOrder'] = null;
    }
    return json;
  }

  /// Returns a new [SeedCategoryDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SeedCategoryDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SeedCategoryDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SeedCategoryDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SeedCategoryDto(
        key: mapValueOfType<String>(json, r'key'),
        name: mapValueOfType<String>(json, r'name')!,
        slug: mapValueOfType<String>(json, r'slug'),
        description: mapValueOfType<String>(json, r'description'),
        iconName: mapValueOfType<String>(json, r'iconName'),
        colorValue: mapValueOfType<String>(json, r'colorValue'),
        sortOrder: num.parse('${json[r'sortOrder']}'),
      );
    }
    return null;
  }

  static List<SeedCategoryDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SeedCategoryDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SeedCategoryDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SeedCategoryDto> mapFromJson(dynamic json) {
    final map = <String, SeedCategoryDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SeedCategoryDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SeedCategoryDto-objects as value to a dart map
  static Map<String, List<SeedCategoryDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SeedCategoryDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SeedCategoryDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
  };
}

