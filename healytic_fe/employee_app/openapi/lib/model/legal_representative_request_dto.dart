//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LegalRepresentativeRequestDto {
  /// Returns a new [LegalRepresentativeRequestDto] instance.
  LegalRepresentativeRequestDto({
    required this.fullName,
    this.position,
    this.phoneNumber,
    required this.idType,
    required this.idNumber,
    required this.idIssueDate,
    this.documents = const [],
  });


  /// Full name of legal representative
  String fullName;

  /// Position in the company
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? position;

  /// Phone number of legal representative
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? phoneNumber;

  /// Type of identification document
  LegalRepresentativeRequestDtoIdTypeEnum idType;

  /// ID number (9 or 12 digits for Vietnam)
  String idNumber;

  /// Date of ID issuance (ISO 8601 format)
  String idIssueDate;

  List<PartnerDocumentVerificationDto> documents;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LegalRepresentativeRequestDto &&
    other.fullName == fullName &&
    other.position == position &&
    other.phoneNumber == phoneNumber &&
    other.idType == idType &&
    other.idNumber == idNumber &&
    other.idIssueDate == idIssueDate &&
    _deepEquality.equals(other.documents, documents);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fullName.hashCode) +
    (position == null ? 0 : position!.hashCode) +
    (phoneNumber == null ? 0 : phoneNumber!.hashCode) +
    (idType.hashCode) +
    (idNumber.hashCode) +
    (idIssueDate.hashCode) +
    (documents.hashCode);

  @override
  String toString() => 'LegalRepresentativeRequestDto[fullName=$fullName, position=$position, phoneNumber=$phoneNumber, idType=$idType, idNumber=$idNumber, idIssueDate=$idIssueDate, documents=$documents]';

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
      json[r'idType'] = this.idType;
      json[r'idNumber'] = this.idNumber;
      json[r'idIssueDate'] = this.idIssueDate;
      json[r'documents'] = this.documents;
    return json;
  }

  /// Returns a new [LegalRepresentativeRequestDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LegalRepresentativeRequestDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "LegalRepresentativeRequestDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "LegalRepresentativeRequestDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LegalRepresentativeRequestDto(
        fullName: mapValueOfType<String>(json, r'fullName')!,
        position: mapValueOfType<String>(json, r'position'),
        phoneNumber: mapValueOfType<String>(json, r'phoneNumber'),
        idType: LegalRepresentativeRequestDtoIdTypeEnum.fromJson(json[r'idType'])!,
        idNumber: mapValueOfType<String>(json, r'idNumber')!,
        idIssueDate: mapValueOfType<String>(json, r'idIssueDate')!,
        documents: PartnerDocumentVerificationDto.listFromJson(json[r'documents']),
      );
    }
    return null;
  }

  static List<LegalRepresentativeRequestDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LegalRepresentativeRequestDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LegalRepresentativeRequestDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LegalRepresentativeRequestDto> mapFromJson(dynamic json) {
    final map = <String, LegalRepresentativeRequestDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LegalRepresentativeRequestDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LegalRepresentativeRequestDto-objects as value to a dart map
  static Map<String, List<LegalRepresentativeRequestDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LegalRepresentativeRequestDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LegalRepresentativeRequestDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fullName',
    'idType',
    'idNumber',
    'idIssueDate',
    'documents',
  };
}

/// Type of identification document
class LegalRepresentativeRequestDtoIdTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const LegalRepresentativeRequestDtoIdTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const CITIZEN_ID = LegalRepresentativeRequestDtoIdTypeEnum._(r'CITIZEN_ID');
  static const PASSPORT = LegalRepresentativeRequestDtoIdTypeEnum._(r'PASSPORT');
  static const MILITARY_ID = LegalRepresentativeRequestDtoIdTypeEnum._(r'MILITARY_ID');

  /// List of all possible values in this [enum][LegalRepresentativeRequestDtoIdTypeEnum].
  static const values = <LegalRepresentativeRequestDtoIdTypeEnum>[
    CITIZEN_ID,
    PASSPORT,
    MILITARY_ID,
  ];

  static LegalRepresentativeRequestDtoIdTypeEnum? fromJson(dynamic value) => LegalRepresentativeRequestDtoIdTypeEnumTypeTransformer().decode(value);

  static List<LegalRepresentativeRequestDtoIdTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LegalRepresentativeRequestDtoIdTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LegalRepresentativeRequestDtoIdTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [LegalRepresentativeRequestDtoIdTypeEnum] to String,
/// and [decode] dynamic data back to [LegalRepresentativeRequestDtoIdTypeEnum].
class LegalRepresentativeRequestDtoIdTypeEnumTypeTransformer {
  factory LegalRepresentativeRequestDtoIdTypeEnumTypeTransformer() => _instance ??= const LegalRepresentativeRequestDtoIdTypeEnumTypeTransformer._();

  const LegalRepresentativeRequestDtoIdTypeEnumTypeTransformer._();

  String encode(LegalRepresentativeRequestDtoIdTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a LegalRepresentativeRequestDtoIdTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  LegalRepresentativeRequestDtoIdTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'CITIZEN_ID': return LegalRepresentativeRequestDtoIdTypeEnum.CITIZEN_ID;
        case r'PASSPORT': return LegalRepresentativeRequestDtoIdTypeEnum.PASSPORT;
        case r'MILITARY_ID': return LegalRepresentativeRequestDtoIdTypeEnum.MILITARY_ID;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [LegalRepresentativeRequestDtoIdTypeEnumTypeTransformer] instance.
  static LegalRepresentativeRequestDtoIdTypeEnumTypeTransformer? _instance;
}


