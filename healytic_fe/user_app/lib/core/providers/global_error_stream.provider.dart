import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/entities/app_exception.dart';

part 'global_error_stream.provider.g.dart';

/// A global broadcast channel for [AppException]
/// events.
///
/// Presentation-layer widgets listen to this provider
/// to display error toasts without coupling to
/// individual feature providers.
///
/// The [ErrorObserver] pushes errors here; the
/// [GlobalErrorListener] widget consumes them.
@riverpod
class GlobalErrorStream extends _$GlobalErrorStream {
  @override
  AppException? build() => null;

  /// Emits a new [AppException] to all listeners.
  void emit(AppException error) => state = error;

  /// Clears the current error state.
  void clear() => state = null;
}
