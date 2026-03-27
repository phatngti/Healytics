import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/bot_chat/domain/entities/chat_sse_event.entity.dart';

/// Connects to the chatbot SSE stream and yields
/// parsed [ChatSseEvent] objects.
///
/// Supports both GET-based and POST-based SSE
/// connections. The POST variant is used by the
/// `/generative_ai/stream` endpoint.
class ChatSseService {
  final String _basePath;

  /// Creates a service pointing at [basePath]
  /// (e.g. `https://api.healytics.vn/api`).
  const ChatSseService({required String basePath}) : _basePath = basePath;

  /// Opens a GET-based SSE connection to [streamPath].
  ///
  /// [streamPath] is relative, e.g.
  /// `/chatbot/stream/{conversationId}`.
  Stream<ChatSseEvent> connect(String streamPath) {
    final controller = StreamController<ChatSseEvent>();
    _startGetStream(streamPath, controller);
    return controller.stream;
  }

  /// Opens a POST-based SSE connection to [path] with
  /// a JSON [body].
  ///
  /// Used by the generative-AI streaming endpoint which
  /// returns SSE events directly in the response body.
  Stream<ChatSseEvent> postAndStream(String path, Map<String, dynamic> body) {
    final controller = StreamController<ChatSseEvent>();
    _startPostStream(path, body, controller);
    return controller.stream;
  }

  // ── GET-based SSE ─────────────────────────────────

  Future<void> _startGetStream(
    String streamPath,
    StreamController<ChatSseEvent> controller,
  ) async {
    final client = http.Client();

    try {
      final uri = Uri.parse('$_basePath$streamPath');
      final request = http.Request('GET', uri);
      request.headers.addAll(_sseHeaders());

      final response = await client.send(request);
      await _listenToResponse(response, controller);
    } catch (e, st) {
      _handleStreamError(e, st, controller);
    } finally {
      _closeResources(controller, client);
    }
  }

  // ── POST-based SSE ────────────────────────────────

  Future<void> _startPostStream(
    String path,
    Map<String, dynamic> body,
    StreamController<ChatSseEvent> controller,
  ) async {
    final ioClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 600)
      ..idleTimeout = const Duration(seconds: 600);
    final client = IOClient(ioClient);

    try {
      final uri = Uri.parse('$_basePath$path');
      final request = http.Request('POST', uri);
      request.headers.addAll(_sseHeaders());
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);

      final response = await client.send(request);
      await _listenToResponse(response, controller);
    } catch (e, st) {
      _handleStreamError(e, st, controller);
    } finally {
      _closeResources(controller, client);
    }
  }

  // ── Shared SSE response parsing ───────────────────

  /// Reads a streamed HTTP response and parses SSE
  /// `event:` / `data:` lines into [ChatSseEvent]s.
  Future<void> _listenToResponse(
    http.StreamedResponse response,
    StreamController<ChatSseEvent> controller,
  ) async {
    if (response.statusCode >= 400) {
      controller.addError(
        Exception('SSE connection failed: ${response.statusCode}'),
      );
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
            log('SSE event received: $eventType', name: 'ChatSseService');
          } else if (line.startsWith('data:')) {
            dataBuffer.write(line.substring(5).trim());
          } else if (line.isEmpty && eventType.isNotEmpty) {
            _emitEvent(eventType, dataBuffer.toString(), controller);
            eventType = '';
            dataBuffer.clear();
          }
        });
  }

  // ── Helpers ───────────────────────────────────────

  /// Returns the common headers for SSE connections.
  Map<String, String> _sseHeaders() {
    final headers = ApiService.getRequestHeaders();
    headers['Accept'] = 'text/event-stream';
    headers['Cache-Control'] = 'no-cache';
    return headers;
  }

  /// Logs an error and forwards it to the [controller].
  void _handleStreamError(
    Object error,
    StackTrace st,
    StreamController<ChatSseEvent> controller,
  ) {
    log(
      'SSE stream error',
      name: 'ChatSseService',
      error: error,
      stackTrace: st,
    );
    if (!controller.isClosed) {
      controller.addError(error);
    }
  }

  /// Closes the [controller] and HTTP [client].
  Future<void> _closeResources(
    StreamController<ChatSseEvent> controller,
    http.Client client,
  ) async {
    if (!controller.isClosed) {
      await controller.close();
    }
    client.close();
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
