// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$mobileWrapperRoutes, $lottieSplashRoute];

RouteBase get $mobileWrapperRoutes => StatefulShellRouteData.$route(
  factory: $MobileWrapperRoutesExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/home',
          name: 'home',
          factory: $HomeRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/orders',
          name: 'order_approved',
          factory: $OrderApprovedRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/chat',
          name: 'chat',
          factory: $ChatRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/notifications',
          name: 'notifications',
          factory: $NotificationsRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/profile',
          name: 'profile',
          factory: $ProfileRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $MobileWrapperRoutesExtension on MobileWrapperRoutes {
  static MobileWrapperRoutes _fromState(GoRouterState state) =>
      const MobileWrapperRoutes();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $OrderApprovedRoute on GoRouteData {
  static OrderApprovedRoute _fromState(GoRouterState state) =>
      const OrderApprovedRoute();

  @override
  String get location => GoRouteData.$location('/orders');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ChatRoute on GoRouteData {
  static ChatRoute _fromState(GoRouterState state) => const ChatRoute();

  @override
  String get location => GoRouteData.$location('/chat');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $NotificationsRoute on GoRouteData {
  static NotificationsRoute _fromState(GoRouterState state) =>
      const NotificationsRoute();

  @override
  String get location => GoRouteData.$location('/notifications');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $lottieSplashRoute => GoRouteData.$route(
  path: '/',
  name: 'lottie_splash',
  factory: $LottieSplashRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: '/onboarding',
      name: 'onboarding',
      factory: $OnboardingRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/signin',
      name: 'signin',
      factory: $SignInRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/email_form',
      name: 'email_form',
      factory: $EmailFormRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: '/email_code_confirmation',
          name: 'email_code_confirmation',
          factory: $EmailCodeConfirmationRoute._fromState,
        ),
      ],
    ),
    GoRouteData.$route(
      path: '/finish_sign_up',
      name: 'finish_sign_up',
      factory: $FinishSignUpRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/survey_screen',
      name: 'survey_screen',
      factory: $SurveyScreenRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/general_goals_step',
      name: 'general_goals_step',
      factory: $GeneralGoalsStepRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/lifestyle_activity_step',
      name: 'lifestyle_activity_step',
      factory: $LifestyleActivityStepRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/body_energy_step',
      name: 'body_energy_step',
      factory: $BodyEnergyStepRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/health_safety_step',
      name: 'health_safety_step',
      factory: $HealthSafetyStepRoute._fromState,
    ),
  ],
);

mixin $LottieSplashRoute on GoRouteData {
  static LottieSplashRoute _fromState(GoRouterState state) =>
      const LottieSplashRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $OnboardingRoute on GoRouteData {
  static OnboardingRoute _fromState(GoRouterState state) =>
      const OnboardingRoute();

  @override
  String get location => GoRouteData.$location('/onboarding');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SignInRoute on GoRouteData {
  static SignInRoute _fromState(GoRouterState state) => const SignInRoute();

  @override
  String get location => GoRouteData.$location('/signin');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EmailFormRoute on GoRouteData {
  static EmailFormRoute _fromState(GoRouterState state) =>
      const EmailFormRoute();

  @override
  String get location => GoRouteData.$location('/email_form');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EmailCodeConfirmationRoute on GoRouteData {
  static EmailCodeConfirmationRoute _fromState(GoRouterState state) =>
      const EmailCodeConfirmationRoute();

  @override
  String get location => GoRouteData.$location('/email_code_confirmation');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FinishSignUpRoute on GoRouteData {
  static FinishSignUpRoute _fromState(GoRouterState state) =>
      const FinishSignUpRoute();

  @override
  String get location => GoRouteData.$location('/finish_sign_up');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SurveyScreenRoute on GoRouteData {
  static SurveyScreenRoute _fromState(GoRouterState state) =>
      const SurveyScreenRoute();

  @override
  String get location => GoRouteData.$location('/survey_screen');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GeneralGoalsStepRoute on GoRouteData {
  static GeneralGoalsStepRoute _fromState(GoRouterState state) =>
      const GeneralGoalsStepRoute();

  @override
  String get location => GoRouteData.$location('/general_goals_step');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LifestyleActivityStepRoute on GoRouteData {
  static LifestyleActivityStepRoute _fromState(GoRouterState state) =>
      const LifestyleActivityStepRoute();

  @override
  String get location => GoRouteData.$location('/lifestyle_activity_step');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BodyEnergyStepRoute on GoRouteData {
  static BodyEnergyStepRoute _fromState(GoRouterState state) =>
      const BodyEnergyStepRoute();

  @override
  String get location => GoRouteData.$location('/body_energy_step');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $HealthSafetyStepRoute on GoRouteData {
  static HealthSafetyStepRoute _fromState(GoRouterState state) =>
      const HealthSafetyStepRoute();

  @override
  String get location => GoRouteData.$location('/health_safety_step');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
