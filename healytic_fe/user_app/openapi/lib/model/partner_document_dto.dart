//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerDocumentDto {
  /// Returns a new [PartnerDocumentDto] instance.
  PartnerDocumentDto({
    required this.id,
    required this.documentType,
    required this.documentUrl,
    required this.documentKey,
    required this.status,
    required this.isRequired,
    required this.description,
    required this.isReviewed,
    required this.isValid,
    required this.adminFeedback,
    required this.verificationNotes,
    required this.uploadedAt,
  });

  Object? id;

  PartnerDocumentDtoDocumentTypeEnum documentType;

  Object? documentUrl;

  Object? documentKey;

  PartnerDocumentDtoStatusEnum status;

  bool isRequired;

  Object? description;

  bool isReviewed;

  bool isValid;

  Object? adminFeedback;

  Object? verificationNotes;

  Object? uploadedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerDocumentDto &&
    other.id == id &&
    other.documentType == documentType &&
    other.documentUrl == documentUrl &&
    other.documentKey == documentKey &&
    other.status == status &&
    other.isRequired == isRequired &&
    other.description == description &&
    other.isReviewed == isReviewed &&
    other.isValid == isValid &&
    other.adminFeedback == adminFeedback &&
    other.verificationNotes == verificationNotes &&
    other.uploadedAt == uploadedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (documentType.hashCode) +
    (documentUrl == null ? 0 : documentUrl!.hashCode) +
    (documentKey == null ? 0 : documentKey!.hashCode) +
    (status.hashCode) +
    (isRequired.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (isReviewed.hashCode) +
    (isValid.hashCode) +
    (adminFeedback == null ? 0 : adminFeedback!.hashCode) +
    (verificationNotes == null ? 0 : verificationNotes!.hashCode) +
    (uploadedAt == null ? 0 : uploadedAt!.hashCode);

  @override
  String toString() => 'PartnerDocumentDto[id=$id, documentType=$documentType, documentUrl=$documentUrl, documentKey=$documentKey, status=$status, isRequired=$isRequired, description=$description, isReviewed=$isReviewed, isValid=$isValid, adminFeedback=$adminFeedback, verificationNotes=$verificationNotes, uploadedAt=$uploadedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
      json[r'documentType'] = this.documentType;
    if (this.documentUrl != null) {
      json[r'documentUrl'] = this.documentUrl;
    } else {
      json[r'documentUrl'] = null;
    }
    if (this.documentKey != null) {
      json[r'documentKey'] = this.documentKey;
    } else {
      json[r'documentKey'] = null;
    }
      json[r'status'] = this.status;
      json[r'isRequired'] = this.isRequired;
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'isReviewed'] = this.isReviewed;
      json[r'isValid'] = this.isValid;
    if (this.adminFeedback != null) {
      json[r'adminFeedback'] = this.adminFeedback;
    } else {
      json[r'adminFeedback'] = null;
    }
    if (this.verificationNotes != null) {
      json[r'verificationNotes'] = this.verificationNotes;
    } else {
      json[r'verificationNotes'] = null;
    }
    if (this.uploadedAt != null) {
      json[r'uploadedAt'] = this.uploadedAt;
    } else {
      json[r'uploadedAt'] = null;
    }
    return json;
  }

  /// Returns a new [PartnerDocumentDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerDocumentDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerDocumentDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerDocumentDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerDocumentDto(
        id: mapValueOfType<Object>(json, r'id'),
        documentType: PartnerDocumentDtoDocumentTypeEnum.fromJson(json[r'documentType'])!,
        documentUrl: mapValueOfType<Object>(json, r'documentUrl'),
        documentKey: mapValueOfType<Object>(json, r'documentKey'),
        status: PartnerDocumentDtoStatusEnum.fromJson(json[r'status'])!,
        isRequired: mapValueOfType<bool>(json, r'isRequired')!,
        description: mapValueOfType<Object>(json, r'description'),
        isReviewed: mapValueOfType<bool>(json, r'isReviewed')!,
        isValid: mapValueOfType<bool>(json, r'isValid')!,
        adminFeedback: mapValueOfType<Object>(json, r'adminFeedback'),
        verificationNotes: mapValueOfType<Object>(json, r'verificationNotes'),
        uploadedAt: mapValueOfType<Object>(json, r'uploadedAt'),
      );
    }
    return null;
  }

  static List<PartnerDocumentDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerDocumentDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerDocumentDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerDocumentDto> mapFromJson(dynamic json) {
    final map = <String, PartnerDocumentDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerDocumentDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerDocumentDto-objects as value to a dart map
  static Map<String, List<PartnerDocumentDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerDocumentDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerDocumentDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'documentType',
    'documentUrl',
    'documentKey',
    'status',
    'isRequired',
    'description',
    'isReviewed',
    'isValid',
    'adminFeedback',
    'verificationNotes',
    'uploadedAt',
  };
}


class PartnerDocumentDtoDocumentTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const PartnerDocumentDtoDocumentTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const BUSINESS_LICENSE = PartnerDocumentDtoDocumentTypeEnum._(r'BUSINESS_LICENSE');
  static const IDENTITY_FRONT = PartnerDocumentDtoDocumentTypeEnum._(r'IDENTITY_FRONT');
  static const IDENTITY_BACK = PartnerDocumentDtoDocumentTypeEnum._(r'IDENTITY_BACK');
  static const AUTHORIZATION_LETTER = PartnerDocumentDtoDocumentTypeEnum._(r'AUTHORIZATION_LETTER');
  static const ANTT = PartnerDocumentDtoDocumentTypeEnum._(r'ANTT');
  static const KCB_LICENSE = PartnerDocumentDtoDocumentTypeEnum._(r'KCB_LICENSE');
  static const GCN_FITNESS = PartnerDocumentDtoDocumentTypeEnum._(r'GCN_FITNESS');
  static const GPP = PartnerDocumentDtoDocumentTypeEnum._(r'GPP');
  static const RHM_LICENSE = PartnerDocumentDtoDocumentTypeEnum._(r'RHM_LICENSE');
  static const MEDICAL_WASTE_CONTRACT = PartnerDocumentDtoDocumentTypeEnum._(r'MEDICAL_WASTE_CONTRACT');
  static const YHCT_LICENSE = PartnerDocumentDtoDocumentTypeEnum._(r'YHCT_LICENSE');
  static const PSYCHOLOGY_LICENSE = PartnerDocumentDtoDocumentTypeEnum._(r'PSYCHOLOGY_LICENSE');
  static const DERMATOLOGY_LICENSE = PartnerDocumentDtoDocumentTypeEnum._(r'DERMATOLOGY_LICENSE');
  static const TECHNICAL_PORTFOLIO = PartnerDocumentDtoDocumentTypeEnum._(r'TECHNICAL_PORTFOLIO');
  static const NUTRITION_LICENSE = PartnerDocumentDtoDocumentTypeEnum._(r'NUTRITION_LICENSE');
  static const PSYCHIATRY_LICENSE = PartnerDocumentDtoDocumentTypeEnum._(r'PSYCHIATRY_LICENSE');

  /// List of all possible values in this [enum][PartnerDocumentDtoDocumentTypeEnum].
  static const values = <PartnerDocumentDtoDocumentTypeEnum>[
    BUSINESS_LICENSE,
    IDENTITY_FRONT,
    IDENTITY_BACK,
    AUTHORIZATION_LETTER,
    ANTT,
    KCB_LICENSE,
    GCN_FITNESS,
    GPP,
    RHM_LICENSE,
    MEDICAL_WASTE_CONTRACT,
    YHCT_LICENSE,
    PSYCHOLOGY_LICENSE,
    DERMATOLOGY_LICENSE,
    TECHNICAL_PORTFOLIO,
    NUTRITION_LICENSE,
    PSYCHIATRY_LICENSE,
  ];

  static PartnerDocumentDtoDocumentTypeEnum? fromJson(dynamic value) => PartnerDocumentDtoDocumentTypeEnumTypeTransformer().decode(value);

  static List<PartnerDocumentDtoDocumentTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerDocumentDtoDocumentTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerDocumentDtoDocumentTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PartnerDocumentDtoDocumentTypeEnum] to String,
/// and [decode] dynamic data back to [PartnerDocumentDtoDocumentTypeEnum].
class PartnerDocumentDtoDocumentTypeEnumTypeTransformer {
  factory PartnerDocumentDtoDocumentTypeEnumTypeTransformer() => _instance ??= const PartnerDocumentDtoDocumentTypeEnumTypeTransformer._();

  const PartnerDocumentDtoDocumentTypeEnumTypeTransformer._();

  String encode(PartnerDocumentDtoDocumentTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a PartnerDocumentDtoDocumentTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PartnerDocumentDtoDocumentTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'BUSINESS_LICENSE': return PartnerDocumentDtoDocumentTypeEnum.BUSINESS_LICENSE;
        case r'IDENTITY_FRONT': return PartnerDocumentDtoDocumentTypeEnum.IDENTITY_FRONT;
        case r'IDENTITY_BACK': return PartnerDocumentDtoDocumentTypeEnum.IDENTITY_BACK;
        case r'AUTHORIZATION_LETTER': return PartnerDocumentDtoDocumentTypeEnum.AUTHORIZATION_LETTER;
        case r'ANTT': return PartnerDocumentDtoDocumentTypeEnum.ANTT;
        case r'KCB_LICENSE': return PartnerDocumentDtoDocumentTypeEnum.KCB_LICENSE;
        case r'GCN_FITNESS': return PartnerDocumentDtoDocumentTypeEnum.GCN_FITNESS;
        case r'GPP': return PartnerDocumentDtoDocumentTypeEnum.GPP;
        case r'RHM_LICENSE': return PartnerDocumentDtoDocumentTypeEnum.RHM_LICENSE;
        case r'MEDICAL_WASTE_CONTRACT': return PartnerDocumentDtoDocumentTypeEnum.MEDICAL_WASTE_CONTRACT;
        case r'YHCT_LICENSE': return PartnerDocumentDtoDocumentTypeEnum.YHCT_LICENSE;
        case r'PSYCHOLOGY_LICENSE': return PartnerDocumentDtoDocumentTypeEnum.PSYCHOLOGY_LICENSE;
        case r'DERMATOLOGY_LICENSE': return PartnerDocumentDtoDocumentTypeEnum.DERMATOLOGY_LICENSE;
        case r'TECHNICAL_PORTFOLIO': return PartnerDocumentDtoDocumentTypeEnum.TECHNICAL_PORTFOLIO;
        case r'NUTRITION_LICENSE': return PartnerDocumentDtoDocumentTypeEnum.NUTRITION_LICENSE;
        case r'PSYCHIATRY_LICENSE': return PartnerDocumentDtoDocumentTypeEnum.PSYCHIATRY_LICENSE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PartnerDocumentDtoDocumentTypeEnumTypeTransformer] instance.
  static PartnerDocumentDtoDocumentTypeEnumTypeTransformer? _instance;
}



class PartnerDocumentDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const PartnerDocumentDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MISSING = PartnerDocumentDtoStatusEnum._(r'MISSING');
  static const PENDING = PartnerDocumentDtoStatusEnum._(r'PENDING');
  static const APPROVED = PartnerDocumentDtoStatusEnum._(r'APPROVED');
  static const REJECTED = PartnerDocumentDtoStatusEnum._(r'REJECTED');

  /// List of all possible values in this [enum][PartnerDocumentDtoStatusEnum].
  static const values = <PartnerDocumentDtoStatusEnum>[
    MISSING,
    PENDING,
    APPROVED,
    REJECTED,
  ];

  static PartnerDocumentDtoStatusEnum? fromJson(dynamic value) => PartnerDocumentDtoStatusEnumTypeTransformer().decode(value);

  static List<PartnerDocumentDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerDocumentDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerDocumentDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PartnerDocumentDtoStatusEnum] to String,
/// and [decode] dynamic data back to [PartnerDocumentDtoStatusEnum].
class PartnerDocumentDtoStatusEnumTypeTransformer {
  factory PartnerDocumentDtoStatusEnumTypeTransformer() => _instance ??= const PartnerDocumentDtoStatusEnumTypeTransformer._();

  const PartnerDocumentDtoStatusEnumTypeTransformer._();

  String encode(PartnerDocumentDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a PartnerDocumentDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PartnerDocumentDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MISSING': return PartnerDocumentDtoStatusEnum.MISSING;
        case r'PENDING': return PartnerDocumentDtoStatusEnum.PENDING;
        case r'APPROVED': return PartnerDocumentDtoStatusEnum.APPROVED;
        case r'REJECTED': return PartnerDocumentDtoStatusEnum.REJECTED;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PartnerDocumentDtoStatusEnumTypeTransformer] instance.
  static PartnerDocumentDtoStatusEnumTypeTransformer? _instance;
}


