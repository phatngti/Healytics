import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:logging/logging.dart';

import 'sse_event.dart';

/// Reusable SSE (Server-Sent Events) client that
/// opens an HTTP connection and yields [SseEvent]s.
///
/// Supports both GET and POST methods. Auth headers
/// are injected via the [headers] parameter so this
/// class stays decoupled from [ApiService].
class SseClient {
  static final _log = Logger('SseClient');

  /// Default timeout for long-running SSE streams.
  static const _defaultTimeout =
      Duration(seconds: 600);

  const SseClient._();

  /// Singleton instance.
  static const instance = SseClient._();

  /// Opens a **GET**-based SSE stream to [url].
  Stream<SseEvent> get(
    String url, {
    required Map<String, String> headers,
  }) {
    final controller = StreamController<SseEvent>();
    _startStream(
      method: 'GET',
      url: url,
      headers: headers,
      controller: controller,
    );
    return controller.stream;
  }

  /// Opens a **POST**-based SSE stream to [url]
  /// with a JSON [body].
  Stream<SseEvent> post(
    String url, {
    required Map<String, String> headers,
    required Map<String, dynamic> body,
  }) {
    final controller = StreamController<SseEvent>();
    _startStream(
      method: 'POST',
      url: url,
      headers: headers,
      body: body,
      controller: controller,
    );
    return controller.stream;
  }

  // ── Internal ──────────────────────────────────────

  Future<void> _startStream({
    required String method,
    required String url,
    required Map<String, String> headers,
    required StreamController<SseEvent> controller,
    Map<String, dynamic>? body,
  }) async {
    // Use a long-timeout IOClient for SSE streams
    // to avoid premature disconnection.
    final ioClient = HttpClient()
      ..connectionTimeout = _defaultTimeout
      ..idleTimeout = _defaultTimeout;
    final client = IOClient(ioClient);

    try {
      final uri = Uri.parse(url);
      final request = http.Request(method, uri);

      // Merge caller headers with SSE defaults.
      request.headers.addAll(headers);
      request.headers['Accept'] =
          'text/event-stream';
      request.headers['Cache-Control'] = 'no-cache';

      if (body != null) {
        request.headers['Content-Type'] =
            'application/json';
        request.body = jsonEncode(body);
      }

      final response = await client.send(request);
      await _parseResponse(response, controller);
    } catch (e, st) {
      _log.severe('SSE stream error', e, st);
      if (!controller.isClosed) {
        controller.addError(e, st);
      }
    } finally {
      if (!controller.isClosed) {
        await controller.close();
      }
      client.close();
    }
  }

  /// Reads a streamed HTTP response and parses SSE
  /// `event:` / `data:` lines into [SseEvent]s.
  Future<void> _parseResponse(
    http.StreamedResponse response,
    StreamController<SseEvent> controller,
  ) async {
    if (response.statusCode >= 400) {
      controller.addError(
        Exception(
          'SSE connection failed: '
          '${response.statusCode}',
        ),
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
          } else if (line.startsWith('data:')) {
            dataBuffer.write(
              line.substring(5).trim(),
            );
          } else if (line.isEmpty &&
              eventType.isNotEmpty) {
            _emitEvent(
              eventType,
              dataBuffer.toString(),
              controller,
            );
            eventType = '';
            dataBuffer.clear();
          }
        });
  }

  /// Parses raw SSE data and emits an [SseEvent].
  void _emitEvent(
    String rawType,
    String rawData,
    StreamController<SseEvent> controller,
  ) {
    try {
      final data = rawData.isNotEmpty
          ? jsonDecode(rawData)
                as Map<String, dynamic>
          : <String, dynamic>{};

      controller.add(
        SseEvent(type: rawType, data: data),
      );
    } catch (e) {
      _log.severe(
        'Failed to parse SSE data: $rawData',
        e,
      );
    }
  }
}
