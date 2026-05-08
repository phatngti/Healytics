//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PresignRequestDto {
  /// Returns a new [PresignRequestDto] instance.
  PresignRequestDto({
    required this.fileName,
    required this.contentType,
  });


  /// Original file name
  String fileName;

  /// MIME type of the file
  String contentType;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PresignRequestDto &&
    other.fileName == fileName &&
    other.contentType == contentType;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fileName.hashCode) +
    (contentType.hashCode);

  @override
  String toString() => 'PresignRequestDto[fileName=$fileName, contentType=$contentType]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fileName'] = this.fileName;
      json[r'contentType'] = this.contentType;
    return json;
  }

  /// Returns a new [PresignRequestDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PresignRequestDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PresignRequestDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PresignRequestDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PresignRequestDto(
        fileName: mapValueOfType<String>(json, r'fileName')!,
        contentType: mapValueOfType<String>(json, r'contentType')!,
      );
    }
    return null;
  }

  static List<PresignRequestDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PresignRequestDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PresignRequestDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PresignRequestDto> mapFromJson(dynamic json) {
    final map = <String, PresignRequestDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PresignRequestDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PresignRequestDto-objects as value to a dart map
  static Map<String, List<PresignRequestDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PresignRequestDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PresignRequestDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fileName',
    'contentType',
  };
}

