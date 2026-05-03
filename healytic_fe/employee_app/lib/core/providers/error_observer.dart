import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import '../entities/app_exception.dart';
import 'global_error_stream.provider.dart';

final _log = Logger('ErrorObserver');

/// Intercepts all provider failures globally.
base class ErrorObserver extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    final appError = AppException.fromError(error);

    // Skip 401 errors — handled by AuthHttpClient.
    if (appError is ServerException && appError.statusCode == 401) {
      return;
    }

    final name =
        context.provider.name ?? context.provider.runtimeType.toString();

    _log.severe('Provider "$name" failed', error, stackTrace);

    context.container.read(globalErrorStreamProvider.notifier).emit(appError);
  }
}
