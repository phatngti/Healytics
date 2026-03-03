import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user_app/core/models/log.model.dart';

/// Singleton service that logs to the terminal
/// (via `debugPrint`) and persists entries to a
/// daily file under `<app_docs>/log/`.
class LogService {
  final List<LogMessage> _msgBuffer = [];
  Directory? _logDir;

  /// Whether to buffer logs in memory before writing to the database.
  /// This is useful when logging in quick succession, as it increases performance
  /// and reduces NAND wear. However, it may cause the logs to be lost in case of a crash / in isolates.
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
    await instance._initLogDirectory();

    Logger.root.level = Level.ALL;
    return instance;
  }

  LogService._(this._shouldBuffer) {
    _logSubscription = Logger.root.onRecord.listen(_handleLogRecord);
  }

  /// Creates `<app_docs>/log/` if it doesn't exist.
  Future<void> _initLogDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    _logDir = Directory('${docsDir.path}/log');
    if (!_logDir!.existsSync()) {
      _logDir!.createSync(recursive: true);
    }
  }

  /// Returns today's log file, e.g. `log/2026-03-02.log`.
  File? get _todayLogFile {
    if (_logDir == null) return null;
    final date = DateTime.now().toIso8601String().split('T').first;
    return File('${_logDir!.path}/$date.log');
  }

  /// Appends a single formatted line to the daily file.
  Future<void> _writeToFile(LogRecord r) async {
    final file = _todayLogFile;
    if (file == null) return;
    final line =
        '[${r.level.name}] '
        '[${r.time}] '
        '[${r.loggerName}] '
        '${r.message}'
        '${r.error == null ? '' : '\nError: ${r.error}'}'
        '${r.stackTrace == null ? '' : '\nStack: ${r.stackTrace}'}'
        '\n';
    await file.writeAsString(line, mode: FileMode.append);
  }

  void _handleLogRecord(LogRecord r) {
    if (kDebugMode) {
      debugPrint(
        '[${r.level.name}] [${r.time}] '
        '[${r.loggerName}] ${r.message}'
        '${r.error == null ? '' : '\nError: ${r.error}'}'
        '${r.stackTrace == null ? '' : '\nStack: ${r.stackTrace}'}',
      );
    }

    // Persist to daily log file.
    unawaited(_writeToFile(r));

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
