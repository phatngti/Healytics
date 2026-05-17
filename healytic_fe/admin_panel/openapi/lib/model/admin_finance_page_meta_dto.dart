//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinancePageMetaDto {
  /// Returns a new [AdminFinancePageMetaDto] instance.
  AdminFinancePageMetaDto({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });


  num total;

  num page;

  num limit;

  num totalPages;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinancePageMetaDto &&
    other.total == total &&
    other.page == page &&
    other.limit == limit &&
    other.totalPages == totalPages;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (total.hashCode) +
    (page.hashCode) +
    (limit.hashCode) +
    (totalPages.hashCode);

  @override
  String toString() => 'AdminFinancePageMetaDto[total=$total, page=$page, limit=$limit, totalPages=$totalPages]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'total'] = this.total;
      json[r'page'] = this.page;
      json[r'limit'] = this.limit;
      json[r'totalPages'] = this.totalPages;
    return json;
  }

  /// Returns a new [AdminFinancePageMetaDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinancePageMetaDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinancePageMetaDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinancePageMetaDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinancePageMetaDto(
        total: num.parse('${json[r'total']}'),
        page: num.parse('${json[r'page']}'),
        limit: num.parse('${json[r'limit']}'),
        totalPages: num.parse('${json[r'totalPages']}'),
      );
    }
    return null;
  }

  static List<AdminFinancePageMetaDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinancePageMetaDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinancePageMetaDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinancePageMetaDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinancePageMetaDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinancePageMetaDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinancePageMetaDto-objects as value to a dart map
  static Map<String, List<AdminFinancePageMetaDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinancePageMetaDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinancePageMetaDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'total',
    'page',
    'limit',
    'totalPages',
  };
}

