import 'package:user_app/features/partner_chat/domain/entities/partner_chat_message.entity.dart';
import 'package:user_app/features/partner_chat/domain/entities/partner_conversation.entity.dart';

/// Repository interface for P2P partner chat.
///
/// Provides REST-based operations for conversation
/// management and message history. Real-time messaging
/// is handled separately via the socket service.
abstract class PartnerChatRepository {
  /// Get or create a conversation with the specified
  /// partner.
  ///
  /// If an active conversation already exists between
  /// the current user and [partnerAccountId], returns
  /// the existing one. Otherwise creates a new one.
  Future<PartnerConversation> getOrCreateConversation({
    required String partnerAccountId,
    String? initialMessage,
  });

  /// Fetch paginated message history for a
  /// conversation.
  ///
  /// Returns messages ordered newest-first. Use
  /// [beforeId] for cursor-based pagination.
  Future<List<PartnerChatMessage>> getMessages(
    String conversationId, {
    String? beforeId,
    int limit = 20,
  });

  /// Fetch all conversations for the current user.
  Future<List<PartnerConversation>> getConversations();

  /// Mark all messages in a conversation as read.
  Future<void> markAsRead(String conversationId);
}
