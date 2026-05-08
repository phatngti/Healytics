//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PartnerPublicProfileResponseDto {
  /// Returns a new [PartnerPublicProfileResponseDto] instance.
  PartnerPublicProfileResponseDto({
    required this.id,
    required this.businessInfo,
    required this.address,
    this.readOnlyLegalSummary,
    required this.verificationStatus,
    required this.publicProfile,
    required this.completionSummary,
  });


  String id;

  PublicProfileBusinessInfoDto businessInfo;

  PublicProfileAddressDto address;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PublicProfileLegalSummaryDto? readOnlyLegalSummary;

  PartnerPublicProfileResponseDtoVerificationStatusEnum verificationStatus;

  PublicProfileStorefrontDto publicProfile;

  PublicProfileCompletionSummaryDto completionSummary;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerPublicProfileResponseDto &&
    other.id == id &&
    other.businessInfo == businessInfo &&
    other.address == address &&
    other.readOnlyLegalSummary == readOnlyLegalSummary &&
    other.verificationStatus == verificationStatus &&
    other.publicProfile == publicProfile &&
    other.completionSummary == completionSummary;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (businessInfo.hashCode) +
    (address.hashCode) +
    (readOnlyLegalSummary == null ? 0 : readOnlyLegalSummary!.hashCode) +
    (verificationStatus.hashCode) +
    (publicProfile.hashCode) +
    (completionSummary.hashCode);

  @override
  String toString() => 'PartnerPublicProfileResponseDto[id=$id, businessInfo=$businessInfo, address=$address, readOnlyLegalSummary=$readOnlyLegalSummary, verificationStatus=$verificationStatus, publicProfile=$publicProfile, completionSummary=$completionSummary]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'businessInfo'] = this.businessInfo;
      json[r'address'] = this.address;
    if (this.readOnlyLegalSummary != null) {
      json[r'readOnlyLegalSummary'] = this.readOnlyLegalSummary;
    } else {
      json[r'readOnlyLegalSummary'] = null;
    }
      json[r'verificationStatus'] = this.verificationStatus;
      json[r'publicProfile'] = this.publicProfile;
      json[r'completionSummary'] = this.completionSummary;
    return json;
  }

  /// Returns a new [PartnerPublicProfileResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PartnerPublicProfileResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PartnerPublicProfileResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PartnerPublicProfileResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PartnerPublicProfileResponseDto(
        id: mapValueOfType<String>(json, r'id')!,
        businessInfo: PublicProfileBusinessInfoDto.fromJson(json[r'businessInfo'])!,
        address: PublicProfileAddressDto.fromJson(json[r'address'])!,
        readOnlyLegalSummary: PublicProfileLegalSummaryDto.fromJson(json[r'readOnlyLegalSummary']),
        verificationStatus: PartnerPublicProfileResponseDtoVerificationStatusEnum.fromJson(json[r'verificationStatus'])!,
        publicProfile: PublicProfileStorefrontDto.fromJson(json[r'publicProfile'])!,
        completionSummary: PublicProfileCompletionSummaryDto.fromJson(json[r'completionSummary'])!,
      );
    }
    return null;
  }

  static List<PartnerPublicProfileResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerPublicProfileResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerPublicProfileResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PartnerPublicProfileResponseDto> mapFromJson(dynamic json) {
    final map = <String, PartnerPublicProfileResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PartnerPublicProfileResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PartnerPublicProfileResponseDto-objects as value to a dart map
  static Map<String, List<PartnerPublicProfileResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PartnerPublicProfileResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PartnerPublicProfileResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'businessInfo',
    'address',
    'verificationStatus',
    'publicProfile',
    'completionSummary',
  };
}


class PartnerPublicProfileResponseDtoVerificationStatusEnum {
  /// Instantiate a new enum with the provided [value].
  const PartnerPublicProfileResponseDtoVerificationStatusEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const PENDING = PartnerPublicProfileResponseDtoVerificationStatusEnum._(r'PENDING');
  static const APPROVED = PartnerPublicProfileResponseDtoVerificationStatusEnum._(r'APPROVED');
  static const REJECTED = PartnerPublicProfileResponseDtoVerificationStatusEnum._(r'REJECTED');
  static const REQUIRED_RESUBMIT = PartnerPublicProfileResponseDtoVerificationStatusEnum._(r'REQUIRED_RESUBMIT');

  /// List of all possible values in this [enum][PartnerPublicProfileResponseDtoVerificationStatusEnum].
  static const values = <PartnerPublicProfileResponseDtoVerificationStatusEnum>[
    PENDING,
    APPROVED,
    REJECTED,
    REQUIRED_RESUBMIT,
  ];

  static PartnerPublicProfileResponseDtoVerificationStatusEnum? fromJson(dynamic value) => PartnerPublicProfileResponseDtoVerificationStatusEnumTypeTransformer().decode(value);

  static List<PartnerPublicProfileResponseDtoVerificationStatusEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerPublicProfileResponseDtoVerificationStatusEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerPublicProfileResponseDtoVerificationStatusEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PartnerPublicProfileResponseDtoVerificationStatusEnum] to String,
/// and [decode] dynamic data back to [PartnerPublicProfileResponseDtoVerificationStatusEnum].
class PartnerPublicProfileResponseDtoVerificationStatusEnumTypeTransformer {
  factory PartnerPublicProfileResponseDtoVerificationStatusEnumTypeTransformer() => _instance ??= const PartnerPublicProfileResponseDtoVerificationStatusEnumTypeTransformer._();

  const PartnerPublicProfileResponseDtoVerificationStatusEnumTypeTransformer._();

  String encode(PartnerPublicProfileResponseDtoVerificationStatusEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a PartnerPublicProfileResponseDtoVerificationStatusEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PartnerPublicProfileResponseDtoVerificationStatusEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'PENDING': return PartnerPublicProfileResponseDtoVerificationStatusEnum.PENDING;
        case r'APPROVED': return PartnerPublicProfileResponseDtoVerificationStatusEnum.APPROVED;
        case r'REJECTED': return PartnerPublicProfileResponseDtoVerificationStatusEnum.REJECTED;
        case r'REQUIRED_RESUBMIT': return PartnerPublicProfileResponseDtoVerificationStatusEnum.REQUIRED_RESUBMIT;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PartnerPublicProfileResponseDtoVerificationStatusEnumTypeTransformer] instance.
  static PartnerPublicProfileResponseDtoVerificationStatusEnumTypeTransformer? _instance;
}


