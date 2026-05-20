// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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
/// notification list.
///
/// Features:
/// - Initial fetch from REST API
/// - Cursor-based load-more
/// - Optimistic mark-read / mark-all-read
/// - Pull-to-refresh

@ProviderFor(NotificationNotifier)
const notificationProvider = NotificationNotifierProvider._();

/// Stateful async notifier managing the paginated
/// notification list.
///
/// Features:
/// - Initial fetch from REST API
/// - Cursor-based load-more
/// - Optimistic mark-read / mark-all-read
/// - Pull-to-refresh
final class NotificationNotifierProvider
    extends
        $AsyncNotifierProvider<NotificationNotifier, List<NotificationEntity>> {
  /// Stateful async notifier managing the paginated
  /// notification list.
  ///
  /// Features:
  /// - Initial fetch from REST API
  /// - Cursor-based load-more
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
    r'99c8e8a896eaa4d0426ebe46c28c6b47cfae71a7';

/// Stateful async notifier managing the paginated
/// notification list.
///
/// Features:
/// - Initial fetch from REST API
/// - Cursor-based load-more
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
/// - Supports optimistic inc/dec from mark-read

@ProviderFor(UnreadCount)
const unreadCountProvider = UnreadCountProvider._();

/// Manages the unread notification badge count.
///
/// - Initialises from REST API
/// - Supports optimistic inc/dec from mark-read
final class UnreadCountProvider
    extends $AsyncNotifierProvider<UnreadCount, int> {
  /// Manages the unread notification badge count.
  ///
  /// - Initialises from REST API
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

String _$unreadCountHash() => r'b8df5f50a74c47df1d05b9ed30a9ddf21ae12d66';

/// Manages the unread notification badge count.
///
/// - Initialises from REST API
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

/// Keeps the backend `/notifications` Socket.IO namespace connected for
/// authenticated real-backend environments.

@ProviderFor(notificationWsConnection)
const notificationWsConnectionProvider = NotificationWsConnectionProvider._();

/// Keeps the backend `/notifications` Socket.IO namespace connected for
/// authenticated real-backend environments.

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
  /// Keeps the backend `/notifications` Socket.IO namespace connected for
  /// authenticated real-backend environments.
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
    r'b876c259d299866158f7bb8f1cbc0100140f7ec4';

/// Emits notification entities as they arrive from the backend in real time.
///
/// Side effects stay here so all global listeners share one subscription:
/// - insert/update the in-memory notification list
/// - update the unread badge when the backend sends `unread_count`

@ProviderFor(latestNotificationEvent)
const latestNotificationEventProvider = LatestNotificationEventProvider._();

/// Emits notification entities as they arrive from the backend in real time.
///
/// Side effects stay here so all global listeners share one subscription:
/// - insert/update the in-memory notification list
/// - update the unread badge when the backend sends `unread_count`

final class LatestNotificationEventProvider
    extends
        $FunctionalProvider<
          AsyncValue<NotificationEntity>,
          NotificationEntity,
          Stream<NotificationEntity>
        >
    with
        $FutureModifier<NotificationEntity>,
        $StreamProvider<NotificationEntity> {
  /// Emits notification entities as they arrive from the backend in real time.
  ///
  /// Side effects stay here so all global listeners share one subscription:
  /// - insert/update the in-memory notification list
  /// - update the unread badge when the backend sends `unread_count`
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
  $StreamProviderElement<NotificationEntity> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<NotificationEntity> create(Ref ref) {
    return latestNotificationEvent(ref);
  }
}

String _$latestNotificationEventHash() =>
    r'cb2d84114945ead98698395bef44d55f78348a4b';
