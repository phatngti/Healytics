// Domain repository interface — pure Dart.

import 'package:user_app/features/notifications/domain/'
    'entities/notification.entity.dart';

/// Contract for fetching and mutating notifications.
abstract class NotificationRepository {
  /// Returns a cursor-paginated page of
  /// notifications for the current user.
  Future<NotificationPage> getNotifications({
    int limit = 20,
    String? cursor,
  });

  /// Returns the total unread notification count.
  Future<int> getUnreadCount();

  /// Mark a single notification as read.
  Future<void> markRead(String notificationId);

  /// Mark all notifications as read.
  /// Returns the number of notifications marked.
  Future<int> markAllRead();

  /// Register a device token for push notifications.
  Future<void> registerDevice({
    required String token,
    required String platform,
  });

  /// Unregister a device token (e.g. on logout).
  Future<void> unregisterDevice(String token);
}
