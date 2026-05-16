//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminFinanceRiskTone {
  /// Instantiate a new enum with the provided [value].
  const AdminFinanceRiskTone._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const neutral = AdminFinanceRiskTone._(r'neutral');
  static const positive = AdminFinanceRiskTone._(r'positive');
  static const warning = AdminFinanceRiskTone._(r'warning');
  static const critical = AdminFinanceRiskTone._(r'critical');

  /// List of all possible values in this [enum][AdminFinanceRiskTone].
  static const values = <AdminFinanceRiskTone>[
    neutral,
    positive,
    warning,
    critical,
  ];

  static AdminFinanceRiskTone? fromJson(dynamic value) => AdminFinanceRiskToneTypeTransformer().decode(value);

  static List<AdminFinanceRiskTone> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceRiskTone>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceRiskTone.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminFinanceRiskTone] to String,
/// and [decode] dynamic data back to [AdminFinanceRiskTone].
class AdminFinanceRiskToneTypeTransformer {
  factory AdminFinanceRiskToneTypeTransformer() => _instance ??= const AdminFinanceRiskToneTypeTransformer._();

  const AdminFinanceRiskToneTypeTransformer._();

  String encode(AdminFinanceRiskTone data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminFinanceRiskTone.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminFinanceRiskTone? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'neutral': return AdminFinanceRiskTone.neutral;
        case r'positive': return AdminFinanceRiskTone.positive;
        case r'warning': return AdminFinanceRiskTone.warning;
        case r'critical': return AdminFinanceRiskTone.critical;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminFinanceRiskToneTypeTransformer] instance.
  static AdminFinanceRiskToneTypeTransformer? _instance;
}

