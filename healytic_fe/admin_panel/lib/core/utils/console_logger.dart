/// Platform-aware console logger.
///
/// On **web**, delegates to `console.error` via JS
/// interop so errors appear in the browser DevTools
/// "Errors" tab with red highlighting.
///
/// On **non-web** platforms, this is a no-op — terminal
/// output is handled by [LogService] via [debugPrint].
export 'console_logger_io.dart'
    if (dart.library.html) 'console_logger_web.dart';
