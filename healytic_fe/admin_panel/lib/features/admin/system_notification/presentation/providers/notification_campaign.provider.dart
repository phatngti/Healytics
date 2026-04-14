import 'package:admin_panel/features/admin/system_notification/datasource/system_notification_impl.repository.dart';
import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationCampaignIndexState {
  const NotificationCampaignIndexState({
    this.filter = const NotificationCampaignFilter(),
    this.activeStatus,
    this.reloadToken = 0,
  });

  final NotificationCampaignFilter filter;
  final NotificationCampaignStatus? activeStatus;
  final int reloadToken;

  NotificationCampaignIndexState copyWith({
    NotificationCampaignFilter? filter,
    NotificationCampaignStatus? activeStatus,
    bool clearActiveStatus = false,
    int? reloadToken,
  }) {
    return NotificationCampaignIndexState(
      filter: filter ?? this.filter,
      activeStatus: clearActiveStatus
          ? null
          : activeStatus ?? this.activeStatus,
      reloadToken: reloadToken ?? this.reloadToken,
    );
  }

  NotificationCampaignFilter get effectiveFilter {
    if (activeStatus == null) return filter.copyWith(statuses: {});
    return filter.copyWith(statuses: {activeStatus!});
  }
}

class NotificationCampaignIndexNotifier
    extends Notifier<NotificationCampaignIndexState> {
  @override
  NotificationCampaignIndexState build() {
    return const NotificationCampaignIndexState();
  }

  Future<int> getTotalRows() {
    return ref
        .read(notificationCampaignRepositoryProvider)
        .getCampaignTotalRows(filter: state.effectiveFilter);
  }

  Future<List<NotificationCampaign>> getCampaigns({
    int? startingAt,
    int? count,
  }) async {
    final campaigns = await ref
        .read(notificationCampaignRepositoryProvider)
        .listCampaigns(filter: state.effectiveFilter);

    final offset = startingAt ?? 0;
    final limit = count ?? campaigns.length;
    final end = (offset + limit).clamp(0, campaigns.length);

    return campaigns.sublist(offset.clamp(0, campaigns.length), end);
  }

  void setActiveStatus(NotificationCampaignStatus? status) {
    state = state.copyWith(
      activeStatus: status,
      clearActiveStatus: status == null,
      reloadToken: state.reloadToken + 1,
    );
  }

  void setSearchQuery(String value) {
    state = state.copyWith(
      filter: state.filter.copyWith(searchQuery: value),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setChannelFilter(NotificationChannel? channel) {
    state = state.copyWith(
      filter: state.filter.copyWith(channels: channel == null ? {} : {channel}),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setAudiencePreset(String? value) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        audiencePreset: value,
        clearAudiencePreset: value == null,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setCreatedBy(String? value) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        createdBy: value,
        clearCreatedBy: value == null || value.isEmpty,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setStartDate(DateTime? value) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        startDate: value,
        clearStartDate: value == null,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setEndDate(DateTime? value) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        endDate: value,
        clearEndDate: value == null,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void resetFilters() {
    state = NotificationCampaignIndexState(reloadToken: state.reloadToken + 1);
  }

  void bumpReload() {
    state = state.copyWith(reloadToken: state.reloadToken + 1);
  }
}

final notificationCampaignIndexProvider =
    NotifierProvider<
      NotificationCampaignIndexNotifier,
      NotificationCampaignIndexState
    >(NotificationCampaignIndexNotifier.new);

final notificationCapabilitiesProvider = FutureProvider<NotificationCapability>(
  (ref) async {
    return ref.read(notificationCampaignRepositoryProvider).getCapabilities();
  },
);

final notificationSegmentsProvider = FutureProvider<List<NotificationSegment>>((
  ref,
) async {
  return ref.read(notificationCampaignRepositoryProvider).listSegments();
});

final notificationCampaignStatsProvider = FutureProvider<NotificationStats>((
  ref,
) async {
  ref.watch(
    notificationCampaignIndexProvider.select((state) => state.reloadToken),
  );
  final campaigns = await ref
      .read(notificationCampaignRepositoryProvider)
      .listCampaigns();
  final segments = await ref
      .read(notificationCampaignRepositoryProvider)
      .listSegments();
  final today = DateTime.now();

  final sentToday = campaigns.where((campaign) {
    final sentAt = campaign.sentAt;
    if (sentAt == null) return false;
    return sentAt.year == today.year &&
        sentAt.month == today.month &&
        sentAt.day == today.day;
  }).length;

  return NotificationStats(
    sentToday: sentToday,
    scheduled: campaigns
        .where(
          (campaign) => campaign.status == NotificationCampaignStatus.scheduled,
        )
        .length,
    drafts: campaigns
        .where(
          (campaign) => campaign.status == NotificationCampaignStatus.draft,
        )
        .length,
    activeSegments: segments.length,
  );
});

class NotificationCampaignComposerState {
  const NotificationCampaignComposerState({
    this.draft = const NotificationCampaignDraft(),
    this.draftId,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final NotificationCampaignDraft draft;
  final NotificationCampaignId? draftId;
  final bool isSubmitting;
  final String? errorMessage;

  NotificationCampaignComposerState copyWith({
    NotificationCampaignDraft? draft,
    NotificationCampaignId? draftId,
    bool clearDraftId = false,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationCampaignComposerState(
      draft: draft ?? this.draft,
      draftId: clearDraftId ? null : draftId ?? this.draftId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  List<String> validationIssues(NotificationCapability capability) {
    final issues = <String>[];
    if (draft.campaignName.trim().isEmpty) {
      issues.add('Campaign name is required.');
    }
    if (draft.content.title.trim().isEmpty) {
      issues.add('Notification title is required.');
    }
    if (draft.content.body.trim().isEmpty) {
      issues.add('Notification body is required.');
    }
    if (draft.channels.isEmpty) {
      issues.add('At least one channel must be selected.');
    }
    final unsupportedChannels = draft.channels
        .where((channel) => !capability.supportsChannel(channel))
        .toList();
    if (unsupportedChannels.isNotEmpty) {
      issues.add(
        'Selected channels are not available in the current backend capability set.',
      );
    }
    if (!draft.schedule.sendNow && draft.schedule.scheduledAt == null) {
      issues.add('Choose a scheduled send time or switch back to Send now.');
    }
    return issues;
  }
}

class NotificationCampaignComposerNotifier
    extends Notifier<NotificationCampaignComposerState> {
  @override
  NotificationCampaignComposerState build() {
    return const NotificationCampaignComposerState();
  }

  void updateCampaignName(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(campaignName: value),
      clearError: true,
    );
  }

  void updateInternalNote(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(internalNote: value),
      clearError: true,
    );
  }

  void updateTitle(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        content: state.draft.content.copyWith(title: value),
      ),
      clearError: true,
    );
  }

  void updateBody(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        content: state.draft.content.copyWith(body: value),
      ),
      clearError: true,
    );
  }

  void updatePreviewText(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        content: state.draft.content.copyWith(previewText: value),
      ),
      clearError: true,
    );
  }

  void updateCtaLabel(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        content: state.draft.content.copyWith(ctaLabel: value),
      ),
      clearError: true,
    );
  }

  void updateDeepLinkTarget(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        content: state.draft.content.copyWith(deepLinkTarget: value),
      ),
      clearError: true,
    );
  }

  void toggleChannel(NotificationChannel channel, bool selected) {
    final nextChannels = [...state.draft.channels];
    if (selected) {
      if (!nextChannels.contains(channel)) nextChannels.add(channel);
    } else {
      nextChannels.remove(channel);
    }
    state = state.copyWith(
      draft: state.draft.copyWith(channels: nextChannels),
      clearError: true,
    );
  }

  void updateAudience({
    String? presetLabel,
    List<NotificationRecipientRole>? roles,
    List<NotificationSegmentId>? includeSegments,
    List<NotificationSegmentId>? excludeSegments,
    int? estimatedReach,
  }) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        audience: state.draft.audience.copyWith(
          presetLabel: presetLabel,
          roles: roles,
          includeSegmentIds: includeSegments,
          excludeSegmentIds: excludeSegments,
          estimatedReach: estimatedReach,
          clearEstimate: estimatedReach == null,
        ),
      ),
      clearError: true,
    );
  }

  void updateScheduleMode(bool sendNow) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        schedule: state.draft.schedule.copyWith(
          sendNow: sendNow,
          clearScheduledAt: sendNow,
        ),
      ),
      clearError: true,
    );
  }

  void updateScheduledAt(DateTime? value) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        schedule: state.draft.schedule.copyWith(
          sendNow: value == null,
          scheduledAt: value,
        ),
      ),
      clearError: true,
    );
  }

  Future<NotificationCampaign> saveDraft() async {
    final repo = ref.read(notificationCampaignRepositoryProvider);
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final saved = state.draftId == null
          ? await repo.createDraft(state.draft)
          : await repo.updateDraft(state.draftId!, state.draft);
      state = state.copyWith(
        draftId: saved.id,
        draft: saved.toDraft(),
        isSubmitting: false,
        clearError: true,
      );
      return saved;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  Future<NotificationCampaign> sendNow(
    NotificationCapability capability,
  ) async {
    final issues = state.validationIssues(capability);
    if (issues.isNotEmpty) {
      final message = issues.join('\n');
      state = state.copyWith(errorMessage: message);
      throw Exception(message);
    }

    final saved = await saveDraft();
    final repo = ref.read(notificationCampaignRepositoryProvider);
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final sent = await repo.sendNow(saved.id);
      state = state.copyWith(isSubmitting: false, clearError: true);
      return sent;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }

  Future<NotificationCampaign> scheduleDraft(
    NotificationCapability capability,
  ) async {
    final issues = state.validationIssues(capability);
    if (issues.isNotEmpty) {
      final message = issues.join('\n');
      state = state.copyWith(errorMessage: message);
      throw Exception(message);
    }

    final saved = await saveDraft();
    final repo = ref.read(notificationCampaignRepositoryProvider);
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final scheduled = await repo.schedule(saved.id, state.draft.schedule);
      state = state.copyWith(
        draftId: scheduled.id,
        draft: scheduled.toDraft(),
        isSubmitting: false,
        clearError: true,
      );
      return scheduled;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString(),
      );
      rethrow;
    }
  }
}

final notificationCampaignComposerProvider =
    NotifierProvider<
      NotificationCampaignComposerNotifier,
      NotificationCampaignComposerState
    >(NotificationCampaignComposerNotifier.new);

final notificationCampaignDetailProvider =
    FutureProvider.family<NotificationCampaign, NotificationCampaignId>((
      ref,
      id,
    ) async {
      ref.watch(
        notificationCampaignIndexProvider.select((state) => state.reloadToken),
      );
      return ref.read(notificationCampaignRepositoryProvider).getCampaign(id);
    });
