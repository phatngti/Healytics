import 'dart:async';

import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/providers/ws.provider.dart';
import 'package:admin_panel/core/services/ws/ws_client.dart';
import 'package:admin_panel/features/partner/chat/data/datasources/remote/partner_inbox_remote_datasource.dart';
import 'package:admin_panel/features/partner/chat/data/repositories/partner_inbox_chat_impl.repository.dart';
import 'package:admin_panel/features/partner/chat/domain/entities/partner_chat_message.entity.dart';
import 'package:admin_panel/features/partner/chat/domain/entities/partner_conversation.entity.dart';
import 'package:admin_panel/features/partner/chat/domain/repositories/partner_inbox_chat.repository.dart';

part 'partner_inbox.provider.g.dart';

// ── DI Providers ─────────────────────────────────────

@riverpod
PartnerInboxRemoteDatasource
    partnerInboxRemoteDatasource(Ref ref) {
  final isMock =
      Store.get(StoreKey.mockFlag, false);
  if (isMock) {
    return PartnerInboxRemoteDatasourceMock();
  }
  final apiService = ref.read(apiServiceProvider);
  return PartnerInboxRemoteDatasourceImpl(
    apiService: apiService,
  );
}

@riverpod
PartnerInboxChatRepository
    partnerInboxChatRepository(Ref ref) {
  final ds =
      ref.read(partnerInboxRemoteDatasourceProvider);
  return PartnerInboxChatRepositoryImpl(
    datasource: ds,
  );
}

// ── Inbox State ──────────────────────────────────────

class PartnerInboxState {
  final List<PartnerConversation> conversations;
  final bool isLoading;
  final String? error;
  final String? activeConversationId;

  const PartnerInboxState({
    this.conversations = const [],
    this.isLoading = false,
    this.error,
    this.activeConversationId,
  });

  PartnerInboxState copyWith({
    List<PartnerConversation>? conversations,
    bool? isLoading,
    String? error,
    String? activeConversationId,
  }) {
    return PartnerInboxState(
      conversations:
          conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      activeConversationId: activeConversationId ??
          this.activeConversationId,
    );
  }
}

/// Manages the conversation list (left panel).
///
/// Subscribes to [PartnerChatSocket] events so the
/// list stays in sync with real-time messages and
/// read-receipts without polling.
@riverpod
class PartnerInbox extends _$PartnerInbox {
  static final _log = Logger('PartnerInbox');
  late final PartnerInboxChatRepository _repository;
  late final PartnerChatSocket _socket;
  final List<StreamSubscription> _subscriptions = [];

  @override
  PartnerInboxState build() {
    _repository =
        ref.read(partnerInboxChatRepositoryProvider);

    final wsService = ref.read(wsServiceProvider);
    wsService.connectPartnerChat();
    _socket = wsService.partnerChat;

    ref.onDispose(_cleanup);

    Future.microtask(() async {
      await _loadConversations();
      _setupWsListeners();
    });
    return const PartnerInboxState(isLoading: true);
  }

  Future<void> _loadConversations() async {
    try {
      final conversations =
          await _repository.getConversations();
      if (!ref.mounted) return;
      state = state.copyWith(
        conversations: conversations,
        isLoading: false,
      );
    } catch (e, st) {
      _log.severe('Load conversations failed', e, st);
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load conversations.',
      );
    }
  }

  void _setupWsListeners() {
    _subscriptions.add(
      _socket.onNewMessage.listen(_handleNewMessage),
    );

    _subscriptions.add(
      _socket.onMessagesRead.listen(_handleMessagesRead),
    );
  }

  void _handleNewMessage(WsNewMessageEvent event) {
    if (!ref.mounted) return;

    final conversations = [...state.conversations];
    final index = conversations.indexWhere(
      (c) => c.id == event.conversationId,
    );
    if (index < 0) return;

    final conv = conversations[index];
    final isActive =
        state.activeConversationId == conv.id;

    final updated = conv.copyWith(
      lastMessage: LastMessagePreview(
        text: event.content,
        timestamp: event.createdAt,
        senderId: event.senderId,
      ),
      unreadCount:
          isActive ? 0 : conv.unreadCount + 1,
    );

    conversations
      ..removeAt(index)
      ..insert(0, updated);

    state = state.copyWith(
      conversations: conversations,
    );
  }

  void _handleMessagesRead(WsMessagesReadEvent event) {
    if (!ref.mounted) return;

    final conversations = state.conversations.map((c) {
      if (c.id == event.conversationId) {
        return c.copyWith(unreadCount: 0);
      }
      return c;
    }).toList();

    state = state.copyWith(
      conversations: conversations,
    );
  }

  void selectConversation(String conversationId) {
    final conversations = state.conversations.map((c) {
      if (c.id == conversationId && c.unreadCount > 0) {
        return c.copyWith(unreadCount: 0);
      }
      return c;
    }).toList();

    state = state.copyWith(
      activeConversationId: conversationId,
      conversations: conversations,
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _loadConversations();
  }

  void _cleanup() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
}

