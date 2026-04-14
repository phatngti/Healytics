import 'package:admin_panel/features/admin/system_notification/datasource/system_notification_remote.datasource.dart';
import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationCampaignImplRepository
    implements NotificationCampaignRepository {
  NotificationCampaignImplRepository({required this.dataSource});

  final NotificationCampaignRemoteDataSource dataSource;

  @override
  Future<List<NotificationCampaign>> listCampaigns({
    NotificationCampaignFilter filter = const NotificationCampaignFilter(),
  }) {
    return dataSource.listCampaigns(filter: filter);
  }

  @override
  Future<int> getCampaignTotalRows({
    NotificationCampaignFilter filter = const NotificationCampaignFilter(),
  }) {
    return dataSource.getCampaignTotalRows(filter: filter);
  }

  @override
  Future<NotificationCampaign> getCampaign(NotificationCampaignId id) {
    return dataSource.getCampaign(id);
  }

  @override
  Future<NotificationCampaign> createDraft(NotificationCampaignDraft draft) {
    return dataSource.createDraft(draft);
  }

  @override
  Future<NotificationCampaign> updateDraft(
    NotificationCampaignId id,
    NotificationCampaignDraft draft,
  ) {
    return dataSource.updateDraft(id, draft);
  }

  @override
  Future<NotificationCampaign> sendNow(NotificationCampaignId id) {
    return dataSource.sendNow(id);
  }

  @override
  Future<NotificationCampaign> schedule(
    NotificationCampaignId id,
    NotificationSchedule schedule,
  ) {
    return dataSource.schedule(id, schedule);
  }

  @override
  Future<List<NotificationSegment>> listSegments() {
    return dataSource.listSegments();
  }

  @override
  Future<int?> estimateAudience(NotificationAudience audience) {
    return dataSource.estimateAudience(audience);
  }

  @override
  Future<NotificationCapability> getCapabilities() {
    return dataSource.getCapabilities();
  }
}

final notificationCampaignRepositoryProvider =
    Provider<NotificationCampaignRepository>((ref) {
      final dataSource = ref.read(notificationCampaignRemoteDataSourceProvider);
      return NotificationCampaignImplRepository(dataSource: dataSource);
    });
