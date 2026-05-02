// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $signInRoute,
  $mainShellRoute,
  $appointmentDetailRoute,
];

RouteBase get $signInRoute =>
    GoRouteData.$route(path: '/signin', factory: $SignInRoute._fromState);

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

RouteBase get $mainShellRoute => StatefulShellRouteData.$route(
  factory: $MainShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/appointments',
          factory: $AppointmentsRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(path: '/revenue', factory: $RevenueRoute._fromState),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(path: '/profile', factory: $ProfileRoute._fromState),
      ],
    ),
  ],
);

extension $MainShellRouteExtension on MainShellRoute {
  static MainShellRoute _fromState(GoRouterState state) =>
      const MainShellRoute();
}

mixin $AppointmentsRoute on GoRouteData {
  static AppointmentsRoute _fromState(GoRouterState state) =>
      const AppointmentsRoute();

  @override
  String get location => GoRouteData.$location('/appointments');

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

mixin $RevenueRoute on GoRouteData {
  static RevenueRoute _fromState(GoRouterState state) => const RevenueRoute();

  @override
  String get location => GoRouteData.$location('/revenue');

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

RouteBase get $appointmentDetailRoute => GoRouteData.$route(
  path: '/appointment-detail/:id',
  factory: $AppointmentDetailRoute._fromState,
);

mixin $AppointmentDetailRoute on GoRouteData {
  static AppointmentDetailRoute _fromState(GoRouterState state) =>
      AppointmentDetailRoute(id: state.pathParameters['id']!);

  AppointmentDetailRoute get _self => this as AppointmentDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/appointment-detail/${Uri.encodeComponent(_self.id)}',
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
