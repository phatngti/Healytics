//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnersResponseDto {
  /// Returns a new [PartnersResponseDto] instance.
  PartnersResponseDto({
    this.data = const [],
    required this.total,
    required this.page,
    required this.limit,
  });

  List<PartnerItemDto> data;

  num total;

  num page;

  num limit;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnersResponseDto &&
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
  String toString() => 'PartnersResponseDto[data=$data, total=$total, page=$page, limit=$limit]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'data'] = this.data;
      json[r'total'] = this.total;
      json[r'page'] = this.page;
      json[r'limit'] = this.limit;
    return json;
  }

  /// Returns a new [PartnersResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnersResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnersResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnersResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnersResponseDto(
        data: PartnerItemDto.listFromJson(json[r'data']),
        total: num.parse('${json[r'total']}'),
        page: num.parse('${json[r'page']}'),
        limit: num.parse('${json[r'limit']}'),
      );
    }
    return null;
  }

  static List<PartnersResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnersResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnersResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnersResponseDto> mapFromJson(dynamic json) {
    final map = <String, PartnersResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnersResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnersResponseDto-objects as value to a dart map
  static Map<String, List<PartnersResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnersResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnersResponseDto.listFromJson(entry.value, growable: growable,);
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

