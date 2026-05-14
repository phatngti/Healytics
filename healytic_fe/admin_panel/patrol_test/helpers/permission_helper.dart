import 'package:patrol/patrol.dart';

/// Handles native permission dialogs if visible.
///
/// Safe to call even if no dialog appears. The admin
/// panel primarily runs on web, but keeping this helper
/// matches the Patrol suite structure used by user_app.
Future<void> handlePermissionIfVisible(
  PatrolIntegrationTester $, {
  Duration timeout = const Duration(seconds: 3),
}) async {
  final isVisible = await _isPermissionDialogVisible($, timeout);
  if (isVisible) {
    await $.platform.mobile.grantPermissionWhenInUse();
  }
}

/// Grants all visible permission dialogs.
Future<void> grantAllPermissions(PatrolIntegrationTester $) async {
  for (var i = 0; i < 3; i++) {
    final isVisible = await _isPermissionDialogVisible(
      $,
      const Duration(seconds: 2),
    );
    if (!isVisible) break;
    await $.platform.mobile.grantPermissionWhenInUse();
  }
}

Future<bool> _isPermissionDialogVisible(
  PatrolIntegrationTester $,
  Duration timeout,
) async {
  try {
    return await $.platform.mobile.isPermissionDialogVisible(timeout: timeout);
  } on UnsupportedError {
    return false;
  }
}
