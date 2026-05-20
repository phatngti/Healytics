import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_dashboard_notification.entity.freezed.dart';
part 'admin_dashboard_notification.entity.g.dart';

enum AdminDashboardNotificationType {
  broadcast,
  payment,
  review,
  category,
  operations,
}

enum AdminDashboardNotificationPriority { low, medium, high, critical }

@freezed
abstract class AdminDashboardNotificationItem
    with _$AdminDashboardNotificationItem {
  const factory AdminDashboardNotificationItem({
    required String id,
    required String title,
    required String body,
    required DateTime createdAt,
    @Default(AdminDashboardNotificationType.operations)
    AdminDashboardNotificationType type,
    @Default(AdminDashboardNotificationPriority.medium)
    AdminDashboardNotificationPriority priority,
    @Default(false) bool isRead,
    @Default(true) bool isBroadcast,
  }) = _AdminDashboardNotificationItem;

  factory AdminDashboardNotificationItem.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardNotificationItemFromJson(json);
}
