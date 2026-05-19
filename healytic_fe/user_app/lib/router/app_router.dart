import 'package:logging/logging.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';
import 'package:user_app/router/routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final _log = Logger('AppRouter');

@riverpod
GoRouter router(Ref ref) {
  final notifier = ref.watch(routerListenableProvider.notifier);
  String initialLocation = '/';

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    debugLogDiagnostics: true,
    routes: $appRoutes,
    refreshListenable: notifier,
    redirect: notifier.redirect,
  );
}

@riverpod
class RouterListenable extends _$RouterListenable implements Listenable {
  final List<VoidCallback> _listeners = [];

  @override
  FutureOr<void> build() {
    final authSessionStore = ref.watch(authSessionStoreProvider);
    final subscription = authSessionStore.watchAccessToken().listen((_) {
      _notifyListeners();
    });
    ref.onDispose(subscription.cancel);
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final authSessionStore = ref.watch(authSessionStoreProvider);
    final isLoggedIn = authSessionStore.isLoggedIn;
    final path = state.uri.path;

    final isPublicRoute =
        (LottieSplashRoute.isPublic && path == LottieSplashRoute.pathPattern) ||
        (OnboardingRoute.isPublic && path == OnboardingRoute.pathPattern) ||
        (SignInRoute.isPublic && path == SignInRoute.pathPattern) ||
        (ForgotPasswordRoute.isPublic &&
            path == ForgotPasswordRoute.pathPattern) ||
        (PasswordResetCodeRoute.isPublic &&
            path == PasswordResetCodeRoute.pathPattern) ||
        (ResetPasswordRoute.isPublic &&
            path == ResetPasswordRoute.pathPattern) ||
        (EmailFormRoute.isPublic && path == EmailFormRoute.pathPattern) ||
        (EmailCodeConfirmationRoute.isPublic &&
            path == EmailCodeConfirmationRoute.pathPattern) ||
        (FinishSignUpRoute.isPublic && path == FinishSignUpRoute.pathPattern) ||
        (SurveyScreenRoute.isPublic && path == SurveyScreenRoute.pathPattern) ||
        (GeneralGoalsStepRoute.isPublic &&
            path == GeneralGoalsStepRoute.pathPattern) ||
        (LifestyleActivityStepRoute.isPublic &&
            path == LifestyleActivityStepRoute.pathPattern) ||
        (BodyEnergyStepRoute.isPublic &&
            path == BodyEnergyStepRoute.pathPattern) ||
        (HealthSafetyStepRoute.isPublic &&
            path == HealthSafetyStepRoute.pathPattern);

    if (isLoggedIn) {
      _log.info('Logged In Route requested: $path');
      if (isPublicRoute) {
        return '/home';
      }
    } else {
      _log.info('Public Route requested: $path');
      if (!isPublicRoute) {
        return '/signin';
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
