import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'widgets/global_error_listener.widget.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final theme = AppTheme();

    return MaterialApp.router(
      title: 'Healytics Employee',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: theme.lightTheme(),
      darkTheme: theme.darkTheme(),
      builder: (context, child) {
        return GlobalErrorListener(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
