import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/providers/auth_session.provider.dart';
import 'routes.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  final authSession = ref.watch(authSessionStoreProvider);
  final refreshNotifier = _AuthRouteRefreshNotifier(
    authSession.watchAccessToken(),
  );
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: SignInRoute.path,
    routes: $appRoutes,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final isLoggedIn = authSession.isLoggedIn;
      final currentPath = state.matchedLocation;
      const loginPath = SignInRoute.path;
      const appointmentsPath = AppointmentsRoute.path;

      final isOnLoginPage = currentPath == loginPath;

      if (!isLoggedIn && !isOnLoginPage) {
        return loginPath;
      }

      if (isLoggedIn && isOnLoginPage) {
        return appointmentsPath;
      }

      return null;
    },
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text(
            'Page not found: '
            '${state.matchedLocation}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      );
    },
  );
}

class _AuthRouteRefreshNotifier extends ChangeNotifier {
  _AuthRouteRefreshNotifier(Stream<String?> accessTokenStream) {
    _subscription = accessTokenStream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<String?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
