// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $mobileWrapperRoutes,
  $chatRoute,
  $serviceDetailsRoute,
  $reviewsRoute,
  $checkoutRoute,
  $lottieSplashRoute,
  $onboardingRoute,
  $signInRoute,
  $emailFormRoute,
  $emailCodeConfirmationRoute,
  $finishSignUpRoute,
  $surveyScreenRoute,
  $generalGoalsStepRoute,
  $lifestyleActivityStepRoute,
  $bodyEnergyStepRoute,
  $healthSafetyStepRoute,
];

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
          path: '/conversation_history',
          name: 'conversation_history',
          factory: $ConversationHistoryRoute._fromState,
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

mixin $ConversationHistoryRoute on GoRouteData {
  static ConversationHistoryRoute _fromState(GoRouterState state) =>
      const ConversationHistoryRoute();

  @override
  String get location => GoRouteData.$location('/conversation_history');

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

RouteBase get $chatRoute => GoRouteData.$route(
  path: '/chat',
  name: 'chat',
  factory: $ChatRoute._fromState,
);

mixin $ChatRoute on GoRouteData {
  static ChatRoute _fromState(GoRouterState state) =>
      ChatRoute(conversationId: state.uri.queryParameters['conversation-id']);

  ChatRoute get _self => this as ChatRoute;

  @override
  String get location => GoRouteData.$location(
    '/chat',
    queryParams: {
      if (_self.conversationId != null) 'conversation-id': _self.conversationId,
    },
  );

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

RouteBase get $serviceDetailsRoute => GoRouteData.$route(
  path: '/service_details',
  name: 'service_details',
  factory: $ServiceDetailsRoute._fromState,
);

mixin $ServiceDetailsRoute on GoRouteData {
  static ServiceDetailsRoute _fromState(GoRouterState state) =>
      ServiceDetailsRoute(serviceId: state.uri.queryParameters['service-id']!);

  ServiceDetailsRoute get _self => this as ServiceDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/service_details',
    queryParams: {'service-id': _self.serviceId},
  );

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

RouteBase get $reviewsRoute => GoRouteData.$route(
  path: '/reviews',
  name: 'reviews',
  factory: $ReviewsRoute._fromState,
);

mixin $ReviewsRoute on GoRouteData {
  static ReviewsRoute _fromState(GoRouterState state) =>
      ReviewsRoute(serviceId: state.uri.queryParameters['service-id']!);

  ReviewsRoute get _self => this as ReviewsRoute;

  @override
  String get location => GoRouteData.$location(
    '/reviews',
    queryParams: {'service-id': _self.serviceId},
  );

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

RouteBase get $checkoutRoute => GoRouteData.$route(
  path: '/checkout',
  name: 'checkout',
  factory: $CheckoutRoute._fromState,
);

mixin $CheckoutRoute on GoRouteData {
  static CheckoutRoute _fromState(GoRouterState state) => const CheckoutRoute();

  @override
  String get location => GoRouteData.$location('/checkout');

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

RouteBase get $onboardingRoute => GoRouteData.$route(
  path: '/onboarding',
  name: 'onboarding',
  factory: $OnboardingRoute._fromState,
);

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

RouteBase get $signInRoute => GoRouteData.$route(
  path: '/signin',
  name: 'signin',
  factory: $SignInRoute._fromState,
);

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

RouteBase get $emailFormRoute => GoRouteData.$route(
  path: '/email_form',
  name: 'email_form',
  factory: $EmailFormRoute._fromState,
);

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

RouteBase get $emailCodeConfirmationRoute => GoRouteData.$route(
  path: '/email_code_confirmation',
  name: 'email_code_confirmation',
  factory: $EmailCodeConfirmationRoute._fromState,
);

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

RouteBase get $finishSignUpRoute => GoRouteData.$route(
  path: '/finish_sign_up',
  name: 'finish_sign_up',
  factory: $FinishSignUpRoute._fromState,
);

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

RouteBase get $surveyScreenRoute => GoRouteData.$route(
  path: '/survey_screen',
  name: 'survey_screen',
  factory: $SurveyScreenRoute._fromState,
);

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

RouteBase get $generalGoalsStepRoute => GoRouteData.$route(
  path: '/general_goals_step',
  name: 'general_goals_step',
  factory: $GeneralGoalsStepRoute._fromState,
);

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

RouteBase get $lifestyleActivityStepRoute => GoRouteData.$route(
  path: '/lifestyle_activity_step',
  name: 'lifestyle_activity_step',
  factory: $LifestyleActivityStepRoute._fromState,
);

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

RouteBase get $bodyEnergyStepRoute => GoRouteData.$route(
  path: '/body_energy_step',
  name: 'body_energy_step',
  factory: $BodyEnergyStepRoute._fromState,
);

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

RouteBase get $healthSafetyStepRoute => GoRouteData.$route(
  path: '/health_safety_step',
  name: 'health_safety_step',
  factory: $HealthSafetyStepRoute._fromState,
);

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
