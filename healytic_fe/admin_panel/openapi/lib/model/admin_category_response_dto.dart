//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminCategoryResponseDto {
  /// Returns a new [AdminCategoryResponseDto] instance.
  AdminCategoryResponseDto({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.imageUrl,
    required this.isActive,
    this.iconName,
    this.colorValue,
    required this.sortOrder,
    required this.serviceCount,
    required this.createdAt,
    required this.updatedAt,
    this.parent,
    this.children = const [],
  });


  /// Unique category identifier
  String id;

  /// Category name
  String name;

  /// URL-friendly slug
  String slug;

  /// Category description
  String? description;

  /// Category image URL
  String? imageUrl;

  /// Whether category is active
  bool isActive;

  /// Icon identifier for frontend rendering
  String? iconName;

  /// Hex color value (e.g. #FF6B6B)
  String? colorValue;

  /// Sort order for display (lower = first)
  num sortOrder;

  /// Number of health services in this category
  num serviceCount;

  /// Creation timestamp
  DateTime createdAt;

  /// Last update timestamp
  DateTime updatedAt;

  /// Parent category
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CategorySummaryDto? parent;

  /// Child categories
  List<CategorySummaryDto> children;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminCategoryResponseDto &&
    other.id == id &&
    other.name == name &&
    other.slug == slug &&
    other.description == description &&
    other.imageUrl == imageUrl &&
    other.isActive == isActive &&
    other.iconName == iconName &&
    other.colorValue == colorValue &&
    other.sortOrder == sortOrder &&
    other.serviceCount == serviceCount &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt &&
    other.parent == parent &&
    _deepEquality.equals(other.children, children);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (slug.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (isActive.hashCode) +
    (iconName == null ? 0 : iconName!.hashCode) +
    (colorValue == null ? 0 : colorValue!.hashCode) +
    (sortOrder.hashCode) +
    (serviceCount.hashCode) +
    (createdAt.hashCode) +
    (updatedAt.hashCode) +
    (parent == null ? 0 : parent!.hashCode) +
    (children.hashCode);

  @override
  String toString() => 'AdminCategoryResponseDto[id=$id, name=$name, slug=$slug, description=$description, imageUrl=$imageUrl, isActive=$isActive, iconName=$iconName, colorValue=$colorValue, sortOrder=$sortOrder, serviceCount=$serviceCount, createdAt=$createdAt, updatedAt=$updatedAt, parent=$parent, children=$children]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'slug'] = this.slug;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.imageUrl != null) {
      json[r'imageUrl'] = this.imageUrl;
    } else {
      json[r'imageUrl'] = null;
    }
      json[r'isActive'] = this.isActive;
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
      json[r'sortOrder'] = this.sortOrder;
      json[r'serviceCount'] = this.serviceCount;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
      json[r'updatedAt'] = this.updatedAt.toUtc().toIso8601String();
    if (this.parent != null) {
      json[r'parent'] = this.parent;
    } else {
      json[r'parent'] = null;
    }
      json[r'children'] = this.children;
    return json;
  }

  /// Returns a new [AdminCategoryResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminCategoryResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminCategoryResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminCategoryResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminCategoryResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        slug: mapValueOfType<String>(json, r'slug')!,
        description: mapValueOfType<String>(json, r'description'),
        imageUrl: mapValueOfType<String>(json, r'imageUrl'),
        isActive: mapValueOfType<bool>(json, r'isActive')!,
        iconName: mapValueOfType<String>(json, r'iconName'),
        colorValue: mapValueOfType<String>(json, r'colorValue'),
        sortOrder: num.parse('${json[r'sortOrder']}'),
        serviceCount: num.parse('${json[r'serviceCount']}'),
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        updatedAt: mapDateTime(json, r'updatedAt', r'')!,
        parent: CategorySummaryDto.fromJson(json[r'parent']),
        children: CategorySummaryDto.listFromJson(json[r'children']),
      );
    }
    return null;
  }

  static List<AdminCategoryResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCategoryResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCategoryResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminCategoryResponseDto> mapFromJson(dynamic json) {
    final map = <String, AdminCategoryResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminCategoryResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminCategoryResponseDto-objects as value to a dart map
  static Map<String, List<AdminCategoryResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminCategoryResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminCategoryResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'slug',
    'isActive',
    'sortOrder',
    'serviceCount',
    'createdAt',
    'updatedAt',
  };
}

