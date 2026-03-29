//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DoctorProfileResponseDto {
  /// Returns a new [DoctorProfileResponseDto] instance.
  DoctorProfileResponseDto({
    this.employeeId,
    this.title,
    this.medicalCredentials = const [],
    this.experienceYears,
    this.consultationFee,
    this.specializations = const [],
    this.education = const [],
  });

  /// Employee ID (primary key)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? employeeId;

  /// Doctor title
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? title;

  /// Medical credentials (titles + licenses)
  List<MedicalCredentialResponseDto> medicalCredentials;

  /// Years of experience
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? experienceYears;

  /// Consultation fee
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? consultationFee;

  /// List of specializations
  List<String> specializations;

  /// Education history
  List<String> education;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DoctorProfileResponseDto &&
    other.employeeId == employeeId &&
    other.title == title &&
    _deepEquality.equals(other.medicalCredentials, medicalCredentials) &&
    other.experienceYears == experienceYears &&
    other.consultationFee == consultationFee &&
    _deepEquality.equals(other.specializations, specializations) &&
    _deepEquality.equals(other.education, education);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (employeeId == null ? 0 : employeeId!.hashCode) +
    (title == null ? 0 : title!.hashCode) +
    (medicalCredentials.hashCode) +
    (experienceYears == null ? 0 : experienceYears!.hashCode) +
    (consultationFee == null ? 0 : consultationFee!.hashCode) +
    (specializations.hashCode) +
    (education.hashCode);

  @override
  String toString() => 'DoctorProfileResponseDto[employeeId=$employeeId, title=$title, medicalCredentials=$medicalCredentials, experienceYears=$experienceYears, consultationFee=$consultationFee, specializations=$specializations, education=$education]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.employeeId != null) {
      json[r'employeeId'] = this.employeeId;
    } else {
      json[r'employeeId'] = null;
    }
    if (this.title != null) {
      json[r'title'] = this.title;
    } else {
      json[r'title'] = null;
    }
      json[r'medicalCredentials'] = this.medicalCredentials;
    if (this.experienceYears != null) {
      json[r'experienceYears'] = this.experienceYears;
    } else {
      json[r'experienceYears'] = null;
    }
    if (this.consultationFee != null) {
      json[r'consultationFee'] = this.consultationFee;
    } else {
      json[r'consultationFee'] = null;
    }
      json[r'specializations'] = this.specializations;
      json[r'education'] = this.education;
    return json;
  }

  /// Returns a new [DoctorProfileResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DoctorProfileResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DoctorProfileResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DoctorProfileResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DoctorProfileResponseDto(
        employeeId: mapValueOfType<String>(json, r'employeeId'),
        title: mapValueOfType<String>(json, r'title'),
        medicalCredentials: MedicalCredentialResponseDto.listFromJson(json[r'medicalCredentials']),
        experienceYears: num.parse('${json[r'experienceYears']}'),
        consultationFee: num.parse('${json[r'consultationFee']}'),
        specializations: json[r'specializations'] is Iterable
            ? (json[r'specializations'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        education: json[r'education'] is Iterable
            ? (json[r'education'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<DoctorProfileResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DoctorProfileResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DoctorProfileResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DoctorProfileResponseDto> mapFromJson(dynamic json) {
    final map = <String, DoctorProfileResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DoctorProfileResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DoctorProfileResponseDto-objects as value to a dart map
  static Map<String, List<DoctorProfileResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DoctorProfileResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DoctorProfileResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

