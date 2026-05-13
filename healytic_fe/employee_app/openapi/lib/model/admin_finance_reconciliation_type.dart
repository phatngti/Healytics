//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminFinanceReconciliationType {
  /// Instantiate a new enum with the provided [value].
  const AdminFinanceReconciliationType._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const missingProviderEvent = AdminFinanceReconciliationType._(r'missingProviderEvent');
  static const missingLedgerRecord = AdminFinanceReconciliationType._(r'missingLedgerRecord');
  static const amountMismatch = AdminFinanceReconciliationType._(r'amountMismatch');
  static const currencyMismatch = AdminFinanceReconciliationType._(r'currencyMismatch');
  static const duplicateProviderEvent = AdminFinanceReconciliationType._(r'duplicateProviderEvent');
  static const payoutMismatch = AdminFinanceReconciliationType._(r'payoutMismatch');
  static const refundMismatch = AdminFinanceReconciliationType._(r'refundMismatch');
  static const stalePendingPayment = AdminFinanceReconciliationType._(r'stalePendingPayment');

  /// List of all possible values in this [enum][AdminFinanceReconciliationType].
  static const values = <AdminFinanceReconciliationType>[
    missingProviderEvent,
    missingLedgerRecord,
    amountMismatch,
    currencyMismatch,
    duplicateProviderEvent,
    payoutMismatch,
    refundMismatch,
    stalePendingPayment,
  ];

  static AdminFinanceReconciliationType? fromJson(dynamic value) => AdminFinanceReconciliationTypeTypeTransformer().decode(value);

  static List<AdminFinanceReconciliationType> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceReconciliationType>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceReconciliationType.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminFinanceReconciliationType] to String,
/// and [decode] dynamic data back to [AdminFinanceReconciliationType].
class AdminFinanceReconciliationTypeTypeTransformer {
  factory AdminFinanceReconciliationTypeTypeTransformer() => _instance ??= const AdminFinanceReconciliationTypeTypeTransformer._();

  const AdminFinanceReconciliationTypeTypeTransformer._();

  String encode(AdminFinanceReconciliationType data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminFinanceReconciliationType.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminFinanceReconciliationType? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'missingProviderEvent': return AdminFinanceReconciliationType.missingProviderEvent;
        case r'missingLedgerRecord': return AdminFinanceReconciliationType.missingLedgerRecord;
        case r'amountMismatch': return AdminFinanceReconciliationType.amountMismatch;
        case r'currencyMismatch': return AdminFinanceReconciliationType.currencyMismatch;
        case r'duplicateProviderEvent': return AdminFinanceReconciliationType.duplicateProviderEvent;
        case r'payoutMismatch': return AdminFinanceReconciliationType.payoutMismatch;
        case r'refundMismatch': return AdminFinanceReconciliationType.refundMismatch;
        case r'stalePendingPayment': return AdminFinanceReconciliationType.stalePendingPayment;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminFinanceReconciliationTypeTypeTransformer] instance.
  static AdminFinanceReconciliationTypeTypeTransformer? _instance;
}

