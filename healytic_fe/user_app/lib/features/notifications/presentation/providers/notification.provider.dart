import 'dart:async';

import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/config/notification_config.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';
import 'package:user_app/core/providers/ws.provider.dart';
import 'package:user_app/core/services/ws/ws_client.dart';
import 'package:user_app/features/notifications/'
    'data/datasources/remote/'
    'notification_remote_datasource.dart';
import 'package:user_app/features/notifications/'
    'data/repositories/'
    'notification_impl.repository.dart';
import 'package:user_app/features/notifications/'
    'domain/entities/notification.entity.dart';
import 'package:user_app/features/notifications/'
    'domain/repositories/notification.repository.dart';

part 'notification.provider.g.dart';

final _log = Logger('NotificationProvider');

// ─── Repository Provider ───────────────────────────

/// Provides the [NotificationRepository] backed by
/// the current datasource (real or mock).
@riverpod
NotificationRepository notificationRepository(Ref ref) {
  final datasource = ref.read(notificationRemoteDatasourceProvider);
  return NotificationRepositoryImpl(datasource);
}

// ─── Notification List (Stateful) ──────────────────

/// Stateful async notifier managing the paginated
/// notification list.
///
/// Features:
/// - Initial fetch from REST API
/// - Cursor-based load-more
/// - Optimistic mark-read / mark-all-read
/// - Pull-to-refresh
@riverpod
class NotificationNotifier extends _$NotificationNotifier {
  List<NotificationEntity> _all = [];
  String? _nextCursor;
  bool _hasMore = true;
  final Set<String> _markingReadIds = <String>{};
  bool _isMarkingAllRead = false;

  @override
  FutureOr<List<NotificationEntity>> build() async {
    final repo = ref.read(notificationRepositoryProvider);
    final page = await repo.getNotifications();
    _all = page.notifications.toList();
    _nextCursor = page.nextCursor;
    _hasMore = page.hasMore;

    return List.unmodifiable(_all);
  }

  /// Whether there are more pages to load.
  bool get hasMore => _hasMore;

  /// Load the next page of notifications.
  Future<void> loadMore() async {
    if (!_hasMore || _nextCursor == null) return;

    final repo = ref.read(notificationRepositoryProvider);
    final page = await repo.getNotifications(cursor: _nextCursor);

    _all.addAll(page.notifications);
    _nextCursor = page.nextCursor;
    _hasMore = page.hasMore;
    state = AsyncData(List.unmodifiable(_all));
  }

  /// Mark a single notification as read
  /// (optimistic update).
  Future<void> markRead(String id) async {
    if (_isMarkingAllRead || _markingReadIds.contains(id)) {
      return;
    }

    final idx = _all.indexWhere((n) => n.id == id);
    if (idx == -1 || _all[idx].isRead) return;
    _markingReadIds.add(id);
    final previousNotification = _all[idx];
    final previousUnreadCount = ref.read(unreadCountProvider).value;

    _all[idx] = _all[idx].copyWith(isRead: true);
    state = AsyncData(List.unmodifiable(_all));

    ref.read(unreadCountProvider.notifier).decrement();

    try {
      final repo = ref.read(notificationRepositoryProvider);
      await repo.markRead(id);
    } catch (e) {
      _log.warning('markRead failed: $e');
      _all[idx] = previousNotification;
      state = AsyncData(List.unmodifiable(_all));
      final unreadCountNotifier = ref.read(unreadCountProvider.notifier);
      if (previousUnreadCount != null) {
        unreadCountNotifier.setCount(previousUnreadCount);
      } else {
        ref.invalidate(unreadCountProvider);
      }
    } finally {
      _markingReadIds.remove(id);
    }
  }

  /// Mark all notifications as read.
  Future<void> markAllRead() async {
    if (_isMarkingAllRead) {
      return;
    }

    if (_all.every((notification) => notification.isRead)) {
      return;
    }

    _isMarkingAllRead = true;
    final previousAll = List<NotificationEntity>.from(_all);
    final previousUnreadCount = ref.read(unreadCountProvider).value;
    _all = _all.map((n) => n.isRead ? n : n.copyWith(isRead: true)).toList();
    state = AsyncData(List.unmodifiable(_all));
    ref.read(unreadCountProvider.notifier).reset();

    try {
      final repo = ref.read(notificationRepositoryProvider);
      await repo.markAllRead();
    } catch (e) {
      _log.warning('markAllRead failed: $e');
      _all = previousAll;
      state = AsyncData(List.unmodifiable(_all));
      final unreadCountNotifier = ref.read(unreadCountProvider.notifier);
      if (previousUnreadCount != null) {
        unreadCountNotifier.setCount(previousUnreadCount);
      } else {
        ref.invalidate(unreadCountProvider);
      }
    } finally {
      _isMarkingAllRead = false;
    }
  }

  /// Pull-to-refresh: reload from scratch.
  Future<void> refresh() async {
    final repo = ref.read(notificationRepositoryProvider);
    final page = await repo.getNotifications();
    _all = page.notifications.toList();
    _nextCursor = page.nextCursor;
    _hasMore = page.hasMore;
    state = AsyncData(List.unmodifiable(_all));

    ref.invalidate(unreadCountProvider);
  }

  /// Merge a real-time notification pushed by the backend WS gateway.
  void addIncoming(NotificationEntity notification) {
    final index = _all.indexWhere((item) => item.id == notification.id);
    if (index == -1) {
      _all.insert(0, notification);
    } else {
      _all[index] = notification;
    }

    _all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = AsyncData(List.unmodifiable(_all));
  }
}

