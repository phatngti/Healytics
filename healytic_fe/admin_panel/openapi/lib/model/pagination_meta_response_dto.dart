//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PaginationMetaResponseDto {
  /// Returns a new [PaginationMetaResponseDto] instance.
  PaginationMetaResponseDto({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });


  /// Current page number
  num page;

  /// Items per page
  num limit;

  /// Total number of items
  num total;

  /// Total number of pages
  num totalPages;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PaginationMetaResponseDto &&
    other.page == page &&
    other.limit == limit &&
    other.total == total &&
    other.totalPages == totalPages;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (page.hashCode) +
    (limit.hashCode) +
    (total.hashCode) +
    (totalPages.hashCode);

  @override
  String toString() => 'PaginationMetaResponseDto[page=$page, limit=$limit, total=$total, totalPages=$totalPages]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'page'] = this.page;
      json[r'limit'] = this.limit;
      json[r'total'] = this.total;
      json[r'totalPages'] = this.totalPages;
    return json;
  }

  /// Returns a new [PaginationMetaResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PaginationMetaResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PaginationMetaResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PaginationMetaResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PaginationMetaResponseDto(
        page: num.parse('${json[r'page']}'),
        limit: num.parse('${json[r'limit']}'),
        total: num.parse('${json[r'total']}'),
        totalPages: num.parse('${json[r'totalPages']}'),
      );
    }
    return null;
  }

  static List<PaginationMetaResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PaginationMetaResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PaginationMetaResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PaginationMetaResponseDto> mapFromJson(dynamic json) {
    final map = <String, PaginationMetaResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PaginationMetaResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PaginationMetaResponseDto-objects as value to a dart map
  static Map<String, List<PaginationMetaResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PaginationMetaResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PaginationMetaResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'page',
    'limit',
    'total',
    'totalPages',
  };
}

