import 'dart:async';

import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';
import 'package:user_app/core/providers/ws.provider.dart';
import 'package:user_app/core/services/push_notification_flutter.service.dart';
import 'package:user_app/core/services/ws/ws_client.dart';

part 'chat_message_event.provider.g.dart';

final _log = Logger('ChatMessageEventProvider');

// ─── Active Conversation Tracking ──────────────────

/// Tracks which conversation is currently visible
/// so inline toasts can be suppressed for it.
@Riverpod(keepAlive: true)
class ActiveChatConversationId extends _$ActiveChatConversationId {
  @override
  String? build() => null;

  // ignore: use_setters_to_change_properties
  void set(String? conversationId) {
    if (!ref.mounted) return;
    state = conversationId;
  }

  void clearIf(String conversationId) {
    if (!ref.mounted || state != conversationId) return;
    state = null;
  }
}

// ─── WS Connection Lifecycle ───────────────────────

/// Eagerly connects the `/chat-notifications`
/// WebSocket
/// namespace and keeps it alive for the app session.
///
/// Mirrors [notificationWsConnectionProvider] — watch
/// this provider early so chat notification events
/// are received globally.
@Riverpod(keepAlive: true)
Stream<WsConnectionStatus> chatWsConnection(Ref ref) {
  final authSessionStore = ref.read(authSessionStoreProvider);
  final wsService = ref.read(wsServiceProvider);
  String previousToken = '';

  void syncWithToken(String? token) {
    final currentToken = (token ?? '').trim();
    if (currentToken.isEmpty) {
      if (wsService.chatNotifications.status !=
          WsConnectionStatus.disconnected) {
        _log.info(
          'Disconnecting /chat-notifications WS '
          'because token is empty',
        );
        wsService.chatNotifications.disconnect();
      }
      previousToken = '';
      return;
    }

    final shouldReconnect =
        previousToken.isNotEmpty && previousToken != currentToken;
    previousToken = currentToken;

    if (shouldReconnect) {
      _log.info(
        'Reconnecting /chat-notifications WS '
        'after token change',
      );
      wsService.reconnectChatNotifications();
      return;
    }

    _log.info('Connecting /chat-notifications WS namespace');
    wsService.connectChatNotifications();
  }

  final tokenStream = authSessionStore.watchAccessToken();
  syncWithToken(Store.tryGet(StoreKey.accessToken));
  final tokenSub = tokenStream.listen(syncWithToken);

  ref.onDispose(() {
    tokenSub.cancel();
    _log.info('Disposed /chat-notifications WS connection');
  });

  return wsService.chatNotifications.onConnectionChange;
}

// ─── Latest Chat Message Event (for Toast) ─────────

/// Exposes the latest incoming [WsNewMessageEvent]
/// as a unified stream from both WebSocket and push
/// notifications — filtered to exclude messages from
/// the currently active conversation and messages
/// sent by the current user.
///
/// Sources:
/// 1. `/chat-notifications` WS
///    `new_message_notification` events
/// 2. Push notifications with `new_chat_message` type
///    (via [PushNotificationFlutterService])
///
/// Used by [ChatMessageToastListener] to show inline
/// in-app notifications for incoming chat messages.
@Riverpod(keepAlive: true)
Stream<WsNewMessageEvent> latestChatMessageEvent(Ref ref) {
  ref.watch(chatWsConnectionProvider);
  final wsService = ref.read(wsServiceProvider);
  final currentUserId = ref.read(currentUserIdProvider);

  final controller = StreamController<WsNewMessageEvent>.broadcast();

  bool shouldSuppressByConversation(String conversationId) {
    final activeConvId = ref.read(activeChatConversationIdProvider);
    return activeConvId != null && conversationId == activeConvId;
  }

  WsNewMessageEvent mapToChatEvent(WsNewMessageNotification event) {
    return WsNewMessageEvent(
      id: event.messageId,
      conversationId: event.conversationId,
      senderId: event.senderId,
      receiverId: currentUserId ?? '',
      senderName: event.senderName,
      senderAvatar: event.senderAvatar,
      content: event.messagePreview,
      messageType: event.messageType,
      createdAt: event.createdAt,
    );
  }

  // Source 1: `/chat-notifications` events
  final wsSub = wsService.chatNotifications.onNewMessageNotification.listen((
    event,
  ) {
    if (event.senderId == currentUserId) return;
    if (shouldSuppressByConversation(event.conversationId)) {
      return;
    }
    controller.add(mapToChatEvent(event));
  });

  // Source 2: Push notification events
  StreamSubscription<WsNewMessageEvent>? pushSub;
  ref.watch(pushNotificationServiceProvider).whenData((pushService) {
    pushSub?.cancel();
    pushSub = pushService.onChatPushMessage.listen((event) {
      if (event.senderId == currentUserId) return;
      if (shouldSuppressByConversation(event.conversationId)) {
        return;
      }
      controller.add(event);
    });
  });

  ref.onDispose(() {
    wsSub.cancel();
    pushSub?.cancel();
    controller.close();
  });

  return controller.stream;
}
