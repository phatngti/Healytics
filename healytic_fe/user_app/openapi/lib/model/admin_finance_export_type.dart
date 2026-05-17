//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminFinanceExportType {
  /// Instantiate a new enum with the provided [value].
  const AdminFinanceExportType._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const transactions = AdminFinanceExportType._(r'transactions');
  static const payouts = AdminFinanceExportType._(r'payouts');
  static const refundCases = AdminFinanceExportType._(r'refundCases');
  static const reconciliation = AdminFinanceExportType._(r'reconciliation');
  static const partnerExposure = AdminFinanceExportType._(r'partnerExposure');
  static const monthlySummary = AdminFinanceExportType._(r'monthlySummary');

  /// List of all possible values in this [enum][AdminFinanceExportType].
  static const values = <AdminFinanceExportType>[
    transactions,
    payouts,
    refundCases,
    reconciliation,
    partnerExposure,
    monthlySummary,
  ];

  static AdminFinanceExportType? fromJson(dynamic value) => AdminFinanceExportTypeTypeTransformer().decode(value);

  static List<AdminFinanceExportType> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceExportType>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceExportType.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminFinanceExportType] to String,
/// and [decode] dynamic data back to [AdminFinanceExportType].
class AdminFinanceExportTypeTypeTransformer {
  factory AdminFinanceExportTypeTypeTransformer() => _instance ??= const AdminFinanceExportTypeTypeTransformer._();

  const AdminFinanceExportTypeTypeTransformer._();

  String encode(AdminFinanceExportType data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminFinanceExportType.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminFinanceExportType? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'transactions': return AdminFinanceExportType.transactions;
        case r'payouts': return AdminFinanceExportType.payouts;
        case r'refundCases': return AdminFinanceExportType.refundCases;
        case r'reconciliation': return AdminFinanceExportType.reconciliation;
        case r'partnerExposure': return AdminFinanceExportType.partnerExposure;
        case r'monthlySummary': return AdminFinanceExportType.monthlySummary;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminFinanceExportTypeTypeTransformer] instance.
  static AdminFinanceExportTypeTypeTransformer? _instance;
}

