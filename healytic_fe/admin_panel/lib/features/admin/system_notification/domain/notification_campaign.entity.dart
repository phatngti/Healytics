extension type const NotificationCampaignId(String value) implements String {
  factory NotificationCampaignId.fromJson(dynamic json) =>
      NotificationCampaignId(json as String);

  String toJson() => value;
}

extension type const NotificationSegmentId(String value) implements String {
  factory NotificationSegmentId.fromJson(dynamic json) =>
      NotificationSegmentId(json as String);

  String toJson() => value;
}

enum NotificationCampaignStatus { draft, scheduled, sent, failed }

extension NotificationCampaignStatusX on NotificationCampaignStatus {
  String get label => switch (this) {
    NotificationCampaignStatus.draft => 'Draft',
    NotificationCampaignStatus.scheduled => 'Scheduled',
    NotificationCampaignStatus.sent => 'Sent',
    NotificationCampaignStatus.failed => 'Failed',
  };
}

enum NotificationChannel { inApp, push, email }

extension NotificationChannelX on NotificationChannel {
  String get label => switch (this) {
    NotificationChannel.inApp => 'In-App',
    NotificationChannel.push => 'Push',
    NotificationChannel.email => 'Email',
  };
}

enum NotificationRecipientRole { allUsers, users, partners, admins }

extension NotificationRecipientRoleX on NotificationRecipientRole {
  String get label => switch (this) {
    NotificationRecipientRole.allUsers => 'All Users',
    NotificationRecipientRole.users => 'Users',
    NotificationRecipientRole.partners => 'Partners',
    NotificationRecipientRole.admins => 'Admins',
  };
}

class NotificationCapability {
  const NotificationCapability({
    required this.supportsDrafts,
    required this.supportsScheduling,
    required this.supportsSegments,
    required this.supportsAudienceEstimate,
    required this.supportsPush,
    required this.supportsEmail,
  });

  const NotificationCapability.real()
    : supportsDrafts = false,
      supportsScheduling = false,
      supportsSegments = false,
      supportsAudienceEstimate = false,
      supportsPush = false,
      supportsEmail = false;

  const NotificationCapability.mock()
    : supportsDrafts = true,
      supportsScheduling = true,
      supportsSegments = true,
      supportsAudienceEstimate = true,
      supportsPush = true,
      supportsEmail = true;

  final bool supportsDrafts;
  final bool supportsScheduling;
  final bool supportsSegments;
  final bool supportsAudienceEstimate;
  final bool supportsPush;
  final bool supportsEmail;

  bool supportsChannel(NotificationChannel channel) => switch (channel) {
    NotificationChannel.inApp => true,
    NotificationChannel.push => supportsPush,
    NotificationChannel.email => supportsEmail,
  };
}

class NotificationSegment {
  const NotificationSegment({
    required this.id,
    required this.name,
    required this.description,
    required this.estimatedReach,
    required this.defaultRole,
  });

  final NotificationSegmentId id;
  final String name;
  final String description;
  final int estimatedReach;
  final NotificationRecipientRole defaultRole;
}

class NotificationAudience {
  const NotificationAudience({
    this.presetLabel = 'All Users',
    this.roles = const [NotificationRecipientRole.allUsers],
    this.includeSegmentIds = const [],
    this.excludeSegmentIds = const [],
    this.estimatedReach,
  });

  final String presetLabel;
  final List<NotificationRecipientRole> roles;
  final List<NotificationSegmentId> includeSegmentIds;
  final List<NotificationSegmentId> excludeSegmentIds;
  final int? estimatedReach;

  NotificationAudience copyWith({
    String? presetLabel,
    List<NotificationRecipientRole>? roles,
    List<NotificationSegmentId>? includeSegmentIds,
    List<NotificationSegmentId>? excludeSegmentIds,
    int? estimatedReach,
    bool clearEstimate = false,
  }) {
    return NotificationAudience(
      presetLabel: presetLabel ?? this.presetLabel,
      roles: roles ?? this.roles,
      includeSegmentIds: includeSegmentIds ?? this.includeSegmentIds,
      excludeSegmentIds: excludeSegmentIds ?? this.excludeSegmentIds,
      estimatedReach: clearEstimate
          ? null
          : estimatedReach ?? this.estimatedReach,
    );
  }
}

class NotificationSchedule {
  const NotificationSchedule({
    this.sendNow = true,
    this.scheduledAt,
    this.timezone = 'Asia/Ho_Chi_Minh',
  });

  final bool sendNow;
  final DateTime? scheduledAt;
  final String timezone;

  NotificationSchedule copyWith({
    bool? sendNow,
    DateTime? scheduledAt,
    String? timezone,
    bool clearScheduledAt = false,
  }) {
    return NotificationSchedule(
      sendNow: sendNow ?? this.sendNow,
      scheduledAt: clearScheduledAt ? null : scheduledAt ?? this.scheduledAt,
      timezone: timezone ?? this.timezone,
    );
  }
}

class NotificationContent {
  const NotificationContent({
    this.title = '',
    this.body = '',
    this.previewText = '',
    this.ctaLabel = '',
    this.deepLinkTarget = '',
  });

  final String title;
  final String body;
  final String previewText;
  final String ctaLabel;
  final String deepLinkTarget;

