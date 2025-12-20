import 'package:admin_panel/features/admin/dashboard/presentation/admin_dashboard_screen.dart';
import 'package:admin_panel/features/authenticate/presentation/forgot_password/forgot_password.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_in.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/email_code_verification.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/sign_up.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/sign_up_form.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/partner_manager_screen.dart';
import 'package:admin_panel/router/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'admin_routes.g.dart';

// --- AUTH & ONBOARDING ROUTES ---

@TypedGoRoute<SignInRoute>(path: '/', name: SignInRoute.name, routes: [
  ],
)
class SignInRoute extends GoRouteData with $SignInRoute {
  const SignInRoute();
  static const name = "signin";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const SignInScreen(),
    );
  }
}

@TypedGoRoute<ForgotPasswordRoute>(
  path: '/forgot-password',
  name: ForgotPasswordRoute.name,
)
class ForgotPasswordRoute extends GoRouteData with $ForgotPasswordRoute {
  const ForgotPasswordRoute();
  static const name = "forgot-password";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const ForgotPasswordScreen(),
    );
  }
}

@TypedGoRoute<SignUpRoute>(
  path: '/sign-up',
  name: SignUpRoute.name,
  routes: [
    TypedGoRoute<EmailCodeVerificationRoute>(
      path: 'email-code-verification',
      name: EmailCodeVerificationRoute.name,
    ),
    TypedGoRoute<SignUpFormRoute>(
      path: 'sign-up-form',
      name: SignUpFormRoute.name,
    ),
  ],
)
class SignUpRoute extends GoRouteData with $SignUpRoute {
  const SignUpRoute();
  static const name = "sign-up";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const SignUpScreen(),
    );
  }
}

class EmailCodeVerificationRoute extends GoRouteData
    with $EmailCodeVerificationRoute {
  const EmailCodeVerificationRoute();
  static const name = "email-code-verification";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const EmailCodeVerificationScreen(),
    );
  }
}

class SignUpFormRoute extends GoRouteData with $SignUpFormRoute {
  const SignUpFormRoute();
  static const name = "sign-up-form";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const SignUpFormScreen(),
    );
  }
}

// ADMIN ROUTES
@TypedShellRoute<AdminShellRouteData>(
  routes: [
    TypedGoRoute<AdminDashboardRoute>(
      path: '/admin/dashboard',
      name: AdminDashboardRoute.name,
    ),
    TypedGoRoute<PartnerManagerRoute>(
      path: '/admin/partner-manager',
      name: PartnerManagerRoute.name,
    ),
  ],
)
class AdminShellRouteData extends ShellRouteData {
  const AdminShellRouteData();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return navigator;
  }
}

class AdminDashboardRoute extends GoRouteData with $AdminDashboardRoute {
  const AdminDashboardRoute();
  static const name = "admin-dashboard";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const AdminDashboardScreen(),
    );
  }
}

class PartnerManagerRoute extends GoRouteData with $PartnerManagerRoute {
  const PartnerManagerRoute();
  static const name = "partner-manager";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const PartnerManagerScreen(),
    );
  }
}
