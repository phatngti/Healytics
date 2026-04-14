import 'package:admin_panel/features/admin/system_notification/datasource/system_notification_impl.repository.dart';
import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/providers/notification_campaign.provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_notification_repository.dart';

void main() {
  test('composer sends campaign and list state refreshes', () async {
    final container = ProviderContainer(
      overrides: [
        notificationCampaignRepositoryProvider.overrideWithValue(
          buildTestNotificationRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final composer = container.read(
      notificationCampaignComposerProvider.notifier,
    );
    composer.updateCampaignName('Critical maintenance notice');
    composer.updateTitle('Maintenance starts at 01:00 ICT');
    composer.updateBody(
      'The platform will enter maintenance mode for approximately 60 minutes.',
    );

    final capability = await container.read(
      notificationCapabilitiesProvider.future,
    );
    final sentCampaign = await composer.sendNow(capability);

    expect(sentCampaign.status, NotificationCampaignStatus.sent);
    expect(sentCampaign.content.title, 'Maintenance starts at 01:00 ICT');

    final campaigns = await container
        .read(notificationCampaignIndexProvider.notifier)
        .getCampaigns();
    expect(campaigns.any((campaign) => campaign.id == sentCampaign.id), isTrue);
  });
}
