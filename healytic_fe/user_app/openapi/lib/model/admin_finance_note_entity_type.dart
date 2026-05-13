//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminFinanceNoteEntityType {
  /// Instantiate a new enum with the provided [value].
  const AdminFinanceNoteEntityType._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const transaction = AdminFinanceNoteEntityType._(r'transaction');
  static const payout = AdminFinanceNoteEntityType._(r'payout');
  static const refundCase = AdminFinanceNoteEntityType._(r'refundCase');
  static const reconciliation = AdminFinanceNoteEntityType._(r'reconciliation');

  /// List of all possible values in this [enum][AdminFinanceNoteEntityType].
  static const values = <AdminFinanceNoteEntityType>[
    transaction,
    payout,
    refundCase,
    reconciliation,
  ];

  static AdminFinanceNoteEntityType? fromJson(dynamic value) => AdminFinanceNoteEntityTypeTypeTransformer().decode(value);

  static List<AdminFinanceNoteEntityType> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceNoteEntityType>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceNoteEntityType.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminFinanceNoteEntityType] to String,
/// and [decode] dynamic data back to [AdminFinanceNoteEntityType].
class AdminFinanceNoteEntityTypeTypeTransformer {
  factory AdminFinanceNoteEntityTypeTypeTransformer() => _instance ??= const AdminFinanceNoteEntityTypeTypeTransformer._();

  const AdminFinanceNoteEntityTypeTypeTransformer._();

  String encode(AdminFinanceNoteEntityType data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminFinanceNoteEntityType.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminFinanceNoteEntityType? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'transaction': return AdminFinanceNoteEntityType.transaction;
        case r'payout': return AdminFinanceNoteEntityType.payout;
        case r'refundCase': return AdminFinanceNoteEntityType.refundCase;
        case r'reconciliation': return AdminFinanceNoteEntityType.reconciliation;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminFinanceNoteEntityTypeTypeTransformer] instance.
  static AdminFinanceNoteEntityTypeTypeTransformer? _instance;
}

