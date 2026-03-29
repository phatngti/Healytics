import 'package:user_app/features/notifications/'
    'domain/entities/notification.entity.dart';
import 'package:user_app/features/notifications/'
    'domain/repositories/notification.repository.dart';

/// Mock notification data matching the HTML
/// reference design (Today + Yesterday sections).
final kMockNotificationSections = <NotificationSection>[
  NotificationSection(
    label: 'Today',
    notifications: [
      NotificationEntity(
        id: '1',
        type: NotificationType.userInteraction,
        title: 'Elena Vance',
        body: 'sent you a message',
        quote: 'Loved the meditation session today!',
        timeAgo: '2m ago',
        avatarUrl:
            'https://i.pravatar.cc/112?img=5',
        actionLabel: 'Reply',
        actionStyle: NotificationActionStyle.tonal,
        createdAt: DateTime.now(),
      ),
      NotificationEntity(
        id: '2',
        type: NotificationType.systemAlert,
        title: 'Order Shipped!',
        body: 'Your Lavender Wellness Kit is on '
            'its way and should arrive by Thursday.',
        timeAgo: '1h ago',
        icon: NotificationIcon.shipping,
        actionLabel: 'Track Order',
        actionStyle: NotificationActionStyle.filled,
        createdAt: DateTime.now().subtract(
          const Duration(hours: 1),
        ),
      ),
      NotificationEntity(
        id: '3',
        type: NotificationType.systemAlert,
        title: 'Gift for a purchase',
        body: "You've unlocked a complimentary "
            '1-month Premium pass for your '
            'recent purchase.',
        timeAgo: '4h ago',
        icon: NotificationIcon.gift,
        actionLabel: 'Learn more',
        actionStyle: NotificationActionStyle.text,
        createdAt: DateTime.now().subtract(
          const Duration(hours: 4),
        ),
      ),
    ],
  ),
  NotificationSection(
    label: 'Yesterday',
    notifications: [
      NotificationEntity(
        id: '4',
        type: NotificationType.systemAlert,
        title: 'Security Update',
        body: "We've added new encryption features "
            'to protect your health data. '
            'Please update your settings.',
        timeAgo: 'Yesterday',
        icon: NotificationIcon.shield,
        actionLabel: 'Update',
        actionStyle: NotificationActionStyle.outlined,
        isRead: true,
        createdAt: DateTime.now().subtract(
          const Duration(days: 1),
        ),
      ),
      NotificationEntity(
        id: '5',
        type: NotificationType.userInteraction,
        title: 'Marcus Chen',
        body: 'shared a new workout',
        quote: 'Morning Yoga Flow - Week 3',
        timeAgo: 'Yesterday',
        avatarUrl:
            'https://i.pravatar.cc/112?img=12',
        actionLabel: 'View Routine',
        actionStyle: NotificationActionStyle.tonal,
        isRead: true,
        createdAt: DateTime.now().subtract(
          const Duration(days: 1),
        ),
      ),
    ],
  ),
];
