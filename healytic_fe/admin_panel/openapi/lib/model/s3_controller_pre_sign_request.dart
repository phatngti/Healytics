//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class S3ControllerPreSignRequest {
  /// Returns a new [S3ControllerPreSignRequest] instance.
  S3ControllerPreSignRequest({
    required this.fileName,
    required this.contentType,
  });

  String fileName;

  String contentType;

  @override
  bool operator ==(Object other) => identical(this, other) || other is S3ControllerPreSignRequest &&
    other.fileName == fileName &&
    other.contentType == contentType;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fileName.hashCode) +
    (contentType.hashCode);

  @override
  String toString() => 'S3ControllerPreSignRequest[fileName=$fileName, contentType=$contentType]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fileName'] = this.fileName;
      json[r'contentType'] = this.contentType;
    return json;
  }

  /// Returns a new [S3ControllerPreSignRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static S3ControllerPreSignRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "S3ControllerPreSignRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "S3ControllerPreSignRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return S3ControllerPreSignRequest(
        fileName: mapValueOfType<String>(json, r'fileName')!,
        contentType: mapValueOfType<String>(json, r'contentType')!,
      );
    }
    return null;
  }

  static List<S3ControllerPreSignRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <S3ControllerPreSignRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = S3ControllerPreSignRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, S3ControllerPreSignRequest> mapFromJson(dynamic json) {
    final map = <String, S3ControllerPreSignRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = S3ControllerPreSignRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of S3ControllerPreSignRequest-objects as value to a dart map
  static Map<String, List<S3ControllerPreSignRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<S3ControllerPreSignRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = S3ControllerPreSignRequest.listFromJson(entry.value, growable: growable,);
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

