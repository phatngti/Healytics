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
    this.businessLicenseUrl,
    this.authorizationLetterUrl,
    this.taxCertificateUrl,
    this.otherDocumentUrls = const [],
  });

  /// URL to business license document
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? businessLicenseUrl;

  /// URL to authorization letter document
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? authorizationLetterUrl;

  /// URL to tax certificate document
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? taxCertificateUrl;

  /// Array of URLs to other supporting documents
  List<String> otherDocumentUrls;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerDocumentVerificationDto &&
    other.businessLicenseUrl == businessLicenseUrl &&
    other.authorizationLetterUrl == authorizationLetterUrl &&
    other.taxCertificateUrl == taxCertificateUrl &&
    _deepEquality.equals(other.otherDocumentUrls, otherDocumentUrls);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (businessLicenseUrl == null ? 0 : businessLicenseUrl!.hashCode) +
    (authorizationLetterUrl == null ? 0 : authorizationLetterUrl!.hashCode) +
    (taxCertificateUrl == null ? 0 : taxCertificateUrl!.hashCode) +
    (otherDocumentUrls.hashCode);

  @override
  String toString() => 'PartnerDocumentVerificationDto[businessLicenseUrl=$businessLicenseUrl, authorizationLetterUrl=$authorizationLetterUrl, taxCertificateUrl=$taxCertificateUrl, otherDocumentUrls=$otherDocumentUrls]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.businessLicenseUrl != null) {
      json[r'businessLicenseUrl'] = this.businessLicenseUrl;
    } else {
      json[r'businessLicenseUrl'] = null;
    }
    if (this.authorizationLetterUrl != null) {
      json[r'authorizationLetterUrl'] = this.authorizationLetterUrl;
    } else {
      json[r'authorizationLetterUrl'] = null;
    }
    if (this.taxCertificateUrl != null) {
      json[r'taxCertificateUrl'] = this.taxCertificateUrl;
    } else {
      json[r'taxCertificateUrl'] = null;
    }
      json[r'otherDocumentUrls'] = this.otherDocumentUrls;
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
        businessLicenseUrl: mapValueOfType<String>(json, r'businessLicenseUrl'),
        authorizationLetterUrl: mapValueOfType<String>(json, r'authorizationLetterUrl'),
        taxCertificateUrl: mapValueOfType<String>(json, r'taxCertificateUrl'),
        otherDocumentUrls: json[r'otherDocumentUrls'] is Iterable
            ? (json[r'otherDocumentUrls'] as Iterable).cast<String>().toList(growable: false)
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
  };
}

