//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminPartnerItemDto {
  /// Returns a new [AdminPartnerItemDto] instance.
  AdminPartnerItemDto({
    required this.id,
    required this.taxCode,
    required this.legalName,
    required this.brandName,
    required this.email,
    this.businessType = const [],
    required this.verificationStatus,
    required this.priority,
    required this.createdAt,
    this.verificationCompletedAt,
    required this.isAccountActive,
  });


  String id;

  String taxCode;

  String legalName;

  String brandName;

  String email;

  List<BusinessType> businessType;

  PartnerVerificationStatus verificationStatus;

  PartnerPriority priority;

  DateTime createdAt;

  Object? verificationCompletedAt;

  /// Whether the linked account is active
  bool isAccountActive;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminPartnerItemDto &&
    other.id == id &&
    other.taxCode == taxCode &&
    other.legalName == legalName &&
    other.brandName == brandName &&
    other.email == email &&
    _deepEquality.equals(other.businessType, businessType) &&
    other.verificationStatus == verificationStatus &&
    other.priority == priority &&
    other.createdAt == createdAt &&
    other.verificationCompletedAt == verificationCompletedAt &&
    other.isAccountActive == isAccountActive;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (taxCode.hashCode) +
    (legalName.hashCode) +
    (brandName.hashCode) +
    (email.hashCode) +
    (businessType.hashCode) +
    (verificationStatus.hashCode) +
    (priority.hashCode) +
    (createdAt.hashCode) +
    (verificationCompletedAt == null ? 0 : verificationCompletedAt!.hashCode) +
    (isAccountActive.hashCode);

  @override
  String toString() => 'AdminPartnerItemDto[id=$id, taxCode=$taxCode, legalName=$legalName, brandName=$brandName, email=$email, businessType=$businessType, verificationStatus=$verificationStatus, priority=$priority, createdAt=$createdAt, verificationCompletedAt=$verificationCompletedAt, isAccountActive=$isAccountActive]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'taxCode'] = this.taxCode;
      json[r'legalName'] = this.legalName;
      json[r'brandName'] = this.brandName;
      json[r'email'] = this.email;
      json[r'businessType'] = this.businessType;
      json[r'verificationStatus'] = this.verificationStatus;
      json[r'priority'] = this.priority;
      json[r'createdAt'] = this.createdAt.toUtc().toIso8601String();
    if (this.verificationCompletedAt != null) {
      json[r'verificationCompletedAt'] = this.verificationCompletedAt;
    } else {
      json[r'verificationCompletedAt'] = null;
    }
      json[r'isAccountActive'] = this.isAccountActive;
    return json;
  }

  /// Returns a new [AdminPartnerItemDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminPartnerItemDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminPartnerItemDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminPartnerItemDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminPartnerItemDto(
        id: mapValueOfType<String>(json, r'id')!,
        taxCode: mapValueOfType<String>(json, r'taxCode')!,
        legalName: mapValueOfType<String>(json, r'legalName')!,
        brandName: mapValueOfType<String>(json, r'brandName')!,
        email: mapValueOfType<String>(json, r'email')!,
        businessType: BusinessType.listFromJson(json[r'businessType']),
        verificationStatus: PartnerVerificationStatus.fromJson(json[r'verificationStatus'])!,
        priority: PartnerPriority.fromJson(json[r'priority'])!,
        createdAt: mapDateTime(json, r'createdAt', r'')!,
        verificationCompletedAt: mapValueOfType<Object>(json, r'verificationCompletedAt'),
        isAccountActive: mapValueOfType<bool>(json, r'isAccountActive')!,
      );
    }
    return null;
  }

  static List<AdminPartnerItemDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPartnerItemDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPartnerItemDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminPartnerItemDto> mapFromJson(dynamic json) {
    final map = <String, AdminPartnerItemDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminPartnerItemDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminPartnerItemDto-objects as value to a dart map
  static Map<String, List<AdminPartnerItemDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminPartnerItemDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminPartnerItemDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'taxCode',
    'legalName',
    'brandName',
    'email',
    'businessType',
    'verificationStatus',
    'priority',
    'createdAt',
    'isAccountActive',
  };
}

