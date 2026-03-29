// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_error_stream.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A global broadcast channel for [AppException]
/// events.
///
/// Presentation-layer widgets listen to this provider
/// to display error toasts without coupling to
/// individual feature providers.
///
/// The [ErrorObserver] pushes errors here; the
/// [GlobalErrorListener] widget consumes them.

@ProviderFor(GlobalErrorStream)
const globalErrorStreamProvider = GlobalErrorStreamProvider._();

/// A global broadcast channel for [AppException]
/// events.
///
/// Presentation-layer widgets listen to this provider
/// to display error toasts without coupling to
/// individual feature providers.
///
/// The [ErrorObserver] pushes errors here; the
/// [GlobalErrorListener] widget consumes them.
final class GlobalErrorStreamProvider
    extends $NotifierProvider<GlobalErrorStream, AppException?> {
  /// A global broadcast channel for [AppException]
  /// events.
  ///
  /// Presentation-layer widgets listen to this provider
  /// to display error toasts without coupling to
  /// individual feature providers.
  ///
  /// The [ErrorObserver] pushes errors here; the
  /// [GlobalErrorListener] widget consumes them.
  const GlobalErrorStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'globalErrorStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$globalErrorStreamHash();

  @$internal
  @override
  GlobalErrorStream create() => GlobalErrorStream();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppException? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppException?>(value),
    );
  }
}

String _$globalErrorStreamHash() => r'a6e996d442b62b69ede3c60a9b53da213c7acc48';

/// A global broadcast channel for [AppException]
/// events.
///
/// Presentation-layer widgets listen to this provider
/// to display error toasts without coupling to
/// individual feature providers.
///
/// The [ErrorObserver] pushes errors here; the
/// [GlobalErrorListener] widget consumes them.

abstract class _$GlobalErrorStream extends $Notifier<AppException?> {
  AppException? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AppException?, AppException?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppException?, AppException?>,
              AppException?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
