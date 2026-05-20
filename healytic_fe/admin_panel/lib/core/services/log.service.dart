import 'dart:async';

import 'package:admin_panel/core/utils/console_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:admin_panel/core/models/log.model.dart';

class LogService {
  final List<LogMessage> _msgBuffer = [];

  /// Whether to buffer logs in memory before writing
  /// to the database. Increases performance and
  /// reduces NAND wear when logging in quick
  /// succession. May cause log loss on crash.
  final bool _shouldBuffer;

  Timer? _flushTimer;

  late final StreamSubscription<LogRecord> _logSubscription;

  static LogService? _instance;
  static LogService get I {
    if (_instance == null) {
      throw const LoggerUnInitializedException();
    }
    return _instance!;
  }

  static Future<LogService> init({bool shouldBuffer = true}) async {
    _instance ??= await create(shouldBuffer: shouldBuffer);
    return _instance!;
  }

  static Future<LogService> create({bool shouldBuffer = true}) async {
    final instance = LogService._(shouldBuffer);

    Logger.root.level = Level.ALL;
    return instance;
  }

  LogService._(this._shouldBuffer) {
    _logSubscription = Logger.root.onRecord.listen(_handleLogRecord);
  }

  void _handleLogRecord(LogRecord r) {
    if (kDebugMode) {
      final formatted =
          '[${r.level.name}] [${r.time}] '
          '[${r.loggerName}] ${r.message}'
          '${r.error == null ? '' : '\nError: ${r.error}'}'
          '${r.stackTrace == null ? '' : '\nStack: ${r.stackTrace}'}';

      debugPrint(formatted);

      // Route WARNING+ logs to browser console.error
      // so they appear in the DevTools "Errors" tab
      // with red highlighting. No-op on non-web.
      if (r.level >= Level.WARNING) {
        logErrorToConsole(formatted);
      }
    }

    final record = LogMessage(
      message: r.message,
      level: r.level.toLogLevel(),
      createdAt: r.time,
      logger: r.loggerName,
      error: r.error?.toString(),
      stack: r.stackTrace?.toString(),
    );

    if (_shouldBuffer) {
      _msgBuffer.add(record);
      _flushTimer ??= Timer(
        const Duration(seconds: 5),
        () => unawaited(flushBuffer()),
      );
    } else {
      // TODO: insert database here
    }
  }

  Future<void> setLogLevel(LogLevel level) async {
    Logger.root.level = level.toLevel();
  }

  Future<List<LogMessage>> getMessages() async {
    return [..._msgBuffer.reversed];
  }

  Future<void> clearLogs() async {
    _flushTimer?.cancel();
    _flushTimer = null;
    _msgBuffer.clear();
  }

  void flush() {
    _flushTimer?.cancel();
  }

  Future<void> dispose() {
    _flushTimer?.cancel();
    _logSubscription.cancel();
    return flushBuffer();
  }

  // TOOD: Move this to private once Isar is removed
  Future<void> flushBuffer() async {
    _flushTimer = null;
    _msgBuffer.clear();
  }
}

class LoggerUnInitializedException implements Exception {
  const LoggerUnInitializedException();

  @override
  String toString() => 'Logger is not initialized. Call init()';
}

/// Log levels according to dart logging [Level]
extension LevelDomainToInfraExtension on Level {
  LogLevel toLogLevel() =>
      LogLevel.values.elementAtOrNull(Level.LEVELS.indexOf(this)) ??
      LogLevel.info;
}

extension on LogLevel {
  Level toLevel() => Level.LEVELS.elementAtOrNull(index) ?? Level.INFO;
}
