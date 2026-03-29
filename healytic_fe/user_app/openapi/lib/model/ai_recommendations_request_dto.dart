//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AiRecommendationsRequestDto {
  /// Returns a new [AiRecommendationsRequestDto] instance.
  AiRecommendationsRequestDto({
    this.serviceIds = const [],
  });

  /// List of service IDs to retrieve recommendations for
  List<String> serviceIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AiRecommendationsRequestDto &&
    _deepEquality.equals(other.serviceIds, serviceIds);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (serviceIds.hashCode);

  @override
  String toString() => 'AiRecommendationsRequestDto[serviceIds=$serviceIds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'serviceIds'] = this.serviceIds;
    return json;
  }

  /// Returns a new [AiRecommendationsRequestDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AiRecommendationsRequestDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AiRecommendationsRequestDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AiRecommendationsRequestDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AiRecommendationsRequestDto(
        serviceIds: json[r'serviceIds'] is Iterable
            ? (json[r'serviceIds'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<AiRecommendationsRequestDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AiRecommendationsRequestDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AiRecommendationsRequestDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AiRecommendationsRequestDto> mapFromJson(dynamic json) {
    final map = <String, AiRecommendationsRequestDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AiRecommendationsRequestDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AiRecommendationsRequestDto-objects as value to a dart map
  static Map<String, List<AiRecommendationsRequestDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AiRecommendationsRequestDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AiRecommendationsRequestDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'serviceIds',
  };
}

