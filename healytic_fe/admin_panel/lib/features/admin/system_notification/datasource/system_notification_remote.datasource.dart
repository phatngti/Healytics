import 'package:admin_openapi/api.dart';
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/admin/system_notification/datasource/data/system_notification_mock_data.dart';
import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

abstract class NotificationCampaignRemoteDataSource {
  Future<List<NotificationCampaign>> listCampaigns({
    NotificationCampaignFilter filter = const NotificationCampaignFilter(),
  });

  Future<int> getCampaignTotalRows({
    NotificationCampaignFilter filter = const NotificationCampaignFilter(),
  });

  Future<NotificationCampaign> getCampaign(NotificationCampaignId id);

  Future<NotificationCampaign> createDraft(NotificationCampaignDraft draft);

  Future<NotificationCampaign> updateDraft(
    NotificationCampaignId id,
    NotificationCampaignDraft draft,
  );

  Future<NotificationCampaign> sendNow(NotificationCampaignId id);

  Future<NotificationCampaign> schedule(
    NotificationCampaignId id,
    NotificationSchedule schedule,
  );

  Future<NotificationCampaign> sendBroadcast({
    required String title,
    required String body,
  });

  Future<List<NotificationSegment>> listSegments();

  Future<int?> estimateAudience(NotificationAudience audience);

  Future<NotificationCapability> getCapabilities();
}

