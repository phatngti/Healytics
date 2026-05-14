//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminDashboardNotificationType {
  /// Instantiate a new enum with the provided [value].
  const AdminDashboardNotificationType._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const broadcast = AdminDashboardNotificationType._(r'broadcast');
  static const payment = AdminDashboardNotificationType._(r'payment');
  static const review = AdminDashboardNotificationType._(r'review');
  static const category = AdminDashboardNotificationType._(r'category');
  static const operations = AdminDashboardNotificationType._(r'operations');

  /// List of all possible values in this [enum][AdminDashboardNotificationType].
  static const values = <AdminDashboardNotificationType>[
    broadcast,
    payment,
    review,
    category,
    operations,
  ];

  static AdminDashboardNotificationType? fromJson(dynamic value) => AdminDashboardNotificationTypeTypeTransformer().decode(value);

  static List<AdminDashboardNotificationType> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboardNotificationType>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboardNotificationType.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminDashboardNotificationType] to String,
/// and [decode] dynamic data back to [AdminDashboardNotificationType].
class AdminDashboardNotificationTypeTypeTransformer {
  factory AdminDashboardNotificationTypeTypeTransformer() => _instance ??= const AdminDashboardNotificationTypeTypeTransformer._();

  const AdminDashboardNotificationTypeTypeTransformer._();

  String encode(AdminDashboardNotificationType data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminDashboardNotificationType.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminDashboardNotificationType? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'broadcast': return AdminDashboardNotificationType.broadcast;
        case r'payment': return AdminDashboardNotificationType.payment;
        case r'review': return AdminDashboardNotificationType.review;
        case r'category': return AdminDashboardNotificationType.category;
        case r'operations': return AdminDashboardNotificationType.operations;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminDashboardNotificationTypeTypeTransformer] instance.
  static AdminDashboardNotificationTypeTypeTransformer? _instance;
}

