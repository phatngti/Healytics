import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/features/ai_health_assistant/domain/repositories/chat.repository.dart';
import 'package:user_app/features/ai_health_assistant/domain/entities/chat_conversation.entity.dart';
import 'package:user_app/features/ai_health_assistant/domain/entities/chat_message.entity.dart';
import 'package:user_app/features/ai_health_assistant/domain/entities/chat_sse_event.entity.dart';
import 'package:user_app/features/ai_health_assistant/data/datasources/remote/chat_remote_datasource.dart';

/// Concrete [ChatRepository] that delegates to a
/// [ChatRemoteDatasource].
class ChatImplementRepository
    implements ChatRepository {
  final ChatRemoteDatasource _remoteDatasource;

  ChatImplementRepository({
    required ChatRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<List<ChatConversation>>
      getConversations() async {
    return _remoteDatasource.getConversations();
  }

  @override
  Future<List<ChatMessage>> getMessages(
    String conversationId,
  ) async {
    return _remoteDatasource.getMessages(
      conversationId,
    );
  }

  @override
  Stream<ChatSseEvent> sendMessageAndStream(
    String? conversationId,
    String text, {
    double? currentLat,
    double? currentLng,
  }) {
    return _remoteDatasource.sendMessageAndStream(
      conversationId,
      text,
      currentLat: currentLat,
      currentLng: currentLng,
    );
  }
}

/// Provides a [ChatRepository] backed by the active
/// datasource (real or mock, determined by
/// [chatRemoteDatasourceProvider]).
final chatRepositoryProvider =
    Provider<ChatRepository>((ref) {
      final remoteDatasource =
          ref.read(chatRemoteDatasourceProvider);
      return ChatImplementRepository(
        remoteDatasource: remoteDatasource,
      );
    });
