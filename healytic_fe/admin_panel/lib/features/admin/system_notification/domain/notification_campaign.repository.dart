import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';

abstract class NotificationCampaignRepository {
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

  Future<List<NotificationSegment>> listSegments();

  Future<int?> estimateAudience(NotificationAudience audience);

  Future<NotificationCapability> getCapabilities();
}
