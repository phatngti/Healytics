//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RecommendedServiceResponseDto {
  /// Returns a new [RecommendedServiceResponseDto] instance.
  RecommendedServiceResponseDto({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.duration,
  });

  String id;

  String name;

  String description;

  String imageUrl;

  String price;

  String duration;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RecommendedServiceResponseDto &&
    other.id == id &&
    other.name == name &&
    other.description == description &&
    other.imageUrl == imageUrl &&
    other.price == price &&
    other.duration == duration;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (name.hashCode) +
    (description.hashCode) +
    (imageUrl.hashCode) +
    (price.hashCode) +
    (duration.hashCode);

  @override
  String toString() => 'RecommendedServiceResponseDto[id=$id, name=$name, description=$description, imageUrl=$imageUrl, price=$price, duration=$duration]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'name'] = this.name;
      json[r'description'] = this.description;
      json[r'imageUrl'] = this.imageUrl;
      json[r'price'] = this.price;
      json[r'duration'] = this.duration;
    return json;
  }

  /// Returns a new [RecommendedServiceResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RecommendedServiceResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RecommendedServiceResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RecommendedServiceResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RecommendedServiceResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        name: mapValueOfType<String>(json, r'name')!,
        description: mapValueOfType<String>(json, r'description')!,
        imageUrl: mapValueOfType<String>(json, r'imageUrl')!,
        price: mapValueOfType<String>(json, r'price')!,
        duration: mapValueOfType<String>(json, r'duration')!,
      );
    }
    return null;
  }

  static List<RecommendedServiceResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RecommendedServiceResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RecommendedServiceResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RecommendedServiceResponseDto> mapFromJson(dynamic json) {
    final map = <String, RecommendedServiceResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RecommendedServiceResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RecommendedServiceResponseDto-objects as value to a dart map
  static Map<String, List<RecommendedServiceResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RecommendedServiceResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RecommendedServiceResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'name',
    'description',
    'imageUrl',
    'price',
    'duration',
  };
}

