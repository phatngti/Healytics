import 'package:user_app/features/notifications/domain/'
    'entities/notification.entity.dart';

/// Simulated account creation date used by the mock
/// datasource to mirror the backend's behaviour of only
/// returning broadcasts that were published *after* the
/// user joined the platform.
///
/// Set to 30 days ago so that [notif-b00] (60 days old)
/// is correctly excluded — matching backend logic.
final DateTime kMockAccountCreatedAt =
    DateTime.now().subtract(const Duration(days: 30));

/// Seed notifications used by the mock datasource.
///
/// Ordered from newest to oldest.
/// Broadcasts pre-dating [kMockAccountCreatedAt] must be
/// excluded by the datasource to mirror backend filtering.
final List<NotificationEntity> kMockNotifications = [
  NotificationEntity(
    id: 'notif-001',
    type: NotificationType.bookingConfirmed,
    title: 'Booking Confirmed',
    body: 'Your appointment at An Mien Spa is '
        'confirmed for 10:00 AM.',
    isRead: false,
    createdAt: DateTime.now().subtract(
      const Duration(minutes: 5),
    ),
    data: {'appointmentId': 'apt-1001'},
  ),
  NotificationEntity(
    id: 'notif-002',
    type: NotificationType.newChatMessage,
    title: 'New Message',
    body: 'Dr. Sarah sent you a new message in '
        'consultation chat.',
    isRead: false,
    createdAt: DateTime.now().subtract(
      const Duration(minutes: 25),
    ),
    data: {'conversationId': 'conv-201'},
  ),
  NotificationEntity(
    id: 'notif-003',
    type: NotificationType.paymentSuccess,
    title: 'Payment Successful',
    body: 'Payment of 850,000 VND has been completed.',
    isRead: true,
    readAt: DateTime.now().subtract(
      const Duration(minutes: 30),
    ),
    createdAt: DateTime.now().subtract(
      const Duration(hours: 2),
    ),
    data: {'orderId': 'ord-5001'},
  ),
  NotificationEntity(
    id: 'notif-004',
    type: NotificationType.appointmentReminder,
    title: 'Appointment Reminder',
    body: 'Reminder: You have an appointment '
        'tomorrow at 2:00 PM.',
    isRead: false,
    createdAt: DateTime.now().subtract(
      const Duration(hours: 6),
    ),
    data: {'appointmentId': 'apt-1002'},
  ),
  // Broadcast sent 10 h ago — after join date → visible
  NotificationEntity(
    id: 'notif-005',
    type: NotificationType.systemBroadcast,
    title: 'New Feature Available',
    body: 'Try our new wellness recommendation '
        'dashboard today.',
    isBroadcast: true,
    isRead: true,
    readAt: DateTime.now().subtract(
      const Duration(hours: 8),
    ),
    createdAt: DateTime.now().subtract(
      const Duration(hours: 10),
    ),
  ),
  NotificationEntity(
    id: 'notif-006',
    type: NotificationType.appointmentUpdated,
    title: 'Appointment Updated',
    body: 'Your appointment time has been updated '
        'to 4:30 PM.',
    isRead: false,
    createdAt: DateTime.now().subtract(
      const Duration(days: 1, hours: 2),
    ),
    data: {'appointmentId': 'apt-1003'},
  ),
  NotificationEntity(
    id: 'notif-007',
    type: NotificationType.bookingCancelled,
    title: 'Booking Cancelled',
    body: 'Your booking for 12 Apr was cancelled '
        'by the provider.',
    isRead: true,
    readAt: DateTime.now().subtract(
      const Duration(days: 1),
    ),
    createdAt: DateTime.now().subtract(
      const Duration(days: 1, hours: 6),
    ),
    data: {'appointmentId': 'apt-1004'},
  ),
  // Broadcast sent 2 days ago — after join date → visible
  NotificationEntity(
    id: 'notif-008',
    type: NotificationType.systemMaintenance,
    title: 'Maintenance Notice',
    body: 'System maintenance is scheduled at '
        '1:00 AM this Sunday.',
    isBroadcast: true,
    isRead: false,
    createdAt: DateTime.now().subtract(
      const Duration(days: 2, hours: 1),
    ),
  ),
  NotificationEntity(
    id: 'notif-009',
    type: NotificationType.bookingCompleted,
    title: 'Booking Completed',
    body: 'Thanks for visiting us. Please leave '
        'a quick review.',
    isRead: true,
    readAt: DateTime.now().subtract(
      const Duration(days: 2),
    ),
    createdAt: DateTime.now().subtract(
      const Duration(days: 2, hours: 8),
    ),
    data: {'appointmentId': 'apt-1005'},
  ),
  NotificationEntity(
    id: 'notif-010',
    type: NotificationType.partnerVerified,
    title: 'Partner Verified',
    body: 'Your preferred clinic profile is now '
        'fully verified.',
    isRead: true,
    readAt: DateTime.now().subtract(
      const Duration(days: 3),
    ),
    createdAt: DateTime.now().subtract(
      const Duration(days: 3, hours: 3),
    ),
  ),
  NotificationEntity(
    id: 'notif-011',
    type: NotificationType.paymentFailed,
    title: 'Payment Failed',
    body: 'We could not process your latest '
        'payment. Try again.',
    isRead: false,
    createdAt: DateTime.now().subtract(
      const Duration(days: 4, hours: 4),
    ),
    data: {'orderId': 'ord-5004'},
  ),
  NotificationEntity(
    id: 'notif-012',
    type: NotificationType.partnerRejected,
    title: 'Verification Update',
    body: 'A partner profile update requires '
        'additional documents.',
    isRead: true,
    readAt: DateTime.now().subtract(
      const Duration(days: 5),
    ),
    createdAt: DateTime.now().subtract(
      const Duration(days: 5, hours: 2),
    ),
  ),
  // Broadcast sent 60 days ago — BEFORE join date → filtered out.
  // This entry must never appear in the UI because the mock datasource
  // excludes broadcasts pre-dating [kMockAccountCreatedAt].
  NotificationEntity(
    id: 'notif-b00',
    type: NotificationType.systemBroadcast,
    title: 'Welcome to Healytics (legacy)',
    body: 'This broadcast predates your account '
        'and should not be shown.',
    isBroadcast: true,
    isRead: false,
    createdAt: DateTime.now().subtract(
      const Duration(days: 60),
    ),
  ),
];
