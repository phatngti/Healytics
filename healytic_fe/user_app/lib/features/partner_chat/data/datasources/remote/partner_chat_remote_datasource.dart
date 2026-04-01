import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:user_app/features/partner_chat/domain/entities/partner_chat_message.entity.dart';
import 'package:user_app/features/partner_chat/domain/entities/partner_conversation.entity.dart';
import 'package:user_openapi/api.dart';

import 'partner_chat_mock_data.dart';

// ─── Part A: Abstract Interface ──────────────────────

/// Data source contract for partner chat REST
/// operations.
abstract class PartnerChatRemoteDatasource {
  /// Get or create a conversation with a partner.
  Future<PartnerConversation> getOrCreateConversation({
    required String partnerAccountId,
    String? initialMessage,
  });

  /// Fetch paginated messages for a conversation.
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

// ─── Part B: Real Implementation ─────────────────────

/// Uses the OpenAPI-generated [UserChatApi] for
/// conversation and read endpoints, with a raw HTTP
/// fallback for `getMessages` (OpenAPI spec doesn't
/// return a typed body for that endpoint yet).
class PartnerChatRemoteDatasourceImpl
    implements PartnerChatRemoteDatasource {
  static final _log = Logger(
    'PartnerChatRemoteDatasourceImpl',
  );

  final UserChatApi _chatApi;

  PartnerChatRemoteDatasourceImpl({
    required UserChatApi chatApi,
  }) : _chatApi = chatApi;

  @override
  Future<PartnerConversation> getOrCreateConversation({
    required String partnerAccountId,
    String? initialMessage,
  }) async {
    _log.info(
      'Creating conversation with $partnerAccountId',
    );

    final dto = CreateConversationDto(
      healthPartnerId: partnerAccountId,
      initialMessage: initialMessage,
    );

    final response = await _chatApi
        .userChatControllerCreateConversation(dto);

    if (response == null) {
      throw Exception(
        'Failed to create conversation: '
        'empty response',
      );
    }

    return _mapConversationDto(response);
  }

  @override
  Future<List<PartnerChatMessage>> getMessages(
    String conversationId, {
    String? beforeId,
    int limit = 20,
  }) async {
    // The OpenAPI spec returns void for getMessages,
    // so we use the raw HTTP response directly.
    final response = await _chatApi
        .userChatControllerGetMessagesWithHttpInfo(
      conversationId,
      beforeId: beforeId,
      limit: limit,
    );

    if (response.statusCode >= 400) {
      throw Exception(
        'Failed to fetch messages: '
        '${response.statusCode}',
      );
    }

    if (response.body.isEmpty) return [];

    final data = jsonDecode(response.body);
    // Backend may wrap in {messages: [...]}
    // or return a flat list.
    final List<dynamic> list;
    if (data is Map<String, dynamic>) {
      list = data['messages'] as List<dynamic>? ?? [];
    } else if (data is List) {
      list = data;
    } else {
      return [];
    }

    // Backend returns DESC (newest first) — reverse
    // to chronological order (oldest first) so the
    // provider and reverse ListView work correctly.
    return list
        .map(
          (e) => _mapMessage(
            e as Map<String, dynamic>,
          ),
        )
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<List<PartnerConversation>>
      getConversations() async {
    _log.info('Fetching conversations');

    final response = await _chatApi
        .userChatControllerGetConversations();

    if (response == null) return [];

    return response.map(_mapConversationDto).toList();
  }

  @override
  Future<void> markAsRead(
    String conversationId,
  ) async {
    _log.info('Marking $conversationId as read');
    try {
      await _chatApi.userChatControllerMarkRead(
        conversationId,
      );
    } catch (e) {
      _log.warning(
        'markAsRead failed: $e',
      );
    }
  }

  // ── DTO → Entity mapping ──────────────────────────

  PartnerConversation _mapConversationDto(
    ConversationResponseDto dto,
  ) {
    final p = dto.otherParticipant;
    final lm = dto.lastMessage;

    return PartnerConversation(
      id: dto.id,
      status: dto.status.value,
      bookingId: dto.bookingId,
      otherParticipant: ParticipantInfo(
        id: p.id,
        name: p.name,
        avatar: p.avatar,
        role: p.role,
      ),
      lastMessage: LastMessagePreview(
        text: lm.text,
        timestamp: lm.timestamp,
        senderId: lm.senderId,
      ),
      unreadCount: dto.unreadCount.toInt(),
      createdAt: dto.createdAt,
    );
  }

  PartnerChatMessage _mapMessage(
    Map<String, dynamic> data,
  ) {
    return PartnerChatMessage(
      id: data['id'] as String,
      conversationId:
          data['conversationId'] as String,
      senderId: data['senderId'] as String,
      senderName: data['senderName'] as String?,
      senderAvatar: data['senderAvatar'] as String?,
      content: data['content'] as String? ?? '',
      messageType: _parseMessageType(
        data['messageType'],
      ),
      clientMessageId:
          data['clientMessageId'] as String?,
      createdAt: DateTime.parse(
        data['createdAt'] as String,
      ),
    );
  }

  PartnerMessageType _parseMessageType(dynamic raw) {
    if (raw == null) return PartnerMessageType.text;
    final str = raw.toString().toLowerCase();
    return switch (str) {
      'system' => PartnerMessageType.system,
      _ => PartnerMessageType.text,
    };
  }
}

// ─── Part C: Mock Implementation ─────────────────────

/// Returns hardcoded data for UI development.
class PartnerChatRemoteDatasourceMock
    implements PartnerChatRemoteDatasource {
  @override
  Future<PartnerConversation> getOrCreateConversation({
    required String partnerAccountId,
    String? initialMessage,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    return parseConversation(
      kMockPartnerConversations.first,
    );
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
    return kMockMessages;
  }

  @override
  Future<List<PartnerConversation>>
      getConversations() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    return kMockPartnerConversations
        .map(parseConversation)
        .toList();
  }

  @override
  Future<void> markAsRead(String conversationId) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
    );
    Logger('PartnerChatMock').info(
      'Marked $conversationId as read',
    );
  }
}
