import 'package:user_app/features/bot_chat/domain/entities/chat_conversation.entity.dart';
import 'package:user_app/features/bot_chat/domain/entities/chat_message.entity.dart';

/// Abstract repository for bot chat operations.
///
/// Implemented in the data layer; consumed by presentation
/// notifiers via Riverpod providers.
abstract class ChatRepository {
  /// Returns all past conversation sessions for the
  /// current user.
  Future<List<ChatConversation>> getConversations();

  /// Returns the messages within [conversationId].
  Future<List<ChatMessage>> getMessages(String conversationId);

  /// Sends a user [text] message in [conversationId] and
  /// returns the created message entity.
  Future<ChatMessage> sendMessage(String conversationId, String text);
}
