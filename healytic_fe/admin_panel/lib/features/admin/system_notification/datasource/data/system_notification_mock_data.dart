import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';

final mockNotificationSegments = <NotificationSegment>[
  const NotificationSegment(
    id: NotificationSegmentId('seg_all_users'),
    name: 'All Users',
    description: 'All customer, partner, and admin accounts across the app.',
    estimatedReach: 12480,
    defaultRole: NotificationRecipientRole.allUsers,
  ),
  const NotificationSegment(
    id: NotificationSegmentId('seg_active_customers'),
    name: 'Active Customers',
    description: 'Users active in the last 30 days with at least one booking.',
    estimatedReach: 8420,
    defaultRole: NotificationRecipientRole.users,
  ),
  const NotificationSegment(
    id: NotificationSegmentId('seg_verified_partners'),
    name: 'Verified Partners',
    description: 'Approved partners with completed operational setup.',
    estimatedReach: 640,
    defaultRole: NotificationRecipientRole.partners,
  ),
  const NotificationSegment(
    id: NotificationSegmentId('seg_admin_ops'),
    name: 'Admin Operations',
    description: 'Internal operations and support administrators.',
    estimatedReach: 18,
    defaultRole: NotificationRecipientRole.admins,
  ),
];

NotificationCampaign buildMockCampaign({
  required NotificationCampaignId id,
  required String name,
  required NotificationCampaignStatus status,
  required String title,
  required String body,
  required DateTime createdAt,
  required DateTime updatedAt,
  DateTime? sentAt,
  DateTime? scheduledAt,
  String createdBy = 'Platform Operations',
  List<NotificationChannel> channels = const [NotificationChannel.inApp],
  NotificationAudience audience = const NotificationAudience(
    presetLabel: 'All Users',
    roles: [NotificationRecipientRole.allUsers],
    estimatedReach: 12480,
  ),
  String previewText = '',
  String ctaLabel = '',
  String deepLinkTarget = '',
  bool failed = false,
}) {
  final effectiveSchedule = NotificationSchedule(
    sendNow: scheduledAt == null,
    scheduledAt: scheduledAt,
    timezone: 'Asia/Ho_Chi_Minh',
  );

  final events = <NotificationActivityEvent>[
    NotificationActivityEvent(
      id: '${id.value}_created',
      label: 'Campaign created',
      detail: 'Workspace draft initialized by $createdBy.',
      occurredAt: createdAt,
    ),
  ];

  if (status == NotificationCampaignStatus.scheduled && scheduledAt != null) {
    events.add(
      NotificationActivityEvent(
        id: '${id.value}_scheduled',
        label: 'Scheduled',
        detail: 'Campaign queued for ${scheduledAt.toIso8601String()}.',
        occurredAt: updatedAt,
      ),
    );
  }

  if (status == NotificationCampaignStatus.sent && sentAt != null) {
    events.add(
      NotificationActivityEvent(
        id: '${id.value}_sent',
        label: 'Sent',
        detail: 'Notification delivered to the system broadcast pipeline.',
        occurredAt: sentAt,
      ),
    );
  }

  if (failed) {
    events.add(
      NotificationActivityEvent(
        id: '${id.value}_failed',
        label: 'Delivery failed',
        detail:
            'Email channel was blocked because the provider integration is not configured.',
        occurredAt: updatedAt,
        isError: true,
      ),
    );
  }

  return NotificationCampaign(
    id: id,
    campaignName: name,
    internalNote: 'Campaign workspace sample for market-style notification UX.',
    status: status,
    channels: channels,
    audience: audience,
    schedule: effectiveSchedule,
    content: NotificationContent(
      title: title,
      body: body,
      previewText: previewText,
      ctaLabel: ctaLabel,
      deepLinkTarget: deepLinkTarget,
    ),
    createdAt: createdAt,
    updatedAt: updatedAt,
    sentAt: sentAt,
    createdBy: createdBy,
    auditTrail: events,
  );
}

