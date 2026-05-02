import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/widgets/toast.dart';
import '../../../core/entities/app_exception.dart';
import '../../../core/providers/global_error_stream.provider.dart';

/// Listens to [globalErrorStreamProvider] and
/// displays a toast for every new [AppException].
class GlobalErrorListener extends ConsumerWidget {
  final Widget child;

  const GlobalErrorListener({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AppException?>(globalErrorStreamProvider, (previous, next) {
      if (next == null) return;

      if (previous != null && previous.userMessage == next.userMessage) {
        return;
      }

      AppToast.error(context, next.userMessage);

      ref.read(globalErrorStreamProvider.notifier).clear();
    });

    return child;
  }
}
