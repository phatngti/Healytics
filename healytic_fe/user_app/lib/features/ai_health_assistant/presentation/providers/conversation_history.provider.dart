import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/features/ai_health_assistant/data/repositories/chat_impl.repository.dart';
import 'package:user_app/features/ai_health_assistant/domain/repositories/chat.repository.dart';
import 'package:user_app/features/ai_health_assistant/domain/entities/chat_conversation.entity.dart';
import 'package:user_app/features/partner_chat/domain/entities/partner_conversation.entity.dart';
import 'package:user_app/features/partner_chat/presentation/providers/partner_chat.provider.dart';

/// Immutable state for the conversation history page.
///
/// Holds both AI and partner conversation lists
/// independently, each with their own loading and
/// error state.
class ConversationHistoryState {
  /// Whether AI conversations are loading.
  final bool isLoading;

  /// Optional error for AI conversations.
  final String? error;

  /// AI chatbot conversations.
  final List<ChatConversation> conversations;

  /// Whether partner conversations are loading.
  final bool isLoadingPartner;

  /// Optional error for partner conversations.
  final String? partnerError;

  /// Partner chat conversations.
  final List<PartnerConversation> partnerConversations;

  /// Current search query applied to filter
  /// conversations.
  final String searchQuery;

  const ConversationHistoryState({
    this.isLoading = false,
    this.error,
    this.conversations = const [],
    this.isLoadingPartner = false,
    this.partnerError,
    this.partnerConversations = const [],
    this.searchQuery = '',
  });

  ConversationHistoryState copyWith({
    bool? isLoading,
    String? error,
    List<ChatConversation>? conversations,
    bool? isLoadingPartner,
    String? partnerError,
    List<PartnerConversation>? partnerConversations,
    String? searchQuery,
  }) {
    return ConversationHistoryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      conversations:
          conversations ?? this.conversations,
      isLoadingPartner:
          isLoadingPartner ?? this.isLoadingPartner,
      partnerError: partnerError,
      partnerConversations: partnerConversations ??
          this.partnerConversations,
      searchQuery:
          searchQuery ?? this.searchQuery,
    );
  }

  /// Returns AI conversations filtered by
  /// [searchQuery] (title or last-message match).
  List<ChatConversation> get filtered {
    if (searchQuery.isEmpty) return conversations;
    final q = searchQuery.toLowerCase();
    return conversations
        .where(
          (c) =>
              c.title.toLowerCase().contains(q) ||
              c.lastMessage
                  .toLowerCase()
                  .contains(q),
        )
        .toList();
  }

  /// Returns partner conversations filtered by
  /// [searchQuery] (participant name or last-message
  /// text match).
  List<PartnerConversation> get filteredPartner {
    if (searchQuery.isEmpty) {
      return partnerConversations;
    }
    final q = searchQuery.toLowerCase();
    return partnerConversations
        .where(
          (c) =>
              c.otherParticipant.name
                  .toLowerCase()
                  .contains(q) ||
              (c.lastMessage.text ?? '')
                  .toLowerCase()
                  .contains(q),
        )
        .toList();
  }
}

/// Manages the conversation list and search filtering
/// for both AI and partner chat types.
class ConversationHistoryNotifier
    extends Notifier<ConversationHistoryState> {
  late final ChatRepository _repository;

  @override
  ConversationHistoryState build() {
    _repository = ref.read(chatRepositoryProvider);
    Future.microtask(loadConversations);
    Future.microtask(loadPartnerConversations);
    return const ConversationHistoryState();
  }

  /// Fetches all AI conversations from the repository.
  Future<void> loadConversations() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final conversations =
          await _repository.getConversations();
      state = state.copyWith(
        isLoading: false,
        conversations: conversations,
      );
    } catch (e, st) {
      log(
        'Error loading conversations: $e',
        stackTrace: st,
        name: 'ConversationHistoryNotifier',
      );
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load conversations.',
      );
    }
  }

  /// Fetches all partner conversations.
  Future<void> loadPartnerConversations() async {
    state = state.copyWith(
      isLoadingPartner: true,
      partnerError: null,
    );

    try {
      final partnerRepo =
          ref.read(partnerChatRepositoryProvider);
      final conversations =
          await partnerRepo.getConversations();
      state = state.copyWith(
        isLoadingPartner: false,
        partnerConversations: conversations,
      );
    } catch (e, st) {
      log(
        'Error loading partner conversations: $e',
        stackTrace: st,
        name: 'ConversationHistoryNotifier',
      );
      state = state.copyWith(
        isLoadingPartner: false,
        partnerError:
            'Failed to load partner conversations.',
      );
    }
  }

  /// Updates the search filter; no network call
  /// needed.
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

/// Provider for the conversation history state.
final conversationHistoryProvider = NotifierProvider<
    ConversationHistoryNotifier,
    ConversationHistoryState>(
  ConversationHistoryNotifier.new,
);
