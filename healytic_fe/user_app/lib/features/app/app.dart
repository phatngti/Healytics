import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/app/widgets/'
    'global_error_listener.widget.dart';
import 'package:user_app/router/app_router.dart';
import 'package:user_app/theme/app_theme.dart';

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final theme = AppTheme();

    return GlobalErrorListener(
      child: MaterialApp.router(
        title: 'GoHealh',
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: theme.lightTheme(),
        darkTheme: theme.darkTheme(),
      ),
    );
  }
}