  NotificationContent copyWith({
    String? title,
    String? body,
    String? previewText,
    String? ctaLabel,
    String? deepLinkTarget,
  }) {
    return NotificationContent(
      title: title ?? this.title,
      body: body ?? this.body,
      previewText: previewText ?? this.previewText,
      ctaLabel: ctaLabel ?? this.ctaLabel,
      deepLinkTarget: deepLinkTarget ?? this.deepLinkTarget,
    );
  }
}

class NotificationActivityEvent {
  const NotificationActivityEvent({
    required this.id,
    required this.label,
    required this.detail,
    required this.occurredAt,
    this.isError = false,
  });

  final String id;
  final String label;
  final String detail;
  final DateTime occurredAt;
  final bool isError;
}

class NotificationCampaignDraft {
  const NotificationCampaignDraft({
    this.campaignName = '',
    this.internalNote = '',
    this.channels = const [NotificationChannel.inApp],
    this.audience = const NotificationAudience(),
    this.schedule = const NotificationSchedule(),
    this.content = const NotificationContent(),
  });

  final String campaignName;
  final String internalNote;
  final List<NotificationChannel> channels;
  final NotificationAudience audience;
  final NotificationSchedule schedule;
  final NotificationContent content;

  NotificationCampaignDraft copyWith({
    String? campaignName,
    String? internalNote,
    List<NotificationChannel>? channels,
    NotificationAudience? audience,
    NotificationSchedule? schedule,
    NotificationContent? content,
  }) {
    return NotificationCampaignDraft(
      campaignName: campaignName ?? this.campaignName,
      internalNote: internalNote ?? this.internalNote,
      channels: channels ?? this.channels,
      audience: audience ?? this.audience,
      schedule: schedule ?? this.schedule,
      content: content ?? this.content,
    );
  }
}

class NotificationCampaign {
  const NotificationCampaign({
    required this.id,
    required this.campaignName,
    required this.internalNote,
    required this.status,
    required this.channels,
    required this.audience,
    required this.schedule,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.auditTrail,
    this.sentAt,
    this.isBroadcast = true,
    this.typeLabel = 'System Broadcast',
  });

  final NotificationCampaignId id;
  final String campaignName;
  final String internalNote;
  final NotificationCampaignStatus status;
  final List<NotificationChannel> channels;
  final NotificationAudience audience;
  final NotificationSchedule schedule;
  final NotificationContent content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? sentAt;
  final String createdBy;
  final List<NotificationActivityEvent> auditTrail;
  final bool isBroadcast;
  final String typeLabel;

  NotificationCampaign copyWith({
    NotificationCampaignId? id,
    String? campaignName,
    String? internalNote,
    NotificationCampaignStatus? status,
    List<NotificationChannel>? channels,
    NotificationAudience? audience,
    NotificationSchedule? schedule,
    NotificationContent? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? sentAt,
    String? createdBy,
    List<NotificationActivityEvent>? auditTrail,
    bool? isBroadcast,
    String? typeLabel,
  }) {
    return NotificationCampaign(
      id: id ?? this.id,
      campaignName: campaignName ?? this.campaignName,
      internalNote: internalNote ?? this.internalNote,
      status: status ?? this.status,
      channels: channels ?? this.channels,
      audience: audience ?? this.audience,
      schedule: schedule ?? this.schedule,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sentAt: sentAt ?? this.sentAt,
      createdBy: createdBy ?? this.createdBy,
      auditTrail: auditTrail ?? this.auditTrail,
      isBroadcast: isBroadcast ?? this.isBroadcast,
      typeLabel: typeLabel ?? this.typeLabel,
    );
  }

  NotificationCampaignDraft toDraft() {
    return NotificationCampaignDraft(
      campaignName: campaignName,
      internalNote: internalNote,
      channels: channels,
      audience: audience,
      schedule: schedule,
      content: content,
    );
  }
}

class NotificationStats {
  const NotificationStats({
    this.sentToday = 0,
    this.scheduled = 0,
    this.drafts = 0,
    this.activeSegments = 0,
  });

  final int sentToday;
  final int scheduled;
  final int drafts;
  final int activeSegments;
}

class NotificationCampaignFilter {
  const NotificationCampaignFilter({
    this.searchQuery = '',
    this.statuses = const {},
    this.channels = const {},
    this.audiencePreset,
    this.startDate,
    this.endDate,
    this.createdBy,
  });

  final String searchQuery;
  final Set<NotificationCampaignStatus> statuses;
  final Set<NotificationChannel> channels;
  final String? audiencePreset;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? createdBy;

  NotificationCampaignFilter copyWith({
    String? searchQuery,
    Set<NotificationCampaignStatus>? statuses,
    Set<NotificationChannel>? channels,
    String? audiencePreset,
    DateTime? startDate,
    DateTime? endDate,
    String? createdBy,
    bool clearAudiencePreset = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearCreatedBy = false,
  }) {
    return NotificationCampaignFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      statuses: statuses ?? this.statuses,
      channels: channels ?? this.channels,
      audiencePreset: clearAudiencePreset
          ? null
          : audiencePreset ?? this.audiencePreset,
      startDate: clearStartDate ? null : startDate ?? this.startDate,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
      createdBy: clearCreatedBy ? null : createdBy ?? this.createdBy,
    );
  }
}
