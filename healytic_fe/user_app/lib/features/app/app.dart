import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:user_app/core/providers/location.provider.dart';
import 'package:user_app/features/app/widgets/'
    'global_error_listener.widget.dart';
import 'package:user_app/features/notifications/'
    'presentation/widgets/'
    'notification_toast_listener.widget.dart';
import 'package:user_app/features/partner_chat/'
    'presentation/widgets/'
    'chat_message_toast_listener.widget.dart';
import 'package:user_app/router/app_router.dart';
import 'package:user_app/theme/app_theme.dart';

final _log = Logger('App');

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      unawaited(_requestLocationPermission(ref));
      return null;
    }, const []);

    final router = ref.watch(routerProvider);
    final theme = AppTheme();

    return MaterialApp.router(
      title: 'GoHealh',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: theme.lightTheme(),
      darkTheme: theme.darkTheme(),
      builder: (context, child) {
        return GlobalErrorListener(
          child: NotificationToastListener(
            child: ChatMessageToastListener(
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _requestLocationPermission(WidgetRef ref) async {
    try {
      await ref.read(locationServiceProvider).requestPermission();
    } catch (error, stackTrace) {
      _log.warning(
        'Failed to request location permission during app startup.',
        error,
        stackTrace,
      );
    }
  }
}
