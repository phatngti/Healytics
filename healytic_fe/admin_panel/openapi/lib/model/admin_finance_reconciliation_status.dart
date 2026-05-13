//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminFinanceReconciliationStatus {
  /// Instantiate a new enum with the provided [value].
  const AdminFinanceReconciliationStatus._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const open = AdminFinanceReconciliationStatus._(r'open');
  static const underReview = AdminFinanceReconciliationStatus._(r'underReview');
  static const resolved = AdminFinanceReconciliationStatus._(r'resolved');
  static const reopened = AdminFinanceReconciliationStatus._(r'reopened');

  /// List of all possible values in this [enum][AdminFinanceReconciliationStatus].
  static const values = <AdminFinanceReconciliationStatus>[
    open,
    underReview,
    resolved,
    reopened,
  ];

  static AdminFinanceReconciliationStatus? fromJson(dynamic value) => AdminFinanceReconciliationStatusTypeTransformer().decode(value);

  static List<AdminFinanceReconciliationStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceReconciliationStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceReconciliationStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminFinanceReconciliationStatus] to String,
/// and [decode] dynamic data back to [AdminFinanceReconciliationStatus].
class AdminFinanceReconciliationStatusTypeTransformer {
  factory AdminFinanceReconciliationStatusTypeTransformer() => _instance ??= const AdminFinanceReconciliationStatusTypeTransformer._();

  const AdminFinanceReconciliationStatusTypeTransformer._();

  String encode(AdminFinanceReconciliationStatus data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminFinanceReconciliationStatus.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminFinanceReconciliationStatus? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'open': return AdminFinanceReconciliationStatus.open;
        case r'underReview': return AdminFinanceReconciliationStatus.underReview;
        case r'resolved': return AdminFinanceReconciliationStatus.resolved;
        case r'reopened': return AdminFinanceReconciliationStatus.reopened;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminFinanceReconciliationStatusTypeTransformer] instance.
  static AdminFinanceReconciliationStatusTypeTransformer? _instance;
}

