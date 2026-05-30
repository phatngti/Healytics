//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminCategorySnapshotDto {
  /// Returns a new [AdminCategorySnapshotDto] instance.
  AdminCategorySnapshotDto({
    required this.id,
    required this.name,
    required this.serviceCount,
    required this.subCategoryCount,
    required this.isRoot,
    required this.isActive,
  });


  String id;

  String name;

  num serviceCount;

  num subCategoryCount;

  bool isRoot;

  bool isActive;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminCategorySnapshotDto &&
    other.id == id &&
    other.name == name &&
    other.serviceCount == serviceCount &&
    other.subCategoryCount == subCategoryCount &&
    other.isRoot == isRoot &&
    other.isActive == isActive;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (serviceCount.hashCode) +
    (subCategoryCount.hashCode) +
    (isRoot.hashCode) +
    (isActive.hashCode);

  @override
  String toString() => 'AdminCategorySnapshotDto[id=$id, name=$name, serviceCount=$serviceCount, subCategoryCount=$subCategoryCount, isRoot=$isRoot, isActive=$isActive]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'serviceCount'] = this.serviceCount;
      json[r'subCategoryCount'] = this.subCategoryCount;
      json[r'isRoot'] = this.isRoot;
      json[r'isActive'] = this.isActive;
    return json;
  }

  /// Returns a new [AdminCategorySnapshotDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminCategorySnapshotDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminCategorySnapshotDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminCategorySnapshotDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminCategorySnapshotDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        serviceCount: num.parse('${json[r'serviceCount']}'),
        subCategoryCount: num.parse('${json[r'subCategoryCount']}'),
        isRoot: mapValueOfType<bool>(json, r'isRoot')!,
        isActive: mapValueOfType<bool>(json, r'isActive')!,
      );
    }
    return null;
  }

  static List<AdminCategorySnapshotDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminCategorySnapshotDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminCategorySnapshotDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminCategorySnapshotDto> mapFromJson(dynamic json) {
    final map = <String, AdminCategorySnapshotDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminCategorySnapshotDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminCategorySnapshotDto-objects as value to a dart map
  static Map<String, List<AdminCategorySnapshotDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminCategorySnapshotDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminCategorySnapshotDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'serviceCount',
    'subCategoryCount',
    'isRoot',
    'isActive',
  };
}

