import 'dart:async';

import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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

// ─── WS Connection Lifecycle ───────────────────────

/// Eagerly connects the `/notifications` WebSocket
/// namespace and keeps it alive for the app session.
///
/// Watch this provider in the shell route to ensure
/// the WS is connected as soon as the user is
/// authenticated and the main scaffold loads.
@Riverpod(keepAlive: true)
Stream<WsConnectionStatus> notificationWsConnection(
  Ref ref,
) {
  final authSessionStore = ref.read(authSessionStoreProvider);
  final wsService = ref.read(wsServiceProvider);
  String previousToken = '';

  void syncWithToken(String? token) {
    final currentToken = (token ?? '').trim();
    if (currentToken.isEmpty) {
      if (wsService.notifications.status !=
          WsConnectionStatus.disconnected) {
        _log.info(
          'Disconnecting /notifications WS '
          'because token is empty',
        );
        wsService.notifications.disconnect();
      }
      previousToken = '';
      return;
    }

    final shouldReconnect =
        previousToken.isNotEmpty &&
        previousToken != currentToken;
    previousToken = currentToken;

    if (shouldReconnect) {
      _log.info(
        'Reconnecting /notifications WS '
        'after token change',
      );
      wsService.reconnectNotifications();
      return;
    }

    _log.info('Connecting /notifications WS namespace');
    wsService.connectNotifications();
  }

  final tokenStream = authSessionStore.watchAccessToken();
  syncWithToken(Store.tryGet(StoreKey.accessToken));
  final tokenSub = tokenStream.listen(
    syncWithToken,
  );

  ref.onDispose(() {
    tokenSub.cancel();
    _log.info('Disposed /notifications WS connection');
  });

  return wsService.notifications.onConnectionChange;
}

// ─── Latest Notification Event (for Toast) ─────────

/// Exposes the latest WS [WsNewNotificationEvent] as
/// a stream for the global toast listener.
///
/// This is a thin wrapper over the socket stream so
/// that the toast widget does not need to depend on
/// the full [NotificationNotifier] state.
@Riverpod(keepAlive: true)
Stream<WsNewNotificationEvent> latestNotificationEvent(
  Ref ref,
) {
  // Ensure WS is connected first
  ref.watch(notificationWsConnectionProvider);
  final wsService = ref.read(wsServiceProvider);
  return wsService.notifications.onNewNotification;
}

// ─── Repository Provider ───────────────────────────

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

// ─── Notification List (Stateful) ──────────────────

/// Stateful async notifier managing the paginated
/// notification list with real-time WS updates.
///
/// Features:
/// - Initial fetch from REST API
/// - Cursor-based load-more
/// - Prepends real-time WS notifications
/// - Optimistic mark-read / mark-all-read
/// - Pull-to-refresh
@riverpod
class NotificationNotifier extends _$NotificationNotifier {
  List<NotificationEntity> _all = [];
  String? _nextCursor;
  bool _hasMore = true;
  StreamSubscription<WsNewNotificationEvent>? _wsSub;

  @override
  FutureOr<List<NotificationEntity>> build() async {
    // 1. Fetch first page from REST
    final repo = ref.read(notificationRepositoryProvider);
    final page = await repo.getNotifications();
    _all = page.notifications.toList();
    _nextCursor = page.nextCursor;
    _hasMore = page.hasMore;

    // 2. Subscribe to real-time WS notifications
    _setupWsListener();

    // 3. Clean up on dispose
    ref.onDispose(() {
      _wsSub?.cancel();
      _wsSub = null;
    });

    return List.unmodifiable(_all);
  }

  /// Whether there are more pages to load.
  bool get hasMore => _hasMore;

  /// Load the next page of notifications.
  Future<void> loadMore() async {
    if (!_hasMore || _nextCursor == null) return;

    final repo = ref.read(notificationRepositoryProvider);
    final page = await repo.getNotifications(
      cursor: _nextCursor,
    );

    _all.addAll(page.notifications);
    _nextCursor = page.nextCursor;
    _hasMore = page.hasMore;
    state = AsyncData(List.unmodifiable(_all));
  }

