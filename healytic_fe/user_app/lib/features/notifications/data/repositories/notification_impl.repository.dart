import 'package:user_app/features/notifications/'
    'data/datasources/remote/'
    'notification_remote_datasource.dart';
import 'package:user_app/features/notifications/domain/'
    'entities/notification.entity.dart';
import 'package:user_app/features/notifications/domain/'
    'repositories/notification.repository.dart';

/// Delegates all calls to the remote data source.
class NotificationRepositoryImpl
    implements NotificationRepository {
  final NotificationRemoteDatasource _datasource;

  NotificationRepositoryImpl(this._datasource);

  @override
  Future<NotificationPage> getNotifications({
    int limit = 20,
    String? cursor,
  }) =>
      _datasource.getNotifications(
        limit: limit,
        cursor: cursor,
      );

  @override
  Future<int> getUnreadCount() =>
      _datasource.getUnreadCount();

  @override
  Future<void> markRead(String notificationId) =>
      _datasource.markRead(notificationId);

  @override
  Future<int> markAllRead() =>
      _datasource.markAllRead();

  @override
  Future<void> registerDevice({
    required String token,
    required String platform,
  }) =>
      _datasource.registerDevice(
        token: token,
        platform: platform,
      );

  @override
  Future<void> unregisterDevice(String token) =>
      _datasource.unregisterDevice(token);
}