final mockNotificationCampaigns = <NotificationCampaign>[
  buildMockCampaign(
    id: NotificationCampaignId('cmp_apr_001'),
    name: 'Golden Week Service Reminder',
    status: NotificationCampaignStatus.sent,
    title: 'Golden Week bookings are now live',
    body:
        'Appointments for the holiday week are filling quickly. Open the app to secure your preferred time slot before peak hours are fully booked.',
    createdAt: DateTime(2026, 4, 10, 8, 30),
    updatedAt: DateTime(2026, 4, 10, 9, 0),
    sentAt: DateTime(2026, 4, 10, 9, 0),
    previewText: 'Booking demand is rising ahead of the holiday week.',
    ctaLabel: 'Book now',
    deepLinkTarget: '/booking',
    audience: NotificationAudience(
      presetLabel: 'Active Customers',
      roles: const [NotificationRecipientRole.users],
      includeSegmentIds: const [NotificationSegmentId('seg_active_customers')],
      estimatedReach: 8420,
    ),
  ),
  buildMockCampaign(
    id: NotificationCampaignId('cmp_apr_002'),
    name: 'Partner Operations Refresh',
    status: NotificationCampaignStatus.scheduled,
    title: 'Dashboard maintenance window tomorrow',
    body:
        'The partner dashboard will enter maintenance mode from 01:00 to 02:00 ICT. Ongoing orders will be processed normally during this window.',
    createdAt: DateTime(2026, 4, 9, 14, 20),
    updatedAt: DateTime(2026, 4, 9, 15, 0),
    scheduledAt: DateTime(2026, 4, 12, 10, 0),
    audience: NotificationAudience(
      presetLabel: 'Verified Partners',
      roles: const [NotificationRecipientRole.partners],
      includeSegmentIds: const [NotificationSegmentId('seg_verified_partners')],
      estimatedReach: 640,
    ),
    channels: const [NotificationChannel.inApp, NotificationChannel.push],
  ),
  buildMockCampaign(
    id: NotificationCampaignId('cmp_apr_003'),
    name: 'Policy Refresh Draft',
    status: NotificationCampaignStatus.draft,
    title: 'Updated cancellation protection now available',
    body:
        'Customers can review the new cancellation coverage policy in the Help Center before their next booking.',
    createdAt: DateTime(2026, 4, 8, 16, 45),
    updatedAt: DateTime(2026, 4, 8, 17, 5),
    previewText:
        'Review the updated protection policy before your next appointment.',
    ctaLabel: 'View policy',
    deepLinkTarget: '/help/policy',
  ),
  buildMockCampaign(
    id: NotificationCampaignId('cmp_apr_004'),
    name: 'Admin SLA Escalation',
    status: NotificationCampaignStatus.failed,
    title: 'Response SLA breach detected',
    body:
        'Three high-priority verification requests have crossed the internal response SLA and require immediate attention.',
    createdAt: DateTime(2026, 4, 7, 11, 5),
    updatedAt: DateTime(2026, 4, 7, 11, 25),
    channels: const [NotificationChannel.inApp, NotificationChannel.email],
    audience: NotificationAudience(
      presetLabel: 'Admin Operations',
      roles: const [NotificationRecipientRole.admins],
      includeSegmentIds: const [NotificationSegmentId('seg_admin_ops')],
      estimatedReach: 18,
    ),
    failed: true,
  ),
  buildMockCampaign(
    id: NotificationCampaignId('cmp_apr_005'),
    name: 'Spring Weekend Promo',
    status: NotificationCampaignStatus.sent,
    title: 'Weekend wellness flash offer starts tonight',
    body:
        'Open the app after 18:00 to unlock limited-time offers on selected wellness bundles and premium recovery services.',
    createdAt: DateTime(2026, 4, 5, 13, 0),
    updatedAt: DateTime(2026, 4, 5, 18, 0),
    sentAt: DateTime(2026, 4, 5, 18, 0),
    previewText: 'Your weekend promotion is live at 18:00 ICT.',
    ctaLabel: 'Explore offers',
    deepLinkTarget: '/offers',
    channels: const [NotificationChannel.inApp, NotificationChannel.push],
  ),
];
