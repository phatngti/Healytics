//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DocumentEntryDto {
  /// Returns a new [DocumentEntryDto] instance.
  DocumentEntryDto({
    required this.name,
    required this.url,
    this.updatedTime,
  });


  /// Display name of the document
  String name;

  /// URL of the uploaded document
  String url;

  /// ISO timestamp of the last update
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? updatedTime;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DocumentEntryDto &&
    other.name == name &&
    other.url == url &&
    other.updatedTime == updatedTime;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (url.hashCode) +
    (updatedTime == null ? 0 : updatedTime!.hashCode);

  @override
  String toString() => 'DocumentEntryDto[name=$name, url=$url, updatedTime=$updatedTime]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'url'] = this.url;
    if (this.updatedTime != null) {
      json[r'updatedTime'] = this.updatedTime;
    } else {
      json[r'updatedTime'] = null;
    }
    return json;
  }

  /// Returns a new [DocumentEntryDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DocumentEntryDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DocumentEntryDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DocumentEntryDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DocumentEntryDto(
        name: mapValueOfType<String>(json, r'name')!,
        url: mapValueOfType<String>(json, r'url')!,
        updatedTime: mapValueOfType<String>(json, r'updatedTime'),
      );
    }
    return null;
  }

  static List<DocumentEntryDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DocumentEntryDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DocumentEntryDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DocumentEntryDto> mapFromJson(dynamic json) {
    final map = <String, DocumentEntryDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DocumentEntryDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DocumentEntryDto-objects as value to a dart map
  static Map<String, List<DocumentEntryDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DocumentEntryDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DocumentEntryDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'url',
  };
}

