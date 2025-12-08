// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $signInRoute,
  $forgotPasswordRoute,
  $signUpRoute,
  $adminShellRouteData,
  $providerShellRouteData,
];

RouteBase get $signInRoute => GoRouteData.$route(
  path: '/',
  name: 'signin',
  factory: $SignInRoute._fromState,
);

mixin $SignInRoute on GoRouteData {
  static SignInRoute _fromState(GoRouterState state) => const SignInRoute();

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

RouteBase get $forgotPasswordRoute => GoRouteData.$route(
  path: '/forgot-password',
  name: 'forgot-password',
  factory: $ForgotPasswordRoute._fromState,
);

mixin $ForgotPasswordRoute on GoRouteData {
  static ForgotPasswordRoute _fromState(GoRouterState state) =>
      const ForgotPasswordRoute();

  @override
  String get location => GoRouteData.$location('/forgot-password');

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

RouteBase get $signUpRoute => GoRouteData.$route(
  path: '/sign-up',
  name: 'sign-up',
  factory: $SignUpRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'email-code-verification',
      name: 'email-code-verification',
      factory: $EmailCodeVerificationRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'sign-up-form',
      name: 'sign-up-form',
      factory: $SignUpFormRoute._fromState,
    ),
  ],
);

mixin $SignUpRoute on GoRouteData {
  static SignUpRoute _fromState(GoRouterState state) => const SignUpRoute();

  @override
  String get location => GoRouteData.$location('/sign-up');

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

mixin $EmailCodeVerificationRoute on GoRouteData {
  static EmailCodeVerificationRoute _fromState(GoRouterState state) =>
      const EmailCodeVerificationRoute();

  @override
  String get location =>
      GoRouteData.$location('/sign-up/email-code-verification');

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

mixin $SignUpFormRoute on GoRouteData {
  static SignUpFormRoute _fromState(GoRouterState state) =>
      const SignUpFormRoute();

  @override
  String get location => GoRouteData.$location('/sign-up/sign-up-form');

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

RouteBase get $adminShellRouteData => ShellRouteData.$route(
  factory: $AdminShellRouteDataExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/admin/dashboard',
      name: 'admin-dashboard',
      factory: $AdminDashboardRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/admin/partner-manager',
      name: 'partner-manager',
      factory: $PartnerManagerRoute._fromState,
    ),
  ],
);

extension $AdminShellRouteDataExtension on AdminShellRouteData {
  static AdminShellRouteData _fromState(GoRouterState state) =>
      const AdminShellRouteData();
}

mixin $AdminDashboardRoute on GoRouteData {
  static AdminDashboardRoute _fromState(GoRouterState state) =>
      const AdminDashboardRoute();

  @override
  String get location => GoRouteData.$location('/admin/dashboard');

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

mixin $PartnerManagerRoute on GoRouteData {
  static PartnerManagerRoute _fromState(GoRouterState state) =>
      const PartnerManagerRoute();

  @override
  String get location => GoRouteData.$location('/admin/partner-manager');

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

RouteBase get $providerShellRouteData => ShellRouteData.$route(
  factory: $ProviderShellRouteDataExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/provider/dashboard',
      name: 'provider-dashboard',
      factory: $DashboardRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/provider/products',
      name: 'provider-product-home',
      factory: $ProductHomeRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/provider/products/add',
      name: 'provider-product-add',
      factory: $ProductAddRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/provider/products/:id',
      name: 'provider-product-details',
      factory: $ProductDetailsRoute._fromState,
    ),
  ],
);

extension $ProviderShellRouteDataExtension on ProviderShellRouteData {
  static ProviderShellRouteData _fromState(GoRouterState state) =>
      const ProviderShellRouteData();
}

mixin $DashboardRoute on GoRouteData {
  static DashboardRoute _fromState(GoRouterState state) =>
      const DashboardRoute();

  @override
  String get location => GoRouteData.$location('/provider/dashboard');

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

mixin $ProductHomeRoute on GoRouteData {
  static ProductHomeRoute _fromState(GoRouterState state) =>
      const ProductHomeRoute();

  @override
  String get location => GoRouteData.$location('/provider/products');

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

mixin $ProductAddRoute on GoRouteData {
  static ProductAddRoute _fromState(GoRouterState state) =>
      const ProductAddRoute();

  @override
  String get location => GoRouteData.$location('/provider/products/add');

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

mixin $ProductDetailsRoute on GoRouteData {
  static ProductDetailsRoute _fromState(GoRouterState state) =>
      ProductDetailsRoute(id: int.parse(state.pathParameters['id']!));

  ProductDetailsRoute get _self => this as ProductDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/provider/products/${Uri.encodeComponent(_self.id.toString())}',
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
