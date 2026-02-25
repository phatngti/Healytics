import 'package:admin_panel/features/admin/category/presentation/category_add.dart';
import 'package:admin_panel/features/admin/category/presentation/category_home.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/admin_dashboard_screen.dart';
import 'package:admin_panel/features/authenticate/presentation/forgot_password/forgot_password.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_in.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/email_code_verification.screen.dart';

import 'package:admin_panel/features/authenticate/presentation/sign_up/sign_up_form.screen.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/sucess_registration.screen.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/partner_manager_screen.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/review_application.screen.dart';
import 'package:admin_panel/router/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'admin_routes.g.dart';

// --- AUTH & ONBOARDING ROUTES ---

@TypedGoRoute<SignInRoute>(path: '/', name: SignInRoute.name, routes: [
  ],
)
class SignInRoute extends GoRouteData with $SignInRoute {
  const SignInRoute({this.autofill});
  static const name = "signin";

  /// Dev flag: `?autofill=true` pre-fills email & password.
  final bool? autofill;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: SignInScreen(autofill: autofill ?? false),
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
    TypedGoRoute<SuccessRegistrationRoute>(
      path: 'success',
      name: SuccessRegistrationRoute.name,
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
      child: const SignUpFormScreen(),
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

/// Route displayed after successful partner registration.
class SuccessRegistrationRoute extends GoRouteData
    with $SuccessRegistrationRoute {
  const SuccessRegistrationRoute();
  static const name = 'success-registration';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const SucessRegistrationScreen(),
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
    TypedGoRoute<ReviewApplicationRoute>(
      path: '/admin/partner-manager/review/:partnerId',
      name: ReviewApplicationRoute.name,
    ),
    TypedGoRoute<CategoryHomeRoute>(
      path: '/admin/category',
      name: CategoryHomeRoute.name,
    ),
    TypedGoRoute<CategoryAddRoute>(
      path: '/admin/category/add',
      name: CategoryAddRoute.name,
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

class ReviewApplicationRoute extends GoRouteData with $ReviewApplicationRoute {
  const ReviewApplicationRoute({required this.partnerId});

  /// The partner verification ID to review
  final String partnerId;

  static const name = "review-application";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: ReviewApplicationScreen(partnerId: partnerId),
    );
  }
}

class CategoryHomeRoute extends GoRouteData with $CategoryHomeRoute {
  const CategoryHomeRoute();
  static const name = "admin-category";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const CategoryHomeScreen(),
    );
  }
}

class CategoryAddRoute extends GoRouteData with $CategoryAddRoute {
  const CategoryAddRoute({this.autofill});
  static const name = "admin-category-add";

  /// Dev flag: `?autofill=true` pre-fills all category fields.
  final bool? autofill;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: CategoryAddScreen(autofill: autofill ?? false),
    );
  }
}
