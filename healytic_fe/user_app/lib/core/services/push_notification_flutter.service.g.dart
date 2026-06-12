// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_flutter.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the push notification service instance.
///
/// Initialization is triggered explicitly after
/// authentication succeeds so `/v1/user/devices`
/// is not called during app startup.

@ProviderFor(pushNotificationService)
const pushNotificationServiceProvider = PushNotificationServiceProvider._();

/// Provides the push notification service instance.
///
/// Initialization is triggered explicitly after
/// authentication succeeds so `/v1/user/devices`
/// is not called during app startup.

final class PushNotificationServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<PushNotificationFlutterService>,
          PushNotificationFlutterService,
          FutureOr<PushNotificationFlutterService>
        >
    with
        $FutureModifier<PushNotificationFlutterService>,
        $FutureProvider<PushNotificationFlutterService> {
  /// Provides the push notification service instance.
  ///
  /// Initialization is triggered explicitly after
  /// authentication succeeds so `/v1/user/devices`
  /// is not called during app startup.
  const PushNotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushNotificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushNotificationServiceHash();

  @$internal
  @override
  $FutureProviderElement<PushNotificationFlutterService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PushNotificationFlutterService> create(Ref ref) {
    return pushNotificationService(ref);
  }
}

String _$pushNotificationServiceHash() =>
    r'26f748c7ea4e9faf7886b557928e64666c49eb4c';
