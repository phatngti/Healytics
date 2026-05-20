//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminPartnerDetailResponseDto {
  /// Returns a new [AdminPartnerDetailResponseDto] instance.
  AdminPartnerDetailResponseDto({
    required this.id,
    required this.businessInfo,
    this.legalRepresentative,
    this.kycDocuments = const [],
    required this.status,
    required this.priority,
    required this.submittedAt,
    this.reviewNote,
  });


  String id;

  BusinessInfoDto businessInfo;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  LegalRepresentativeDto? legalRepresentative;

  List<VerifiedField> kycDocuments;

  PartnerVerificationStatus status;

  PartnerPriority priority;

  DateTime submittedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? reviewNote;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminPartnerDetailResponseDto &&
    other.id == id &&
    other.businessInfo == businessInfo &&
    other.legalRepresentative == legalRepresentative &&
    _deepEquality.equals(other.kycDocuments, kycDocuments) &&
    other.status == status &&
    other.priority == priority &&
    other.submittedAt == submittedAt &&
    other.reviewNote == reviewNote;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (businessInfo.hashCode) +
    (legalRepresentative == null ? 0 : legalRepresentative!.hashCode) +
    (kycDocuments.hashCode) +
    (status.hashCode) +
    (priority.hashCode) +
    (submittedAt.hashCode) +
    (reviewNote == null ? 0 : reviewNote!.hashCode);

  @override
  String toString() => 'AdminPartnerDetailResponseDto[id=$id, businessInfo=$businessInfo, legalRepresentative=$legalRepresentative, kycDocuments=$kycDocuments, status=$status, priority=$priority, submittedAt=$submittedAt, reviewNote=$reviewNote]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'businessInfo'] = this.businessInfo;
    if (this.legalRepresentative != null) {
      json[r'legalRepresentative'] = this.legalRepresentative;
    } else {
      json[r'legalRepresentative'] = null;
    }
      json[r'kycDocuments'] = this.kycDocuments;
      json[r'status'] = this.status;
      json[r'priority'] = this.priority;
      json[r'submittedAt'] = this.submittedAt.toUtc().toIso8601String();
    if (this.reviewNote != null) {
      json[r'reviewNote'] = this.reviewNote;
    } else {
      json[r'reviewNote'] = null;
    }
    return json;
  }

  /// Returns a new [AdminPartnerDetailResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminPartnerDetailResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminPartnerDetailResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminPartnerDetailResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminPartnerDetailResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        businessInfo: BusinessInfoDto.fromJson(json[r'businessInfo'])!,
        legalRepresentative: LegalRepresentativeDto.fromJson(json[r'legalRepresentative']),
        kycDocuments: VerifiedField.listFromJson(json[r'kycDocuments']),
        status: PartnerVerificationStatus.fromJson(json[r'status'])!,
        priority: PartnerPriority.fromJson(json[r'priority'])!,
        submittedAt: mapDateTime(json, r'submittedAt', r'')!,
        reviewNote: mapValueOfType<String>(json, r'reviewNote'),
      );
    }
    return null;
  }

  static List<AdminPartnerDetailResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPartnerDetailResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPartnerDetailResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminPartnerDetailResponseDto> mapFromJson(dynamic json) {
    final map = <String, AdminPartnerDetailResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminPartnerDetailResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminPartnerDetailResponseDto-objects as value to a dart map
  static Map<String, List<AdminPartnerDetailResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminPartnerDetailResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminPartnerDetailResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'businessInfo',
    'kycDocuments',
    'status',
    'priority',
    'submittedAt',
  };
}

