//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminDashboardNotificationPriority {
  /// Instantiate a new enum with the provided [value].
  const AdminDashboardNotificationPriority._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const low = AdminDashboardNotificationPriority._(r'low');
  static const medium = AdminDashboardNotificationPriority._(r'medium');
  static const high = AdminDashboardNotificationPriority._(r'high');
  static const critical = AdminDashboardNotificationPriority._(r'critical');

  /// List of all possible values in this [enum][AdminDashboardNotificationPriority].
  static const values = <AdminDashboardNotificationPriority>[
    low,
    medium,
    high,
    critical,
  ];

  static AdminDashboardNotificationPriority? fromJson(dynamic value) => AdminDashboardNotificationPriorityTypeTransformer().decode(value);

  static List<AdminDashboardNotificationPriority> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboardNotificationPriority>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboardNotificationPriority.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminDashboardNotificationPriority] to String,
/// and [decode] dynamic data back to [AdminDashboardNotificationPriority].
class AdminDashboardNotificationPriorityTypeTransformer {
  factory AdminDashboardNotificationPriorityTypeTransformer() => _instance ??= const AdminDashboardNotificationPriorityTypeTransformer._();

  const AdminDashboardNotificationPriorityTypeTransformer._();

  String encode(AdminDashboardNotificationPriority data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminDashboardNotificationPriority.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminDashboardNotificationPriority? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'low': return AdminDashboardNotificationPriority.low;
        case r'medium': return AdminDashboardNotificationPriority.medium;
        case r'high': return AdminDashboardNotificationPriority.high;
        case r'critical': return AdminDashboardNotificationPriority.critical;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminDashboardNotificationPriorityTypeTransformer] instance.
  static AdminDashboardNotificationPriorityTypeTransformer? _instance;
}

