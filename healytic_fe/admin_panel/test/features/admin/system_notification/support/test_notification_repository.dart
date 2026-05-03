import 'package:admin_panel/features/admin/system_notification/datasource/system_notification_impl.repository.dart';
import 'package:admin_panel/features/admin/system_notification/datasource/system_notification_remote.datasource.dart';
import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.repository.dart';

class TestNotificationRemoteDataSource
    implements NotificationCampaignRemoteDataSource {
  TestNotificationRemoteDataSource(this.capability);

  final NotificationCapability capability;
  final NotificationCampaignRemoteDataSourceMock _delegate =
      NotificationCampaignRemoteDataSourceMock();

  @override
  Future<NotificationCampaign> createDraft(NotificationCampaignDraft draft) {
    return _delegate.createDraft(draft);
  }

  @override
  Future<int?> estimateAudience(NotificationAudience audience) {
    return _delegate.estimateAudience(audience);
  }

  @override
  Future<NotificationCampaign> getCampaign(NotificationCampaignId id) {
    return _delegate.getCampaign(id);
  }

  @override
  Future<int> getCampaignTotalRows({
    NotificationCampaignFilter filter = const NotificationCampaignFilter(),
  }) {
    return _delegate.getCampaignTotalRows(filter: filter);
  }

  @override
  Future<NotificationCapability> getCapabilities() async => capability;

  @override
  Future<List<NotificationCampaign>> listCampaigns({
    NotificationCampaignFilter filter = const NotificationCampaignFilter(),
  }) {
    return _delegate.listCampaigns(filter: filter);
  }

  @override
  Future<List<NotificationSegment>> listSegments() {
    return _delegate.listSegments();
  }

  @override
  Future<NotificationCampaign> schedule(
    NotificationCampaignId id,
    NotificationSchedule schedule,
  ) {
    return _delegate.schedule(id, schedule);
  }

  @override
  Future<NotificationCampaign> sendBroadcast({
    required String title,
    required String body,
  }) {
    return _delegate.sendBroadcast(title: title, body: body);
  }

  @override
  Future<NotificationCampaign> sendNow(NotificationCampaignId id) {
    return _delegate.sendNow(id);
  }

  @override
  Future<NotificationCampaign> updateDraft(
    NotificationCampaignId id,
    NotificationCampaignDraft draft,
  ) {
    return _delegate.updateDraft(id, draft);
  }
}

NotificationCampaignRepository buildTestNotificationRepository({
  NotificationCapability capability = const NotificationCapability.mock(),
}) {
  return NotificationCampaignImplRepository(
    dataSource: TestNotificationRemoteDataSource(capability),
  );
}
