/// No-op on non-web platforms.
///
/// Terminal output is already handled by [LogService]
/// via [debugPrint], so no additional console logging
/// is needed for native/desktop targets.
void logErrorToConsole(String message) {}
