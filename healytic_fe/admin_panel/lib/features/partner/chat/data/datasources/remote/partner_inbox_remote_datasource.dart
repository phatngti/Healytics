import 'package:flutter/foundation.dart';

import 'package:admin_panel/features/partner/chat/domain/entities/partner_chat_message.entity.dart';
import 'package:admin_panel/features/partner/chat/domain/entities/partner_conversation.entity.dart';

import 'partner_chat_mock_data.dart';

// ─── Part A: Interface ───────────────────────────────

/// Data source contract for partner inbox REST calls.
abstract class PartnerInboxRemoteDatasource {
  Future<List<PartnerConversation>> getConversations();
  Future<List<PartnerChatMessage>> getMessages(
    String conversationId, {
    String? beforeId,
    int limit = 20,
  });
  Future<void> markAsRead(String conversationId);
}

// ─── Part B: Real Implementation ─────────────────────

/// TODO: Wire with OpenAPI PartnerChatApi.
class PartnerInboxRemoteDatasourceImpl
    implements PartnerInboxRemoteDatasource {
  @override
  Future<List<PartnerConversation>>
      getConversations() async {
    throw UnimplementedError(
      'Wire up with OpenAPI client',
    );
  }

  @override
  Future<List<PartnerChatMessage>> getMessages(
    String conversationId, {
    String? beforeId,
    int limit = 20,
  }) async {
    throw UnimplementedError(
      'Wire up with OpenAPI client',
    );
  }

  @override
  Future<void> markAsRead(
    String conversationId,
  ) async {
    throw UnimplementedError(
      'Wire up with OpenAPI client',
    );
  }
}

// ─── Part C: Mock Implementation ─────────────────────

class PartnerInboxRemoteDatasourceMock
    implements PartnerInboxRemoteDatasource {
  @override
  Future<List<PartnerConversation>>
      getConversations() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    return kMockInboxConversations;
  }

  @override
  Future<List<PartnerChatMessage>> getMessages(
    String conversationId, {
    String? beforeId,
    int limit = 20,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 400),
    );
    return kMockInboxMessages;
  }

  @override
  Future<void> markAsRead(
    String conversationId,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    );
    debugPrint(
      '[Mock] Marked $conversationId as read',
    );
  }
}
