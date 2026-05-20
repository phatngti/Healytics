import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:user_app/core/services/local_notification.service.dart';
import 'package:user_app/core/services/ws/ws_client.dart';
import 'package:user_app/features/partner_chat/presentation/providers/chat_message_event.provider.dart';
import 'package:user_app/router/app_router.dart';
import 'package:user_app/router/routes.dart';

final _log = Logger('NotificationToastListener');

/// Global listener that fires OS-level local
/// notifications when real-time events arrive.
///
/// Triggers local notifications for:
/// - Chat messages via WS `new_message_notification`
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
  @override
  Widget build(BuildContext context) {
    // Eagerly initialise the local notification
    // service.
    ref.watch(localNotificationServiceProvider);

    // Listen for incoming chat message events and
    // show OS notifications.
    ref.listen(latestChatMessageEventProvider, _onChatMessageEvent);

    // Listen for notification taps to navigate.
    ref.listen(localNotificationServiceProvider, _onServiceReady);

    return widget.child;
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

  void _listenToTaps(LocalNotificationService service) {
    service.onNotificationTapped.listen((payload) {
      if (payload == null || payload.isEmpty) {
        return;
      }

      try {
        final data = jsonDecode(payload) as Map<String, dynamic>;
        final type = data['type'] as String?;

        if (type == 'chat') {
          _navigateToChat(data);
        }
        // Future: handle 'general' type here.
      } catch (e) {
        _log.warning(
          'Failed to parse notification '
          'payload: $e',
        );
      }
    });
  }

  void _navigateToChat(Map<String, dynamic> data) {
    final navCtx = rootNavigatorKey.currentContext;
    if (navCtx == null) return;

    final senderId = data['senderId'] as String? ?? '';
    final senderName = data['senderName'] as String? ?? 'Partner';
    final senderAvatar = data['senderAvatar'] as String?;

    PartnerChatRoute(
      partnerAccountId: senderId,
      partnerName: senderName,
      partnerAvatar: senderAvatar,
    ).push(navCtx);
  }
}
