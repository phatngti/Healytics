import 'dart:async';

import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';
import 'package:user_app/core/providers/ws.provider.dart';
import 'package:user_app/core/services/ws.service.dart';
import 'package:user_app/core/services/ws/ws_client.dart';
import 'package:user_app/features/partner_chat/data/datasources/remote/partner_chat_remote_datasource.dart';
import 'package:user_app/features/partner_chat/data/repositories/partner_chat_impl.repository.dart';
import 'package:user_app/features/partner_chat/domain/entities/partner_chat_message.entity.dart';
import 'package:user_app/features/partner_chat/domain/entities/partner_conversation.entity.dart';
import 'package:user_app/features/partner_chat/domain/repositories/partner_chat.repository.dart';
import 'package:user_app/features/partner_chat/presentation/providers/chat_message_event.provider.dart';

part 'partner_chat.provider.g.dart';

/// Immutable state for the partner chat screen.
class PartnerChatState {
  final WsConnectionStatus connectionStatus;
  final PartnerConversation? conversation;
  final List<PartnerChatMessage> messages;
  final bool isLoadingMessages;
  final bool isSending;
  final bool partnerIsTyping;
  final String? typingPartnerName;
  final String? error;
  final bool hasMoreMessages;

  /// When true, the WS connection failed but REST
  /// data may still be usable — show a warning banner
  /// instead of blocking the whole UI.
  final bool wsUnavailable;

  const PartnerChatState({
    this.connectionStatus = WsConnectionStatus.disconnected,
    this.conversation,
    this.messages = const [],
    this.isLoadingMessages = false,
    this.isSending = false,
    this.partnerIsTyping = false,
    this.typingPartnerName,
    this.error,
    this.hasMoreMessages = true,
    this.wsUnavailable = false,
  });

  PartnerChatState copyWith({
    WsConnectionStatus? connectionStatus,
    PartnerConversation? conversation,
    List<PartnerChatMessage>? messages,
    bool? isLoadingMessages,
    bool? isSending,
    bool? partnerIsTyping,
    String? typingPartnerName,
    String? error,
    bool? hasMoreMessages,
    bool? wsUnavailable,
  }) {
    return PartnerChatState(
      connectionStatus: connectionStatus ?? this.connectionStatus,
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isSending: isSending ?? this.isSending,
      partnerIsTyping: partnerIsTyping ?? this.partnerIsTyping,
      typingPartnerName: typingPartnerName ?? this.typingPartnerName,
      error: error,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      wsUnavailable: wsUnavailable ?? this.wsUnavailable,
    );
  }
}

// ── Providers for DI ────────────────────────────────

