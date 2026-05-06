import 'dart:convert';
import 'dart:developer';

import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/utils/browser_storage.dart';
import 'package:admin_panel/core/utils/user_role_helper.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

/// Global HTTP interceptor that catches and logs all
/// HTTP errors with actionable diagnostics.
///
/// For every failed request, logs include:
/// - HTTP method, URL, and status code
/// - Error message parsed from the response body
/// - Request duration
/// - **Caller file and line number** for easy tracking
///
/// Output goes to:
/// - **Terminal**: via [Logger] → [LogService]
/// - **Browser console**: via `console.error` (web),
///   handled by [LogService] for WARNING+ levels
class LoggingClient extends BaseClient {
  final Client _inner;
  final Logger _log = Logger('HTTP');

  LoggingClient(this._inner);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    // Capture call stack before any await so we can
    // trace back to the originating datasource.
    final callerTrace = StackTrace.current;
    final stopwatch = Stopwatch()..start();

    try {
      final response = await _inner.send(request);
      stopwatch.stop();

      if (response.statusCode == 401) {
        _handleUnauthorized(request);
        return response;
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return _handleErrorResponse(
          request: request,
          response: response,
          elapsed: stopwatch.elapsed,
          callerTrace: callerTrace,
        );
      }

      _log.finer(
        '✓ ${request.method} ${request.url}'
        ' (${stopwatch.elapsedMilliseconds}ms)',
      );
      return response;
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logNetworkException(
        request: request,
        error: e,
        stackTrace: stackTrace,
        elapsed: stopwatch.elapsed,
      );
      rethrow;
    }
  }

  /// Reads the error response body, logs full
  /// diagnostics, and rebuilds the response stream
  /// so the caller can still consume it.
  Future<StreamedResponse> _handleErrorResponse({
    required BaseRequest request,
    required StreamedResponse response,
    required Duration elapsed,
    required StackTrace callerTrace,
  }) async {
    final bytes = await response.stream.toBytes();
    final body = utf8.decode(bytes, allowMalformed: true);

    _logHttpError(
      request: request,
      statusCode: response.statusCode,
      body: body,
      elapsed: elapsed,
      callerTrace: callerTrace,
    );

    // Rebuild response so the caller's stream is not
    // consumed by our logging.
    return StreamedResponse(
      Stream.value(bytes),
      response.statusCode,
      contentLength: bytes.length,
      request: response.request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }

  /// Formats and emits the HTTP error log to the
  /// [Logger] pipeline. [LogService] handles routing
  /// to terminal and browser `console.error`.
  void _logHttpError({
    required BaseRequest request,
    required int statusCode,
    required String body,
    required Duration elapsed,
    required StackTrace callerTrace,
  }) {
    final errorMsg = _parseErrorMessage(body);
    final callerInfo = _extractCallerInfo(callerTrace);
    final callerLines = callerInfo.split('\n').map((l) => '║   $l').join('\n');

    final message = StringBuffer()
      ..writeln(
        '╔══ HTTP ERROR '
        '${'═' * 40}',
      )
      ..writeln('║ ${request.method} ${request.url}')
      ..writeln('║ Status: $statusCode')
      ..writeln('║ Message: $errorMsg')
      ..writeln(
        '║ Duration: '
        '${elapsed.inMilliseconds}ms',
      )
      ..writeln('║ Called from:')
      ..writeln(callerLines)
      ..write('╚${'═' * 54}');

    _log.warning(message.toString());
  }

  /// Logs network-level exceptions (timeout, socket
  /// errors, etc.) that prevent a response entirely.
  void _logNetworkException({
    required BaseRequest request,
    required Object error,
    required StackTrace stackTrace,
    required Duration elapsed,
  }) {
    final message = StringBuffer()
      ..writeln(
        '╔══ NETWORK ERROR '
        '${'═' * 37}',
      )
      ..writeln('║ ${request.method} ${request.url}')
      ..writeln('║ Error: $error')
      ..writeln(
        '║ Duration: '
        '${elapsed.inMilliseconds}ms',
      )
      ..write('╚${'═' * 54}');

    _log.severe(message.toString(), error, stackTrace);
  }

  /// Clears the entire auth session so
  /// [RouterListenable] triggers a GoRouter refresh,
  /// which redirects the user to the login page.
  ///
  /// Clears:
  /// - Drift store access token (triggers watch)
  /// - Browser localStorage fallback token (web)
  /// - Partner verification & profile flags
  void _handleUnauthorized(BaseRequest request) {
    log(
      '401 Unauthorized — clearing session: '
      '${request.url}',
      name: 'HTTP',
    );

    // Clear the primary Drift store token.
    // This triggers Store.watch → RouterListenable
    // → GoRouter redirect to login.
    Store.delete(StoreKey.accessToken);

    // Clear the browser localStorage fallback so
    // getRequestHeaders() stops sending stale tokens.
    removeBrowserItem('access_token');

    // Reset partner-specific flags to prevent stale
    // redirect state on next login.
    UserRoleHelper.clearSession();
  }

  /// Attempts to parse a human-readable error message
  /// from the JSON response [body].
  ///
  /// Handles NestJS error format where `message` can
  /// be a string or a list of validation errors.
  String _parseErrorMessage(String body) {
    if (body.isEmpty) return '<empty response>';

    try {
      final json = jsonDecode(body);
      if (json is! Map<String, dynamic>) return body;

      final message = json['message'];
      if (message is String) return message;
      if (message is List) return message.join(', ');

      final error = json['error'];
      if (error is String) return error;

      return body;
    } catch (_) {
      // Not JSON — return truncated raw body.
      return body.length > 200 ? '${body.substring(0, 200)}...' : body;
    }
  }

  /// Extracts relevant caller frames from [trace],
  /// filtering out HTTP internals and framework code
  /// to show only project source locations.
  String _extractCallerInfo(StackTrace trace) {
    final frames = trace.toString().split('\n');
    final relevant = <String>[];

    for (final frame in frames) {
      final isProjectFrame =
          frame.contains('package:admin_panel/') ||
          frame.contains('package:admin_openapi/');
      if (!isProjectFrame) continue;

      // Skip internal logging/network frames.
      if (frame.contains('logging_client.dart')) {
        continue;
      }

      relevant.add(frame.trim());
      if (relevant.length >= 5) break;
    }

    return relevant.isNotEmpty
        ? relevant.join('\n')
        : 'No caller info available';
  }
}