class NotificationCampaignRemoteDataSourceImpl
    implements NotificationCampaignRemoteDataSource {
  NotificationCampaignRemoteDataSourceImpl({required this.apiService});

  final ApiService apiService;
  final _uuid = const Uuid();
  final Map<String, NotificationCampaign> _ephemeralDrafts = {};
  final Map<String, NotificationCampaign> _localSent = {};
  NotificationCapability? _capabilitiesCache;

  AdminNotificationsApi get _notificationsApi =>
      AdminNotificationsApi(apiService.clientFor(ServicePrefix.backend));

  @override
  Future<List<NotificationCampaign>> listCampaigns({
    NotificationCampaignFilter filter = const NotificationCampaignFilter(),
  }) async {
    final dtos = await _notificationsApi
        .adminNotificationControllerGetBroadcasts();
    final items = [
      ..._localSent.values,
      ...(dtos ?? <NotificationResponseDto>[]).map(_mapResponseToCampaign),
    ];
    final deduped = <String, NotificationCampaign>{};
    for (final campaign in items) {
      deduped[campaign.id.value] = campaign;
    }
    return _applyFilter(deduped.values.toList(), filter);
  }

  @override
  Future<int> getCampaignTotalRows({
    NotificationCampaignFilter filter = const NotificationCampaignFilter(),
  }) async {
    return (await listCampaigns(filter: filter)).length;
  }

  @override
  Future<NotificationCampaign> getCampaign(NotificationCampaignId id) async {
    final local = _localSent[id.value] ?? _ephemeralDrafts[id.value];
    if (local != null) return local;

    final campaigns = await listCampaigns();
    return campaigns.firstWhere(
      (campaign) => campaign.id == id,
      orElse: () => throw Exception('Campaign not found: ${id.value}'),
    );
  }

  @override
  Future<NotificationCampaign> createDraft(
    NotificationCampaignDraft draft,
  ) async {
    final campaign = NotificationCampaign(
      id: NotificationCampaignId('draft_${_uuid.v4()}'),
      campaignName: draft.campaignName.trim().isEmpty
          ? 'Untitled campaign'
          : draft.campaignName.trim(),
      internalNote: draft.internalNote,
      status: NotificationCampaignStatus.draft,
      channels: draft.channels,
      audience: draft.audience,
      schedule: draft.schedule,
      content: draft.content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: 'Current Admin',
      auditTrail: [
        NotificationActivityEvent(
          id: _uuid.v4(),
          label: 'Composer initialized',
          detail: 'Local working draft created for the admin workspace.',
          occurredAt: DateTime.now(),
        ),
      ],
    );
    _ephemeralDrafts[campaign.id.value] = campaign;
    return campaign;
  }

  @override
  Future<NotificationCampaign> updateDraft(
    NotificationCampaignId id,
    NotificationCampaignDraft draft,
  ) async {
    final existing = _ephemeralDrafts[id.value];
    if (existing == null) {
      throw Exception('Draft not found: ${id.value}');
    }
    final updated = existing.copyWith(
      campaignName: draft.campaignName.trim().isEmpty
          ? existing.campaignName
          : draft.campaignName.trim(),
      internalNote: draft.internalNote,
      channels: draft.channels,
      audience: draft.audience,
      schedule: draft.schedule,
      content: draft.content,
      updatedAt: DateTime.now(),
      auditTrail: [
        ...existing.auditTrail,
        NotificationActivityEvent(
          id: _uuid.v4(),
          label: 'Draft updated',
          detail: 'Composer values synced to the local draft cache.',
          occurredAt: DateTime.now(),
        ),
      ],
    );
    _ephemeralDrafts[id.value] = updated;
    return updated;
  }

  @override
  Future<NotificationCampaign> sendNow(NotificationCampaignId id) async {
    final draft = _ephemeralDrafts[id.value];
    if (draft == null) {
      throw Exception('Draft not found for send: ${id.value}');
    }

    final response = await _notificationsApi
        .adminNotificationControllerCreateBroadcast(
          CreateBroadcastDto(
            title: draft.content.title.trim(),
            body: draft.content.body.trim(),
          ),
        );

    if (response == null) {
      throw Exception('Failed to send system notification');
    }

    final sent = _mapResponseToCampaign(response).copyWith(
      campaignName: draft.campaignName,
      internalNote: draft.internalNote,
      channels: draft.channels,
      audience: draft.audience.copyWith(
        presetLabel: 'All Users',
        roles: const [NotificationRecipientRole.allUsers],
        clearEstimate: true,
      ),
      content: draft.content,
      createdBy: 'Current Admin',
      auditTrail: [
        ...draft.auditTrail,
        NotificationActivityEvent(
          id: _uuid.v4(),
          label: 'Sent',
          detail: 'Broadcast accepted by the backend notification service.',
          occurredAt: response.createdAt,
        ),
      ],
    );

    _ephemeralDrafts.remove(id.value);
    _localSent[sent.id.value] = sent;

    return sent;
  }

  @override
  Future<NotificationCampaign> schedule(
    NotificationCampaignId id,
    NotificationSchedule schedule,
  ) async {
    throw UnsupportedError('Scheduling is not available in the current API.');
  }

  @override
  Future<NotificationCampaign> sendBroadcast({
    required String title,
    required String body,
  }) async {
    final response = await _notificationsApi
        .adminNotificationControllerCreateBroadcast(
          CreateBroadcastDto(title: title.trim(), body: body.trim()),
        );

    if (response == null) {
      throw Exception('Failed to send system notification');
    }

    final sent = _mapResponseToCampaign(response);
    _localSent[sent.id.value] = sent;
    return sent;
  }

  @override
  Future<List<NotificationSegment>> listSegments() async {
    return const [
      NotificationSegment(
        id: NotificationSegmentId('seg_all_users'),
        name: 'All Users',
        description: 'Whole platform audience for real-mode broadcast sending.',
        estimatedReach: 0,
        defaultRole: NotificationRecipientRole.allUsers,
      ),
      NotificationSegment(
        id: NotificationSegmentId('seg_partners'),
        name: 'Partners',
        description:
            'Visible as a future segmentation placeholder in the workspace.',
        estimatedReach: 0,
        defaultRole: NotificationRecipientRole.partners,
      ),
      NotificationSegment(
        id: NotificationSegmentId('seg_admins'),
        name: 'Admins',
        description:
            'Visible as a future segmentation placeholder in the workspace.',
        estimatedReach: 0,
        defaultRole: NotificationRecipientRole.admins,
      ),
    ];
  }

  @override
  Future<int?> estimateAudience(NotificationAudience audience) async {
    if (!(await getCapabilities()).supportsAudienceEstimate) {
      return null;
    }
    return audience.estimatedReach;
  }

  @override
  Future<NotificationCapability> getCapabilities() async {
    return _capabilitiesCache ??= const NotificationCapability.real();
  }

  NotificationCampaign _mapResponseToCampaign(NotificationResponseDto dto) {
    final createdAt = dto.createdAt.toLocal();
    return NotificationCampaign(
      id: NotificationCampaignId(dto.id),
      campaignName: dto.title,
      internalNote: 'Sent through admin broadcast API.',
      status: NotificationCampaignStatus.sent,
      channels: const [NotificationChannel.inApp],
      audience: const NotificationAudience(
        presetLabel: 'All Users',
        roles: [NotificationRecipientRole.allUsers],
      ),
      schedule: const NotificationSchedule(sendNow: true),
      content: NotificationContent(title: dto.title, body: dto.body),
      createdAt: createdAt,
      updatedAt: createdAt,
      sentAt: createdAt,
      createdBy: 'Current Admin',
      auditTrail: [
        NotificationActivityEvent(
          id: '${dto.id}_sent',
          label: 'Sent',
          detail: 'Broadcast stored in backend audit history.',
          occurredAt: createdAt,
        ),
      ],
      typeLabel: dto.type.value,
      isBroadcast: dto.isBroadcast,
    );
  }
}

