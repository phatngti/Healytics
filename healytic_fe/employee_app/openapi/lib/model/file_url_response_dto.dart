//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FileUrlResponseDto {
  /// Returns a new [FileUrlResponseDto] instance.
  FileUrlResponseDto({
    required this.url,
  });


  /// Public or signed URL for the file
  String url;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FileUrlResponseDto &&
    other.url == url;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (url.hashCode);

  @override
  String toString() => 'FileUrlResponseDto[url=$url]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'url'] = this.url;
    return json;
  }

  /// Returns a new [FileUrlResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FileUrlResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "FileUrlResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "FileUrlResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FileUrlResponseDto(
        url: mapValueOfType<String>(json, r'url')!,
      );
    }
    return null;
  }

  static List<FileUrlResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FileUrlResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FileUrlResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FileUrlResponseDto> mapFromJson(dynamic json) {
    final map = <String, FileUrlResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FileUrlResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FileUrlResponseDto-objects as value to a dart map
  static Map<String, List<FileUrlResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FileUrlResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FileUrlResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'url',
  };
}

