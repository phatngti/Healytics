import 'package:patrol/patrol.dart';

/// Handles a native permission dialog if one is currently visible.
///
/// Grants the broadest permission available via the Patrol API
/// (`grantPermissionWhenInUse`). Safe to call unconditionally —
/// if no dialog appears within [timeout] it silently returns.
Future<void> handlePermissionIfVisible(
  PatrolIntegrationTester $, {
  Duration timeout = const Duration(seconds: 3),
}) async {
  if (await $.platform.mobile.isPermissionDialogVisible(
    timeout: timeout,
  )) {
    await $.platform.mobile.grantPermissionWhenInUse();
  }
}

/// Accepts every permission dialog that appears at app startup.
///
/// Repeatedly polls for a visible dialog and grants it up to
/// [maxAttempts] times. Handles sequential dialogs (e.g. location
/// followed by notifications) that arrive one after another.
///
/// Each grant uses [grantPermissionWhenInUse], which is the broadest
/// cross-platform grant exposed by the Patrol 4.x API.
///
/// Example:
/// ```dart
/// await grantAllPermissions($);
/// ```
Future<void> grantAllPermissions(
  PatrolIntegrationTester $, {
  int maxAttempts = 5,
  Duration perDialogTimeout = const Duration(seconds: 2),
}) async {
  for (var i = 0; i < maxAttempts; i++) {
    final isVisible = await $.platform.mobile.isPermissionDialogVisible(
      timeout: perDialogTimeout,
    );
    if (!isVisible) break;
    await $.platform.mobile.grantPermissionWhenInUse();
  }
}
