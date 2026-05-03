import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:user_app/core/entities/app_exception.dart';
import 'package:user_app/core/providers/global_error_stream.provider.dart';

final _log = Logger('ErrorObserver');

/// A [ProviderObserver] that intercepts all provider
/// failures globally.
///
/// When any Riverpod provider transitions to an error
/// state, this observer:
/// 1. Converts the raw error into an [AppException].
/// 2. Pushes the exception into
///    [globalErrorStreamProvider].
/// 3. Logs the error with the provider's name.
///
/// Register this observer in the [ProviderScope]:
/// ```dart
/// ProviderScope(
///   observers: [ErrorObserver()],
///   child: const App(),
/// )
/// ```
base class ErrorObserver extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    final appError = AppException.fromError(error);

    // Skip 401 errors — AuthHttpClient already
    // handles token refresh and forced logout.
    if (appError is ServerException && appError.statusCode == 401) {
      return;
    }

    final name =
        context.provider.name ?? context.provider.runtimeType.toString();

    _log.severe('Provider "$name" failed', error, stackTrace);

    context.container.read(globalErrorStreamProvider.notifier).emit(appError);
  }
}
