import 'dart:convert';

import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';

/// Runtime notification feature switches loaded from the
/// environment store asset.
class NotificationConfig {
  const NotificationConfig({
    required this.inAppEnabled,
    required this.webSocketEnabled,
    required this.localNotificationsEnabled,
    required this.pushRegistrationEnabled,
    required this.mockPushTokenEnabled,
    required this.androidChannelId,
    required this.androidChannelName,
    required this.androidChannelDescription,
  });

  final bool inAppEnabled;
  final bool webSocketEnabled;
  final bool localNotificationsEnabled;
  final bool pushRegistrationEnabled;
  final bool mockPushTokenEnabled;
  final String androidChannelId;
  final String androidChannelName;
  final String androidChannelDescription;

  static const defaults = NotificationConfig(
    inAppEnabled: true,
    webSocketEnabled: true,
    localNotificationsEnabled: true,
    pushRegistrationEnabled: false,
    mockPushTokenEnabled: false,
    androidChannelId: 'healytics_notifications',
    androidChannelName: 'Healytics',
    androidChannelDescription: 'Healytics app notifications',
  );

  static NotificationConfig fromStore() {
    final raw = Store.tryGet(StoreKey.notificationConfig);
    if (raw == null || raw.trim().isEmpty) {
      return defaults;
    }

    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      return defaults;
    }

    return fromJson(decoded.cast<String, dynamic>());
  }

  static NotificationConfig fromJson(Map<String, dynamic> json) {
    final channel = (json['androidChannel'] as Map?)?.cast<String, dynamic>();
    return NotificationConfig(
      inAppEnabled: _bool(json['inAppEnabled'], defaults.inAppEnabled),
      webSocketEnabled: _bool(
        json['webSocketEnabled'],
        defaults.webSocketEnabled,
      ),
      localNotificationsEnabled: _bool(
        json['localNotificationsEnabled'],
        defaults.localNotificationsEnabled,
      ),
      pushRegistrationEnabled: _bool(
        json['pushRegistrationEnabled'],
        defaults.pushRegistrationEnabled,
      ),
      mockPushTokenEnabled: _bool(
        json['mockPushTokenEnabled'],
        defaults.mockPushTokenEnabled,
      ),
      androidChannelId: _string(channel?['id'], defaults.androidChannelId),
      androidChannelName: _string(
        channel?['name'],
        defaults.androidChannelName,
      ),
      androidChannelDescription: _string(
        channel?['description'],
        defaults.androidChannelDescription,
      ),
    );
  }

  static bool _bool(Object? value, bool fallback) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return fallback;
  }

  static String _string(Object? value, String fallback) {
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return fallback;
  }
}
