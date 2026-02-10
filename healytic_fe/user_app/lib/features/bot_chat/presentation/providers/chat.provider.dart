import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/features/bot_chat/data/repositories/chat_repository_impl.dart';
import 'package:user_app/features/bot_chat/domain/repositories/chat.repository.dart';
import 'package:user_app/features/bot_chat/domain/entities/chat_message.entity.dart';

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
///
/// Fetches messages via [ChatRepository] on construction and
/// exposes [sendMessage] to append user messages.
class ChatNotifier extends Notifier<ChatState> {
  late final ChatRepository _repository;

  @override
  ChatState build() {
    _repository = ref.read(chatRepositoryProvider);
    // Load messages for the default conversation on init.
    Future.microtask(() => loadMessages('1'));
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

  /// Sends a user [text] message in [conversationId] and
  /// appends it to the local state optimistically.
  Future<void> sendMessage(String conversationId, String text) async {
    try {
      final message = await _repository.sendMessage(conversationId, text);
      state = state.copyWith(messages: [...state.messages, message]);
    } catch (e, st) {
      debugPrint('Error sending message: $e\n$st');
      state = state.copyWith(error: 'Failed to send message.');
    }
  }
}

/// Provider for the active chat conversation state.
final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
