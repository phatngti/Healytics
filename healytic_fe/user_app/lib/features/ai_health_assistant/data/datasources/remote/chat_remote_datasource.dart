import 'dart:async';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logging/logging.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_openapi/api.dart';

import 'package:user_app/features/ai_health_assistant/domain/entities/chat_conversation.entity.dart';
import 'package:user_app/features/ai_health_assistant/domain/entities/chat_message.entity.dart';
import 'package:user_app/features/ai_health_assistant/domain/entities/chat_sse_event.entity.dart';
import 'chat_mock_data.dart';
import 'chat_sse_service.dart';

/// Contract for fetching chat data from a remote source.
abstract class ChatRemoteDatasource {
  /// Fetches all conversation sessions for the current
  /// user.
  Future<List<ChatConversation>> getConversations();

  /// Fetches messages for a given [conversationId].
  Future<List<ChatMessage>> getMessages(
    String conversationId,
  );

  /// Sends a [text] message and returns an SSE stream
  /// of chatbot response events.
  ///
  /// [conversationId] may be null for a new
  /// conversation.
  Stream<ChatSseEvent> sendMessageAndStream(
    String? conversationId,
    String text,
  );
}

/// Real implementation backed by [ChatbotApi]
/// (via [ApiService]) and [ChatSseService] for
/// POST-based SSE streaming via
/// `POST /generative_ai/stream`.
class ChatRemoteDatasourceImpl
    implements ChatRemoteDatasource {
  static final _log =
      Logger('ChatRemoteDatasourceImpl');

  // ignore: unused_field
  final ApiService _apiService;
  final ChatSseService _sseService;

  const ChatRemoteDatasourceImpl(
    this._apiService,
    this._sseService,
  );

  @override
  Future<List<ChatConversation>>
      getConversations() async {
    final userId = _extractUserId();
    _log.info('GET /chatbot/conversations '
        '(userId=$userId)');

    try {
      final response = await _apiService
          .chatbotApi
          .getConversationsChatbotConversationsGet(
        userId,
      );

      if (response == null) return [];

      return response.conversations
          .map(_mapConversation)
          .toList();
    } catch (e, st) {
      _log.severe(
        'Error fetching conversations',
        e,
        st,
      );
      rethrow;
    }
  }

  @override
  Future<List<ChatMessage>> getMessages(
    String conversationId,
  ) async {
    _log.info(
      'GET /chatbot/conversations/'
      '$conversationId/messages',
    );

    try {
      final response = await _apiService.chatbotApi
          .getMessagesChatbotConversationsConversationIdMessagesGet(
        conversationId,
      );

      if (response == null) return [];

      return response.messages
          .map(_mapMessage)
          .toList();
    } catch (e, st) {
      _log.severe(
        'Error fetching messages for '
        'conversation $conversationId',
        e,
        st,
      );
      rethrow;
    }
  }

  /// Maps [ConversationResponse] DTO to
  /// [ChatConversation] domain entity.
  ///
  /// Falls back to [title] for `lastMessage` since
  /// the API does not provide a preview field.
  ChatConversation _mapConversation(
    ConversationResponse dto,
  ) {
    return ChatConversation(
      id: dto.id,
      title: dto.title,
      lastMessage: dto.title,
      timestamp: dto.updatedAt,
      iconName: 'smart_toy',
    );
  }

  /// Maps [MessageResponse] DTO to [ChatMessage]
  /// domain entity.
  ///
  /// Uses `role == 'user'` to distinguish user
  /// messages from bot messages.
  ChatMessage _mapMessage(MessageResponse dto) {
    return ChatMessage(
      id: dto.id,
      text: dto.content,
      timestamp: dto.createdAt,
      isUser: dto.role == 'user',
      isRead: true,
    );
  }

  @override
  Stream<ChatSseEvent> sendMessageAndStream(
    String? conversationId,
    String text,
  ) async* {
    final userId = _extractUserId();

    final body = ChatbotRequest(
      conversationId: conversationId,
      userId: userId,
      message: text,
      enableNer: false,
    ).toJson();

    _log.info(
      'POST /generative_ai/stream '
      '(convId=$conversationId)',
    );

    var isFirstEvent = true;

    _log.fine('body:  $body');

    yield* _sseService
        .postAndStream(
          '/generative_ai/stream',
          body,
        )
        .map((event) {
          if (isFirstEvent) {
            _log.info(
              'SSE connected, first event '
              'type: ${event.type}',
            );
            isFirstEvent = false;
          }
          return event;
        })
        .handleError((Object error, StackTrace st) {
          _log.severe(
            'SSE connection error',
            error,
            st,
          );
          // Re-throw so upstream consumers still see
          // the error.
          // ignore: only_throw_errors
          throw error;
        });
  }

  /// Extracts the user ID from the JWT `sub` claim
  /// stored in [StoreKey.accessToken].
  String _extractUserId() {
    final token = Store.tryGet(StoreKey.accessToken);
    if (token == null || token.isEmpty) {
      throw Exception(
        'Cannot send message: no access token',
      );
    }

    try {
      final claims = JwtDecoder.decode(token);
      final sub = claims['sub'] as String?;
      if (sub == null || sub.isEmpty) {
        throw Exception(
          'Cannot send message: '
          'JWT missing "sub" claim',
        );
      }
      return sub;
    } catch (e) {
      throw Exception(
        'Cannot send message: '
        'failed to decode JWT — $e',
      );
    }
  }
}

