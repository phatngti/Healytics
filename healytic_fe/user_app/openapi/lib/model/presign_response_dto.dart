//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PresignResponseDto {
  /// Returns a new [PresignResponseDto] instance.
  PresignResponseDto({
    required this.uploadUrl,
    required this.key,
  });


  /// Presigned URL for uploading the file
  String uploadUrl;

  /// Storage key for the uploaded file
  String key;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PresignResponseDto &&
    other.uploadUrl == uploadUrl &&
    other.key == key;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (uploadUrl.hashCode) +
    (key.hashCode);

  @override
  String toString() => 'PresignResponseDto[uploadUrl=$uploadUrl, key=$key]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'uploadUrl'] = this.uploadUrl;
      json[r'key'] = this.key;
    return json;
  }

  /// Returns a new [PresignResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PresignResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PresignResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PresignResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PresignResponseDto(
        uploadUrl: mapValueOfType<String>(json, r'uploadUrl')!,
        key: mapValueOfType<String>(json, r'key')!,
      );
    }
    return null;
  }

  static List<PresignResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PresignResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PresignResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PresignResponseDto> mapFromJson(dynamic json) {
    final map = <String, PresignResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PresignResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PresignResponseDto-objects as value to a dart map
  static Map<String, List<PresignResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PresignResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PresignResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'uploadUrl',
    'key',
  };
}

