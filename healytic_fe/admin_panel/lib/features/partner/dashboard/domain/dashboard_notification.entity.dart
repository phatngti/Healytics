import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_notification.entity.freezed.dart';

/// A notification item for the dashboard notification
/// center.
@freezed
abstract class DashboardNotification with _$DashboardNotification {
  const factory DashboardNotification({
    required String id,
    required String title,
    required String message,

    /// e.g., 'appointment', 'review', 'system', 'alert'
    required String type,
    required DateTime createdAt,
    @Default(false) bool isRead,
  }) = _DashboardNotification;
}
