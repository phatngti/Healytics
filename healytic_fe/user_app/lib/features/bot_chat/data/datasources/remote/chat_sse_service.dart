import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/bot_chat/domain/entities/chat_sse_event.entity.dart';

/// Connects to the chatbot SSE stream and yields
/// parsed [ChatSseEvent] objects.
///
/// Uses [http.Client.send] with a [http.StreamedRequest]
/// to obtain a streamed response, then parses the raw
/// SSE text format (`event:` / `data:` lines) into
/// domain events.
class ChatSseService {
  final String _basePath;

  /// Creates a service pointing at [basePath]
  /// (e.g. `https://api.healytics.vn/api`).
  const ChatSseService({required String basePath}) : _basePath = basePath;

  /// Opens an SSE connection to [streamPath] and returns
  /// a broadcast stream of [ChatSseEvent]s.
  ///
  /// [streamPath] is relative, e.g.
  /// `/chatbot/stream/{conversationId}`.
  ///
  /// The returned stream completes when the server closes
  /// the connection or a `done` / `error` event is
  /// received.
  Stream<ChatSseEvent> connect(String streamPath) {
    final controller = StreamController<ChatSseEvent>();
    _startListening(streamPath, controller);
    return controller.stream;
  }

  Future<void> _startListening(
    String streamPath,
    StreamController<ChatSseEvent> controller,
  ) async {
    final client = http.Client();

    try {
      final uri = Uri.parse('$_basePath$streamPath');
      final headers = ApiService.getRequestHeaders();
      headers['Accept'] = 'text/event-stream';
      headers['Cache-Control'] = 'no-cache';

      final request = http.Request('GET', uri);
      request.headers.addAll(headers);

      final response = await client.send(request);

      if (response.statusCode >= 400) {
        controller.addError(
          Exception('SSE connection failed: ${response.statusCode}'),
        );
        await controller.close();
        client.close();
        return;
      }

      String eventType = '';
      final dataBuffer = StringBuffer();

      await response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .forEach((line) {
            if (controller.isClosed) return;

            if (line.startsWith('event:')) {
              eventType = line.substring(6).trim();
            } else if (line.startsWith('data:')) {
              dataBuffer.write(line.substring(5).trim());
            } else if (line.isEmpty && eventType.isNotEmpty) {
              // Empty line = end of SSE event block.
              _emitEvent(eventType, dataBuffer.toString(), controller);
              eventType = '';
              dataBuffer.clear();
            }
          });
    } catch (e, st) {
      log('SSE stream error', name: 'ChatSseService', error: e, stackTrace: st);
      if (!controller.isClosed) {
        controller.addError(e);
      }
    } finally {
      if (!controller.isClosed) {
        await controller.close();
      }
      client.close();
    }
  }

  /// Parses a raw SSE data payload and emits a
  /// [ChatSseEvent] into the [controller].
  void _emitEvent(
    String rawType,
    String rawData,
    StreamController<ChatSseEvent> controller,
  ) {
    final type = ChatSseEvent.parseType(rawType);
    if (type == null) {
      log('Unknown SSE event type: $rawType', name: 'ChatSseService');
      return;
    }

    try {
      final data = rawData.isNotEmpty
          ? jsonDecode(rawData) as Map<String, dynamic>
          : <String, dynamic>{};

      controller.add(ChatSseEvent(type: type, data: data));
    } catch (e) {
      log(
        'Failed to parse SSE data: $rawData',
        name: 'ChatSseService',
        error: e,
      );
    }
  }
}
