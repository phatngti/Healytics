//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnerSettlementStatus {
  /// Instantiate a new enum with the provided [value].
  const PartnerSettlementStatus._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const unsettled = PartnerSettlementStatus._(r'unsettled');
  static const scheduled = PartnerSettlementStatus._(r'scheduled');
  static const settled = PartnerSettlementStatus._(r'settled');
  static const held = PartnerSettlementStatus._(r'held');

  /// List of all possible values in this [enum][PartnerSettlementStatus].
  static const values = <PartnerSettlementStatus>[
    unsettled,
    scheduled,
    settled,
    held,
  ];

  static PartnerSettlementStatus? fromJson(dynamic value) => PartnerSettlementStatusTypeTransformer().decode(value);

  static List<PartnerSettlementStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerSettlementStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerSettlementStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PartnerSettlementStatus] to String,
/// and [decode] dynamic data back to [PartnerSettlementStatus].
class PartnerSettlementStatusTypeTransformer {
  factory PartnerSettlementStatusTypeTransformer() => _instance ??= const PartnerSettlementStatusTypeTransformer._();

  const PartnerSettlementStatusTypeTransformer._();

  String encode(PartnerSettlementStatus data) => data.value;

  /// Decodes a [dynamic value][data] to a PartnerSettlementStatus.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PartnerSettlementStatus? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'unsettled': return PartnerSettlementStatus.unsettled;
        case r'scheduled': return PartnerSettlementStatus.scheduled;
        case r'settled': return PartnerSettlementStatus.settled;
        case r'held': return PartnerSettlementStatus.held;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PartnerSettlementStatusTypeTransformer] instance.
  static PartnerSettlementStatusTypeTransformer? _instance;
}

