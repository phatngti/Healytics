// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_event.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tracks which conversation is currently visible
/// so inline toasts can be suppressed for it.

@ProviderFor(ActiveChatConversationId)
const activeChatConversationIdProvider = ActiveChatConversationIdProvider._();

/// Tracks which conversation is currently visible
/// so inline toasts can be suppressed for it.
final class ActiveChatConversationIdProvider
    extends $NotifierProvider<ActiveChatConversationId, String?> {
  /// Tracks which conversation is currently visible
  /// so inline toasts can be suppressed for it.
  const ActiveChatConversationIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeChatConversationIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeChatConversationIdHash();

  @$internal
  @override
  ActiveChatConversationId create() => ActiveChatConversationId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$activeChatConversationIdHash() =>
    r'f553575d7df0bc79abc6f44f3899465a934be8d9';

/// Tracks which conversation is currently visible
/// so inline toasts can be suppressed for it.

abstract class _$ActiveChatConversationId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Eagerly connects the `/chat-notifications`
/// WebSocket
/// namespace and keeps it alive for the app session.
///
/// Mirrors [notificationWsConnectionProvider] — watch
/// this provider early so chat notification events
/// are received globally.

@ProviderFor(chatWsConnection)
const chatWsConnectionProvider = ChatWsConnectionProvider._();

/// Eagerly connects the `/chat-notifications`
/// WebSocket
/// namespace and keeps it alive for the app session.
///
/// Mirrors [notificationWsConnectionProvider] — watch
/// this provider early so chat notification events
/// are received globally.

final class ChatWsConnectionProvider
    extends
        $FunctionalProvider<
          AsyncValue<WsConnectionStatus>,
          WsConnectionStatus,
          Stream<WsConnectionStatus>
        >
    with
        $FutureModifier<WsConnectionStatus>,
        $StreamProvider<WsConnectionStatus> {
  /// Eagerly connects the `/chat-notifications`
  /// WebSocket
  /// namespace and keeps it alive for the app session.
  ///
  /// Mirrors [notificationWsConnectionProvider] — watch
  /// this provider early so chat notification events
  /// are received globally.
  const ChatWsConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatWsConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatWsConnectionHash();

  @$internal
  @override
  $StreamProviderElement<WsConnectionStatus> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WsConnectionStatus> create(Ref ref) {
    return chatWsConnection(ref);
  }
}

String _$chatWsConnectionHash() => r'957a00ecd56f1e27db705a377f1e5e03ef476283';

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

@ProviderFor(latestChatMessageEvent)
const latestChatMessageEventProvider = LatestChatMessageEventProvider._();

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

final class LatestChatMessageEventProvider
    extends
        $FunctionalProvider<
          AsyncValue<WsNewMessageEvent>,
          WsNewMessageEvent,
          Stream<WsNewMessageEvent>
        >
    with
        $FutureModifier<WsNewMessageEvent>,
        $StreamProvider<WsNewMessageEvent> {
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
  const LatestChatMessageEventProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestChatMessageEventProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestChatMessageEventHash();

  @$internal
  @override
  $StreamProviderElement<WsNewMessageEvent> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WsNewMessageEvent> create(Ref ref) {
    return latestChatMessageEvent(ref);
  }
}

String _$latestChatMessageEventHash() =>
    r'fe72215d9694554087b4c7833723afc4eaea6043';
