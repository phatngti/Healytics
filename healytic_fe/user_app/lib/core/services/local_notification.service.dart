import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/config/notification_config.dart';

part 'local_notification.service.g.dart';

final _log = Logger('LocalNotification');

/// OS-level local notification service wrapping
/// [FlutterLocalNotificationsPlugin].
///
/// Provides helpers for:
/// - Chat message notifications
/// - General app notifications (booking, payment…)
/// - Handling notification tap actions
///
/// Initialised lazily via
/// [localNotificationServiceProvider].
class LocalNotificationService {
  LocalNotificationService({required NotificationConfig config})
    : _config = config;

  final NotificationConfig _config;

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  int _nextId = 0;
  String? _initialPayload;

  final _tapController = StreamController<String?>.broadcast();

  /// Stream of notification payloads when the user
  /// taps a notification.
  ///
  /// Payload is a JSON string containing routing
  /// information (e.g. `conversationId`).
  Stream<String?> get onNotificationTapped => _tapController.stream;

  // ── Initialisation ─────────────────────────────

  /// Initialise the plugin with platform settings.
  ///
  /// Safe to call multiple times — subsequent
  /// calls are no-ops.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    if (!_config.localNotificationsEnabled) {
      _log.info('Local notifications disabled by config');
      return;
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    await _captureLaunchPayload();

    // Create Android notification channel.
    if (Platform.isAndroid) {
      await _createAndroidChannel();
    }

    _log.info('Local notification service initialised');
  }

  // ── Permission ─────────────────────────────────

  /// Request notification permission.
  ///
  /// On Android 13+ this triggers the system
  /// permission dialog. On iOS it requests alert,
  /// badge, and sound permissions.
  Future<bool> requestPermission() async {
    if (!_config.localNotificationsEnabled) {
      return false;
    }

    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final granted = await androidPlugin?.requestNotificationsPermission();
      _log.fine(
        'Android notification permission: '
        '$granted',
      );
      return granted ?? false;
    }

    if (Platform.isIOS) {
      final iosPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final granted = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      _log.fine('iOS notification permission: $granted');
      return granted ?? false;
    }

    return false;
  }

  // ── Show Notifications ─────────────────────────

  /// Show a generic OS notification.
  Future<void> showNotification({
    int? id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_config.localNotificationsEnabled) {
      return;
    }

    final notificationId = id ?? _nextId++;

    final androidDetails = AndroidNotificationDetails(
      _config.androidChannelId,
      _config.androidChannelName,
      channelDescription: _config.androidChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _plugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  /// Show an OS notification for an incoming chat
  /// message.
  ///
  /// [senderName] → notification title.
  /// [messagePreview] → notification body.
  /// Routing payload: `conversationId` + `senderId`.
  Future<void> showChatNotification({
    required String senderName,
    required String messagePreview,
    required String conversationId,
    required String senderId,
    String? senderAvatar,
  }) async {
    final payload = jsonEncode({
      'type': 'chat',
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      if (senderAvatar != null) 'senderAvatar': senderAvatar,
    });

    await showNotification(
      title: senderName,
      body: messagePreview,
      payload: payload,
    );
  }

  /// Show an OS notification for a general app
  /// notification (booking, payment, system, etc.).
  Future<void> showGeneralNotification({
    required String title,
    required String body,
    String? notificationId,
    String? type,
    Map<String, dynamic>? data,
  }) async {
    final payload = jsonEncode({
      'type': type ?? 'general',
      if (notificationId != null) 'notificationId': notificationId,
      if (type != null) 'notificationType': type,
      ...?data,
    });

    await showNotification(title: title, body: body, payload: payload);
  }

  String? consumeInitialPayload() {
    final payload = _initialPayload;
    _initialPayload = null;
    return payload;
  }

  // ── Tap Handler ────────────────────────────────

  void _onNotificationResponse(NotificationResponse response) {
    _log.fine('Notification tapped: ${response.payload}');
    _tapController.add(response.payload);
  }

  Future<void> _captureLaunchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      _initialPayload = details?.notificationResponse?.payload;
    }
  }

  // ── Channel Setup ──────────────────────────────

  Future<void> _createAndroidChannel() async {
    final channel = AndroidNotificationChannel(
      _config.androidChannelId,
      _config.androidChannelName,
      description: _config.androidChannelDescription,
      importance: Importance.high,
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(channel);
  }

  /// Release resources.
  void dispose() {
    _tapController.close();
  }
}

// ─── Provider ──────────────────────────────────────

/// Provides and eagerly initialises the local
/// notification service.
///
/// This is a `keepAlive` provider so the service
/// persists for the entire app lifecycle.
@Riverpod(keepAlive: true)
Future<LocalNotificationService> localNotificationService(Ref ref) async {
  final config = NotificationConfig.fromStore();
  final service = LocalNotificationService(config: config);
  await service.initialize();
  if (config.localNotificationsEnabled) {
    await service.requestPermission();
  }

  ref.onDispose(service.dispose);

  return service;
}
