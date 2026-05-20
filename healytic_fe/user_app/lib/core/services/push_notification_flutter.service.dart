import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/config/notification_config.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';
import 'package:user_app/core/services/local_notification.service.dart';
import 'package:user_app/core/services/ws/ws_models.dart';
import 'package:user_app/features/notifications/'
    'data/datasources/remote/'
    'notification_remote_datasource.dart';

part 'push_notification_flutter.service.g.dart';

final _log = Logger('PushNotificationFlutter');

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    _log.fine('Background FCM message received: ${message.messageId}');
  } catch (_) {
    // Firebase is not configured for this build. The OS still displays
    // notification payloads when native Firebase config exists.
  }
}

Future<void> configureFirebaseMessagingBackgroundHandler() async {
  final config = NotificationConfig.fromStore();
  if (!config.pushRegistrationEnabled || config.mockPushTokenEnabled) {
    return;
  }

  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (error) {
    _log.warning(
      'Firebase Messaging background handler skipped. Add '
      'android/app/google-services.json or iOS GoogleService-Info.plist '
      'to enable out-of-app push notifications. Error: $error',
    );
  }
}

/// Flutter-side push notification service.
class PushNotificationFlutterService {
  PushNotificationFlutterService({
    required NotificationRemoteDatasource datasource,
    required AuthSessionStore authSessionStore,
    required NotificationConfig config,
    required LocalNotificationService localNotificationService,
  }) : _datasource = datasource,
       _authSessionStore = authSessionStore,
       _config = config,
       _localNotificationService = localNotificationService;

  final NotificationRemoteDatasource _datasource;
  final AuthSessionStore _authSessionStore;
  final NotificationConfig _config;
  final LocalNotificationService _localNotificationService;
  bool _initialized = false;
  bool _firebaseAvailable = false;
  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _foregroundSub;
  StreamSubscription<RemoteMessage>? _openedSub;
  Map<String, dynamic>? _initialOpenPayload;

  final _chatPushController = StreamController<WsNewMessageEvent>.broadcast();
  final _openedNotificationController =
      StreamController<Map<String, dynamic>>.broadcast();

  /// Stream of chat messages received via push
  /// notification while the app is in the foreground.
  ///
  /// [ChatMessageToastListener] subscribes to this
  /// alongside the WS stream for inline toasts.
  Stream<WsNewMessageEvent> get onChatPushMessage => _chatPushController.stream;

  /// Stream of push payloads opened by tapping an OS notification.
  Stream<Map<String, dynamic>> get onNotificationOpened =>
      _openedNotificationController.stream;

  /// Initialise the service. Safe to call multiple
  /// times — subsequent calls are no-ops.
  Future<void> initialize() async {
    if (_initialized) return;

    if (!_config.pushRegistrationEnabled) {
      _log.info('Push device registration disabled by config');
      _initialized = true;
      return;
    }

    final userId = _authSessionStore.currentUserId;
    if (userId == null) {
      _log.fine('Push initialization postponed until user is logged in');
      return;
    }

    final granted = await requestPermission();
    if (!granted) {
      _log.warning('Push permission denied');
      _initialized = true;
      return;
    }

    if (_config.mockPushTokenEnabled) {
      final token = await getToken();
      await _registerToken(token);
      _initialized = true;
      return;
    }

    _firebaseAvailable = await _ensureFirebase();
    if (!_firebaseAvailable) {
      _log.warning(
        'Real push registration is enabled, but Firebase client config '
        'is missing for this build',
      );
      _initialized = true;
      return;
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    await _registerCurrentFcmToken();
    _listenForTokenRefresh();
    await _listenForPushMessages();
    _initialized = true;
  }

  /// Handle a foreground push notification containing
  /// a chat message payload.
  ///
  /// Call this from `FirebaseMessaging.onMessage` when
  /// the notification data contains a `type` of
  /// `new_chat_message`:
  ///
  /// ```dart
  /// FirebaseMessaging.onMessage.listen((msg) {
  ///   final data = msg.data;
  ///   if (data['type'] == 'new_chat_message') {
  ///     service.handleChatPushMessage(data);
  ///   }
  /// });
  /// ```
  void handleChatPushMessage(Map<String, dynamic> data) {
    try {
      final event = WsNewMessageEvent(
        id:
            data['messageId'] as String? ??
            'push-${DateTime.now().millisecondsSinceEpoch}',
        conversationId: data['conversationId'] as String? ?? '',
        senderId: data['senderId'] as String? ?? '',
        receiverId: data['receiverId'] as String? ?? '',
        senderName: data['senderName'] as String?,
        senderAvatar: data['senderAvatar'] as String?,
        content: data['content'] as String? ?? data['body'] as String? ?? '',
        messageType: WsMessageType.text,
        createdAt: DateTime.now(),
      );

      _chatPushController.add(event);
      _log.fine(
        'Forwarded chat push to inline toast: '
        '${event.id}',
      );
    } catch (e) {
      _log.warning('Failed to parse chat push payload: $e');
    }
  }

  /// Mock permission request. Returns `true`.
  Future<bool> requestPermission() async {
    if (_config.mockPushTokenEnabled) {
      _log.fine('Mock: permission granted');
      return true;
    }

    if (!await _ensureFirebase()) {
      return false;
    }

    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final granted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
    _log.fine('FCM permission: ${settings.authorizationStatus.name}');
    return granted;
  }

  /// Returns a mock FCM/APNs token.
  Future<String> getToken() async {
    if (_config.mockPushTokenEnabled) {
      final ts = DateTime.now().millisecondsSinceEpoch;
      return 'mock-fcm-token-$ts';
    }

    if (!await _ensureFirebase()) {
      throw StateError('Firebase is not configured');
    }

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.trim().isEmpty) {
      throw StateError('Firebase returned an empty FCM token');
    }
    return token;
  }

