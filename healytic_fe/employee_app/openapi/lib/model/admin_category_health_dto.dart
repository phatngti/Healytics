//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminCategoryHealthDto {
  /// Returns a new [AdminCategoryHealthDto] instance.
  AdminCategoryHealthDto({
    required this.totalCategories,
    required this.activeCategories,
    required this.inactiveCategories,
    required this.rootCategories,
    required this.subCategories,
    required this.emptyCategories,
    required this.totalMappedServices,
    this.topCategories = const [],
  });


  num totalCategories;

  num activeCategories;

  num inactiveCategories;

  num rootCategories;

  num subCategories;

  num emptyCategories;

  num totalMappedServices;

  List<AdminCategorySnapshotDto> topCategories;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminCategoryHealthDto &&
    other.totalCategories == totalCategories &&
    other.activeCategories == activeCategories &&
    other.inactiveCategories == inactiveCategories &&
    other.rootCategories == rootCategories &&
    other.subCategories == subCategories &&
    other.emptyCategories == emptyCategories &&
    other.totalMappedServices == totalMappedServices &&
    _deepEquality.equals(other.topCategories, topCategories);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (totalCategories.hashCode) +
    (activeCategories.hashCode) +
    (inactiveCategories.hashCode) +
    (rootCategories.hashCode) +
    (subCategories.hashCode) +
    (emptyCategories.hashCode) +
    (totalMappedServices.hashCode) +
    (topCategories.hashCode);

  @override
  String toString() => 'AdminCategoryHealthDto[totalCategories=$totalCategories, activeCategories=$activeCategories, inactiveCategories=$inactiveCategories, rootCategories=$rootCategories, subCategories=$subCategories, emptyCategories=$emptyCategories, totalMappedServices=$totalMappedServices, topCategories=$topCategories]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'totalCategories'] = this.totalCategories;
      json[r'activeCategories'] = this.activeCategories;
      json[r'inactiveCategories'] = this.inactiveCategories;
      json[r'rootCategories'] = this.rootCategories;
      json[r'subCategories'] = this.subCategories;
      json[r'emptyCategories'] = this.emptyCategories;
      json[r'totalMappedServices'] = this.totalMappedServices;
      json[r'topCategories'] = this.topCategories;
    return json;
  }

  /// Returns a new [AdminCategoryHealthDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminCategoryHealthDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminCategoryHealthDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminCategoryHealthDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminCategoryHealthDto(
        totalCategories: num.parse('${json[r'totalCategories']}'),
        activeCategories: num.parse('${json[r'activeCategories']}'),
        inactiveCategories: num.parse('${json[r'inactiveCategories']}'),
        rootCategories: num.parse('${json[r'rootCategories']}'),
        subCategories: num.parse('${json[r'subCategories']}'),
        emptyCategories: num.parse('${json[r'emptyCategories']}'),
        totalMappedServices: num.parse('${json[r'totalMappedServices']}'),
        topCategories: AdminCategorySnapshotDto.listFromJson(json[r'topCategories']),
      );
    }
    return null;
  }

  static List<AdminCategoryHealthDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCategoryHealthDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCategoryHealthDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminCategoryHealthDto> mapFromJson(dynamic json) {
    final map = <String, AdminCategoryHealthDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminCategoryHealthDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminCategoryHealthDto-objects as value to a dart map
  static Map<String, List<AdminCategoryHealthDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminCategoryHealthDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminCategoryHealthDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'totalCategories',
    'activeCategories',
    'inactiveCategories',
    'rootCategories',
    'subCategories',
    'emptyCategories',
    'totalMappedServices',
    'topCategories',
  };
}

