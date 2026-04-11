import 'package:user_app/features/partner_chat/data/datasources/remote/partner_chat_remote_datasource.dart';
import 'package:user_app/features/partner_chat/domain/entities/partner_chat_message.entity.dart';
import 'package:user_app/features/partner_chat/domain/entities/partner_conversation.entity.dart';
import 'package:user_app/features/partner_chat/domain/repositories/partner_chat.repository.dart';

/// Concrete repository implementation.
///
/// Delegates all operations to
/// [PartnerChatRemoteDatasource].
class PartnerChatRepositoryImpl
    implements PartnerChatRepository {
  final PartnerChatRemoteDatasource _datasource;

  PartnerChatRepositoryImpl({
    required PartnerChatRemoteDatasource datasource,
  }) : _datasource = datasource;

  @override
  Future<PartnerConversation> getOrCreateConversation({
    required String partnerAccountId,
    String? initialMessage,
  }) =>
      _datasource.getOrCreateConversation(
        partnerAccountId: partnerAccountId,
        initialMessage: initialMessage,
      );

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
  Future<List<PartnerConversation>>
      getConversations() =>
          _datasource.getConversations();

  @override
  Future<void> markAsRead(String conversationId) =>
      _datasource.markAsRead(conversationId);
}
