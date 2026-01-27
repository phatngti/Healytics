//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IdImagesRequestDto {
  /// Returns a new [IdImagesRequestDto] instance.
  IdImagesRequestDto({
    required this.frontImgUrl,
    required this.backImgUrl,
  });

  /// URL to front image of ID document
  String frontImgUrl;

  /// URL to back image of ID document
  String backImgUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IdImagesRequestDto &&
    other.frontImgUrl == frontImgUrl &&
    other.backImgUrl == backImgUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (frontImgUrl.hashCode) +
    (backImgUrl.hashCode);

  @override
  String toString() => 'IdImagesRequestDto[frontImgUrl=$frontImgUrl, backImgUrl=$backImgUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'frontImgUrl'] = this.frontImgUrl;
      json[r'backImgUrl'] = this.backImgUrl;
    return json;
  }

  /// Returns a new [IdImagesRequestDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IdImagesRequestDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IdImagesRequestDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IdImagesRequestDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IdImagesRequestDto(
        frontImgUrl: mapValueOfType<String>(json, r'frontImgUrl')!,
        backImgUrl: mapValueOfType<String>(json, r'backImgUrl')!,
      );
    }
    return null;
  }

  static List<IdImagesRequestDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IdImagesRequestDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IdImagesRequestDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IdImagesRequestDto> mapFromJson(dynamic json) {
    final map = <String, IdImagesRequestDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IdImagesRequestDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IdImagesRequestDto-objects as value to a dart map
  static Map<String, List<IdImagesRequestDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IdImagesRequestDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IdImagesRequestDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'frontImgUrl',
    'backImgUrl',
  };
}

