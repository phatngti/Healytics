import 'package:user_app/features/notifications/'
    'data/datasources/remote/'
    'notification_remote_datasource.dart';
import 'package:user_app/features/notifications/domain/'
    'repositories/notification.repository.dart';

/// Delegates to the remote data source.
class NotificationRepositoryImpl
    implements NotificationRepository {
  final NotificationRemoteDatasource _datasource;

  NotificationRepositoryImpl(this._datasource);

  @override
  Future<List<NotificationSection>>
      getNotifications() =>
          _datasource.getNotifications();
}
