//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DocumentUpdateDto {
  /// Returns a new [DocumentUpdateDto] instance.
  DocumentUpdateDto({
    this.documentType,
    this.documentUrl,
  });

  DocumentUpdateDtoDocumentTypeEnum? documentType;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? documentUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DocumentUpdateDto &&
    other.documentType == documentType &&
    other.documentUrl == documentUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (documentType == null ? 0 : documentType!.hashCode) +
    (documentUrl == null ? 0 : documentUrl!.hashCode);

  @override
  String toString() => 'DocumentUpdateDto[documentType=$documentType, documentUrl=$documentUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.documentType != null) {
      json[r'documentType'] = this.documentType;
    } else {
      json[r'documentType'] = null;
    }
    if (this.documentUrl != null) {
      json[r'documentUrl'] = this.documentUrl;
    } else {
      json[r'documentUrl'] = null;
    }
    return json;
  }

  /// Returns a new [DocumentUpdateDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DocumentUpdateDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DocumentUpdateDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DocumentUpdateDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DocumentUpdateDto(
        documentType: DocumentUpdateDtoDocumentTypeEnum.fromJson(json[r'documentType']),
        documentUrl: mapValueOfType<String>(json, r'documentUrl'),
      );
    }
    return null;
  }

  static List<DocumentUpdateDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DocumentUpdateDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DocumentUpdateDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DocumentUpdateDto> mapFromJson(dynamic json) {
    final map = <String, DocumentUpdateDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DocumentUpdateDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DocumentUpdateDto-objects as value to a dart map
  static Map<String, List<DocumentUpdateDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DocumentUpdateDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DocumentUpdateDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class DocumentUpdateDtoDocumentTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const DocumentUpdateDtoDocumentTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const BUSINESS_LICENSE = DocumentUpdateDtoDocumentTypeEnum._(r'BUSINESS_LICENSE');
  static const IDENTITY_FRONT = DocumentUpdateDtoDocumentTypeEnum._(r'IDENTITY_FRONT');
  static const IDENTITY_BACK = DocumentUpdateDtoDocumentTypeEnum._(r'IDENTITY_BACK');
  static const AUTHORIZATION_LETTER = DocumentUpdateDtoDocumentTypeEnum._(r'AUTHORIZATION_LETTER');
  static const ANTT = DocumentUpdateDtoDocumentTypeEnum._(r'ANTT');
  static const KCB_LICENSE = DocumentUpdateDtoDocumentTypeEnum._(r'KCB_LICENSE');
  static const GCN_FITNESS = DocumentUpdateDtoDocumentTypeEnum._(r'GCN_FITNESS');
  static const GPP = DocumentUpdateDtoDocumentTypeEnum._(r'GPP');
  static const RHM_LICENSE = DocumentUpdateDtoDocumentTypeEnum._(r'RHM_LICENSE');
  static const MEDICAL_WASTE_CONTRACT = DocumentUpdateDtoDocumentTypeEnum._(r'MEDICAL_WASTE_CONTRACT');
  static const YHCT_LICENSE = DocumentUpdateDtoDocumentTypeEnum._(r'YHCT_LICENSE');
  static const PSYCHOLOGY_LICENSE = DocumentUpdateDtoDocumentTypeEnum._(r'PSYCHOLOGY_LICENSE');
  static const DERMATOLOGY_LICENSE = DocumentUpdateDtoDocumentTypeEnum._(r'DERMATOLOGY_LICENSE');
  static const TECHNICAL_PORTFOLIO = DocumentUpdateDtoDocumentTypeEnum._(r'TECHNICAL_PORTFOLIO');
  static const NUTRITION_LICENSE = DocumentUpdateDtoDocumentTypeEnum._(r'NUTRITION_LICENSE');
  static const PSYCHIATRY_LICENSE = DocumentUpdateDtoDocumentTypeEnum._(r'PSYCHIATRY_LICENSE');

  /// List of all possible values in this [enum][DocumentUpdateDtoDocumentTypeEnum].
  static const values = <DocumentUpdateDtoDocumentTypeEnum>[
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

  static DocumentUpdateDtoDocumentTypeEnum? fromJson(dynamic value) => DocumentUpdateDtoDocumentTypeEnumTypeTransformer().decode(value);

  static List<DocumentUpdateDtoDocumentTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DocumentUpdateDtoDocumentTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DocumentUpdateDtoDocumentTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [DocumentUpdateDtoDocumentTypeEnum] to String,
/// and [decode] dynamic data back to [DocumentUpdateDtoDocumentTypeEnum].
class DocumentUpdateDtoDocumentTypeEnumTypeTransformer {
  factory DocumentUpdateDtoDocumentTypeEnumTypeTransformer() => _instance ??= const DocumentUpdateDtoDocumentTypeEnumTypeTransformer._();

  const DocumentUpdateDtoDocumentTypeEnumTypeTransformer._();

  String encode(DocumentUpdateDtoDocumentTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a DocumentUpdateDtoDocumentTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  DocumentUpdateDtoDocumentTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'BUSINESS_LICENSE': return DocumentUpdateDtoDocumentTypeEnum.BUSINESS_LICENSE;
        case r'IDENTITY_FRONT': return DocumentUpdateDtoDocumentTypeEnum.IDENTITY_FRONT;
        case r'IDENTITY_BACK': return DocumentUpdateDtoDocumentTypeEnum.IDENTITY_BACK;
        case r'AUTHORIZATION_LETTER': return DocumentUpdateDtoDocumentTypeEnum.AUTHORIZATION_LETTER;
        case r'ANTT': return DocumentUpdateDtoDocumentTypeEnum.ANTT;
        case r'KCB_LICENSE': return DocumentUpdateDtoDocumentTypeEnum.KCB_LICENSE;
        case r'GCN_FITNESS': return DocumentUpdateDtoDocumentTypeEnum.GCN_FITNESS;
        case r'GPP': return DocumentUpdateDtoDocumentTypeEnum.GPP;
        case r'RHM_LICENSE': return DocumentUpdateDtoDocumentTypeEnum.RHM_LICENSE;
        case r'MEDICAL_WASTE_CONTRACT': return DocumentUpdateDtoDocumentTypeEnum.MEDICAL_WASTE_CONTRACT;
        case r'YHCT_LICENSE': return DocumentUpdateDtoDocumentTypeEnum.YHCT_LICENSE;
        case r'PSYCHOLOGY_LICENSE': return DocumentUpdateDtoDocumentTypeEnum.PSYCHOLOGY_LICENSE;
        case r'DERMATOLOGY_LICENSE': return DocumentUpdateDtoDocumentTypeEnum.DERMATOLOGY_LICENSE;
        case r'TECHNICAL_PORTFOLIO': return DocumentUpdateDtoDocumentTypeEnum.TECHNICAL_PORTFOLIO;
        case r'NUTRITION_LICENSE': return DocumentUpdateDtoDocumentTypeEnum.NUTRITION_LICENSE;
        case r'PSYCHIATRY_LICENSE': return DocumentUpdateDtoDocumentTypeEnum.PSYCHIATRY_LICENSE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [DocumentUpdateDtoDocumentTypeEnumTypeTransformer] instance.
  static DocumentUpdateDtoDocumentTypeEnumTypeTransformer? _instance;
}


