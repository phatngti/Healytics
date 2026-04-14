import 'dart:async';

import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
    final idx = _all.indexWhere((n) => n.id == id);
    if (idx == -1 || _all[idx].isRead) return;
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
    }
  }

  /// Mark all notifications as read.
  Future<void> markAllRead() async {
    if (_all.every((notification) => notification.isRead)) {
      return;
    }

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
