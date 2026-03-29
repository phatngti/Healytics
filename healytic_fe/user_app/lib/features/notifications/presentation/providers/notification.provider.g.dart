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

/// Fetches grouped notification sections.

@ProviderFor(notifications)
const notificationsProvider = NotificationsProvider._();

/// Fetches grouped notification sections.

final class NotificationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NotificationSection>>,
          List<NotificationSection>,
          FutureOr<List<NotificationSection>>
        >
    with
        $FutureModifier<List<NotificationSection>>,
        $FutureProvider<List<NotificationSection>> {
  /// Fetches grouped notification sections.
  const NotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsHash();

  @$internal
  @override
  $FutureProviderElement<List<NotificationSection>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NotificationSection>> create(Ref ref) {
    return notifications(ref);
  }
}

String _$notificationsHash() => r'a1b12498247442d50ab4109bd4e19b50a484ad52';