  /// Registers the token with the backend.
  Future<void> _registerToken(String token) async {
    final platform = Platform.isIOS ? 'ios' : 'android';
    try {
      await _datasource.registerDevice(token: token, platform: platform);
      _log.info(
        'Registered device token: '
        '${token.substring(0, 20)}... '
        '(platform: $platform)',
      );
    } catch (e) {
      _log.warning('Failed to register device token: $e');
    }
  }

  Future<bool> _ensureFirebase() async {
    if (_firebaseAvailable) return true;
    try {
      await Firebase.initializeApp();
      _firebaseAvailable = true;
      return true;
    } catch (error) {
      _log.warning('Firebase initialization failed: $error');
      return false;
    }
  }

  Future<void> _registerCurrentFcmToken() async {
    try {
      final token = await getToken();
      await _registerToken(token);
    } catch (error) {
      _log.warning('Failed to register FCM token: $error');
    }
  }

  void _listenForTokenRefresh() {
    _tokenRefreshSub ??= FirebaseMessaging.instance.onTokenRefresh.listen((
      token,
    ) {
      if (_authSessionStore.currentUserId == null) return;
      unawaited(_registerToken(token));
    });
  }

  Future<void> _listenForPushMessages() async {
    _foregroundSub ??= FirebaseMessaging.onMessage.listen(
      _handleForegroundMessage,
    );
    _openedSub ??= FirebaseMessaging.onMessageOpenedApp.listen(
      _handleOpenedMessage,
    );

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _initialOpenPayload = _payloadFromRemoteMessage(initialMessage);
    }
  }

  Map<String, dynamic>? consumeInitialOpenPayload() {
    final payload = _initialOpenPayload;
    _initialOpenPayload = null;
    return payload;
  }

  void _handleOpenedMessage(RemoteMessage message) {
    final payload = _payloadFromRemoteMessage(message);
    _openedNotificationController.add(payload);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final payload = _payloadFromRemoteMessage(message);

    if (_isChatPayload(payload)) {
      handleChatPushMessage(payload);
      return;
    }

    final notification = message.notification;
    final title = notification?.title ?? _string(payload['title']);
    final body = notification?.body ?? _string(payload['body']);
    if (title == null || body == null) {
      return;
    }

    unawaited(
      _localNotificationService.showGeneralNotification(
        title: title,
        body: body,
        notificationId: _string(payload['notificationId']),
        type: _string(payload['notificationType'] ?? payload['type']),
        data: payload,
      ),
    );
  }

  Map<String, dynamic> _payloadFromRemoteMessage(RemoteMessage message) {
    return <String, dynamic>{
      ...message.data,
      if (message.messageId != null) 'messageId': message.messageId,
      if (message.notification?.title != null)
        'title': message.notification!.title,
      if (message.notification?.body != null)
        'body': message.notification!.body,
    };
  }

  bool _isChatPayload(Map<String, dynamic> payload) {
    final type = _string(payload['type'] ?? payload['notificationType']);
    return type == 'new_chat_message' || payload['conversationId'] != null;
  }

  String? _string(Object? value) {
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return null;
  }

  /// Release resources.
  void dispose() {
    _tokenRefreshSub?.cancel();
    _foregroundSub?.cancel();
    _openedSub?.cancel();
    _chatPushController.close();
    _openedNotificationController.close();
  }
}

// ─── Provider ──────────────────────────────────────

/// Provides the push notification service instance.
///
/// Initialization is triggered explicitly after
/// authentication succeeds so `/v1/user/devices`
/// is not called during app startup.
@Riverpod(keepAlive: true)
Future<PushNotificationFlutterService> pushNotificationService(Ref ref) async {
  final datasource = ref.read(notificationRemoteDatasourceProvider);
  final authSessionStore = ref.read(authSessionStoreProvider);
  final localNotificationService = await ref.read(
    localNotificationServiceProvider.future,
  );

  final service = PushNotificationFlutterService(
    datasource: datasource,
    authSessionStore: authSessionStore,
    config: NotificationConfig.fromStore(),
    localNotificationService: localNotificationService,
  );
  ref.onDispose(service.dispose);
  return service;
}
