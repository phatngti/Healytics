import 'dart:async';

import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:admin_panel/features/partner/chat/data/datasources/remote/partner_chat_socket_service.dart';
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
  return PartnerInboxRemoteDatasourceMock();
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

@Riverpod(keepAlive: true)
PartnerChatSocketService
    partnerInboxSocketService(Ref ref) {
  final svc = PartnerChatSocketService();
  ref.onDispose(() => svc.dispose());
  return svc;
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
@riverpod
class PartnerInbox extends _$PartnerInbox {
  static final _log = Logger('PartnerInbox');
  late final PartnerInboxChatRepository _repository;

  @override
  PartnerInboxState build() {
    _repository =
        ref.read(partnerInboxChatRepositoryProvider);

    Future.microtask(_loadConversations);
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

  void selectConversation(String conversationId) {
    state = state.copyWith(
      activeConversationId: conversationId,
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _loadConversations();
  }
}

// ── Chat Detail State ────────────────────────────────

class ChatDetailState {
  final List<PartnerChatMessage> messages;
  final bool isLoading;
  final bool isSending;
  final bool userIsTyping;
  final String? typingUserName;
  final String? error;

  const ChatDetailState({
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.userIsTyping = false,
    this.typingUserName,
    this.error,
  });

  ChatDetailState copyWith({
    List<PartnerChatMessage>? messages,
    bool? isLoading,
    bool? isSending,
    bool? userIsTyping,
    String? typingUserName,
    String? error,
  }) {
    return ChatDetailState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      userIsTyping:
          userIsTyping ?? this.userIsTyping,
      typingUserName:
          typingUserName ?? this.typingUserName,
      error: error,
    );
  }
}

/// Manages the active conversation messages (right
/// panel).
@riverpod
class PartnerChatDetail extends _$PartnerChatDetail {
  static final _log = Logger('PartnerChatDetail');
  late final PartnerInboxChatRepository _repository;
  late final PartnerChatSocketService _socketService;
  final List<StreamSubscription> _subscriptions = [];

  @override
  ChatDetailState build(String conversationId) {
    _repository =
        ref.read(partnerInboxChatRepositoryProvider);
    _socketService =
        ref.read(partnerInboxSocketServiceProvider);

    ref.onDispose(_cleanup);

    Future.microtask(_loadMessages);
    return const ChatDetailState(isLoading: true);
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await _repository.getMessages(
        conversationId,
      );
      if (!ref.mounted) return;

      state = state.copyWith(
        messages: messages,
        isLoading: false,
      );

      _socketService.joinConversation(conversationId);
      _socketService.markRead(conversationId);
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

  void _setupListeners() {
    _subscriptions.add(
      _socketService.onNewMessage.listen((msg) {
        if (msg.conversationId != conversationId) {
          return;
        }
        if (!ref.mounted) return;
        state = state.copyWith(
          messages: [...state.messages, msg],
          userIsTyping: false,
        );
        _socketService.markRead(conversationId);
      }),
    );

    _subscriptions.add(
      _socketService.onTyping.listen((event) {
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
      _socketService.onStopTyping.listen((event) {
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
      _socketService.onMessagesRead.listen((event) {
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
    );

    _socketService.sendMessage(
      SendMessagePayload(
        conversationId: conversationId,
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
          isSending: false,
        );
      },
    );

    Future.delayed(
      const Duration(seconds: 5),
      () {
        if (!ref.mounted) return;
        if (state.isSending) {
          state = state.copyWith(isSending: false);
        }
      },
    );
  }

  void notifyTyping() {
    _socketService.sendTyping(conversationId);
  }

  void notifyStopTyping() {
    _socketService.sendStopTyping(conversationId);
  }

  void _cleanup() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
}
