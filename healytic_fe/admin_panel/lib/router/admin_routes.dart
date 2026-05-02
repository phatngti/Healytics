import 'package:admin_panel/features/admin/category/presentation/category_add.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/admin_finance_manager_screen.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/admin_finance_transaction_detail.screen.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/admin_finance_payout_detail.screen.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/admin_finance_refund_case_detail.screen.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/admin_finance_reconciliation_detail.screen.dart';
import 'package:admin_panel/features/admin/category/presentation/category_home.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/admin_dashboard_screen.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/notification_campaign_composer.screen.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/notification_campaign_detail.screen.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/notification_campaign_index.screen.dart';
import 'package:admin_panel/features/authenticate/presentation/forgot_password/forgot_password.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_in.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/email_code_verification.screen.dart';

import 'package:admin_panel/features/authenticate/presentation/sign_up/sign_up_form.screen.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/sucess_registration.screen.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/partner_manager_screen.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/review_application.screen.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/view_partner_detail.screen.dart';
import 'package:admin_panel/router/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'admin_routes.g.dart';

// --- AUTH & ONBOARDING ROUTES ---

@TypedGoRoute<SignInRoute>(path: '/', name: SignInRoute.name, routes: [])
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
  const SignUpRoute({this.autofill});
  static const name = "sign-up";

  /// Dev flag: `?autofill=true` pre-fills all
  /// registration fields.
  final bool? autofill;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: SignUpFormScreen(autofill: autofill ?? false),
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
    TypedGoRoute<ViewPartnerDetailRoute>(
      path: '/admin/partner-manager/detail/:partnerId',
      name: ViewPartnerDetailRoute.name,
    ),
    TypedGoRoute<CategoryHomeRoute>(
      path: '/admin/category',
      name: CategoryHomeRoute.name,
    ),
    TypedGoRoute<CategoryAddRoute>(
      path: '/admin/category/add',
      name: CategoryAddRoute.name,
    ),
    TypedGoRoute<AdminNotificationCampaignIndexRoute>(
      path: '/admin/notifications',
      name: AdminNotificationCampaignIndexRoute.name,
    ),
    TypedGoRoute<AdminNotificationCampaignNewRoute>(
      path: '/admin/notifications/new',
      name: AdminNotificationCampaignNewRoute.name,
    ),
    TypedGoRoute<AdminNotificationCampaignDetailRoute>(
      path: '/admin/notifications/:id',
      name: AdminNotificationCampaignDetailRoute.name,
    ),
    TypedGoRoute<AdminFinanceManagerRoute>(
      path: '/admin/finance',
      name: AdminFinanceManagerRoute.name,
    ),
    TypedGoRoute<AdminFinanceTransactionDetailRoute>(
      path: '/admin/finance/transactions/:transactionId',
      name: AdminFinanceTransactionDetailRoute.name,
    ),
    TypedGoRoute<AdminFinancePayoutDetailRoute>(
      path: '/admin/finance/payouts/:payoutId',
      name: AdminFinancePayoutDetailRoute.name,
    ),
    TypedGoRoute<AdminFinanceRefundCaseDetailRoute>(
      path: '/admin/finance/refund-cases/:caseId',
      name: AdminFinanceRefundCaseDetailRoute.name,
    ),
    TypedGoRoute<AdminFinanceReconciliationDetailRoute>(
      path: '/admin/finance/reconciliation/:exceptionId',
      name: AdminFinanceReconciliationDetailRoute.name,
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

/// Route for viewing partner details (read-only)
class ViewPartnerDetailRoute extends GoRouteData with $ViewPartnerDetailRoute {
  const ViewPartnerDetailRoute({required this.partnerId});

  /// The partner ID to view
  final String partnerId;

  static const name = 'view-partner-detail';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: ViewPartnerDetailScreen(partnerId: partnerId),
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

class AdminNotificationCampaignIndexRoute extends GoRouteData
    with $AdminNotificationCampaignIndexRoute {
  const AdminNotificationCampaignIndexRoute();

  static const name = 'admin-notification-campaign-index';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const NotificationCampaignIndexScreen(),
    );
  }
}

class AdminNotificationCampaignNewRoute extends GoRouteData
    with $AdminNotificationCampaignNewRoute {
  const AdminNotificationCampaignNewRoute();

  static const name = 'admin-notification-campaign-new';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const NotificationCampaignComposerScreen(),
    );
  }
}

class AdminNotificationCampaignDetailRoute extends GoRouteData
    with $AdminNotificationCampaignDetailRoute {
  const AdminNotificationCampaignDetailRoute({required this.id});

  static const name = 'admin-notification-campaign-detail';

  final String id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: NotificationCampaignDetailScreen(campaignId: id),
    );
  }
}

// ── ADMIN FINANCE ROUTES ──────────────────────────

class AdminFinanceManagerRoute extends GoRouteData
    with $AdminFinanceManagerRoute {
  const AdminFinanceManagerRoute();
  static const name = 'admin-finance';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const AdminFinanceManagerScreen(),
    );
  }
}

class AdminFinanceTransactionDetailRoute extends GoRouteData
    with $AdminFinanceTransactionDetailRoute {
  const AdminFinanceTransactionDetailRoute({
    required this.transactionId,
  });
  static const name = 'admin-finance-transaction-detail';
  final String transactionId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: AdminFinanceTransactionDetailScreen(
        transactionId: transactionId,
      ),
    );
  }
}

class AdminFinancePayoutDetailRoute extends GoRouteData
    with $AdminFinancePayoutDetailRoute {
  const AdminFinancePayoutDetailRoute({
    required this.payoutId,
  });
  static const name = 'admin-finance-payout-detail';
  final String payoutId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: AdminFinancePayoutDetailScreen(
        payoutId: payoutId,
      ),
    );
  }
}

class AdminFinanceRefundCaseDetailRoute extends GoRouteData
    with $AdminFinanceRefundCaseDetailRoute {
  const AdminFinanceRefundCaseDetailRoute({
    required this.caseId,
  });
  static const name = 'admin-finance-refund-case-detail';
  final String caseId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: AdminFinanceRefundCaseDetailScreen(
        caseId: caseId,
      ),
    );
  }
}

class AdminFinanceReconciliationDetailRoute extends GoRouteData
    with $AdminFinanceReconciliationDetailRoute {
  const AdminFinanceReconciliationDetailRoute({
    required this.exceptionId,
  });
  static const name = 'admin-finance-reconciliation-detail';
  final String exceptionId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: AdminFinanceReconciliationDetailScreen(
        exceptionId: exceptionId,
      ),
    );
  }
}
