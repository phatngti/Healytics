import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/widgets/toast.dart';
import 'package:user_app/core/entities/app_exception.dart';
import 'package:user_app/core/providers/'
    'global_error_stream.provider.dart';

/// Listens to [globalErrorStreamProvider] and
/// displays a toast notification for every new
/// [AppException].
///
/// Place this widget inside [MaterialApp.router]'s
/// `builder` so it can display toasts on any screen.
///
/// Uses [rootNavigatorKey] to obtain a context that
/// lives below the [Navigator]'s [Overlay], which
/// [FToast] requires.
///
/// Identical consecutive errors within a short
/// window are deduplicated to prevent toast spam.
class GlobalErrorListener extends ConsumerWidget {
  /// The child widget tree.
  final Widget child;

  const GlobalErrorListener({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AppException?>(
      globalErrorStreamProvider,
      (previous, next) {
        if (next == null) return;

        // Deduplicate identical consecutive errors.
        if (previous != null &&
            previous.userMessage == next.userMessage) {
          return;
        }

        AppToast.error(
          context,
          next.userMessage,
        );

        // Clear after displaying so the same error
        // can be shown again if it recurs later.
        ref
            .read(
              globalErrorStreamProvider.notifier,
            )
            .clear();
      },
    );

    return child;
  }
}
