// Domain repository interface — pure Dart.

import 'package:user_app/features/notifications/domain/'
    'entities/notification.entity.dart';

/// Grouped notifications by date section label.
class NotificationSection {
  final String label;
  final List<NotificationEntity> notifications;

  const NotificationSection({
    required this.label,
    required this.notifications,
  });
}

/// Contract for fetching notifications.
abstract class NotificationRepository {
  /// Returns notifications grouped by date section.
  Future<List<NotificationSection>> getNotifications();
}