/// Datasource provider with mock switching.
///
/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations.
@riverpod
PartnerChatRemoteDatasource partnerChatRemoteDatasource(Ref ref) {
  final useMock = AppEnvironment.current.useMock;
  if (useMock) {
    return PartnerChatRemoteDatasourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return PartnerChatRemoteDatasourceImpl(chatApi: apiService.userChatApi);
}

/// Repository provider.
@riverpod
PartnerChatRepository partnerChatRepository(Ref ref) {
  final datasource = ref.read(partnerChatRemoteDatasourceProvider);
  return PartnerChatRepositoryImpl(datasource: datasource);
}

/// Main chat notifier — manages the full lifecycle of
/// a partner chat conversation.
///
/// Parameters:
/// - [partnerAccountId]: The partner to chat with
/// - [partnerName]: Display name for the header
@riverpod
class PartnerChat extends _$PartnerChat {
  static final _log = Logger('PartnerChat');

  late final PartnerChatRepository _repository;
  late final WsService _wsService;
  late final UserChatSocket _socket;

  final List<StreamSubscription> _subscriptions = [];

  /// Resolved current-user ID from JWT.
  String? _currentUserId;

  /// Whether we're running against real APIs.
  bool get _isRealMode => !AppEnvironment.current.useMock;

  @override
  PartnerChatState build(String partnerAccountId, String partnerName) {
    _repository = ref.read(partnerChatRepositoryProvider);
    _wsService = ref.read(wsServiceProvider);
    _socket = _wsService.userChat;
    _currentUserId = ref.read(currentUserIdProvider);

    ref.onDispose(_cleanup);

    // Start the connection flow.
    Future.microtask(_initializeChat);

    return const PartnerChatState(
      connectionStatus: WsConnectionStatus.connecting,
    );
  }

  /// Mark this conversation as active to suppress
  /// inline toasts while the user is viewing it.
  void _setActiveConversation(String conversationId) {
    ref.read(activeChatConversationIdProvider.notifier).set(conversationId);
  }

  /// Clear active conversation on dispose.
  void _clearActiveConversation() {
    if (ref.exists(activeChatConversationIdProvider)) {
      ref.read(activeChatConversationIdProvider.notifier).set(null);
    }
  }

  /// The current user's account ID for bubble
  /// alignment and filtering.
  String get currentUserId => _currentUserId ?? 'current-user';

  /// Full initialization:
  /// 1. Connect WebSocket (if real mode)
  /// 2. Get or create conversation
  /// 3. Load message history
  /// 4. Listen to WebSocket events
  Future<void> _initializeChat() async {
    try {
      // 1. Connect WebSocket in real mode
      bool wsConnected = false;
      if (_isRealMode) {
        wsConnected = await _connectWebSocket();
      } else {
        _log.info('Skipping WS connect (mock mode)');
      }

      // 2. Get or create conversation
      state = state.copyWith(isLoadingMessages: true);

      final conversation = await _repository.getOrCreateConversation(
        partnerAccountId: partnerAccountId,
      );

      if (!ref.mounted) return;

      // 3. Load message history
      final result = await _repository.getMessages(conversation.id);

      if (!ref.mounted) return;

      state = state.copyWith(
        connectionStatus: WsConnectionStatus.connected,
        conversation: conversation,
        messages: result.messages,
        isLoadingMessages: false,
        hasMoreMessages: result.hasMore,
        wsUnavailable: _isRealMode && !wsConnected,
      );

      // Suppress inline toasts for this conversation
      _setActiveConversation(conversation.id);

      // 4. Join conversation room & mark read
      if (wsConnected) {
        _socket.joinConversation(conversation.id);
        _socket.markRead(
          WsMarkReadPayload(
            conversationId: conversation.id,
            receiverId: partnerAccountId,
          ),
        );
      } else {
        // Fallback: mark read via REST
        _repository.markAsRead(conversation.id);
      }

      // 5. Listen to events (only if WS connected)
      if (wsConnected) {
        _setupEventListeners();
      }
    } catch (e, st) {
      _log.severe('Chat initialization failed', e, st);
      if (!ref.mounted) return;
      state = state.copyWith(
        connectionStatus: WsConnectionStatus.error,
        isLoadingMessages: false,
        error: 'Failed to connect. Please try again.',
      );
    }
  }

  /// Attempt to establish a WebSocket connection
  /// via the centralised [WsService].
  ///
  /// Returns `true` if connected successfully,
  /// `false` otherwise (allowing the UI to degrade
  /// gracefully).
  Future<bool> _connectWebSocket() async {
    try {
      if (_socket.status == WsConnectionStatus.connected) {
        return true;
      }

      _wsService.connectUserChat();

      // Wait for the connection to establish.
      final connected = await _waitForConnection(
        timeout: const Duration(seconds: 5),
      );

      if (!connected) {
        _log.warning('WS connection timed out');
      }

      return connected;
    } catch (e, st) {
      _log.warning('WS connection failed (non-fatal)', e, st);
      return false;
    }
  }

  /// Awaits the socket connection status stream
  /// until connected or timeout.
  Future<bool> _waitForConnection({required Duration timeout}) async {
    if (_socket.status == WsConnectionStatus.connected) {
      return true;
    }

    try {
      await _socket.onConnectionChange
          .firstWhere(
            (s) =>
                s == WsConnectionStatus.connected ||
                s == WsConnectionStatus.error,
          )
          .timeout(timeout);
      return _socket.status == WsConnectionStatus.connected;
    } catch (_) {
      return false;
    }
  }

  void _setupEventListeners() {
    final convId = state.conversation?.id;
    if (convId == null) return;

    // New messages — map WsNewMessageEvent →
    // PartnerChatMessage domain entity.
    // Own echoes are reconciled by clientMessageId
    // to prevent duplicating the optimistic entry.
    _subscriptions.add(
      _socket.onNewMessage.listen((event) {
        if (event.conversationId != convId) return;
        if (!ref.mounted) return;

        final clientMsgId = event.clientMessageId;
        final idx = state.messages.indexWhere(
          (m) =>
              (clientMsgId != null && m.clientMessageId == clientMsgId) ||
              m.id == event.id,
        );

        if (idx != -1) {
          final updated = List<PartnerChatMessage>.from(state.messages);
          updated[idx] = updated[idx].copyWith(
            id: event.id,
            status: MessageStatus.sent,
          );
          state = state.copyWith(messages: updated, isSending: false);
        } else {
          final message = PartnerChatMessage(
            id: event.id,
            conversationId: event.conversationId,
            senderId: event.senderId,
            senderName: event.senderName,
            senderAvatar: event.senderAvatar,
            content: event.content,
            messageType: _mapMessageType(event.messageType),
            clientMessageId: event.clientMessageId,
            createdAt: event.createdAt,
          );

          state = state.copyWith(
            messages: [...state.messages, message],
            partnerIsTyping: event.senderId == currentUserId
                ? state.partnerIsTyping
                : false,
          );
        }

        // Auto mark-read since user is in the chat
        _socket.markRead(
          WsMarkReadPayload(
            conversationId: convId,
            receiverId: partnerAccountId,
          ),
        );
      }),
    );

    // Typing
    _subscriptions.add(
      _socket.onTyping.listen((event) {
        if (event.conversationId != convId) return;
        if (!ref.mounted) return;

        state = state.copyWith(
          partnerIsTyping: true,
          typingPartnerName: event.userName,
        );
      }),
    );

    // Stop typing
    _subscriptions.add(
      _socket.onStopTyping.listen((event) {
        if (event.conversationId != convId) return;
        if (!ref.mounted) return;

        state = state.copyWith(partnerIsTyping: false);
      }),
    );

    // Read receipts
    _subscriptions.add(
      _socket.onMessagesRead.listen((event) {
        if (event.conversationId != convId) return;
        if (!ref.mounted) return;

        // Mark all user messages as read
        final updated = state.messages.map((m) {
          if (m.senderId != event.readerId && !m.isRead) {
            return m.copyWith(isRead: true);
          }
          return m;
        }).toList();

        state = state.copyWith(messages: updated);
      }),
    );

    // Connection status changes
    _subscriptions.add(
      _socket.onConnectionChange.listen((status) {
        if (!ref.mounted) return;
        if (status == WsConnectionStatus.error ||
            status == WsConnectionStatus.disconnected) {
          state = state.copyWith(wsUnavailable: true);
        } else if (status == WsConnectionStatus.connected) {
          state = state.copyWith(wsUnavailable: false);
        }
      }),
    );
  }

  /// Send a text message.
  ///
  /// Creates an optimistic message with [MessageStatus.sending],
  /// then transitions to [MessageStatus.sent] on server ack.
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final convId = state.conversation?.id;
    if (convId == null) return;

    // Cannot send via WS if it's unavailable
    if (state.wsUnavailable) {
      _log.warning('Cannot send message — WS unavailable');
      return;
    }

    final clientId = 'client-${DateTime.now().millisecondsSinceEpoch}';

    // Optimistic update — status: sending
    final optimisticMessage = PartnerChatMessage(
      id: clientId,
      conversationId: convId,
      senderId: currentUserId,
      content: text.trim(),
      clientMessageId: clientId,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );

    state = state.copyWith(
      messages: [...state.messages, optimisticMessage],
      isSending: true,
    );

    // Send via WebSocket using generated payload
    _socket.sendMessage(
      WsSendMessagePayload(
        conversationId: convId,
        receiverId: partnerAccountId,
        content: text.trim(),
        clientMessageId: clientId,
      ),
      onAck: (ack) {
        if (!ref.mounted) return;
        // Update optimistic message: server ID + sent status
        final updated = state.messages.map((m) {
          if (m.clientMessageId == ack.clientMessageId) {
            return m.copyWith(id: ack.id, status: MessageStatus.sent);
          }
          return m;
        }).toList();

        state = state.copyWith(messages: updated, isSending: false);
      },
    );

    // Fallback: clear sending state after timeout
    Future.delayed(const Duration(seconds: 5), () {
      if (!ref.mounted) return;
      if (state.isSending) {
        state = state.copyWith(isSending: false);
      }
    });
  }

  /// Notify the partner that the user is typing.
  void notifyTyping() {
    if (state.wsUnavailable) return;
    final convId = state.conversation?.id;
    if (convId != null) {
      _socket.typing(
        WsTypingPayload(conversationId: convId, receiverId: partnerAccountId),
      );
    }
  }

  /// Notify the partner that the user stopped typing.
  void notifyStopTyping() {
    if (state.wsUnavailable) return;
    final convId = state.conversation?.id;
    if (convId != null) {
      _socket.stopTyping(
        WsTypingPayload(conversationId: convId, receiverId: partnerAccountId),
      );
    }
  }

  /// Load older messages (pagination).
  Future<void> loadMoreMessages() async {
    if (state.isLoadingMessages || !state.hasMoreMessages) {
      return;
    }

    final convId = state.conversation?.id;
    if (convId == null) return;

    state = state.copyWith(isLoadingMessages: true);

    try {
      final oldestId = state.messages.isNotEmpty
          ? state.messages.first.id
          : null;

      final result = await _repository.getMessages(convId, beforeId: oldestId);

      if (!ref.mounted) return;

      state = state.copyWith(
        messages: [...result.messages, ...state.messages],
        isLoadingMessages: false,
        hasMoreMessages: result.hasMore,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoadingMessages: false);
    }
  }

  /// Retry connection after an error.
  Future<void> retry() async {
    state = const PartnerChatState(
      connectionStatus: WsConnectionStatus.connecting,
    );
    await _initializeChat();
  }

  void _cleanup() {
    _clearActiveConversation();
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }

  /// Maps the generated [WsMessageType] to the domain
  /// [PartnerMessageType]. Unsupported variants
  /// (`image`, `file`) fall back to `text`.
  PartnerMessageType _mapMessageType(WsMessageType wsType) {
    return switch (wsType) {
      WsMessageType.system => PartnerMessageType.system,
      _ => PartnerMessageType.text,
    };
  }
}
