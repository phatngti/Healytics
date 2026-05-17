//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminFinanceProvider {
  /// Instantiate a new enum with the provided [value].
  const AdminFinanceProvider._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const stripe = AdminFinanceProvider._(r'stripe');
  static const momo = AdminFinanceProvider._(r'momo');
  static const vnpay = AdminFinanceProvider._(r'vnpay');
  static const bankTransfer = AdminFinanceProvider._(r'bankTransfer');
  static const manual = AdminFinanceProvider._(r'manual');

  /// List of all possible values in this [enum][AdminFinanceProvider].
  static const values = <AdminFinanceProvider>[
    stripe,
    momo,
    vnpay,
    bankTransfer,
    manual,
  ];

  static AdminFinanceProvider? fromJson(dynamic value) => AdminFinanceProviderTypeTransformer().decode(value);

  static List<AdminFinanceProvider> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceProvider>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceProvider.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminFinanceProvider] to String,
/// and [decode] dynamic data back to [AdminFinanceProvider].
class AdminFinanceProviderTypeTransformer {
  factory AdminFinanceProviderTypeTransformer() => _instance ??= const AdminFinanceProviderTypeTransformer._();

  const AdminFinanceProviderTypeTransformer._();

  String encode(AdminFinanceProvider data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminFinanceProvider.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminFinanceProvider? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'stripe': return AdminFinanceProvider.stripe;
        case r'momo': return AdminFinanceProvider.momo;
        case r'vnpay': return AdminFinanceProvider.vnpay;
        case r'bankTransfer': return AdminFinanceProvider.bankTransfer;
        case r'manual': return AdminFinanceProvider.manual;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminFinanceProviderTypeTransformer] instance.
  static AdminFinanceProviderTypeTransformer? _instance;
}

