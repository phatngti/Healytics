import 'package:admin_panel/features/partner/chat/data/datasources/remote/partner_inbox_remote_datasource.dart';
import 'package:admin_panel/features/partner/chat/domain/entities/partner_chat_message.entity.dart';
import 'package:admin_panel/features/partner/chat/domain/entities/partner_conversation.entity.dart';
import 'package:admin_panel/features/partner/chat/domain/repositories/partner_inbox_chat.repository.dart';

/// Repository implementation for partner inbox.
class PartnerInboxChatRepositoryImpl
    implements PartnerInboxChatRepository {
  final PartnerInboxRemoteDatasource _datasource;

  PartnerInboxChatRepositoryImpl({
    required PartnerInboxRemoteDatasource datasource,
  }) : _datasource = datasource;

  @override
  Future<List<PartnerConversation>>
      getConversations() =>
          _datasource.getConversations();

  @override
  Future<PaginatedMessages> getMessages(
    String conversationId, {
    String? beforeId,
    int limit = 20,
  }) =>
      _datasource.getMessages(
        conversationId,
        beforeId: beforeId,
        limit: limit,
      );

  @override
  Future<void> markAsRead(String conversationId) =>
      _datasource.markAsRead(conversationId);
}