// ── Chat Detail State ────────────────────────────────

class ChatDetailState {
  final List<PartnerChatMessage> messages;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSending;
  final Set<String> pendingClientMessageIds;
  final bool userIsTyping;
  final String? typingUserName;
  final String? error;
  final bool hasMoreMessages;

  const ChatDetailState({
    this.messages = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isSending = false,
    this.pendingClientMessageIds = const <String>{},
    this.userIsTyping = false,
    this.typingUserName,
    this.error,
    this.hasMoreMessages = true,
  });

  ChatDetailState copyWith({
    List<PartnerChatMessage>? messages,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isSending,
    Set<String>? pendingClientMessageIds,
    bool? userIsTyping,
    String? typingUserName,
    String? error,
    bool? hasMoreMessages,
  }) {
    return ChatDetailState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore:
          isLoadingMore ?? this.isLoadingMore,
      isSending: isSending ?? this.isSending,
      pendingClientMessageIds:
          pendingClientMessageIds ??
              this.pendingClientMessageIds,
      userIsTyping:
          userIsTyping ?? this.userIsTyping,
      typingUserName:
          typingUserName ?? this.typingUserName,
      error: error,
      hasMoreMessages:
          hasMoreMessages ?? this.hasMoreMessages,
    );
  }
}

/// Manages the active conversation messages (right
/// panel).
@riverpod
class PartnerChatDetail extends _$PartnerChatDetail {
  static final _log = Logger('PartnerChatDetail');
  late final PartnerInboxChatRepository _repository;
  late final PartnerChatSocket _socket;
  final List<StreamSubscription> _subscriptions = [];

  @override
  ChatDetailState build(String conversationId) {
    _repository =
        ref.read(partnerInboxChatRepositoryProvider);
    final wsService = ref.read(wsServiceProvider);
    wsService.connectPartnerChat();
    _socket = wsService.partnerChat;

    ref.onDispose(_cleanup);

    Future.microtask(_loadMessages);
    return const ChatDetailState(isLoading: true);
  }

