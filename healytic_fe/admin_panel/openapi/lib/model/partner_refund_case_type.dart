//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnerRefundCaseType {
  /// Instantiate a new enum with the provided [value].
  const PartnerRefundCaseType._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const refund = PartnerRefundCaseType._(r'refund');
  static const dispute = PartnerRefundCaseType._(r'dispute');

  /// List of all possible values in this [enum][PartnerRefundCaseType].
  static const values = <PartnerRefundCaseType>[
    refund,
    dispute,
  ];

  static PartnerRefundCaseType? fromJson(dynamic value) => PartnerRefundCaseTypeTypeTransformer().decode(value);

  static List<PartnerRefundCaseType> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerRefundCaseType>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerRefundCaseType.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PartnerRefundCaseType] to String,
/// and [decode] dynamic data back to [PartnerRefundCaseType].
class PartnerRefundCaseTypeTypeTransformer {
  factory PartnerRefundCaseTypeTypeTransformer() => _instance ??= const PartnerRefundCaseTypeTypeTransformer._();

  const PartnerRefundCaseTypeTypeTransformer._();

  String encode(PartnerRefundCaseType data) => data.value;

  /// Decodes a [dynamic value][data] to a PartnerRefundCaseType.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PartnerRefundCaseType? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'refund': return PartnerRefundCaseType.refund;
        case r'dispute': return PartnerRefundCaseType.dispute;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PartnerRefundCaseTypeTypeTransformer] instance.
  static PartnerRefundCaseTypeTypeTransformer? _instance;
}

