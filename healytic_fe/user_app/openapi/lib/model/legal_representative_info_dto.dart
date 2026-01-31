//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LegalRepresentativeInfoDto {
  /// Returns a new [LegalRepresentativeInfoDto] instance.
  LegalRepresentativeInfoDto({
    required this.fullName,
    required this.position,
    required this.phoneNumber,
    required this.idType,
    required this.idNumber,
    required this.idIssueDate,
    required this.idFrontImage,
    required this.idBackImage,
    required this.documents,
  });

  VerificationStringFieldDto fullName;

  VerificationStringFieldDto position;

  VerificationOptionalStringFieldDto phoneNumber;

  VerificationStringFieldDto idType;

  VerificationStringFieldDto idNumber;

  VerificationStringFieldDto idIssueDate;

  VerificationDocumentDto idFrontImage;

  VerificationDocumentDto idBackImage;

  DocumentVerificationInfoDto documents;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LegalRepresentativeInfoDto &&
    other.fullName == fullName &&
    other.position == position &&
    other.phoneNumber == phoneNumber &&
    other.idType == idType &&
    other.idNumber == idNumber &&
    other.idIssueDate == idIssueDate &&
    other.idFrontImage == idFrontImage &&
    other.idBackImage == idBackImage &&
    other.documents == documents;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fullName.hashCode) +
    (position.hashCode) +
    (phoneNumber.hashCode) +
    (idType.hashCode) +
    (idNumber.hashCode) +
    (idIssueDate.hashCode) +
    (idFrontImage.hashCode) +
    (idBackImage.hashCode) +
    (documents.hashCode);

  @override
  String toString() => 'LegalRepresentativeInfoDto[fullName=$fullName, position=$position, phoneNumber=$phoneNumber, idType=$idType, idNumber=$idNumber, idIssueDate=$idIssueDate, idFrontImage=$idFrontImage, idBackImage=$idBackImage, documents=$documents]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fullName'] = this.fullName;
      json[r'position'] = this.position;
      json[r'phoneNumber'] = this.phoneNumber;
      json[r'idType'] = this.idType;
      json[r'idNumber'] = this.idNumber;
      json[r'idIssueDate'] = this.idIssueDate;
      json[r'idFrontImage'] = this.idFrontImage;
      json[r'idBackImage'] = this.idBackImage;
      json[r'documents'] = this.documents;
    return json;
  }

  /// Returns a new [LegalRepresentativeInfoDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LegalRepresentativeInfoDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "LegalRepresentativeInfoDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "LegalRepresentativeInfoDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LegalRepresentativeInfoDto(
        fullName: VerificationStringFieldDto.fromJson(json[r'fullName'])!,
        position: VerificationStringFieldDto.fromJson(json[r'position'])!,
        phoneNumber: VerificationOptionalStringFieldDto.fromJson(json[r'phoneNumber'])!,
        idType: VerificationStringFieldDto.fromJson(json[r'idType'])!,
        idNumber: VerificationStringFieldDto.fromJson(json[r'idNumber'])!,
        idIssueDate: VerificationStringFieldDto.fromJson(json[r'idIssueDate'])!,
        idFrontImage: VerificationDocumentDto.fromJson(json[r'idFrontImage'])!,
        idBackImage: VerificationDocumentDto.fromJson(json[r'idBackImage'])!,
        documents: DocumentVerificationInfoDto.fromJson(json[r'documents'])!,
      );
    }
    return null;
  }

  static List<LegalRepresentativeInfoDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LegalRepresentativeInfoDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LegalRepresentativeInfoDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LegalRepresentativeInfoDto> mapFromJson(dynamic json) {
    final map = <String, LegalRepresentativeInfoDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LegalRepresentativeInfoDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LegalRepresentativeInfoDto-objects as value to a dart map
  static Map<String, List<LegalRepresentativeInfoDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LegalRepresentativeInfoDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LegalRepresentativeInfoDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fullName',
    'position',
    'phoneNumber',
    'idType',
    'idNumber',
    'idIssueDate',
    'idFrontImage',
    'idBackImage',
    'documents',
  };
}

