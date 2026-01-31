//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerDocumentVerificationDto {
  /// Returns a new [PartnerDocumentVerificationDto] instance.
  PartnerDocumentVerificationDto({
    required this.fileType,
    required this.type,
    required this.documentKey,
    this.urls = const [],
  });

  /// File type of document
  String fileType;

  /// Type of document
  String type;

  /// Document key (R2/S3 path)
  String documentKey;

  /// Array of URLs to document files
  List<String> urls;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerDocumentVerificationDto &&
    other.fileType == fileType &&
    other.type == type &&
    other.documentKey == documentKey &&
    _deepEquality.equals(other.urls, urls);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fileType.hashCode) +
    (type.hashCode) +
    (documentKey.hashCode) +
    (urls.hashCode);

  @override
  String toString() => 'PartnerDocumentVerificationDto[fileType=$fileType, type=$type, documentKey=$documentKey, urls=$urls]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fileType'] = this.fileType;
      json[r'type'] = this.type;
      json[r'documentKey'] = this.documentKey;
      json[r'urls'] = this.urls;
    return json;
  }

  /// Returns a new [PartnerDocumentVerificationDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerDocumentVerificationDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerDocumentVerificationDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerDocumentVerificationDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerDocumentVerificationDto(
        fileType: mapValueOfType<String>(json, r'fileType')!,
        type: mapValueOfType<String>(json, r'type')!,
        documentKey: mapValueOfType<String>(json, r'documentKey')!,
        urls: json[r'urls'] is Iterable
            ? (json[r'urls'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<PartnerDocumentVerificationDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerDocumentVerificationDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerDocumentVerificationDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerDocumentVerificationDto> mapFromJson(dynamic json) {
    final map = <String, PartnerDocumentVerificationDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerDocumentVerificationDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerDocumentVerificationDto-objects as value to a dart map
  static Map<String, List<PartnerDocumentVerificationDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerDocumentVerificationDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerDocumentVerificationDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fileType',
    'type',
    'documentKey',
    'urls',
  };
}

