import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/features/bot_chat/data/repositories/chat_repository_impl.dart';
import 'package:user_app/features/bot_chat/domain/repositories/chat.repository.dart';
import 'package:user_app/features/bot_chat/domain/entities/chat_conversation.entity.dart';

/// Immutable state for the conversation history page.
class ConversationHistoryState {
  /// Whether conversations are currently being loaded.
  final bool isLoading;

  /// Optional error message on fetch failure.
  final String? error;

  /// All conversations fetched from the repository.
  final List<ChatConversation> conversations;

  /// Current search query applied to filter conversations.
  final String searchQuery;

  const ConversationHistoryState({
    this.isLoading = false,
    this.error,
    this.conversations = const [],
    this.searchQuery = '',
  });

  ConversationHistoryState copyWith({
    bool? isLoading,
    String? error,
    List<ChatConversation>? conversations,
    String? searchQuery,
  }) {
    return ConversationHistoryState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      conversations: conversations ?? this.conversations,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Returns conversations filtered by [searchQuery] (title
  /// or last-message match).
  List<ChatConversation> get filtered {
    if (searchQuery.isEmpty) return conversations;
    final q = searchQuery.toLowerCase();
    return conversations
        .where(
          (c) =>
              c.title.toLowerCase().contains(q) ||
              c.lastMessage.toLowerCase().contains(q),
        )
        .toList();
  }
}

/// Manages the conversation list and search filtering.
class ConversationHistoryNotifier extends Notifier<ConversationHistoryState> {
  late final ChatRepository _repository;

  @override
  ConversationHistoryState build() {
    _repository = ref.read(chatRepositoryProvider);
    Future.microtask(loadConversations);
    return const ConversationHistoryState();
  }

  /// Fetches all conversations from the repository.
  Future<void> loadConversations() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final conversations = await _repository.getConversations();
      state = state.copyWith(isLoading: false, conversations: conversations);
    } catch (e, st) {
      debugPrint('Error loading conversations: $e\n$st');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load conversations.',
      );
    }
  }

  /// Updates the search filter; no network call needed.
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

/// Provider for the conversation history state.
final conversationHistoryProvider =
    NotifierProvider<ConversationHistoryNotifier, ConversationHistoryState>(
      ConversationHistoryNotifier.new,
    );
