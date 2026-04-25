import 'package:user_app/features/ai_health_assistant/domain/entities/chat_conversation.entity.dart';
import 'package:user_app/features/ai_health_assistant/domain/entities/chat_message.entity.dart';
import 'package:user_app/features/ai_health_assistant/domain/entities/chat_sse_event.entity.dart';

/// Abstract repository for AI health assistant chat
/// operations.
///
/// Implemented in the data layer; consumed by
/// presentation notifiers via Riverpod providers.
abstract class ChatRepository {
  /// Returns all past conversation sessions for the
  /// current user.
  Future<List<ChatConversation>> getConversations();

  /// Returns the messages within [conversationId].
  Future<List<ChatMessage>> getMessages(
    String conversationId,
  );

  /// Sends a user [text] message and returns an SSE
  /// stream of chatbot response events.
  ///
  /// [conversationId] may be null for new
  /// conversations.
  ///
  /// [currentLat] and [currentLng] provide the
  /// user's current location for proximity-aware
  /// recommendations.
  Stream<ChatSseEvent> sendMessageAndStream(
    String? conversationId,
    String text, {
    double? currentLat,
    double? currentLng,
  });
}
