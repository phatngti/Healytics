//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublicCategorySummaryDto {
  /// Returns a new [PublicCategorySummaryDto] instance.
  PublicCategorySummaryDto({
    required this.id,
    this.parentId,
    required this.name,
    required this.slug,
    this.parent,
  });


  String id;

  String? parentId;

  String name;

  String slug;

  PublicCategorySummaryDto? parent;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicCategorySummaryDto &&
    other.id == id &&
    other.parentId == parentId &&
    other.name == name &&
    other.slug == slug &&
    other.parent == parent;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (parentId == null ? 0 : parentId!.hashCode) +
    (name.hashCode) +
    (slug.hashCode) +
    (parent == null ? 0 : parent!.hashCode);

  @override
  String toString() => 'PublicCategorySummaryDto[id=$id, parentId=$parentId, name=$name, slug=$slug, parent=$parent]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
    if (this.parentId != null) {
      json[r'parentId'] = this.parentId;
    } else {
      json[r'parentId'] = null;
    }
      json[r'name'] = this.name;
      json[r'slug'] = this.slug;
    if (this.parent != null) {
      json[r'parent'] = this.parent;
    } else {
      json[r'parent'] = null;
    }
    return json;
  }

  /// Returns a new [PublicCategorySummaryDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublicCategorySummaryDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublicCategorySummaryDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublicCategorySummaryDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublicCategorySummaryDto(
        id: mapValueOfType<String>(json, r'id')!,
        parentId: mapValueOfType<String>(json, r'parentId'),
        name: mapValueOfType<String>(json, r'name')!,
        slug: mapValueOfType<String>(json, r'slug')!,
        parent: PublicCategorySummaryDto.fromJson(json[r'parent']),
      );
    }
    return null;
  }

  static List<PublicCategorySummaryDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublicCategorySummaryDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublicCategorySummaryDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublicCategorySummaryDto> mapFromJson(dynamic json) {
    final map = <String, PublicCategorySummaryDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublicCategorySummaryDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublicCategorySummaryDto-objects as value to a dart map
  static Map<String, List<PublicCategorySummaryDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublicCategorySummaryDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublicCategorySummaryDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'slug',
  };
}

