import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/core/config/notification_config.dart';

void main() {
  group('NotificationConfig', () {
    test('uses explicit values from environment JSON', () {
      final config = NotificationConfig.fromJson({
        'inAppEnabled': false,
        'webSocketEnabled': false,
        'localNotificationsEnabled': false,
        'pushRegistrationEnabled': true,
        'mockPushTokenEnabled': true,
        'androidChannel': {
          'id': 'custom_id',
          'name': 'Custom Name',
          'description': 'Custom description',
        },
      });

      expect(config.inAppEnabled, isFalse);
      expect(config.webSocketEnabled, isFalse);
      expect(config.localNotificationsEnabled, isFalse);
      expect(config.pushRegistrationEnabled, isTrue);
      expect(config.mockPushTokenEnabled, isTrue);
      expect(config.androidChannelId, 'custom_id');
      expect(config.androidChannelName, 'Custom Name');
      expect(config.androidChannelDescription, 'Custom description');
    });

    test('falls back safely when optional values are missing', () {
      final config = NotificationConfig.fromJson({});

      expect(config.inAppEnabled, NotificationConfig.defaults.inAppEnabled);
      expect(
        config.webSocketEnabled,
        NotificationConfig.defaults.webSocketEnabled,
      );
      expect(
        config.localNotificationsEnabled,
        NotificationConfig.defaults.localNotificationsEnabled,
      );
      expect(
        config.pushRegistrationEnabled,
        NotificationConfig.defaults.pushRegistrationEnabled,
      );
      expect(
        config.mockPushTokenEnabled,
        NotificationConfig.defaults.mockPushTokenEnabled,
      );
      expect(
        config.androidChannelId,
        NotificationConfig.defaults.androidChannelId,
      );
    });
  });
}
