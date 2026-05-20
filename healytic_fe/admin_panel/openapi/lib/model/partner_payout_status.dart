//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnerPayoutStatus {
  /// Instantiate a new enum with the provided [value].
  const PartnerPayoutStatus._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const notAssigned = PartnerPayoutStatus._(r'notAssigned');
  static const inPayout = PartnerPayoutStatus._(r'inPayout');
  static const paidOut = PartnerPayoutStatus._(r'paidOut');
  static const failed = PartnerPayoutStatus._(r'failed');
  static const held = PartnerPayoutStatus._(r'held');

  /// List of all possible values in this [enum][PartnerPayoutStatus].
  static const values = <PartnerPayoutStatus>[
    notAssigned,
    inPayout,
    paidOut,
    failed,
    held,
  ];

  static PartnerPayoutStatus? fromJson(dynamic value) => PartnerPayoutStatusTypeTransformer().decode(value);

  static List<PartnerPayoutStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerPayoutStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerPayoutStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PartnerPayoutStatus] to String,
/// and [decode] dynamic data back to [PartnerPayoutStatus].
class PartnerPayoutStatusTypeTransformer {
  factory PartnerPayoutStatusTypeTransformer() => _instance ??= const PartnerPayoutStatusTypeTransformer._();

  const PartnerPayoutStatusTypeTransformer._();

  String encode(PartnerPayoutStatus data) => data.value;

  /// Decodes a [dynamic value][data] to a PartnerPayoutStatus.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PartnerPayoutStatus? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'notAssigned': return PartnerPayoutStatus.notAssigned;
        case r'inPayout': return PartnerPayoutStatus.inPayout;
        case r'paidOut': return PartnerPayoutStatus.paidOut;
        case r'failed': return PartnerPayoutStatus.failed;
        case r'held': return PartnerPayoutStatus.held;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PartnerPayoutStatusTypeTransformer] instance.
  static PartnerPayoutStatusTypeTransformer? _instance;
}

