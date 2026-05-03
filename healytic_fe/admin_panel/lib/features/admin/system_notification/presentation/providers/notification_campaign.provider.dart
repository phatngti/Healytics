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
    this.title = '',
    this.body = '',
    this.isSubmitting = false,
    this.errorMessage,
  });

  final String title;
  final String body;
  final bool isSubmitting;
  final String? errorMessage;

  NotificationCampaignComposerState copyWith({
    String? title,
    String? body,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationCampaignComposerState(
      title: title ?? this.title,
      body: body ?? this.body,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  List<String> validationIssues() {
    final issues = <String>[];
    if (title.trim().isEmpty) {
      issues.add('Notification title is required.');
    }
    if (body.trim().isEmpty) {
      issues.add('Notification body is required.');
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

  void updateTitle(String value) {
    state = state.copyWith(title: value, clearError: true);
  }

  void updateBody(String value) {
    state = state.copyWith(body: value, clearError: true);
  }

  Future<NotificationCampaign> sendBroadcast() async {
    final issues = state.validationIssues();
    if (issues.isNotEmpty) {
      final message = issues.join('\n');
      state = state.copyWith(errorMessage: message);
      throw Exception(message);
    }

    final repo = ref.read(notificationCampaignRepositoryProvider);
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final sent = await repo.sendBroadcast(
        title: state.title,
        body: state.body,
      );
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
