// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Eagerly connects the `/notifications` WebSocket
/// namespace and keeps it alive for the app session.
///
/// Watch this provider in the shell route to ensure
/// the WS is connected as soon as the user is
/// authenticated and the main scaffold loads.

@ProviderFor(notificationWsConnection)
const notificationWsConnectionProvider = NotificationWsConnectionProvider._();

/// Eagerly connects the `/notifications` WebSocket
/// namespace and keeps it alive for the app session.
///
/// Watch this provider in the shell route to ensure
/// the WS is connected as soon as the user is
/// authenticated and the main scaffold loads.

final class NotificationWsConnectionProvider
    extends
        $FunctionalProvider<
          AsyncValue<WsConnectionStatus>,
          WsConnectionStatus,
          Stream<WsConnectionStatus>
        >
    with
        $FutureModifier<WsConnectionStatus>,
        $StreamProvider<WsConnectionStatus> {
  /// Eagerly connects the `/notifications` WebSocket
  /// namespace and keeps it alive for the app session.
  ///
  /// Watch this provider in the shell route to ensure
  /// the WS is connected as soon as the user is
  /// authenticated and the main scaffold loads.
  const NotificationWsConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationWsConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationWsConnectionHash();

  @$internal
  @override
  $StreamProviderElement<WsConnectionStatus> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WsConnectionStatus> create(Ref ref) {
    return notificationWsConnection(ref);
  }
}

String _$notificationWsConnectionHash() =>
    r'aca57ed5832472d7a0a4ddbb8af58ba1ce5b89af';

/// Exposes the latest WS [WsNewNotificationEvent] as
/// a stream for the global toast listener.
///
/// This is a thin wrapper over the socket stream so
/// that the toast widget does not need to depend on
/// the full [NotificationNotifier] state.

@ProviderFor(latestNotificationEvent)
const latestNotificationEventProvider = LatestNotificationEventProvider._();

/// Exposes the latest WS [WsNewNotificationEvent] as
/// a stream for the global toast listener.
///
/// This is a thin wrapper over the socket stream so
/// that the toast widget does not need to depend on
/// the full [NotificationNotifier] state.

final class LatestNotificationEventProvider
    extends
        $FunctionalProvider<
          AsyncValue<WsNewNotificationEvent>,
          WsNewNotificationEvent,
          Stream<WsNewNotificationEvent>
        >
    with
        $FutureModifier<WsNewNotificationEvent>,
        $StreamProvider<WsNewNotificationEvent> {
  /// Exposes the latest WS [WsNewNotificationEvent] as
  /// a stream for the global toast listener.
  ///
  /// This is a thin wrapper over the socket stream so
  /// that the toast widget does not need to depend on
  /// the full [NotificationNotifier] state.
  const LatestNotificationEventProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestNotificationEventProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestNotificationEventHash();

  @$internal
  @override
  $StreamProviderElement<WsNewNotificationEvent> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WsNewNotificationEvent> create(Ref ref) {
    return latestNotificationEvent(ref);
  }
}

String _$latestNotificationEventHash() =>
    r'f1ba8fc4b0c1fe10eaf673f17eb7691d66aa216d';

/// Provides the [NotificationRepository] backed by
/// the current datasource (real or mock).

@ProviderFor(notificationRepository)
const notificationRepositoryProvider = NotificationRepositoryProvider._();

/// Provides the [NotificationRepository] backed by
/// the current datasource (real or mock).

final class NotificationRepositoryProvider
    extends
        $FunctionalProvider<
          NotificationRepository,
          NotificationRepository,
          NotificationRepository
        >
    with $Provider<NotificationRepository> {
  /// Provides the [NotificationRepository] backed by
  /// the current datasource (real or mock).
  const NotificationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationRepository create(Ref ref) {
    return notificationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationRepository>(value),
    );
  }
}

String _$notificationRepositoryHash() =>
    r'a0c656f33272985367845aca36f0154f8b3eb0eb';

/// Stateful async notifier managing the paginated
/// notification list with real-time WS updates.
///
/// Features:
/// - Initial fetch from REST API
/// - Cursor-based load-more
/// - Prepends real-time WS notifications
/// - Optimistic mark-read / mark-all-read
/// - Pull-to-refresh

@ProviderFor(NotificationNotifier)
const notificationProvider = NotificationNotifierProvider._();

/// Stateful async notifier managing the paginated
/// notification list with real-time WS updates.
///
/// Features:
/// - Initial fetch from REST API
/// - Cursor-based load-more
/// - Prepends real-time WS notifications
/// - Optimistic mark-read / mark-all-read
/// - Pull-to-refresh
final class NotificationNotifierProvider
    extends
        $AsyncNotifierProvider<NotificationNotifier, List<NotificationEntity>> {
  /// Stateful async notifier managing the paginated
  /// notification list with real-time WS updates.
  ///
  /// Features:
  /// - Initial fetch from REST API
  /// - Cursor-based load-more
  /// - Prepends real-time WS notifications
  /// - Optimistic mark-read / mark-all-read
  /// - Pull-to-refresh
  const NotificationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationNotifierHash();

  @$internal
  @override
  NotificationNotifier create() => NotificationNotifier();
}

String _$notificationNotifierHash() =>
    r'8b64c20b00ae8e90df95e935be1e9b8a3162beeb';

/// Stateful async notifier managing the paginated
/// notification list with real-time WS updates.
///
/// Features:
/// - Initial fetch from REST API
/// - Cursor-based load-more
/// - Prepends real-time WS notifications
/// - Optimistic mark-read / mark-all-read
/// - Pull-to-refresh

abstract class _$NotificationNotifier
    extends $AsyncNotifier<List<NotificationEntity>> {
  FutureOr<List<NotificationEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<NotificationEntity>>,
              List<NotificationEntity>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<NotificationEntity>>,
                List<NotificationEntity>
              >,
              AsyncValue<List<NotificationEntity>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Manages the unread notification badge count.
///
/// - Initialises from REST API
/// - Subscribes to WS `unread_count` events
/// - Supports optimistic inc/dec from mark-read

@ProviderFor(UnreadCount)
const unreadCountProvider = UnreadCountProvider._();

/// Manages the unread notification badge count.
///
/// - Initialises from REST API
/// - Subscribes to WS `unread_count` events
/// - Supports optimistic inc/dec from mark-read
final class UnreadCountProvider
    extends $AsyncNotifierProvider<UnreadCount, int> {
  /// Manages the unread notification badge count.
  ///
  /// - Initialises from REST API
  /// - Subscribes to WS `unread_count` events
  /// - Supports optimistic inc/dec from mark-read
  const UnreadCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadCountHash();

  @$internal
  @override
  UnreadCount create() => UnreadCount();
}

String _$unreadCountHash() => r'afba20254db76d284961c987610d4ccd8e63d97c';

/// Manages the unread notification badge count.
///
/// - Initialises from REST API
/// - Subscribes to WS `unread_count` events
/// - Supports optimistic inc/dec from mark-read

abstract class _$UnreadCount extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
