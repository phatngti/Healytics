import 'package:http/http.dart';
import 'package:logging/logging.dart';

class LoggingClient extends BaseClient {
  final Client _inner;
  final Logger _log = Logger('LoggingClient');

  LoggingClient(this._inner);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final stopwatch = Stopwatch()..start();
    try {
      final response = await _inner.send(request);
      stopwatch.stop();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _logError(request, response, stopwatch.elapsed);
      } else {
        _log.finer(
          'Success: ${request.method} ${request.url} (${stopwatch.elapsedMilliseconds}ms)',
        );
      }

      return response;
    } catch (e, stackTrace) {
      stopwatch.stop();
      _log.severe(
        'Exception: ${request.method} ${request.url} (${stopwatch.elapsedMilliseconds}ms)',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  void _logError(
    BaseRequest request,
    StreamedResponse response,
    Duration elapsed,
  ) async {
    // Note: We avoid reading the stream here because it can only be read once.
    // If we need the body, we would have to use Response.fromStream which might impact performance
    // and complicate the flow since we return StreamedResponse.
    // For now, logging metadata is a safe and effective start.
    _log.warning(
      'API Error: ${request.method} ${request.url}\n'
      'Status: ${response.statusCode}\n'
      'Duration: ${elapsed.elapsedMilliseconds}ms\n'
      'Headers: ${response.headers}',
    );
  }
}

extension on Duration {
  int get elapsedMilliseconds => inMilliseconds;
}