class NotificationCampaignRemoteDataSourceMock
    implements NotificationCampaignRemoteDataSource {
  final _uuid = const Uuid();
  final Map<String, NotificationCampaign> _campaigns = {
    for (final campaign in mockNotificationCampaigns)
      campaign.id.value: campaign,
  };

  @override
  Future<List<NotificationCampaign>> listCampaigns({
    NotificationCampaignFilter filter = const NotificationCampaignFilter(),
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _applyFilter(_campaigns.values.toList(), filter);
  }

  @override
  Future<int> getCampaignTotalRows({
    NotificationCampaignFilter filter = const NotificationCampaignFilter(),
  }) async {
    return (await listCampaigns(filter: filter)).length;
  }

  @override
  Future<NotificationCampaign> getCampaign(NotificationCampaignId id) async {
    final item = _campaigns[id.value];
    if (item == null) throw Exception('Campaign not found: ${id.value}');
    return item;
  }

  @override
  Future<NotificationCampaign> createDraft(
    NotificationCampaignDraft draft,
  ) async {
    final now = DateTime.now();
    final id = NotificationCampaignId('cmp_${_uuid.v4()}');
    final campaign = NotificationCampaign(
      id: id,
      campaignName: draft.campaignName.trim().isEmpty
          ? 'Untitled campaign'
          : draft.campaignName.trim(),
      internalNote: draft.internalNote,
      status: draft.schedule.sendNow
          ? NotificationCampaignStatus.draft
          : NotificationCampaignStatus.scheduled,
      channels: draft.channels,
      audience: draft.audience,
      schedule: draft.schedule,
      content: draft.content,
      createdAt: now,
      updatedAt: now,
      createdBy: 'Platform Operations',
      auditTrail: [
        NotificationActivityEvent(
          id: _uuid.v4(),
          label: 'Draft created',
          detail: 'Campaign saved in the notification workspace.',
          occurredAt: now,
        ),
      ],
    );
    _campaigns[id.value] = campaign;
    return campaign;
  }

  @override
  Future<NotificationCampaign> updateDraft(
    NotificationCampaignId id,
    NotificationCampaignDraft draft,
  ) async {
    final existing = _campaigns[id.value];
    if (existing == null) throw Exception('Campaign not found: ${id.value}');
    final updated = existing.copyWith(
      campaignName: draft.campaignName,
      internalNote: draft.internalNote,
      channels: draft.channels,
      audience: draft.audience,
      schedule: draft.schedule,
      content: draft.content,
      updatedAt: DateTime.now(),
      status: draft.schedule.sendNow
          ? NotificationCampaignStatus.draft
          : NotificationCampaignStatus.scheduled,
    );
    _campaigns[id.value] = updated;
    return updated;
  }

  @override
  Future<NotificationCampaign> sendNow(NotificationCampaignId id) async {
    final campaign = await getCampaign(id);
    final now = DateTime.now();
    final sent = campaign.copyWith(
      status: NotificationCampaignStatus.sent,
      sentAt: now,
      updatedAt: now,
      schedule: campaign.schedule.copyWith(
        sendNow: true,
        clearScheduledAt: true,
      ),
      auditTrail: [
        ...campaign.auditTrail,
        NotificationActivityEvent(
          id: _uuid.v4(),
          label: 'Sent',
          detail: 'Mock delivery completed across the selected channels.',
          occurredAt: now,
        ),
      ],
    );
    _campaigns[id.value] = sent;
    return sent;
  }

  @override
  Future<NotificationCampaign> schedule(
    NotificationCampaignId id,
    NotificationSchedule schedule,
  ) async {
    final campaign = await getCampaign(id);
    final updated = campaign.copyWith(
      status: NotificationCampaignStatus.scheduled,
      schedule: schedule.copyWith(sendNow: false),
      updatedAt: DateTime.now(),
      auditTrail: [
        ...campaign.auditTrail,
        NotificationActivityEvent(
          id: _uuid.v4(),
          label: 'Scheduled',
          detail: 'Campaign queued for ${schedule.scheduledAt}.',
          occurredAt: DateTime.now(),
        ),
      ],
    );
    _campaigns[id.value] = updated;
    return updated;
  }

  @override
  Future<NotificationCampaign> sendBroadcast({
    required String title,
    required String body,
  }) async {
    final trimmedTitle = title.trim();
    final draft = NotificationCampaignDraft(
      campaignName: trimmedTitle.isEmpty
          ? 'Untitled notification'
          : trimmedTitle,
      content: NotificationContent(title: trimmedTitle, body: body.trim()),
    );
    final campaign = await createDraft(draft);
    return sendNow(campaign.id);
  }

  @override
  Future<List<NotificationSegment>> listSegments() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return mockNotificationSegments;
  }

  @override
  Future<int?> estimateAudience(NotificationAudience audience) async {
    final included = audience.includeSegmentIds
        .map(
          (id) => mockNotificationSegments.firstWhere(
            (segment) => segment.id == id,
            orElse: () => const NotificationSegment(
              id: NotificationSegmentId('unknown'),
              name: 'Unknown',
              description: '',
              estimatedReach: 0,
              defaultRole: NotificationRecipientRole.allUsers,
            ),
          ),
        )
        .fold<int>(0, (total, segment) => total + segment.estimatedReach);

    if (included > 0) return included;
    if (audience.roles.contains(NotificationRecipientRole.partners)) return 640;
    if (audience.roles.contains(NotificationRecipientRole.admins)) return 18;
    if (audience.roles.contains(NotificationRecipientRole.users)) return 8420;
    return 12480;
  }

  @override
  Future<NotificationCapability> getCapabilities() async {
    return const NotificationCapability.mock();
  }
}

