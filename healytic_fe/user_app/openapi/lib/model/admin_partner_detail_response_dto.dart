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

  AdminPartnerDetailResponseDtoStatusEnum status;

  AdminPartnerDetailResponseDtoPriorityEnum priority;

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
        status: AdminPartnerDetailResponseDtoStatusEnum.fromJson(json[r'status'])!,
        priority: AdminPartnerDetailResponseDtoPriorityEnum.fromJson(json[r'priority'])!,
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


class AdminPartnerDetailResponseDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const AdminPartnerDetailResponseDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const PENDING = AdminPartnerDetailResponseDtoStatusEnum._(r'PENDING');
  static const APPROVED = AdminPartnerDetailResponseDtoStatusEnum._(r'APPROVED');
  static const REJECTED = AdminPartnerDetailResponseDtoStatusEnum._(r'REJECTED');
  static const REQUIRED_RESUBMIT = AdminPartnerDetailResponseDtoStatusEnum._(r'REQUIRED_RESUBMIT');

  /// List of all possible values in this [enum][AdminPartnerDetailResponseDtoStatusEnum].
  static const values = <AdminPartnerDetailResponseDtoStatusEnum>[
    PENDING,
    APPROVED,
    REJECTED,
    REQUIRED_RESUBMIT,
  ];

  static AdminPartnerDetailResponseDtoStatusEnum? fromJson(dynamic value) => AdminPartnerDetailResponseDtoStatusEnumTypeTransformer().decode(value);

  static List<AdminPartnerDetailResponseDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPartnerDetailResponseDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPartnerDetailResponseDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPartnerDetailResponseDtoStatusEnum] to String,
/// and [decode] dynamic data back to [AdminPartnerDetailResponseDtoStatusEnum].
class AdminPartnerDetailResponseDtoStatusEnumTypeTransformer {
  factory AdminPartnerDetailResponseDtoStatusEnumTypeTransformer() => _instance ??= const AdminPartnerDetailResponseDtoStatusEnumTypeTransformer._();

  const AdminPartnerDetailResponseDtoStatusEnumTypeTransformer._();

  String encode(AdminPartnerDetailResponseDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminPartnerDetailResponseDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPartnerDetailResponseDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'PENDING': return AdminPartnerDetailResponseDtoStatusEnum.PENDING;
        case r'APPROVED': return AdminPartnerDetailResponseDtoStatusEnum.APPROVED;
        case r'REJECTED': return AdminPartnerDetailResponseDtoStatusEnum.REJECTED;
        case r'REQUIRED_RESUBMIT': return AdminPartnerDetailResponseDtoStatusEnum.REQUIRED_RESUBMIT;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminPartnerDetailResponseDtoStatusEnumTypeTransformer] instance.
  static AdminPartnerDetailResponseDtoStatusEnumTypeTransformer? _instance;
}



class AdminPartnerDetailResponseDtoPriorityEnum {
  /// Instantiate a new enum with the provided [value].
  const AdminPartnerDetailResponseDtoPriorityEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const low = AdminPartnerDetailResponseDtoPriorityEnum._(r'low');
  static const normal = AdminPartnerDetailResponseDtoPriorityEnum._(r'normal');
  static const high = AdminPartnerDetailResponseDtoPriorityEnum._(r'high');
  static const urgent = AdminPartnerDetailResponseDtoPriorityEnum._(r'urgent');

  /// List of all possible values in this [enum][AdminPartnerDetailResponseDtoPriorityEnum].
  static const values = <AdminPartnerDetailResponseDtoPriorityEnum>[
    low,
    normal,
    high,
    urgent,
  ];

  static AdminPartnerDetailResponseDtoPriorityEnum? fromJson(dynamic value) => AdminPartnerDetailResponseDtoPriorityEnumTypeTransformer().decode(value);

  static List<AdminPartnerDetailResponseDtoPriorityEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPartnerDetailResponseDtoPriorityEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPartnerDetailResponseDtoPriorityEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPartnerDetailResponseDtoPriorityEnum] to String,
/// and [decode] dynamic data back to [AdminPartnerDetailResponseDtoPriorityEnum].
class AdminPartnerDetailResponseDtoPriorityEnumTypeTransformer {
  factory AdminPartnerDetailResponseDtoPriorityEnumTypeTransformer() => _instance ??= const AdminPartnerDetailResponseDtoPriorityEnumTypeTransformer._();

  const AdminPartnerDetailResponseDtoPriorityEnumTypeTransformer._();

  String encode(AdminPartnerDetailResponseDtoPriorityEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminPartnerDetailResponseDtoPriorityEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPartnerDetailResponseDtoPriorityEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'low': return AdminPartnerDetailResponseDtoPriorityEnum.low;
        case r'normal': return AdminPartnerDetailResponseDtoPriorityEnum.normal;
        case r'high': return AdminPartnerDetailResponseDtoPriorityEnum.high;
        case r'urgent': return AdminPartnerDetailResponseDtoPriorityEnum.urgent;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminPartnerDetailResponseDtoPriorityEnumTypeTransformer] instance.
  static AdminPartnerDetailResponseDtoPriorityEnumTypeTransformer? _instance;
}


