import 'dart:js_interop';

/// JS interop binding to `globalThis.console`.
extension type _JSConsole(JSObject _) {
  external void error(JSAny? message);
}

@JS('console')
external _JSConsole get _console;

/// Outputs [message] to the browser DevTools console
/// as `console.error` — shown in red and filterable
/// via the "Errors" tab.
///
/// This ensures HTTP errors are prominently visible
/// in the browser alongside the terminal output.
void logErrorToConsole(String message) {
  _console.error(message.toJS);
}
