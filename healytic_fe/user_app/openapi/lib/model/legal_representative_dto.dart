//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LegalRepresentativeDto {
  /// Returns a new [LegalRepresentativeDto] instance.
  LegalRepresentativeDto({
    required this.fullName,
    this.position,
    this.phoneNumber,
    this.idType,
    this.idNumber,
    this.idIssueDate,
  });

  VerifiedField fullName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  VerifiedField? position;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  VerifiedField? phoneNumber;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  VerifiedField? idType;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  VerifiedField? idNumber;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  VerifiedField? idIssueDate;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LegalRepresentativeDto &&
    other.fullName == fullName &&
    other.position == position &&
    other.phoneNumber == phoneNumber &&
    other.idType == idType &&
    other.idNumber == idNumber &&
    other.idIssueDate == idIssueDate;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fullName.hashCode) +
    (position == null ? 0 : position!.hashCode) +
    (phoneNumber == null ? 0 : phoneNumber!.hashCode) +
    (idType == null ? 0 : idType!.hashCode) +
    (idNumber == null ? 0 : idNumber!.hashCode) +
    (idIssueDate == null ? 0 : idIssueDate!.hashCode);

  @override
  String toString() => 'LegalRepresentativeDto[fullName=$fullName, position=$position, phoneNumber=$phoneNumber, idType=$idType, idNumber=$idNumber, idIssueDate=$idIssueDate]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fullName'] = this.fullName;
    if (this.position != null) {
      json[r'position'] = this.position;
    } else {
      json[r'position'] = null;
    }
    if (this.phoneNumber != null) {
      json[r'phoneNumber'] = this.phoneNumber;
    } else {
      json[r'phoneNumber'] = null;
    }
    if (this.idType != null) {
      json[r'idType'] = this.idType;
    } else {
      json[r'idType'] = null;
    }
    if (this.idNumber != null) {
      json[r'idNumber'] = this.idNumber;
    } else {
      json[r'idNumber'] = null;
    }
    if (this.idIssueDate != null) {
      json[r'idIssueDate'] = this.idIssueDate;
    } else {
      json[r'idIssueDate'] = null;
    }
    return json;
  }

  /// Returns a new [LegalRepresentativeDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LegalRepresentativeDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "LegalRepresentativeDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "LegalRepresentativeDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LegalRepresentativeDto(
        fullName: VerifiedField.fromJson(json[r'fullName'])!,
        position: VerifiedField.fromJson(json[r'position']),
        phoneNumber: VerifiedField.fromJson(json[r'phoneNumber']),
        idType: VerifiedField.fromJson(json[r'idType']),
        idNumber: VerifiedField.fromJson(json[r'idNumber']),
        idIssueDate: VerifiedField.fromJson(json[r'idIssueDate']),
      );
    }
    return null;
  }

  static List<LegalRepresentativeDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LegalRepresentativeDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LegalRepresentativeDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LegalRepresentativeDto> mapFromJson(dynamic json) {
    final map = <String, LegalRepresentativeDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LegalRepresentativeDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LegalRepresentativeDto-objects as value to a dart map
  static Map<String, List<LegalRepresentativeDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LegalRepresentativeDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LegalRepresentativeDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fullName',
  };
}