  Future<void> _loadMessages() async {
    try {
      final result = await _repository.getMessages(
        conversationId,
      );
      if (!ref.mounted) return;

      state = state.copyWith(
        messages: result.messages,
        isLoading: false,
        hasMoreMessages: result.hasMore,
      );

      _socket.joinConversation(conversationId);
      _emitMarkRead();
      _repository.markAsRead(conversationId);
      _setupListeners();
    } catch (e, st) {
      _log.severe('Load messages failed', e, st);
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load messages.',
      );
    }
  }

  /// Load older messages (pagination).
  Future<void> loadMoreMessages() async {
    if (state.isLoadingMore || !state.hasMoreMessages) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    try {
      final oldestId = state.messages.isNotEmpty
          ? state.messages.first.id
          : null;

      final result = await _repository.getMessages(
        conversationId,
        beforeId: oldestId,
      );

      if (!ref.mounted) return;

      state = state.copyWith(
        messages: [
          ...result.messages,
          ...state.messages,
        ],
        isLoadingMore: false,
        hasMoreMessages: result.hasMore,
      );
    } catch (e) {
      _log.warning('Load more messages failed: $e');
      if (!ref.mounted) return;
      state = state.copyWith(isLoadingMore: false);
    }
  }

  void _setupListeners() {
    _subscriptions.add(
      _socket.onNewMessage.listen((msg) {
        if (msg.conversationId != conversationId) {
          return;
        }
        if (!ref.mounted) return;
        final mappedMessage = _mapWsMessage(msg);
        final clientMessageId = msg.clientMessageId;
        final existingIndex = clientMessageId != null
            ? state.messages.indexWhere(
                (m) => m.clientMessageId == clientMessageId,
              )
            : -1;
        final hasSameServerMessage = state.messages.any(
          (m) => m.id == mappedMessage.id,
        );
        final pendingClientIds = Set<String>.from(
          state.pendingClientMessageIds,
        );
        if (clientMessageId != null) {
          pendingClientIds.remove(clientMessageId);
        }

        final nextMessages = [...state.messages];
        if (existingIndex >= 0) {
          nextMessages[existingIndex] = mappedMessage;
        } else if (!hasSameServerMessage) {
          nextMessages.add(mappedMessage);
        }

        state = state.copyWith(
          messages: nextMessages,
          pendingClientMessageIds: pendingClientIds,
          isSending: pendingClientIds.isNotEmpty,
          userIsTyping: false,
        );
        _emitMarkRead();
      }),
    );

    _subscriptions.add(
      _socket.onTyping.listen((event) {
        if (event.conversationId != conversationId) {
          return;
        }
        if (!ref.mounted) return;
        state = state.copyWith(
          userIsTyping: true,
          typingUserName: event.userName,
        );
      }),
    );

    _subscriptions.add(
      _socket.onStopTyping.listen((event) {
        if (event.conversationId != conversationId) {
          return;
        }
        if (!ref.mounted) return;
        state = state.copyWith(
          userIsTyping: false,
        );
      }),
    );

    _subscriptions.add(
      _socket.onMessagesRead.listen((event) {
        if (event.conversationId != conversationId) {
          return;
        }
        if (!ref.mounted) return;
        final updated = state.messages.map((m) {
          if (m.senderId != event.readerId &&
              !m.isRead) {
            return m.copyWith(isRead: true);
          }
          return m;
        }).toList();
        state = state.copyWith(messages: updated);
      }),
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final receiverId = _resolveReceiverId();
    if (receiverId == null) {
      _log.warning(
        'Cannot send message: missing receiver for conversation $conversationId',
      );
      return;
    }

    final clientId =
        'client-${DateTime.now().millisecondsSinceEpoch}';

    final optimistic = PartnerChatMessage(
      id: clientId,
      conversationId: conversationId,
      senderId: 'current-partner',
      content: text.trim(),
      clientMessageId: clientId,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, optimistic],
      isSending: true,
      pendingClientMessageIds: {
        ...state.pendingClientMessageIds,
        clientId,
      },
    );

    _socket.sendMessage(
      WsSendMessagePayload(
        conversationId: conversationId,
        receiverId: receiverId,
        content: text.trim(),
        clientMessageId: clientId,
      ),
      onAck: (ack) {
        if (!ref.mounted) return;
        final updated = state.messages.map((m) {
          if (m.clientMessageId ==
              ack.clientMessageId) {
            return m.copyWith(id: ack.id);
          }
          return m;
        }).toList();
        state = state.copyWith(
          messages: updated,
          // Keep status as "sending" until the
          // corresponding new-message echo arrives.
          isSending:
              state.pendingClientMessageIds.isNotEmpty,
        );
      },
    );

    Future.delayed(
      const Duration(seconds: 5),
      () {
        if (!ref.mounted) return;
        if (!state.pendingClientMessageIds.contains(
          clientId,
        )) {
          return;
        }
        final pendingClientIds = Set<String>.from(
          state.pendingClientMessageIds,
        )..remove(clientId);
        state = state.copyWith(
          pendingClientMessageIds: pendingClientIds,
          isSending: pendingClientIds.isNotEmpty,
        );
      },
    );
  }

  void notifyTyping() {
    final receiverId = _resolveReceiverId();
    if (receiverId == null) return;
    _socket.typing(
      WsTypingPayload(
        conversationId: conversationId,
        receiverId: receiverId,
      ),
    );
  }

  void notifyStopTyping() {
    final receiverId = _resolveReceiverId();
    if (receiverId == null) return;
    _socket.stopTyping(
      WsTypingPayload(
        conversationId: conversationId,
        receiverId: receiverId,
      ),
    );
  }

  void _cleanup() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }

  /// Maps the generated [WsNewMessageEvent] to a
  /// domain [PartnerChatMessage] entity.
  PartnerChatMessage _mapWsMessage(
    WsNewMessageEvent event,
  ) {
    return PartnerChatMessage(
      id: event.id,
      conversationId: event.conversationId,
      senderId: event.senderId,
      senderName: event.senderName,
      senderAvatar: event.senderAvatar,
      content: event.content,
      messageType: event.messageType.name == 'system'
          ? PartnerMessageType.system
          : PartnerMessageType.text,
      clientMessageId: event.clientMessageId,
      createdAt: event.createdAt,
    );
  }

  void _emitMarkRead() {
    final receiverId = _resolveReceiverId();
    if (receiverId == null) return;
    _socket.markRead(
      WsMarkReadPayload(
        conversationId: conversationId,
        receiverId: receiverId,
      ),
    );
  }

  String? _resolveReceiverId() {
    final conversations =
        ref.read(partnerInboxProvider).conversations;
    for (final conversation in conversations) {
      if (conversation.id == conversationId) {
        return conversation.otherParticipant.id;
      }
    }
    return null;
  }
}
