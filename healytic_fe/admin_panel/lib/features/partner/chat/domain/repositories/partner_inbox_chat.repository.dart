import 'package:admin_panel/features/partner/chat/domain/entities/partner_chat_message.entity.dart';
import 'package:admin_panel/features/partner/chat/domain/entities/partner_conversation.entity.dart';

/// Repository interface for the partner chat inbox.
abstract class PartnerInboxChatRepository {
  /// Fetch all conversations for the logged-in partner.
  Future<List<PartnerConversation>> getConversations();

  /// Fetch paginated messages for a conversation.
  Future<List<PartnerChatMessage>> getMessages(
    String conversationId, {
    String? beforeId,
    int limit = 20,
  });

  /// Mark all messages in a conversation as read.
  Future<void> markAsRead(String conversationId);
}
