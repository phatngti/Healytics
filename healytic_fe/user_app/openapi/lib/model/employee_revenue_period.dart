//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

/// Period used for aggregation
class EmployeeRevenuePeriod {
  /// Instantiate a new enum with the provided [value].
  const EmployeeRevenuePeriod._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const day = EmployeeRevenuePeriod._(r'day');
  static const month = EmployeeRevenuePeriod._(r'month');
  static const year = EmployeeRevenuePeriod._(r'year');

  /// List of all possible values in this [enum][EmployeeRevenuePeriod].
  static const values = <EmployeeRevenuePeriod>[
    day,
    month,
    year,
  ];

  static EmployeeRevenuePeriod? fromJson(dynamic value) => EmployeeRevenuePeriodTypeTransformer().decode(value);

  static List<EmployeeRevenuePeriod> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeRevenuePeriod>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeRevenuePeriod.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [EmployeeRevenuePeriod] to String,
/// and [decode] dynamic data back to [EmployeeRevenuePeriod].
class EmployeeRevenuePeriodTypeTransformer {
  factory EmployeeRevenuePeriodTypeTransformer() => _instance ??= const EmployeeRevenuePeriodTypeTransformer._();

  const EmployeeRevenuePeriodTypeTransformer._();

  String encode(EmployeeRevenuePeriod data) => data.value;

  /// Decodes a [dynamic value][data] to a EmployeeRevenuePeriod.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  EmployeeRevenuePeriod? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'day': return EmployeeRevenuePeriod.day;
        case r'month': return EmployeeRevenuePeriod.month;
        case r'year': return EmployeeRevenuePeriod.year;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [EmployeeRevenuePeriodTypeTransformer] instance.
  static EmployeeRevenuePeriodTypeTransformer? _instance;
}

