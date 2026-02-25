import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';

import 'package:user_app/features/bot_chat/domain/entities/chat_conversation.entity.dart';
import 'package:user_app/features/bot_chat/domain/entities/chat_message.entity.dart';
import 'chat_mock_data.dart';

/// Contract for fetching chat data from a remote source.
abstract class ChatRemoteDatasource {
  /// Fetches all conversation sessions for the current user.
  Future<List<ChatConversation>> getConversations();

  /// Fetches messages for a given [conversationId].
  Future<List<ChatMessage>> getMessages(String conversationId);

  /// Sends a [text] message in [conversationId] and returns
  /// the created message.
  Future<ChatMessage> sendMessage(String conversationId, String text);
}

/// Real implementation that calls the backend API.
///
/// TODO: Inject the generated OpenAPI client once the chatbot
/// endpoints are available on the backend.
class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  // TODO: Accept API client in constructor when endpoints exist.
  // e.g. final ChatApi _chatApi;

  @override
  Future<List<ChatConversation>> getConversations() async {
    // TODO: Replace with real API call.
    throw UnimplementedError(
      'ChatRemoteDatasourceImpl.getConversations is not '
      'yet wired to the API.',
    );
  }

  @override
  Future<List<ChatMessage>> getMessages(String conversationId) async {
    // TODO: Replace with real API call.
    throw UnimplementedError(
      'ChatRemoteDatasourceImpl.getMessages is not '
      'yet wired to the API.',
    );
  }

  @override
  Future<ChatMessage> sendMessage(String conversationId, String text) async {
    // TODO: Replace with real API call.
    throw UnimplementedError(
      'ChatRemoteDatasourceImpl.sendMessage is not '
      'yet wired to the API.',
    );
  }
}

/// Mock implementation that returns fake data after a
/// simulated network delay, useful for development/testing.
class ChatRemoteDatasourceMock implements ChatRemoteDatasource {
  @override
  Future<List<ChatConversation>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockConversations;
  }

  @override
  Future<List<ChatMessage>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return kMockMessages;
  }

  @override
  Future<ChatMessage> sendMessage(String conversationId, String text) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      timestamp: DateTime.now(),
      isUser: true,
      isRead: false,
    );
  }
}

/// Uses [StoreKey.mockFlag] to switch between real and mock
/// implementations at runtime.
final chatRemoteDatasourceProvider = Provider<ChatRemoteDatasource>((ref) {
  final useMock = Store.tryGet(StoreKey.mockFlag) == 'true';

  if (useMock) {
    return ChatRemoteDatasourceMock();
  }

  return ChatRemoteDatasourceImpl();
});
