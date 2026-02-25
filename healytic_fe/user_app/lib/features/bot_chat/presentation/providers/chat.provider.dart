import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/bot_chat/domain/repositories/chat.repository.dart';
import 'package:user_app/features/bot_chat/data/repositories/chat_repository_impl.dart';
import 'package:user_app/features/bot_chat/domain/entities/chat_message.entity.dart';

part 'chat.provider.g.dart';

/// Immutable state for the active chat conversation.
class ChatState {
  /// Whether messages are currently being loaded.
  final bool isLoading;

  /// Optional error message on fetch failure.
  final String? error;

  /// Messages in the active conversation, ordered
  /// chronologically.
  final List<ChatMessage> messages;

  const ChatState({
    this.isLoading = false,
    this.error,
    this.messages = const [],
  });

  ChatState copyWith({
    bool? isLoading,
    String? error,
    List<ChatMessage>? messages,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      messages: messages ?? this.messages,
    );
  }
}

/// Manages the message list for the active conversation.
@riverpod
class Chat extends _$Chat {
  late final ChatRepository _repository;

  @override
  ChatState build(String? conversationId) {
    _repository = ref.read(chatRepositoryProvider);
    // Load messages if we have a valid conversationId.
    if (conversationId != null && conversationId.isNotEmpty) {
      Future.microtask(() => loadMessages(conversationId));
    }
    return const ChatState();
  }

  /// Fetches messages for [conversationId] from the repository.
  Future<void> loadMessages(String conversationId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final messages = await _repository.getMessages(conversationId);
      state = state.copyWith(isLoading: false, messages: messages);
    } catch (e, st) {
      debugPrint('Error loading chat messages: $e\n$st');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load messages. Please try again.',
      );
    }
  }

  /// Sends a user [text] message and appends it to state optimistically.
  Future<void> sendMessage(String text) async {
    final id = conversationId ?? '1';

    try {
      final message = await _repository.sendMessage(id, text);
      state = state.copyWith(messages: [...state.messages, message]);
    } catch (e, st) {
      debugPrint('Error sending message: $e\n$st');
      state = state.copyWith(error: 'Failed to send message.');
    }
  }
}
