//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminFinancePeriod {
  /// Instantiate a new enum with the provided [value].
  const AdminFinancePeriod._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const sevenDays = AdminFinancePeriod._(r'sevenDays');
  static const thirtyDays = AdminFinancePeriod._(r'thirtyDays');
  static const ninetyDays = AdminFinancePeriod._(r'ninetyDays');
  static const thisMonth = AdminFinancePeriod._(r'thisMonth');
  static const lastMonth = AdminFinancePeriod._(r'lastMonth');
  static const custom = AdminFinancePeriod._(r'custom');

  /// List of all possible values in this [enum][AdminFinancePeriod].
  static const values = <AdminFinancePeriod>[
    sevenDays,
    thirtyDays,
    ninetyDays,
    thisMonth,
    lastMonth,
    custom,
  ];

  static AdminFinancePeriod? fromJson(dynamic value) => AdminFinancePeriodTypeTransformer().decode(value);

  static List<AdminFinancePeriod> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinancePeriod>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinancePeriod.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminFinancePeriod] to String,
/// and [decode] dynamic data back to [AdminFinancePeriod].
class AdminFinancePeriodTypeTransformer {
  factory AdminFinancePeriodTypeTransformer() => _instance ??= const AdminFinancePeriodTypeTransformer._();

  const AdminFinancePeriodTypeTransformer._();

  String encode(AdminFinancePeriod data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminFinancePeriod.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminFinancePeriod? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'sevenDays': return AdminFinancePeriod.sevenDays;
        case r'thirtyDays': return AdminFinancePeriod.thirtyDays;
        case r'ninetyDays': return AdminFinancePeriod.ninetyDays;
        case r'thisMonth': return AdminFinancePeriod.thisMonth;
        case r'lastMonth': return AdminFinancePeriod.lastMonth;
        case r'custom': return AdminFinancePeriod.custom;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminFinancePeriodTypeTransformer] instance.
  static AdminFinancePeriodTypeTransformer? _instance;
}

