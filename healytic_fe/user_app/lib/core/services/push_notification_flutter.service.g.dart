// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_flutter.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides and eagerly initialises the mock push
/// notification service after the user authenticates.
///
/// Watch this in the shell route alongside the WS
/// connection provider.

@ProviderFor(pushNotificationService)
const pushNotificationServiceProvider = PushNotificationServiceProvider._();

/// Provides and eagerly initialises the mock push
/// notification service after the user authenticates.
///
/// Watch this in the shell route alongside the WS
/// connection provider.

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
  /// Provides and eagerly initialises the mock push
  /// notification service after the user authenticates.
  ///
  /// Watch this in the shell route alongside the WS
  /// connection provider.
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
    r'8f427e724c946de1e0e0065d582a2a01c314cfd9';