  /// Mark a single notification as read
  /// (optimistic update).
  Future<void> markRead(String id) async {
    // Optimistic: update local state immediately
    final idx = _all.indexWhere((n) => n.id == id);
    if (idx == -1 || _all[idx].isRead) return;

    _all[idx] = _all[idx].copyWith(isRead: true);
    state = AsyncData(List.unmodifiable(_all));

    // Update unread badge
    ref.read(unreadCountProvider.notifier).decrement();

    // Persist to backend
    try {
      final repo = ref.read(
        notificationRepositoryProvider,
      );
      await repo.markRead(id);
    } catch (e) {
      _log.warning('markRead failed: $e');
      // Revert optimistic update
      _all[idx] = _all[idx].copyWith(isRead: false);
      state = AsyncData(List.unmodifiable(_all));
      ref.read(unreadCountProvider.notifier).increment();
    }
  }

  /// Mark all notifications as read.
  Future<void> markAllRead() async {
    // Optimistic: mark all as read locally
    final previousAll = List<NotificationEntity>.from(
      _all,
    );
    _all = _all
        .map((n) => n.isRead ? n : n.copyWith(isRead: true))
        .toList();
    state = AsyncData(List.unmodifiable(_all));
    ref.read(unreadCountProvider.notifier).reset();

    try {
      final repo = ref.read(
        notificationRepositoryProvider,
      );
      await repo.markAllRead();
    } catch (e) {
      _log.warning('markAllRead failed: $e');
      _all = previousAll;
      state = AsyncData(List.unmodifiable(_all));
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

    // Also refresh unread count
    ref.invalidate(unreadCountProvider);
  }

  /// Subscribe to real-time WS new_notification
  /// events and prepend them to the list.
  void _setupWsListener() {
    final wsService = ref.read(wsServiceProvider);
    _wsSub = wsService.notifications.onNewNotification
        .listen((event) {
      // Avoid duplicates
      if (_all.any((n) => n.id == event.id)) return;

      final entity = NotificationEntity(
        id: event.id,
        type: _mapWsType(event.type),
        title: event.title,
        body: event.body,
        data: event.data,
        isRead: event.isRead,
        isBroadcast: event.isBroadcast,
        createdAt: event.createdAt,
      );

      _all.insert(0, entity);
      state = AsyncData(List.unmodifiable(_all));

      // Bump badge immediately — the server also
      // sends a separate unread_count event which
      // will overwrite with the authoritative value,
      // but this ensures instant UI feedback.
      if (!entity.isRead) {
        ref
            .read(unreadCountProvider.notifier)
            .increment();
      }

      _log.fine(
        'WS notification prepended: ${event.id}',
      );
    });
  }

  /// Maps the auto-generated [WsNotificationType]
  /// to the domain [NotificationType].
  NotificationType _mapWsType(WsNotificationType t) {
    return switch (t) {
      WsNotificationType.bookingConfirmed =>
        NotificationType.bookingConfirmed,
      WsNotificationType.bookingCancelled =>
        NotificationType.bookingCancelled,
      WsNotificationType.bookingCompleted =>
        NotificationType.bookingCompleted,
      WsNotificationType.appointmentReminder =>
        NotificationType.appointmentReminder,
      WsNotificationType.appointmentUpdated =>
        NotificationType.appointmentUpdated,
      WsNotificationType.newChatMessage =>
        NotificationType.newChatMessage,
      WsNotificationType.paymentSuccess =>
        NotificationType.paymentSuccess,
      WsNotificationType.paymentFailed =>
        NotificationType.paymentFailed,
      WsNotificationType.systemBroadcast =>
        NotificationType.systemBroadcast,
      WsNotificationType.systemMaintenance =>
        NotificationType.systemMaintenance,
      WsNotificationType.partnerVerified =>
        NotificationType.partnerVerified,
      WsNotificationType.partnerRejected =>
        NotificationType.partnerRejected,
    };
  }
}

// ─── Unread Count (Badge) ──────────────────────────

/// Manages the unread notification badge count.
///
/// - Initialises from REST API
/// - Subscribes to WS `unread_count` events
/// - Supports optimistic inc/dec from mark-read
@riverpod
class UnreadCount extends _$UnreadCount {
  StreamSubscription<WsUnreadCountEvent>? _wsSub;

  @override
  FutureOr<int> build() async {
    final repo = ref.read(notificationRepositoryProvider);
    final count = await repo.getUnreadCount();

    // Subscribe to WS updates
    final wsService = ref.read(wsServiceProvider);
    _wsSub = wsService.notifications.onUnreadCount
        .listen((event) {
      state = AsyncData(event.count.toInt());
    });

    ref.onDispose(() {
      _wsSub?.cancel();
      _wsSub = null;
    });

    return count;
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

  /// Reset to 0 (from mark-all-read).
  void reset() {
    state = const AsyncData(0);
  }
}
