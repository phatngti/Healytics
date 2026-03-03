import 'dart:async';

import 'package:logging/logging.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_openapi/api.dart';

import 'package:user_app/features/bot_chat/domain/entities/chat_conversation.entity.dart';
import 'package:user_app/features/bot_chat/domain/entities/chat_message.entity.dart';
import 'package:user_app/features/bot_chat/domain/entities/chat_sse_event.entity.dart';
import 'chat_mock_data.dart';
import 'chat_sse_service.dart';

/// Contract for fetching chat data from a remote source.
abstract class ChatRemoteDatasource {
  /// Fetches all conversation sessions for the current user.
  Future<List<ChatConversation>> getConversations();

  /// Fetches messages for a given [conversationId].
  Future<List<ChatMessage>> getMessages(String conversationId);

  /// Sends a [text] message and returns an SSE stream
  /// of chatbot response events.
  ///
  /// [conversationId] may be null for a new conversation.
  Stream<ChatSseEvent> sendMessageAndStream(
    String? conversationId,
    String text,
  );
}

/// Real implementation backed by [ChatbotApi] and
/// [ChatSseService] for SSE streaming.
class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  static final _log = Logger('ChatRemoteDatasourceImpl');

  final ChatbotApi _chatbotApi;
  final ChatSseService _sseService;

  const ChatRemoteDatasourceImpl(this._chatbotApi, this._sseService);

  @override
  Future<List<ChatConversation>> getConversations() async {
    final response = await _chatbotApi.chatbotControllerListConversations();
    if (response == null) return [];
    return response.conversations.map(_mapItemToEntity).toList();
  }

  /// Maps [ConversationListItemDto] → [ChatConversation].
  ChatConversation _mapItemToEntity(ConversationListItemDto dto) {
    return ChatConversation(
      id: dto.id,
      title: dto.title,
      lastMessage: dto.lastMessage,
      timestamp: DateTime.parse(dto.timestamp),
    );
  }

  @override
  Future<List<ChatMessage>> getMessages(String conversationId) async {
    _log.info('getMessages not yet wired to API');
    return [];
  }

  @override
  Stream<ChatSseEvent> sendMessageAndStream(
    String? conversationId,
    String text,
  ) async* {
    // 1. POST /chatbot/send → get stream URL.
    final dto = SendMessageDto(message: text, conversationId: conversationId);

    final response = await _chatbotApi.chatbotControllerSendMessage(dto);

    if (response == null) {
      throw Exception('Send message returned null');
    }

    // 2. Open SSE stream.
    _log.info('Opening SSE stream: ${response.streamUrl}');

    var isFirstEvent = true;

    yield* _sseService
        .connect(response.streamUrl)
        .map((event) {
          if (isFirstEvent) {
            _log.info(
              'SSE connected successfully, '
              'first event type: ${event.type}',
            );
            isFirstEvent = false;
          }
          return event;
        })
        .handleError((Object error, StackTrace st) {
          _log.severe('SSE connection error', error, st);
          // Re-throw so upstream consumers still see
          // the error.
          // ignore: only_throw_errors
          throw error;
        });
  }
}

/// Mock implementation that simulates SSE streaming
/// with token-by-token delays.
class ChatRemoteDatasourceMock implements ChatRemoteDatasource {
  @override
  Future<List<ChatConversation>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return kMockConversations;
  }

  @override
  Future<List<ChatMessage>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 400));
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
      await Future.delayed(const Duration(milliseconds: 80));
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
    await Future.delayed(const Duration(milliseconds: 200));
    yield ChatSseEvent(
      type: ChatSseEventType.nerLocation,
      data: {
        'request_id': 'mock-req-1',
        'conversation_id': mockConvId,
        ...kMockNerLocation,
      },
    );

    // 3. Service recommendation event.
    await Future.delayed(const Duration(milliseconds: 300));
    yield ChatSseEvent(
      type: ChatSseEventType.serviceRecommendation,
      data: {
        'request_id': 'mock-req-1',
        'conversation_id': mockConvId,
        ...kMockServiceRecommendation,
      },
    );

    // 4. Follow-up text segment.
    for (var i = 0; i < kMockSseFollowUpWords.length; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      yield ChatSseEvent(
        type: ChatSseEventType.token,
        data: {
          'request_id': 'mock-req-1',
          'conversation_id': mockConvId,
          'text': kMockSseFollowUpWords[i],
          'index': kMockSseTokenWords.length + i + 1,
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

/// Provides a [ChatbotApi] instance using the core
/// [ApiService] client.
final chatbotApiProvider = Provider<ChatbotApi>((ref) {
  final apiClient = ref.read(apiServiceProvider).apiClient;
  return ChatbotApi(apiClient);
});

/// Provides a [ChatSseService] using the same base path
/// as the [ApiService].
final chatSseServiceProvider = Provider<ChatSseService>((ref) {
  final basePath = ref.read(apiServiceProvider).apiClient.basePath;
  return ChatSseService(basePath: basePath);
});

/// Uses [StoreKey.mockFlag] to switch between real and
/// mock implementations at runtime.
final chatRemoteDatasourceProvider = Provider<ChatRemoteDatasource>((ref) {
  final useMock = Store.tryGet(StoreKey.mockFlag) == 'true';

  if (useMock) {
    return ChatRemoteDatasourceMock();
  }

  return ChatRemoteDatasourceImpl(
    ref.read(chatbotApiProvider),
    ref.read(chatSseServiceProvider),
  );
});
