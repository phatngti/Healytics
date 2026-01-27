//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdateLegalRepresentativeDto {
  /// Returns a new [UpdateLegalRepresentativeDto] instance.
  UpdateLegalRepresentativeDto({
    this.fullName,
    this.position,
    this.phoneNumber,
    this.idType,
    this.idNumber,
    this.idIssueDate,
    this.images,
    this.documents,
  });

  /// Full name of legal representative
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? fullName;

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
  UpdateLegalRepresentativeDtoIdTypeEnum? idType;

  /// ID number (9 or 12 digits for Vietnam)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? idNumber;

  /// Date of ID issuance (ISO 8601 format)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? idIssueDate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  IdImagesRequestDto? images;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PartnerDocumentVerificationDto? documents;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateLegalRepresentativeDto &&
    other.fullName == fullName &&
    other.position == position &&
    other.phoneNumber == phoneNumber &&
    other.idType == idType &&
    other.idNumber == idNumber &&
    other.idIssueDate == idIssueDate &&
    other.images == images &&
    other.documents == documents;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fullName == null ? 0 : fullName!.hashCode) +
    (position == null ? 0 : position!.hashCode) +
    (phoneNumber == null ? 0 : phoneNumber!.hashCode) +
    (idType == null ? 0 : idType!.hashCode) +
    (idNumber == null ? 0 : idNumber!.hashCode) +
    (idIssueDate == null ? 0 : idIssueDate!.hashCode) +
    (images == null ? 0 : images!.hashCode) +
    (documents == null ? 0 : documents!.hashCode);

  @override
  String toString() => 'UpdateLegalRepresentativeDto[fullName=$fullName, position=$position, phoneNumber=$phoneNumber, idType=$idType, idNumber=$idNumber, idIssueDate=$idIssueDate, images=$images, documents=$documents]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.fullName != null) {
      json[r'fullName'] = this.fullName;
    } else {
      json[r'fullName'] = null;
    }
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
    if (this.images != null) {
      json[r'images'] = this.images;
    } else {
      json[r'images'] = null;
    }
    if (this.documents != null) {
      json[r'documents'] = this.documents;
    } else {
      json[r'documents'] = null;
    }
    return json;
  }

  /// Returns a new [UpdateLegalRepresentativeDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdateLegalRepresentativeDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdateLegalRepresentativeDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdateLegalRepresentativeDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdateLegalRepresentativeDto(
        fullName: mapValueOfType<String>(json, r'fullName'),
        position: mapValueOfType<String>(json, r'position'),
        phoneNumber: mapValueOfType<String>(json, r'phoneNumber'),
        idType: UpdateLegalRepresentativeDtoIdTypeEnum.fromJson(json[r'idType']),
        idNumber: mapValueOfType<String>(json, r'idNumber'),
        idIssueDate: mapValueOfType<String>(json, r'idIssueDate'),
        images: IdImagesRequestDto.fromJson(json[r'images']),
        documents: PartnerDocumentVerificationDto.fromJson(json[r'documents']),
      );
    }
    return null;
  }

  static List<UpdateLegalRepresentativeDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateLegalRepresentativeDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateLegalRepresentativeDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateLegalRepresentativeDto> mapFromJson(dynamic json) {
    final map = <String, UpdateLegalRepresentativeDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateLegalRepresentativeDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateLegalRepresentativeDto-objects as value to a dart map
  static Map<String, List<UpdateLegalRepresentativeDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateLegalRepresentativeDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateLegalRepresentativeDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

/// Type of identification document
class UpdateLegalRepresentativeDtoIdTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const UpdateLegalRepresentativeDtoIdTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const CITIZEN_ID = UpdateLegalRepresentativeDtoIdTypeEnum._(r'CITIZEN_ID');
  static const PASSPORT = UpdateLegalRepresentativeDtoIdTypeEnum._(r'PASSPORT');
  static const MILITARY_ID = UpdateLegalRepresentativeDtoIdTypeEnum._(r'MILITARY_ID');

  /// List of all possible values in this [enum][UpdateLegalRepresentativeDtoIdTypeEnum].
  static const values = <UpdateLegalRepresentativeDtoIdTypeEnum>[
    CITIZEN_ID,
    PASSPORT,
    MILITARY_ID,
  ];

  static UpdateLegalRepresentativeDtoIdTypeEnum? fromJson(dynamic value) => UpdateLegalRepresentativeDtoIdTypeEnumTypeTransformer().decode(value);

  static List<UpdateLegalRepresentativeDtoIdTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateLegalRepresentativeDtoIdTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateLegalRepresentativeDtoIdTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UpdateLegalRepresentativeDtoIdTypeEnum] to String,
/// and [decode] dynamic data back to [UpdateLegalRepresentativeDtoIdTypeEnum].
class UpdateLegalRepresentativeDtoIdTypeEnumTypeTransformer {
  factory UpdateLegalRepresentativeDtoIdTypeEnumTypeTransformer() => _instance ??= const UpdateLegalRepresentativeDtoIdTypeEnumTypeTransformer._();

  const UpdateLegalRepresentativeDtoIdTypeEnumTypeTransformer._();

  String encode(UpdateLegalRepresentativeDtoIdTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UpdateLegalRepresentativeDtoIdTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UpdateLegalRepresentativeDtoIdTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'CITIZEN_ID': return UpdateLegalRepresentativeDtoIdTypeEnum.CITIZEN_ID;
        case r'PASSPORT': return UpdateLegalRepresentativeDtoIdTypeEnum.PASSPORT;
        case r'MILITARY_ID': return UpdateLegalRepresentativeDtoIdTypeEnum.MILITARY_ID;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UpdateLegalRepresentativeDtoIdTypeEnumTypeTransformer] instance.
  static UpdateLegalRepresentativeDtoIdTypeEnumTypeTransformer? _instance;
}


