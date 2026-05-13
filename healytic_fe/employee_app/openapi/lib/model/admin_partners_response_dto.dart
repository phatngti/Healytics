//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminPartnersResponseDto {
  /// Returns a new [AdminPartnersResponseDto] instance.
  AdminPartnersResponseDto({
    this.data = const [],
    required this.total,
    required this.page,
    required this.limit,
  });


  List<AdminPartnerItemDto> data;

  num total;

  num page;

  num limit;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminPartnersResponseDto &&
    _deepEquality.equals(other.data, data) &&
    other.total == total &&
    other.page == page &&
    other.limit == limit;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (data.hashCode) +
    (total.hashCode) +
    (page.hashCode) +
    (limit.hashCode);

  @override
  String toString() => 'AdminPartnersResponseDto[data=$data, total=$total, page=$page, limit=$limit]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'data'] = this.data;
      json[r'total'] = this.total;
      json[r'page'] = this.page;
      json[r'limit'] = this.limit;
    return json;
  }

  /// Returns a new [AdminPartnersResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminPartnersResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminPartnersResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminPartnersResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminPartnersResponseDto(
        data: AdminPartnerItemDto.listFromJson(json[r'data']),
        total: num.parse('${json[r'total']}'),
        page: num.parse('${json[r'page']}'),
        limit: num.parse('${json[r'limit']}'),
      );
    }
    return null;
  }

  static List<AdminPartnersResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPartnersResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPartnersResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminPartnersResponseDto> mapFromJson(dynamic json) {
    final map = <String, AdminPartnersResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminPartnersResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminPartnersResponseDto-objects as value to a dart map
  static Map<String, List<AdminPartnersResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminPartnersResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminPartnersResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'data',
    'total',
    'page',
    'limit',
  };
}

