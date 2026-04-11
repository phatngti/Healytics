import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:admin_openapi/api.dart';

import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/chat/domain/entities/partner_chat_message.entity.dart';
import 'package:admin_panel/features/partner/chat/domain/entities/partner_conversation.entity.dart';

import 'partner_chat_mock_data.dart';

/// Paginated result from message fetching.
class PaginatedMessages {
  final List<PartnerChatMessage> messages;
  final bool hasMore;
  final String? nextCursor;

  const PaginatedMessages({
    required this.messages,
    required this.hasMore,
    this.nextCursor,
  });
}

// ─── Part A: Interface ───────────────────────────────

/// Data source contract for partner inbox REST calls.
abstract class PartnerInboxRemoteDatasource {
  Future<List<PartnerConversation>> getConversations();
  Future<PaginatedMessages> getMessages(
    String conversationId, {
    String? beforeId,
    int limit = 20,
  });
  Future<void> markAsRead(String conversationId);
}

// ─── Part B: Real Implementation ─────────────────────

/// Wired to [PartnerChatApi] from the OpenAPI client.
class PartnerInboxRemoteDatasourceImpl
    implements PartnerInboxRemoteDatasource {
  final ApiService _apiService;
  static final _log =
      Logger('PartnerInboxRemoteDatasourceImpl');

  PartnerInboxRemoteDatasourceImpl({
    required ApiService apiService,
  }) : _apiService = apiService;

  PartnerChatApi get _chatApi =>
      _apiService.partnerChatApi;

  @override
  Future<List<PartnerConversation>>
      getConversations() async {
    final dtos = await _chatApi
        .partnerChatControllerGetConversations();

    if (dtos == null) return [];

    return dtos
        .map(_mapConversation)
        .toList(growable: false);
  }

  @override
  Future<PaginatedMessages> getMessages(
    String conversationId, {
    String? beforeId,
    int limit = 20,
  }) async {
    // The generated API returns void, so we parse
    // the raw HTTP response manually.
    final response = await _chatApi
        .partnerChatControllerGetMessagesWithHttpInfo(
      conversationId,
      beforeId: beforeId,
      limit: limit,
    );

    if (response.statusCode >= 400) {
      throw ApiException(
        response.statusCode,
        'Failed to load messages',
      );
    }

    if (response.body.isEmpty) {
      return const PaginatedMessages(
        messages: [],
        hasMore: false,
      );
    }

    final decoded = jsonDecode(response.body);

    // The backend returns a paginated wrapper:
    // { "messages": [...], "hasMore": bool, "nextCursor": ... }.
    final List<dynamic> items;
    bool hasMore = false;
    String? nextCursor;

    if (decoded is Map<String, dynamic>) {
      items = (decoded['messages']
              as List<dynamic>?) ??
          [];
      hasMore = decoded['hasMore'] as bool? ?? false;
      nextCursor = decoded['nextCursor'] as String?;
    } else if (decoded is List) {
      items = decoded;
    } else {
      _log.warning(
        'Unexpected messages format: '
        '${decoded.runtimeType}',
      );
      return const PaginatedMessages(
        messages: [],
        hasMore: false,
      );
    }

    // Backend returns messages in ASC (chronological)
    // order — render directly.
    return PaginatedMessages(
      messages: items
          .map(_mapMessage)
          .toList(growable: false),
      hasMore: hasMore,
      nextCursor: nextCursor,
    );
  }

  @override
  Future<void> markAsRead(
    String conversationId,
  ) async {
    await _chatApi.partnerChatControllerMarkRead(
      conversationId,
    );
  }

  // ── DTO → Entity Mappers ──────────────────────────

  /// Maps [ConversationResponseDto] to domain
  /// [PartnerConversation].
  PartnerConversation _mapConversation(
    ConversationResponseDto dto,
  ) {
    return PartnerConversation(
      id: dto.id,
      status: dto.status.value,
      bookingId: dto.bookingId,
      otherParticipant: ParticipantInfo(
        id: dto.otherParticipant.id,
        name: dto.otherParticipant.name,
        avatar: dto.otherParticipant.avatar,
        role: dto.otherParticipant.role,
      ),
      lastMessage: LastMessagePreview(
        text: dto.lastMessage.text,
        timestamp: dto.lastMessage.timestamp,
        senderId: dto.lastMessage.senderId,
      ),
      unreadCount: dto.unreadCount.toInt(),
      createdAt: dto.createdAt,
    );
  }

  /// Maps a raw JSON map to a domain
  /// [PartnerChatMessage].
  ///
  /// Uses defensive parsing because the generated
  /// client lacks a typed response DTO for messages.
  PartnerChatMessage _mapMessage(
    dynamic json,
  ) {
    final map = json as Map<String, dynamic>;

    final rawType =
        map['messageType']?.toString() ?? 'text';
    final messageType = rawType == 'system'
        ? PartnerMessageType.system
        : PartnerMessageType.text;

    return PartnerChatMessage(
      id: map['id']?.toString() ?? '',
      conversationId:
          map['conversationId']?.toString() ?? '',
      senderId: map['senderId']?.toString() ?? '',
      senderName: map['senderName']?.toString(),
      senderAvatar: map['senderAvatar']?.toString(),
      content: map['content']?.toString() ?? '',
      messageType: messageType,
      clientMessageId:
          map['clientMessageId']?.toString(),
      createdAt: _parseDateTime(map['createdAt']),
      isRead: map['isRead'] == true,
    );
  }

  /// Safely parses a date-time value from the API.
  DateTime _parseDateTime(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value) ??
          DateTime.now();
    }
    _log.warning(
      'Unexpected date format: $value',
    );
    return DateTime.now();
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
  Future<PaginatedMessages> getMessages(
    String conversationId, {
    String? beforeId,
    int limit = 20,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 400),
    );
    return PaginatedMessages(
      messages: kMockInboxMessages,
      hasMore: false,
    );
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
