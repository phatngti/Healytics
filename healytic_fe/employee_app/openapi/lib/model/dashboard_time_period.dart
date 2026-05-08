//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class DashboardTimePeriod {
  /// Instantiate a new enum with the provided [value].
  const DashboardTimePeriod._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const today = DashboardTimePeriod._(r'today');
  static const thisWeek = DashboardTimePeriod._(r'this_week');
  static const thisMonth = DashboardTimePeriod._(r'this_month');
  static const thisQuarter = DashboardTimePeriod._(r'this_quarter');
  static const thisYear = DashboardTimePeriod._(r'this_year');

  /// List of all possible values in this [enum][DashboardTimePeriod].
  static const values = <DashboardTimePeriod>[
    today,
    thisWeek,
    thisMonth,
    thisQuarter,
    thisYear,
  ];

  static DashboardTimePeriod? fromJson(dynamic value) => DashboardTimePeriodTypeTransformer().decode(value);

  static List<DashboardTimePeriod> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DashboardTimePeriod>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DashboardTimePeriod.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [DashboardTimePeriod] to String,
/// and [decode] dynamic data back to [DashboardTimePeriod].
class DashboardTimePeriodTypeTransformer {
  factory DashboardTimePeriodTypeTransformer() => _instance ??= const DashboardTimePeriodTypeTransformer._();

  const DashboardTimePeriodTypeTransformer._();

  String encode(DashboardTimePeriod data) => data.value;

  /// Decodes a [dynamic value][data] to a DashboardTimePeriod.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  DashboardTimePeriod? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'today': return DashboardTimePeriod.today;
        case r'this_week': return DashboardTimePeriod.thisWeek;
        case r'this_month': return DashboardTimePeriod.thisMonth;
        case r'this_quarter': return DashboardTimePeriod.thisQuarter;
        case r'this_year': return DashboardTimePeriod.thisYear;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [DashboardTimePeriodTypeTransformer] instance.
  static DashboardTimePeriodTypeTransformer? _instance;
}