// ─── Unread Count (Badge) ──────────────────────────

/// Manages the unread notification badge count.
///
/// - Initialises from REST API
/// - Supports optimistic inc/dec from mark-read
@riverpod
class UnreadCount extends _$UnreadCount {
  @override
  FutureOr<int> build() async {
    final repo = ref.read(notificationRepositoryProvider);
    return repo.getUnreadCount();
  }

  /// Decrement by 1 (optimistic, from mark-read).
  void decrement() {
    final current = state.value ?? 0;
    if (current > 0) {
      state = AsyncData(current - 1);
    }
  }

  /// Increment by 1 (revert failed mark-read).
  void increment() {
    final current = state.value ?? 0;
    state = AsyncData(current + 1);
  }

  /// Restore the unread count to a known value.
  void setCount(int value) {
    state = AsyncData(value);
  }

  /// Reset to 0 (from mark-all-read).
  void reset() {
    state = const AsyncData(0);
  }
}

// ─── Real-time Notification Events ─────────────────

/// Keeps the backend `/notifications` Socket.IO namespace connected for
/// authenticated real-backend environments.
@Riverpod(keepAlive: true)
Stream<WsConnectionStatus> notificationWsConnection(Ref ref) {
  final config = NotificationConfig.fromStore();
  if (!config.inAppEnabled || !config.webSocketEnabled) {
    return Stream.value(WsConnectionStatus.disconnected);
  }

  final authSessionStore = ref.read(authSessionStoreProvider);
  final wsService = ref.read(wsServiceProvider);
  String previousToken = '';

  void syncWithToken(String? token) {
    final currentToken = (token ?? '').trim();
    if (currentToken.isEmpty) {
      if (wsService.notifications.status != WsConnectionStatus.disconnected) {
        _log.info('Disconnecting /notifications WS because token is empty');
        wsService.notifications.disconnect();
      }
      previousToken = '';
      return;
    }

    final shouldReconnect =
        previousToken.isNotEmpty && previousToken != currentToken;
    previousToken = currentToken;

    if (shouldReconnect) {
      _log.info('Reconnecting /notifications WS after token change');
      wsService.reconnectNotifications();
      return;
    }

    _log.info('Connecting /notifications WS namespace');
    wsService.connectNotifications();
  }

  final tokenStream = authSessionStore.watchAccessToken();
  syncWithToken(Store.tryGet(StoreKey.accessToken));
  final tokenSub = tokenStream.listen(syncWithToken);

  ref.onDispose(() {
    tokenSub.cancel();
    _log.info('Disposed /notifications WS connection');
  });

  return wsService.notifications.onConnectionChange;
}

/// Emits notification entities as they arrive from the backend in real time.
///
/// Side effects stay here so all global listeners share one subscription:
/// - insert/update the in-memory notification list
/// - update the unread badge when the backend sends `unread_count`
@Riverpod(keepAlive: true)
Stream<NotificationEntity> latestNotificationEvent(Ref ref) {
  final config = NotificationConfig.fromStore();
  if (!config.inAppEnabled || !config.webSocketEnabled) {
    return const Stream.empty();
  }

  ref.watch(notificationWsConnectionProvider);
  final wsService = ref.read(wsServiceProvider);
  final controller = StreamController<NotificationEntity>.broadcast();

  final notificationSub = wsService.notifications.onNewNotification.listen((
    event,
  ) {
    final notification = _mapWsNotification(event);
    ref.read(notificationProvider.notifier).addIncoming(notification);
    controller.add(notification);
  });

  final countSub = wsService.notifications.onUnreadCount.listen((event) {
    ref.read(unreadCountProvider.notifier).setCount(event.count.toInt());
  });

  ref.onDispose(() {
    notificationSub.cancel();
    countSub.cancel();
    controller.close();
  });

  return controller.stream;
}

NotificationEntity _mapWsNotification(WsNewNotificationEvent event) {
  return NotificationEntity(
    id: event.id,
    type: _mapWsNotificationType(event.type),
    title: event.title,
    body: event.body,
    data: event.data,
    isRead: event.isRead,
    isBroadcast: event.isBroadcast,
    createdAt: event.createdAt,
    readAt: event.readAt,
  );
}

NotificationType _mapWsNotificationType(WsNotificationType type) {
  return switch (type) {
    WsNotificationType.bookingConfirmed => NotificationType.bookingConfirmed,
    WsNotificationType.bookingCancelled => NotificationType.bookingCancelled,
    WsNotificationType.bookingCompleted => NotificationType.bookingCompleted,
    WsNotificationType.appointmentReminder =>
      NotificationType.appointmentReminder,
    WsNotificationType.appointmentUpdated =>
      NotificationType.appointmentUpdated,
    WsNotificationType.newChatMessage => NotificationType.newChatMessage,
    WsNotificationType.paymentSuccess => NotificationType.paymentSuccess,
    WsNotificationType.paymentFailed => NotificationType.paymentFailed,
    WsNotificationType.systemBroadcast => NotificationType.systemBroadcast,
    WsNotificationType.systemMaintenance => NotificationType.systemMaintenance,
    WsNotificationType.partnerVerified => NotificationType.partnerVerified,
    WsNotificationType.partnerRejected => NotificationType.partnerRejected,
  };
}
