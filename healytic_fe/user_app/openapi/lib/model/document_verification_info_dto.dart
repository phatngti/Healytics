//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DocumentVerificationInfoDto {
  /// Returns a new [DocumentVerificationInfoDto] instance.
  DocumentVerificationInfoDto({
    this.businessLicense,
    this.authorizationLetter,
    this.taxCertificate,
  });

  VerificationDocumentDto? businessLicense;

  VerificationDocumentDto? authorizationLetter;

  VerificationDocumentDto? taxCertificate;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DocumentVerificationInfoDto &&
    other.businessLicense == businessLicense &&
    other.authorizationLetter == authorizationLetter &&
    other.taxCertificate == taxCertificate;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (businessLicense == null ? 0 : businessLicense!.hashCode) +
    (authorizationLetter == null ? 0 : authorizationLetter!.hashCode) +
    (taxCertificate == null ? 0 : taxCertificate!.hashCode);

  @override
  String toString() => 'DocumentVerificationInfoDto[businessLicense=$businessLicense, authorizationLetter=$authorizationLetter, taxCertificate=$taxCertificate]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.businessLicense != null) {
      json[r'businessLicense'] = this.businessLicense;
    } else {
      json[r'businessLicense'] = null;
    }
    if (this.authorizationLetter != null) {
      json[r'authorizationLetter'] = this.authorizationLetter;
    } else {
      json[r'authorizationLetter'] = null;
    }
    if (this.taxCertificate != null) {
      json[r'taxCertificate'] = this.taxCertificate;
    } else {
      json[r'taxCertificate'] = null;
    }
    return json;
  }

  /// Returns a new [DocumentVerificationInfoDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DocumentVerificationInfoDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DocumentVerificationInfoDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DocumentVerificationInfoDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DocumentVerificationInfoDto(
        businessLicense: VerificationDocumentDto.fromJson(json[r'businessLicense']),
        authorizationLetter: VerificationDocumentDto.fromJson(json[r'authorizationLetter']),
        taxCertificate: VerificationDocumentDto.fromJson(json[r'taxCertificate']),
      );
    }
    return null;
  }

  static List<DocumentVerificationInfoDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DocumentVerificationInfoDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DocumentVerificationInfoDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DocumentVerificationInfoDto> mapFromJson(dynamic json) {
    final map = <String, DocumentVerificationInfoDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DocumentVerificationInfoDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DocumentVerificationInfoDto-objects as value to a dart map
  static Map<String, List<DocumentVerificationInfoDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DocumentVerificationInfoDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DocumentVerificationInfoDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

