import 'dart:async';
import 'dart:io' show Platform;

import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';
import 'package:user_app/core/services/ws/ws_models.dart';
import 'package:user_app/features/notifications/'
    'data/datasources/remote/'
    'notification_remote_datasource.dart';

part 'push_notification_flutter.service.g.dart';

final _log = Logger('PushNotificationFlutter');

/// Flutter-side push notification service.
///
/// **Current mode: MOCK** — no Firebase dependency.
/// This service registers a synthetic device token
/// with the backend so the REST device-registration
/// flow is exercised end-to-end.
///
/// To enable real push support, replace the mock
/// methods with `firebase_messaging` and
/// `flutter_local_notifications` calls, then call
/// [handleChatPushMessage] from
/// `FirebaseMessaging.onMessage` for foreground chat
/// notifications.
class PushNotificationFlutterService {
  PushNotificationFlutterService({
    required NotificationRemoteDatasource datasource,
    required AuthSessionStore authSessionStore,
  })  : _datasource = datasource,
        _authSessionStore = authSessionStore;

  final NotificationRemoteDatasource _datasource;
  final AuthSessionStore _authSessionStore;
  bool _initialized = false;

  final _chatPushController =
      StreamController<WsNewMessageEvent>.broadcast();

  /// Stream of chat messages received via push
  /// notification while the app is in the foreground.
  ///
  /// [ChatMessageToastListener] subscribes to this
  /// alongside the WS stream for inline toasts.
  Stream<WsNewMessageEvent> get onChatPushMessage =>
      _chatPushController.stream;

  /// Initialise the service. Safe to call multiple
  /// times — subsequent calls are no-ops.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    _log.info(
      'Push notifications: MOCK mode '
      '(no Firebase credentials configured)',
    );

    // Request permission (mock — always granted)
    final granted = await requestPermission();
    if (!granted) {
      _log.warning('Push permission denied');
      return;
    }

    // Register mock token
    final token = getToken();
    final userId = _authSessionStore.currentUserId;
    if (userId != null) {
      await _registerToken(token);
    } else {
      _log.warning(
        'No userId available — skipping token'
        ' registration',
      );
    }
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
  void handleChatPushMessage(
    Map<String, dynamic> data,
  ) {
    try {
      final event = WsNewMessageEvent(
        id: data['messageId'] as String? ??
            'push-${DateTime.now().millisecondsSinceEpoch}',
        conversationId:
            data['conversationId'] as String? ?? '',
        senderId: data['senderId'] as String? ?? '',
        receiverId:
            data['receiverId'] as String? ?? '',
        senderName: data['senderName'] as String?,
        senderAvatar:
            data['senderAvatar'] as String?,
        content:
            data['content'] as String? ??
            data['body'] as String? ??
            '',
        messageType: WsMessageType.text,
        createdAt: DateTime.now(),
      );

      _chatPushController.add(event);
      _log.fine(
        'Forwarded chat push to inline toast: '
        '${event.id}',
      );
    } catch (e) {
      _log.warning(
        'Failed to parse chat push payload: $e',
      );
    }
  }

  /// Mock permission request. Returns `true`.
  Future<bool> requestPermission() async {
    _log.fine('Mock: permission granted');
    return true;
  }

  /// Returns a mock FCM/APNs token.
  String getToken() {
    final ts = DateTime.now().millisecondsSinceEpoch;
    return 'mock-fcm-token-$ts';
  }

  /// Registers the token with the backend.
  Future<void> _registerToken(String token) async {
    final platform =
        Platform.isIOS ? 'ios' : 'android';
    try {
      await _datasource.registerDevice(
        token: token,
        platform: platform,
      );
      _log.info(
        'Registered mock device token: '
        '${token.substring(0, 20)}... '
        '(platform: $platform)',
      );
    } catch (e) {
      _log.warning(
        'Failed to register device token: $e',
      );
    }
  }

  /// Release resources.
  void dispose() {
    _chatPushController.close();
  }
}

// ─── Provider ──────────────────────────────────────

/// Provides the push notification service instance.
///
/// Initialization is triggered explicitly after
/// authentication succeeds so `/v1/user/devices`
/// is not called during app startup.
@Riverpod(keepAlive: true)
Future<PushNotificationFlutterService>
    pushNotificationService(Ref ref) async {
  final datasource = ref.read(
    notificationRemoteDatasourceProvider,
  );
  final authSessionStore = ref.read(
    authSessionStoreProvider,
  );

  final service = PushNotificationFlutterService(
    datasource: datasource,
    authSessionStore: authSessionStore,
  );
  return service;
}
