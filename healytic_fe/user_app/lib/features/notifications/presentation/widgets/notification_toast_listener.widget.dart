import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:user_app/core/services/local_notification.service.dart';
import 'package:user_app/core/services/push_notification_flutter.service.dart';
import 'package:user_app/core/services/ws/ws_client.dart';
import 'package:user_app/core/widgets/root_overlay_toast.dart';
import 'package:user_app/features/notifications/domain/entities/notification.entity.dart';
import 'package:user_app/features/notifications/presentation/providers/notification.provider.dart';
import 'package:user_app/features/notifications/presentation/widgets/notification_toast.widget.dart';
import 'package:user_app/features/partner_chat/presentation/providers/chat_message_event.provider.dart';
import 'package:user_app/router/app_router.dart';
import 'package:user_app/router/routes.dart';

final _log = Logger('NotificationToastListener');

/// Global listener that reacts when real-time
/// notification events arrive.
///
/// Triggers:
/// - Chat messages via WS `new_message_notification`
///   as OS-level local notifications.
/// - Domain notifications via WS `new_notification`
///   as in-app toasts.
///
/// Also handles tap-to-navigate when the user taps
/// a notification from the tray.
///
/// **Placement:** Wrap inside the
/// [MaterialApp.router] builder alongside
/// `ChatMessageToastListener`.
class NotificationToastListener extends ConsumerStatefulWidget {
  /// Creates a [NotificationToastListener].
  const NotificationToastListener({super.key, required this.child});

  /// The child widget to render below.
  final Widget child;

  @override
  ConsumerState<NotificationToastListener> createState() =>
      _NotificationToastListenerState();
}

