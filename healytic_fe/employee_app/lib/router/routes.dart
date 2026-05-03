import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/main_screen_layout.widget.dart';
import '../features/appointments/presentation/screens/appointments.screen.dart';
import '../features/appointments/presentation/screens/appointment_detail.screen.dart';
import '../features/authenticate/presentation/screens/signin.screen.dart';
import '../features/revenue/presentation/screens/revenue.screen.dart';
import '../features/profile/presentation/screens/profile.screen.dart';

part 'routes.g.dart';

// ── Public Routes ───────────────────────────────────

@TypedGoRoute<SignInRoute>(path: SignInRoute.path)
class SignInRoute extends GoRouteData with $SignInRoute {
  const SignInRoute();
  static const path = '/signin';
  static const name = 'signin';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SignInScreen();
}

// ── Shell Route (Bottom Navigation) ────────────────

@TypedStatefulShellRoute<MainShellRoute>(
  branches: [
    TypedStatefulShellBranch<AppointmentsBranch>(
      routes: [TypedGoRoute<AppointmentsRoute>(path: AppointmentsRoute.path)],
    ),
    TypedStatefulShellBranch<RevenueBranch>(
      routes: [TypedGoRoute<RevenueRoute>(path: RevenueRoute.path)],
    ),
    TypedStatefulShellBranch<ProfileBranch>(
      routes: [TypedGoRoute<ProfileRoute>(path: ProfileRoute.path)],
    ),
  ],
)
class MainShellRoute extends StatefulShellRouteData {
  const MainShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return MainScreenLayout(navigationShell: navigationShell);
  }
}

class AppointmentsBranch extends StatefulShellBranchData {
  const AppointmentsBranch();
}

class RevenueBranch extends StatefulShellBranchData {
  const RevenueBranch();
}

class ProfileBranch extends StatefulShellBranchData {
  const ProfileBranch();
}

class AppointmentsRoute extends GoRouteData with $AppointmentsRoute {
  const AppointmentsRoute();
  static const path = '/appointments';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AppointmentsScreen();
}

class RevenueRoute extends GoRouteData with $RevenueRoute {
  const RevenueRoute();
  static const path = '/revenue';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RevenueScreen();
}

class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();
  static const path = '/profile';

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileScreen();
}

// ── Detail Routes ──────────────────────────────────

@TypedGoRoute<AppointmentDetailRoute>(path: AppointmentDetailRoute.path)
class AppointmentDetailRoute extends GoRouteData with $AppointmentDetailRoute {
  const AppointmentDetailRoute({required this.id});
  static const path = '/appointment-detail/:id';
  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      AppointmentDetailScreen(appointmentId: id);
}
