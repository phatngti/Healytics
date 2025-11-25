import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/router/routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  final notifier = ref.watch(routerListenableProvider.notifier);
  String initialLocation = '/'; // Rõ ràng và an toàn hơn

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    debugLogDiagnostics: true,
    routes: [$lottieSplashRoute, $mobileWrapperRoutes],
    refreshListenable: notifier,
    // redirect: notifier.redirect,
  );
}

@riverpod
class RouterListenable extends _$RouterListenable implements Listenable {
  final List<VoidCallback> _listeners = [];

  @override
  FutureOr<void> build() {
    // Watch auth state
    final subscription = Store.watch(StoreKey.accessToken).listen((_) {
      _notifyListeners();
    });
    ref.onDispose(subscription.cancel);
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = Store.tryGet(StoreKey.accessToken)?.isNotEmpty == true;
    final path = state.uri.path;
    print('isLoggedIn: $isLoggedIn');
    // Routes that require authentication
    final isProtectedRoute =
        path.startsWith('/home') ||
        path.startsWith('/orders') ||
        path.startsWith('/chat') ||
        path.startsWith('/notifications') ||
        path.startsWith('/profile');

    if (isLoggedIn) {
      // If logged in and trying to access login/onboarding, redirect to home
      if (path == '/signin' || path == '/onboarding') {
        return '/home';
      }
    } else {
      // If not logged in and trying to access protected route, redirect to signin
      if (isProtectedRoute) {
        return '/home';
      }
    }
    return null;
  }

  // ignore: unused_element
  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
}
