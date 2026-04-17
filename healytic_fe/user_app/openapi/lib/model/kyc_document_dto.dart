//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class KycDocumentDto {
  /// Returns a new [KycDocumentDto] instance.
  KycDocumentDto({
    this.fileUrl,
    this.fileType,
  });


  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? fileUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? fileType;

  @override
  bool operator ==(Object other) => identical(this, other) || other is KycDocumentDto &&
    other.fileUrl == fileUrl &&
    other.fileType == fileType;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fileUrl == null ? 0 : fileUrl!.hashCode) +
    (fileType == null ? 0 : fileType!.hashCode);

  @override
  String toString() => 'KycDocumentDto[fileUrl=$fileUrl, fileType=$fileType]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.fileUrl != null) {
      json[r'fileUrl'] = this.fileUrl;
    } else {
      json[r'fileUrl'] = null;
    }
    if (this.fileType != null) {
      json[r'fileType'] = this.fileType;
    } else {
      json[r'fileType'] = null;
    }
    return json;
  }

  /// Returns a new [KycDocumentDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static KycDocumentDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "KycDocumentDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "KycDocumentDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return KycDocumentDto(
        fileUrl: mapValueOfType<Object>(json, r'fileUrl'),
        fileType: mapValueOfType<Object>(json, r'fileType'),
      );
    }
    return null;
  }

  static List<KycDocumentDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <KycDocumentDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = KycDocumentDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, KycDocumentDto> mapFromJson(dynamic json) {
    final map = <String, KycDocumentDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = KycDocumentDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of KycDocumentDto-objects as value to a dart map
  static Map<String, List<KycDocumentDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<KycDocumentDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = KycDocumentDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