List<NotificationCampaign> _applyFilter(
  List<NotificationCampaign> campaigns,
  NotificationCampaignFilter filter,
) {
  final normalizedSearch = filter.searchQuery.trim().toLowerCase();

  final items =
      campaigns.where((campaign) {
        final matchesSearch =
            normalizedSearch.isEmpty ||
            campaign.campaignName.toLowerCase().contains(normalizedSearch) ||
            campaign.content.title.toLowerCase().contains(normalizedSearch) ||
            campaign.content.body.toLowerCase().contains(normalizedSearch) ||
            campaign.createdBy.toLowerCase().contains(normalizedSearch);

        final matchesStatus =
            filter.statuses.isEmpty ||
            filter.statuses.contains(campaign.status);

        final matchesChannel =
            filter.channels.isEmpty ||
            campaign.channels.any(filter.channels.contains);

        final matchesAudience =
            filter.audiencePreset == null ||
            campaign.audience.presetLabel == filter.audiencePreset;

        final matchesCreator =
            filter.createdBy == null || campaign.createdBy == filter.createdBy;

        final referenceDate =
            campaign.sentAt ??
            campaign.schedule.scheduledAt ??
            campaign.updatedAt;
        final matchesStart =
            filter.startDate == null ||
            !referenceDate.isBefore(_startOfDay(filter.startDate!));
        final matchesEnd =
            filter.endDate == null ||
            !referenceDate.isAfter(_endOfDay(filter.endDate!));

        return matchesSearch &&
            matchesStatus &&
            matchesChannel &&
            matchesAudience &&
            matchesCreator &&
            matchesStart &&
            matchesEnd;
      }).toList()..sort((a, b) {
        final left = a.sentAt ?? a.schedule.scheduledAt ?? a.updatedAt;
        final right = b.sentAt ?? b.schedule.scheduledAt ?? b.updatedAt;
        return right.compareTo(left);
      });

  return items;
}

DateTime _startOfDay(DateTime date) =>
    DateTime(date.year, date.month, date.day);

DateTime _endOfDay(DateTime date) =>
    DateTime(date.year, date.month, date.day, 23, 59, 59);

final notificationCampaignRemoteDataSourceProvider =
    Provider<NotificationCampaignRemoteDataSource>((ref) {
      final isMock = Store.get(StoreKey.mockFlag, false);
      if (isMock) {
        return NotificationCampaignRemoteDataSourceMock();
      }

      final apiService = ref.read(apiServiceProvider);
      return NotificationCampaignRemoteDataSourceImpl(apiService: apiService);
    });
