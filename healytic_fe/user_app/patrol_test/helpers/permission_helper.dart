import 'package:patrol/patrol.dart';

/// Handles native permission dialogs if visible.
///
/// Grants "When In Use" permission. Safe to call
/// even if no dialog appears — will timeout silently.
Future<void> handlePermissionIfVisible(
  PatrolIntegrationTester $, {
  Duration timeout = const Duration(seconds: 3),
}) async {
  if (await $.native
      .isPermissionDialogVisible(timeout: timeout)) {
    await $.native.grantPermissionWhenInUse();
  }
}

/// Grants all visible permission dialogs.
///
/// Useful at app startup when multiple permissions
/// may be requested in sequence.
Future<void> grantAllPermissions(
  PatrolIntegrationTester $,
) async {
  // Try up to 3 times for sequential dialogs
  for (var i = 0; i < 3; i++) {
    final isVisible = await $.native
        .isPermissionDialogVisible(
          timeout: const Duration(seconds: 2),
        );
    if (!isVisible) break;
    await $.native.grantPermissionWhenInUse();
  }
}
