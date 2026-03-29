import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/notifications/'
    'data/datasources/remote/'
    'notification_remote_datasource.dart';
import 'package:user_app/features/notifications/'
    'data/repositories/'
    'notification_impl.repository.dart';
import 'package:user_app/features/notifications/'
    'domain/repositories/notification.repository.dart';

part 'notification.provider.g.dart';

/// Provides the [NotificationRepository] backed by
/// the current datasource (real or mock).
@riverpod
NotificationRepository notificationRepository(
  Ref ref,
) {
  final datasource = ref.read(
    notificationRemoteDatasourceProvider,
  );
  return NotificationRepositoryImpl(datasource);
}

/// Fetches grouped notification sections.
@riverpod
Future<List<NotificationSection>> notifications(
  Ref ref,
) async {
  final repo = ref.read(
    notificationRepositoryProvider,
  );
  return repo.getNotifications();
}
