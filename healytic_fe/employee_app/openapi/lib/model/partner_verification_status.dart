//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnerVerificationStatus {
  /// Instantiate a new enum with the provided [value].
  const PartnerVerificationStatus._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const PENDING = PartnerVerificationStatus._(r'PENDING');
  static const APPROVED = PartnerVerificationStatus._(r'APPROVED');
  static const REJECTED = PartnerVerificationStatus._(r'REJECTED');
  static const REQUIRED_RESUBMIT = PartnerVerificationStatus._(r'REQUIRED_RESUBMIT');

  /// List of all possible values in this [enum][PartnerVerificationStatus].
  static const values = <PartnerVerificationStatus>[
    PENDING,
    APPROVED,
    REJECTED,
    REQUIRED_RESUBMIT,
  ];

  static PartnerVerificationStatus? fromJson(dynamic value) => PartnerVerificationStatusTypeTransformer().decode(value);

  static List<PartnerVerificationStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerVerificationStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerVerificationStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PartnerVerificationStatus] to String,
/// and [decode] dynamic data back to [PartnerVerificationStatus].
class PartnerVerificationStatusTypeTransformer {
  factory PartnerVerificationStatusTypeTransformer() => _instance ??= const PartnerVerificationStatusTypeTransformer._();

  const PartnerVerificationStatusTypeTransformer._();

  String encode(PartnerVerificationStatus data) => data.value;

  /// Decodes a [dynamic value][data] to a PartnerVerificationStatus.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PartnerVerificationStatus? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'PENDING': return PartnerVerificationStatus.PENDING;
        case r'APPROVED': return PartnerVerificationStatus.APPROVED;
        case r'REJECTED': return PartnerVerificationStatus.REJECTED;
        case r'REQUIRED_RESUBMIT': return PartnerVerificationStatus.REQUIRED_RESUBMIT;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PartnerVerificationStatusTypeTransformer] instance.
  static PartnerVerificationStatusTypeTransformer? _instance;
}

