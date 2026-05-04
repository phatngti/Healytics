//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class EmployeeBookingStatusFilter {
  /// Instantiate a new enum with the provided [value].
  const EmployeeBookingStatusFilter._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const upcoming = EmployeeBookingStatusFilter._(r'upcoming');
  static const inProgress = EmployeeBookingStatusFilter._(r'inProgress');
  static const completed = EmployeeBookingStatusFilter._(r'completed');
  static const canceled = EmployeeBookingStatusFilter._(r'canceled');

  /// List of all possible values in this [enum][EmployeeBookingStatusFilter].
  static const values = <EmployeeBookingStatusFilter>[
    upcoming,
    inProgress,
    completed,
    canceled,
  ];

  static EmployeeBookingStatusFilter? fromJson(dynamic value) => EmployeeBookingStatusFilterTypeTransformer().decode(value);

  static List<EmployeeBookingStatusFilter> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeBookingStatusFilter>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeBookingStatusFilter.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [EmployeeBookingStatusFilter] to String,
/// and [decode] dynamic data back to [EmployeeBookingStatusFilter].
class EmployeeBookingStatusFilterTypeTransformer {
  factory EmployeeBookingStatusFilterTypeTransformer() => _instance ??= const EmployeeBookingStatusFilterTypeTransformer._();

  const EmployeeBookingStatusFilterTypeTransformer._();

  String encode(EmployeeBookingStatusFilter data) => data.value;

  /// Decodes a [dynamic value][data] to a EmployeeBookingStatusFilter.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  EmployeeBookingStatusFilter? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'upcoming': return EmployeeBookingStatusFilter.upcoming;
        case r'inProgress': return EmployeeBookingStatusFilter.inProgress;
        case r'completed': return EmployeeBookingStatusFilter.completed;
        case r'canceled': return EmployeeBookingStatusFilter.canceled;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [EmployeeBookingStatusFilterTypeTransformer] instance.
  static EmployeeBookingStatusFilterTypeTransformer? _instance;
}

