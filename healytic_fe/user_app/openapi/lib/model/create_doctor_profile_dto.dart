//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateDoctorProfileDto {
  /// Returns a new [CreateDoctorProfileDto] instance.
  CreateDoctorProfileDto({
    this.title,
    required this.medicalLicense,
    this.experienceYears,
    this.consultationFee,
    this.specializations = const [],
    this.education = const [],
    this.certifications = const [],
  });

  /// Title of the doctor
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? title;

  /// Medical license number
  String medicalLicense;

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

  /// Specializations
  List<String> specializations;

  /// Education history
  List<String> education;

  /// Certifications
  List<String> certifications;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateDoctorProfileDto &&
    other.title == title &&
    other.medicalLicense == medicalLicense &&
    other.experienceYears == experienceYears &&
    other.consultationFee == consultationFee &&
    _deepEquality.equals(other.specializations, specializations) &&
    _deepEquality.equals(other.education, education) &&
    _deepEquality.equals(other.certifications, certifications);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (title == null ? 0 : title!.hashCode) +
    (medicalLicense.hashCode) +
    (experienceYears == null ? 0 : experienceYears!.hashCode) +
    (consultationFee == null ? 0 : consultationFee!.hashCode) +
    (specializations.hashCode) +
    (education.hashCode) +
    (certifications.hashCode);

  @override
  String toString() => 'CreateDoctorProfileDto[title=$title, medicalLicense=$medicalLicense, experienceYears=$experienceYears, consultationFee=$consultationFee, specializations=$specializations, education=$education, certifications=$certifications]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.title != null) {
      json[r'title'] = this.title;
    } else {
      json[r'title'] = null;
    }
      json[r'medicalLicense'] = this.medicalLicense;
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
      json[r'certifications'] = this.certifications;
    return json;
  }

  /// Returns a new [CreateDoctorProfileDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateDoctorProfileDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateDoctorProfileDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateDoctorProfileDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateDoctorProfileDto(
        title: mapValueOfType<String>(json, r'title'),
        medicalLicense: mapValueOfType<String>(json, r'medicalLicense')!,
        experienceYears: num.parse('${json[r'experienceYears']}'),
        consultationFee: num.parse('${json[r'consultationFee']}'),
        specializations: json[r'specializations'] is Iterable
            ? (json[r'specializations'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        education: json[r'education'] is Iterable
            ? (json[r'education'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        certifications: json[r'certifications'] is Iterable
            ? (json[r'certifications'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<CreateDoctorProfileDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateDoctorProfileDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateDoctorProfileDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateDoctorProfileDto> mapFromJson(dynamic json) {
    final map = <String, CreateDoctorProfileDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateDoctorProfileDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateDoctorProfileDto-objects as value to a dart map
  static Map<String, List<CreateDoctorProfileDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateDoctorProfileDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateDoctorProfileDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'medicalLicense',
  };
}