/// Mock implementation that simulates SSE streaming
/// with token-by-token delays.
class ChatRemoteDatasourceMock
    implements ChatRemoteDatasource {
  @override
  Future<List<ChatConversation>> getConversations() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    return kMockConversations;
  }

  @override
  Future<List<ChatMessage>> getMessages(
    String conversationId,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 400),
    );
    return kMockMessages;
  }

  @override
  Stream<ChatSseEvent> sendMessageAndStream(
    String? conversationId,
    String text,
  ) async* {
    final mockConvId = conversationId ?? 'mock-conv-1';

    // 1. First text segment (token-by-token).
    for (var i = 0; i < kMockSseTokenWords.length; i++) {
      await Future.delayed(
        const Duration(milliseconds: 80),
      );
      yield ChatSseEvent(
        type: ChatSseEventType.token,
        data: {
          'request_id': 'mock-req-1',
          'conversation_id': mockConvId,
          'text': kMockSseTokenWords[i],
          'index': i + 1,
        },
      );
    }

    // 2. NER location event.
    await Future.delayed(
      const Duration(milliseconds: 200),
    );
    yield ChatSseEvent(
      type: ChatSseEventType.nerLocation,
      data: {
        'request_id': 'mock-req-1',
        'conversation_id': mockConvId,
        ...kMockNerLocation,
      },
    );

    // 3. Service recommendation event.
    await Future.delayed(
      const Duration(milliseconds: 300),
    );
    yield ChatSseEvent(
      type: ChatSseEventType.serviceRecommendation,
      data: {
        'request_id': 'mock-req-1',
        'conversation_id': mockConvId,
        ...kMockServiceRecommendation,
      },
    );

    // 4. Follow-up text segment.
    for (var i = 0;
        i < kMockSseFollowUpWords.length;
        i++) {
      await Future.delayed(
        const Duration(milliseconds: 80),
      );
      yield ChatSseEvent(
        type: ChatSseEventType.token,
        data: {
          'request_id': 'mock-req-1',
          'conversation_id': mockConvId,
          'text': kMockSseFollowUpWords[i],
          'index':
              kMockSseTokenWords.length + i + 1,
        },
      );
    }

    // 5. Done event.
    yield ChatSseEvent(
      type: ChatSseEventType.done,
      data: {
        'request_id': 'mock-req-1',
        'conversation_id': mockConvId,
        'status': 'completed',
      },
    );
  }
}

/// Provides a [ChatSseService] backed by [ApiService]
/// for centralized SSE stream management.
final chatSseServiceProvider =
    Provider<ChatSseService>((ref) {
      final apiService = ref.read(apiServiceProvider);
      return ChatSseService(apiService);
    });

/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations at runtime.
final chatRemoteDatasourceProvider =
    Provider<ChatRemoteDatasource>((ref) {
      final useMock = AppEnvironment.current.useMock;

      if (useMock) {
        return ChatRemoteDatasourceMock();
      }

      return ChatRemoteDatasourceImpl(
        ref.read(apiServiceProvider),
        ref.read(chatSseServiceProvider),
      );
    });
