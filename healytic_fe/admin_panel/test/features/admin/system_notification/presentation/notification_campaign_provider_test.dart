import 'package:admin_panel/features/admin/system_notification/datasource/system_notification_impl.repository.dart';
import 'package:admin_panel/features/admin/system_notification/domain/notification_campaign.entity.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/providers/notification_campaign.provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_notification_repository.dart';

void main() {
  test('composer reports title and body validation errors', () async {
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

    await expectLater(composer.sendBroadcast(), throwsException);

    final state = container.read(notificationCampaignComposerProvider);
    expect(state.errorMessage, contains('Notification title is required.'));
    expect(state.errorMessage, contains('Notification body is required.'));
    expect(state.isSubmitting, isFalse);
  });

  test('composer sends broadcast and list state refreshes', () async {
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
    composer.updateTitle('Maintenance starts at 01:00 ICT');
    composer.updateBody(
      'The platform will enter maintenance mode for approximately 60 minutes.',
    );

    final sentCampaign = await composer.sendBroadcast();

    expect(sentCampaign.status, NotificationCampaignStatus.sent);
    expect(sentCampaign.content.title, 'Maintenance starts at 01:00 ICT');

    final campaigns = await container
        .read(notificationCampaignIndexProvider.notifier)
        .getCampaigns();
    expect(campaigns.any((campaign) => campaign.id == sentCampaign.id), isTrue);
  });
}