class _NotificationToastListenerState
    extends ConsumerState<NotificationToastListener> {
  StreamSubscription<String?>? _localTapSub;
  StreamSubscription<Map<String, dynamic>>? _pushTapSub;

  @override
  Widget build(BuildContext context) {
    // Eagerly initialise the local notification
    // service.
    ref.watch(localNotificationServiceProvider);

    // Listen for incoming chat message events and
    // show OS notifications.
    ref.listen(latestChatMessageEventProvider, _onChatMessageEvent);

    // Listen for domain notifications from the backend
    // and show in-app toasts.
    ref.listen(latestNotificationEventProvider, _onNotificationEvent);

    // Listen for notification taps to navigate.
    ref.listen(localNotificationServiceProvider, _onServiceReady);
    ref.listen(pushNotificationServiceProvider, _onPushServiceReady);

    return widget.child;
  }

  @override
  void dispose() {
    _localTapSub?.cancel();
    _pushTapSub?.cancel();
    super.dispose();
  }

  void _onChatMessageEvent(
    AsyncValue<WsNewMessageEvent>? previous,
    AsyncValue<WsNewMessageEvent> next,
  ) {
    final event = next.value;
    if (event == null) return;

    // Deduplicate — skip if same event ID.
    final prevEvent = previous?.value;
    if (prevEvent != null && prevEvent.id == event.id) {
      return;
    }

    // Suppress notification for the active
    // conversation.
    final activeConversation = ref.read(activeChatConversationIdProvider);
    if (activeConversation == event.conversationId) {
      return;
    }

    _showChatLocalNotification(event);
  }

  void _onServiceReady(
    AsyncValue<LocalNotificationService>? previous,
    AsyncValue<LocalNotificationService> next,
  ) {
    next.whenData((service) {
      // Only set up once — when the service
      // transitions from loading to data.
      if (previous?.value != null) return;
      _listenToTaps(service);
    });
  }

  void _onPushServiceReady(
    AsyncValue<PushNotificationFlutterService>? previous,
    AsyncValue<PushNotificationFlutterService> next,
  ) {
    next.whenData((service) {
      if (previous?.value != null) return;
      _listenToPushTaps(service);
      unawaited(service.initialize());
    });
  }

  void _showChatLocalNotification(WsNewMessageEvent event) {
    final service = ref.read(localNotificationServiceProvider);

    service.whenData((svc) {
      svc.showChatNotification(
        senderName: event.senderName ?? 'Partner',
        messagePreview: event.content,
        conversationId: event.conversationId,
        senderId: event.senderId,
        senderAvatar: event.senderAvatar,
      );

      _log.fine(
        'Local notification shown: '
        '${event.senderName} — ${event.content}',
      );
    });
  }

  void _onNotificationEvent(
    AsyncValue<NotificationEntity>? previous,
    AsyncValue<NotificationEntity> next,
  ) {
    final notification = next.value;
    if (notification == null) return;

    final prevNotification = previous?.value;
    if (prevNotification != null && prevNotification.id == notification.id) {
      return;
    }

    // Chat has a richer sender-aware toast from the
    // chat notification stream.
    if (notification.type == NotificationType.newChatMessage) {
      return;
    }

    _showNotificationToast(notification);
  }

  void _showNotificationToast(NotificationEntity notification) {
    final shown = RootOverlayToast.show(
      builder: (dismiss) {
        return NotificationToast(
          title: notification.title,
          body: notification.body,
          type: notification.type,
          onTap: () {
            dismiss();
            _openNotification(notification);
          },
          onDismiss: dismiss,
        );
      },
    );

    if (!shown) {
      _log.fine(
        'Skipped in-app notification toast because root overlay is unavailable',
      );
    }
  }

  void _openNotification(NotificationEntity notification) {
    final data = notification.data ?? const <String, dynamic>{};
    _openNotificationData({
      ...data,
      'notificationId': notification.id,
      'notificationType': notification.type.name,
    });
  }

  void _openNotificationData(Map<String, dynamic> data) {
    final navCtx = rootNavigatorKey.currentContext;
    if (navCtx == null) return;

    final notificationId = _firstString(data, const ['notificationId', 'id']);
    if (notificationId != null) {
      unawaited(
        ref.read(notificationProvider.notifier).markRead(notificationId),
      );
    }

    final eventType = _firstString(data, const ['type', 'notificationType']);
    final conversationId = _firstString(data, const ['conversationId']);
    if (eventType == 'chat' ||
        eventType == 'new_chat_message' ||
        conversationId != null) {
      _navigateToChat(data);
      return;
    }

    final appointmentId = _firstString(data, const [
      'appointmentId',
      'bookingId',
      'orderId',
    ]);
    if (appointmentId != null) {
      OrderDetailsRoute(appointmentId: appointmentId).push(navCtx);
      return;
    }

    final partnerId = _firstString(data, const [
      'partnerAccountId',
      'senderId',
    ]);
    if (partnerId != null) {
      PartnerChatRoute(
        partnerAccountId: partnerId,
        partnerName:
            _firstString(data, const ['partnerName', 'senderName']) ??
            'Partner',
        partnerAvatar: _firstString(data, const [
          'partnerAvatar',
          'senderAvatar',
        ]),
      ).push(navCtx);
      return;
    }

    const NotificationsRoute().push(navCtx);
  }

  String? _firstString(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  void _listenToTaps(LocalNotificationService service) {
    _localTapSub?.cancel();
    _localTapSub = service.onNotificationTapped.listen(_openPayloadJson);

    final launchPayload = service.consumeInitialPayload();
    if (launchPayload != null && launchPayload.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openPayloadJson(launchPayload);
      });
    }
  }

  void _listenToPushTaps(PushNotificationFlutterService service) {
    _pushTapSub?.cancel();
    _pushTapSub = service.onNotificationOpened.listen(_openNotificationData);

    final launchPayload = service.consumeInitialOpenPayload();
    if (launchPayload != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openNotificationData(launchPayload);
      });
    }
  }

  void _openPayloadJson(String? payload) {
    if (payload == null || payload.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) {
        _openNotificationData(decoded.cast<String, dynamic>());
      }
    } catch (e) {
      _log.warning('Failed to parse notification payload: $e');
    }
  }

  void _navigateToChat(Map<String, dynamic> data) {
    final navCtx = rootNavigatorKey.currentContext;
    if (navCtx == null) return;

    final senderId =
        _firstString(data, const ['partnerAccountId', 'senderId']) ?? '';
    if (senderId.isEmpty) {
      const NotificationsRoute().push(navCtx);
      return;
    }
    final senderName = data['senderName'] as String? ?? 'Partner';
    final senderAvatar = data['senderAvatar'] as String?;

    PartnerChatRoute(
      partnerAccountId: senderId,
      partnerName: senderName,
      partnerAvatar: senderAvatar,
    ).push(navCtx);
  }
}
