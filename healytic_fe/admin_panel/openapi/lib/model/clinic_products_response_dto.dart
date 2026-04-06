//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ClinicProductsResponseDto {
  /// Returns a new [ClinicProductsResponseDto] instance.
  ClinicProductsResponseDto({
    this.products = const [],
    required this.totalCount,
    required this.hasMore,
  });

  List<ClinicProductDto> products;

  num totalCount;

  bool hasMore;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ClinicProductsResponseDto &&
    _deepEquality.equals(other.products, products) &&
    other.totalCount == totalCount &&
    other.hasMore == hasMore;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (products.hashCode) +
    (totalCount.hashCode) +
    (hasMore.hashCode);

  @override
  String toString() => 'ClinicProductsResponseDto[products=$products, totalCount=$totalCount, hasMore=$hasMore]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'products'] = this.products;
      json[r'totalCount'] = this.totalCount;
      json[r'hasMore'] = this.hasMore;
    return json;
  }

  /// Returns a new [ClinicProductsResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ClinicProductsResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ClinicProductsResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ClinicProductsResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ClinicProductsResponseDto(
        products: ClinicProductDto.listFromJson(json[r'products']),
        totalCount: num.parse('${json[r'totalCount']}'),
        hasMore: mapValueOfType<bool>(json, r'hasMore')!,
      );
    }
    return null;
  }

  static List<ClinicProductsResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ClinicProductsResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ClinicProductsResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ClinicProductsResponseDto> mapFromJson(dynamic json) {
    final map = <String, ClinicProductsResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ClinicProductsResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ClinicProductsResponseDto-objects as value to a dart map
  static Map<String, List<ClinicProductsResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ClinicProductsResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ClinicProductsResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'products',
    'totalCount',
    'hasMore',
  };
}

