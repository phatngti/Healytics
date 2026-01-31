//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class VerificationDocumentDto {
  /// Returns a new [VerificationDocumentDto] instance.
  VerificationDocumentDto({
    required this.id,
    required this.label,
    this.fileUrl,
    this.fileName,
    required this.status,
    required this.requiresUpdate,
    this.adminFeedback,
    this.isVerified,
  });

  /// Document identifier
  String id;

  /// Display label for the document
  String label;

  Object? fileUrl;

  Object? fileName;

  VerificationDocumentDtoStatusEnum status;

  bool requiresUpdate;

  Object? adminFeedback;

  /// Whether this document was verified by admin (from partner_review_log)
  Object? isVerified;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VerificationDocumentDto &&
    other.id == id &&
    other.label == label &&
    other.fileUrl == fileUrl &&
    other.fileName == fileName &&
    other.status == status &&
    other.requiresUpdate == requiresUpdate &&
    other.adminFeedback == adminFeedback &&
    other.isVerified == isVerified;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (label.hashCode) +
    (fileUrl == null ? 0 : fileUrl!.hashCode) +
    (fileName == null ? 0 : fileName!.hashCode) +
    (status.hashCode) +
    (requiresUpdate.hashCode) +
    (adminFeedback == null ? 0 : adminFeedback!.hashCode) +
    (isVerified == null ? 0 : isVerified!.hashCode);

  @override
  String toString() => 'VerificationDocumentDto[id=$id, label=$label, fileUrl=$fileUrl, fileName=$fileName, status=$status, requiresUpdate=$requiresUpdate, adminFeedback=$adminFeedback, isVerified=$isVerified]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'label'] = this.label;
    if (this.fileUrl != null) {
      json[r'fileUrl'] = this.fileUrl;
    } else {
      json[r'fileUrl'] = null;
    }
    if (this.fileName != null) {
      json[r'fileName'] = this.fileName;
    } else {
      json[r'fileName'] = null;
    }
      json[r'status'] = this.status;
      json[r'requiresUpdate'] = this.requiresUpdate;
    if (this.adminFeedback != null) {
      json[r'adminFeedback'] = this.adminFeedback;
    } else {
      json[r'adminFeedback'] = null;
    }
    if (this.isVerified != null) {
      json[r'isVerified'] = this.isVerified;
    } else {
      json[r'isVerified'] = null;
    }
    return json;
  }

  /// Returns a new [VerificationDocumentDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VerificationDocumentDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "VerificationDocumentDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "VerificationDocumentDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return VerificationDocumentDto(
        id: mapValueOfType<String>(json, r'id')!,
        label: mapValueOfType<String>(json, r'label')!,
        fileUrl: mapValueOfType<Object>(json, r'fileUrl'),
        fileName: mapValueOfType<Object>(json, r'fileName'),
        status: VerificationDocumentDtoStatusEnum.fromJson(json[r'status'])!,
        requiresUpdate: mapValueOfType<bool>(json, r'requiresUpdate')!,
        adminFeedback: mapValueOfType<Object>(json, r'adminFeedback'),
        isVerified: mapValueOfType<Object>(json, r'isVerified'),
      );
    }
    return null;
  }

  static List<VerificationDocumentDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VerificationDocumentDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VerificationDocumentDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VerificationDocumentDto> mapFromJson(dynamic json) {
    final map = <String, VerificationDocumentDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VerificationDocumentDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VerificationDocumentDto-objects as value to a dart map
  static Map<String, List<VerificationDocumentDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VerificationDocumentDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VerificationDocumentDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'label',
    'status',
    'requiresUpdate',
  };
}


class VerificationDocumentDtoStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const VerificationDocumentDtoStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const pending = VerificationDocumentDtoStatusEnum._(r'pending');
  static const approved = VerificationDocumentDtoStatusEnum._(r'approved');
  static const rejected = VerificationDocumentDtoStatusEnum._(r'rejected');
  static const revisionRequired = VerificationDocumentDtoStatusEnum._(r'revision_required');
  static const missing = VerificationDocumentDtoStatusEnum._(r'missing');

  /// List of all possible values in this [enum][VerificationDocumentDtoStatusEnum].
  static const values = <VerificationDocumentDtoStatusEnum>[
    pending,
    approved,
    rejected,
    revisionRequired,
    missing,
  ];

  static VerificationDocumentDtoStatusEnum? fromJson(dynamic value) => VerificationDocumentDtoStatusEnumTypeTransformer().decode(value);

  static List<VerificationDocumentDtoStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VerificationDocumentDtoStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VerificationDocumentDtoStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [VerificationDocumentDtoStatusEnum] to String,
/// and [decode] dynamic data back to [VerificationDocumentDtoStatusEnum].
class VerificationDocumentDtoStatusEnumTypeTransformer {
  factory VerificationDocumentDtoStatusEnumTypeTransformer() => _instance ??= const VerificationDocumentDtoStatusEnumTypeTransformer._();

  const VerificationDocumentDtoStatusEnumTypeTransformer._();

  String encode(VerificationDocumentDtoStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a VerificationDocumentDtoStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  VerificationDocumentDtoStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'pending': return VerificationDocumentDtoStatusEnum.pending;
        case r'approved': return VerificationDocumentDtoStatusEnum.approved;
        case r'rejected': return VerificationDocumentDtoStatusEnum.rejected;
        case r'revision_required': return VerificationDocumentDtoStatusEnum.revisionRequired;
        case r'missing': return VerificationDocumentDtoStatusEnum.missing;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [VerificationDocumentDtoStatusEnumTypeTransformer] instance.
  static VerificationDocumentDtoStatusEnumTypeTransformer? _instance;
}


