// Domain entity — pure Dart, no Flutter imports.

/// Notification type — matches backend enum values.
enum NotificationType {
  bookingConfirmed,
  bookingCancelled,
  bookingCompleted,
  appointmentReminder,
  appointmentUpdated,
  newChatMessage,
  paymentSuccess,
  paymentFailed,
  systemBroadcast,
  systemMaintenance,
  partnerVerified,
  partnerRejected,
}

/// Represents a single in-app notification.
///
/// This is a pure domain entity aligned with the
/// backend `NotificationResponseDto`. All UI
/// concerns (icons, action buttons, time formatting)
/// are handled in the presentation layer.
class NotificationEntity {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final bool isRead;
  final bool isBroadcast;
  final DateTime createdAt;
  final DateTime? readAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    this.isRead = false,
    this.isBroadcast = false,
    required this.createdAt,
    this.readAt,
  });

  /// Copy with a new read status.
  NotificationEntity copyWith({bool? isRead}) {
    return NotificationEntity(
      id: id,
      type: type,
      title: title,
      body: body,
      data: data,
      isRead: isRead ?? this.isRead,
      isBroadcast: isBroadcast,
      createdAt: createdAt,
      readAt: isRead == true ? DateTime.now() : readAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationEntity &&
          id == other.id &&
          isRead == other.isRead;

  @override
  int get hashCode => Object.hash(id, isRead);
}

/// Paginated notification response.
class NotificationPage {
  final List<NotificationEntity> notifications;
  final bool hasMore;
  final String? nextCursor;

  const NotificationPage({
    required this.notifications,
    required this.hasMore,
    this.nextCursor,
  });
}
