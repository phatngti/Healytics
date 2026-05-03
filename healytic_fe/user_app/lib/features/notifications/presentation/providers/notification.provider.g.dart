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
    r'2e4c99149c5ba7bbba77acf8e388ae0c59e74587';

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
