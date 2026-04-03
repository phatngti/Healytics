import 'package:logging/logging.dart';

import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/ai_health_assistant/domain/entities/chat_sse_event.entity.dart';

/// Thin wrapper that delegates the raw SSE connection
/// to [ApiService.openSseStream] and maps generic
/// [SseEvent]s into domain-specific [ChatSseEvent]s.
class ChatSseService {
  static final _log = Logger('ChatSseService');
  final ApiService _apiService;

  /// Creates a service backed by [apiService] for
  /// SSE streaming on the AI service prefix.
  const ChatSseService(this._apiService);

  /// Opens a GET-based SSE connection to [streamPath]
  /// on the AI service.
  Stream<ChatSseEvent> connect(String streamPath) {
    return _apiService
        .openSseStream(
          prefix: ServicePrefix.ai,
          method: 'GET',
          path: streamPath,
        )
        .map(_mapEvent)
        .where((e) => e != null)
        .cast<ChatSseEvent>();
  }

  /// Opens a POST-based SSE connection to [path]
  /// with a JSON [body] on the AI service.
  ///
  /// Used by the generative-AI streaming endpoint
  /// (`POST /generative_ai/stream`).
  Stream<ChatSseEvent> postAndStream(
    String path,
    Map<String, dynamic> body,
  ) {
    return _apiService
        .openSseStream(
          prefix: ServicePrefix.ai,
          method: 'POST',
          path: path,
          body: body,
        )
        .map(_mapEvent)
        .where((e) => e != null)
        .cast<ChatSseEvent>();
  }

  /// Maps a generic [SseEvent] to a [ChatSseEvent].
  ///
  /// Returns `null` for unknown event types so they
  /// are filtered out by `.where()`.
  ChatSseEvent? _mapEvent(dynamic raw) {
    final type = ChatSseEvent.parseType(raw.type);
    if (type == null) {
      _log.warning(
        'Unknown SSE event type: ${raw.type}',
      );
      return null;
    }
    return ChatSseEvent(type: type, data: raw.data);
  }
}
