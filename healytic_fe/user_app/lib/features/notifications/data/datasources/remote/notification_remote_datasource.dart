import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/features/notifications/domain/'
    'repositories/notification.repository.dart';
import 'notification_mock_data.dart';

// ─── Abstract Interface ────────────────────────────

/// Contract for fetching notification data from
/// a remote source.
abstract class NotificationRemoteDatasource {
  /// Returns grouped notification sections.
  Future<List<NotificationSection>> getNotifications();
}

// ─── Real Implementation ───────────────────────────

/// Placeholder for real API integration.
///
/// TODO(api): Wire to actual notification endpoint
/// when the backend exposes one.
class NotificationRemoteDatasourceImpl
    implements NotificationRemoteDatasource {
  @override
  Future<List<NotificationSection>>
      getNotifications() async {
    // Temporary: return mock data until the
    // backend notification API is available.
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    return kMockNotificationSections;
  }
}

// ─── Mock Implementation ───────────────────────────

/// Returns fake notification data after a simulated
/// network delay.
class NotificationRemoteDatasourceMock
    implements NotificationRemoteDatasource {
  @override
  Future<List<NotificationSection>>
      getNotifications() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    return kMockNotificationSections;
  }
}

// ─── Provider ──────────────────────────────────────

/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations at runtime.
final notificationRemoteDatasourceProvider =
    Provider<NotificationRemoteDatasource>((ref) {
  final useMock = AppEnvironment.current.useMock;

  if (useMock) {
    return NotificationRemoteDatasourceMock();
  }

  return NotificationRemoteDatasourceImpl();
});
