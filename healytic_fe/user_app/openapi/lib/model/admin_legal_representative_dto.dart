//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminLegalRepresentativeDto {
  /// Returns a new [AdminLegalRepresentativeDto] instance.
  AdminLegalRepresentativeDto({
    required this.fullName,
    required this.position,
    required this.idType,
    required this.idNumber,
    required this.id,
    required this.idIssueDate,
    required this.idFrontImgUrl,
    required this.idBackImgUrl,
    required this.authorizationLetterUrl,
    required this.phoneNumber,
  });

  String fullName;

  String position;

  String idType;

  String idNumber;

  String id;

  DateTime idIssueDate;

  Object? idFrontImgUrl;

  Object? idBackImgUrl;

  Object? authorizationLetterUrl;

  Object? phoneNumber;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminLegalRepresentativeDto &&
    other.fullName == fullName &&
    other.position == position &&
    other.idType == idType &&
    other.idNumber == idNumber &&
    other.id == id &&
    other.idIssueDate == idIssueDate &&
    other.idFrontImgUrl == idFrontImgUrl &&
    other.idBackImgUrl == idBackImgUrl &&
    other.authorizationLetterUrl == authorizationLetterUrl &&
    other.phoneNumber == phoneNumber;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fullName.hashCode) +
    (position.hashCode) +
    (idType.hashCode) +
    (idNumber.hashCode) +
    (id.hashCode) +
    (idIssueDate.hashCode) +
    (idFrontImgUrl == null ? 0 : idFrontImgUrl!.hashCode) +
    (idBackImgUrl == null ? 0 : idBackImgUrl!.hashCode) +
    (authorizationLetterUrl == null ? 0 : authorizationLetterUrl!.hashCode) +
    (phoneNumber == null ? 0 : phoneNumber!.hashCode);

  @override
  String toString() => 'AdminLegalRepresentativeDto[fullName=$fullName, position=$position, idType=$idType, idNumber=$idNumber, id=$id, idIssueDate=$idIssueDate, idFrontImgUrl=$idFrontImgUrl, idBackImgUrl=$idBackImgUrl, authorizationLetterUrl=$authorizationLetterUrl, phoneNumber=$phoneNumber]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fullName'] = this.fullName;
      json[r'position'] = this.position;
      json[r'idType'] = this.idType;
      json[r'idNumber'] = this.idNumber;
      json[r'id'] = this.id;
      json[r'idIssueDate'] = this.idIssueDate.toUtc().toIso8601String();
    if (this.idFrontImgUrl != null) {
      json[r'idFrontImgUrl'] = this.idFrontImgUrl;
    } else {
      json[r'idFrontImgUrl'] = null;
    }
    if (this.idBackImgUrl != null) {
      json[r'idBackImgUrl'] = this.idBackImgUrl;
    } else {
      json[r'idBackImgUrl'] = null;
    }
    if (this.authorizationLetterUrl != null) {
      json[r'authorizationLetterUrl'] = this.authorizationLetterUrl;
    } else {
      json[r'authorizationLetterUrl'] = null;
    }
    if (this.phoneNumber != null) {
      json[r'phoneNumber'] = this.phoneNumber;
    } else {
      json[r'phoneNumber'] = null;
    }
    return json;
  }

  /// Returns a new [AdminLegalRepresentativeDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminLegalRepresentativeDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminLegalRepresentativeDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminLegalRepresentativeDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminLegalRepresentativeDto(
        fullName: mapValueOfType<String>(json, r'fullName')!,
        position: mapValueOfType<String>(json, r'position')!,
        idType: mapValueOfType<String>(json, r'idType')!,
        idNumber: mapValueOfType<String>(json, r'idNumber')!,
        id: mapValueOfType<String>(json, r'id')!,
        idIssueDate: mapDateTime(json, r'idIssueDate', r'')!,
        idFrontImgUrl: mapValueOfType<Object>(json, r'idFrontImgUrl'),
        idBackImgUrl: mapValueOfType<Object>(json, r'idBackImgUrl'),
        authorizationLetterUrl: mapValueOfType<Object>(json, r'authorizationLetterUrl'),
        phoneNumber: mapValueOfType<Object>(json, r'phoneNumber'),
      );
    }
    return null;
  }

  static List<AdminLegalRepresentativeDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminLegalRepresentativeDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminLegalRepresentativeDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminLegalRepresentativeDto> mapFromJson(dynamic json) {
    final map = <String, AdminLegalRepresentativeDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminLegalRepresentativeDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminLegalRepresentativeDto-objects as value to a dart map
  static Map<String, List<AdminLegalRepresentativeDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminLegalRepresentativeDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminLegalRepresentativeDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fullName',
    'position',
    'idType',
    'idNumber',
    'id',
    'idIssueDate',
    'idFrontImgUrl',
    'idBackImgUrl',
    'authorizationLetterUrl',
    'phoneNumber',
  };
}

