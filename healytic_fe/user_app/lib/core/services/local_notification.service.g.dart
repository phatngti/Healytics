// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_notification.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides and eagerly initialises the local
/// notification service.
///
/// This is a `keepAlive` provider so the service
/// persists for the entire app lifecycle.

@ProviderFor(localNotificationService)
const localNotificationServiceProvider = LocalNotificationServiceProvider._();

/// Provides and eagerly initialises the local
/// notification service.
///
/// This is a `keepAlive` provider so the service
/// persists for the entire app lifecycle.

final class LocalNotificationServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<LocalNotificationService>,
          LocalNotificationService,
          FutureOr<LocalNotificationService>
        >
    with
        $FutureModifier<LocalNotificationService>,
        $FutureProvider<LocalNotificationService> {
  /// Provides and eagerly initialises the local
  /// notification service.
  ///
  /// This is a `keepAlive` provider so the service
  /// persists for the entire app lifecycle.
  const LocalNotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localNotificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localNotificationServiceHash();

  @$internal
  @override
  $FutureProviderElement<LocalNotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LocalNotificationService> create(Ref ref) {
    return localNotificationService(ref);
  }
}

String _$localNotificationServiceHash() =>
    r'b55357b2ad3dd1c48f5a158ffade5f08bee14624';
