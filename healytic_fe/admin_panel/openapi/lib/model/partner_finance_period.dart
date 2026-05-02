//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnerFinancePeriod {
  /// Instantiate a new enum with the provided [value].
  const PartnerFinancePeriod._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const sevenDays = PartnerFinancePeriod._(r'sevenDays');
  static const thirtyDays = PartnerFinancePeriod._(r'thirtyDays');
  static const ninetyDays = PartnerFinancePeriod._(r'ninetyDays');

  /// List of all possible values in this [enum][PartnerFinancePeriod].
  static const values = <PartnerFinancePeriod>[
    sevenDays,
    thirtyDays,
    ninetyDays,
  ];

  static PartnerFinancePeriod? fromJson(dynamic value) => PartnerFinancePeriodTypeTransformer().decode(value);

  static List<PartnerFinancePeriod> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PartnerFinancePeriod>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PartnerFinancePeriod.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [PartnerFinancePeriod] to String,
/// and [decode] dynamic data back to [PartnerFinancePeriod].
class PartnerFinancePeriodTypeTransformer {
  factory PartnerFinancePeriodTypeTransformer() => _instance ??= const PartnerFinancePeriodTypeTransformer._();

  const PartnerFinancePeriodTypeTransformer._();

  String encode(PartnerFinancePeriod data) => data.value;

  /// Decodes a [dynamic value][data] to a PartnerFinancePeriod.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  PartnerFinancePeriod? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'sevenDays': return PartnerFinancePeriod.sevenDays;
        case r'thirtyDays': return PartnerFinancePeriod.thirtyDays;
        case r'ninetyDays': return PartnerFinancePeriod.ninetyDays;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [PartnerFinancePeriodTypeTransformer] instance.
  static PartnerFinancePeriodTypeTransformer? _instance;
}

