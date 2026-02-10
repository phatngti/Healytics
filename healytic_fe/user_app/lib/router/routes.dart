import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/features/bot_chat/presentation/screens/chat_page.dart';
import 'package:common/widgets/adaptive_root_scaffold/adaptive_root_scraffold.dart';
import 'package:user_app/features/bot_chat/presentation/screens/conversation_history_page.dart';
import 'package:user_app/features/home/presentation/screens/home_page.screen.dart';
import 'package:user_app/features/notifications/presentation/screens/notifications.screen.dart';
import 'package:user_app/features/onboarding/presentation/screens/lottie_splash.screen.dart';
import 'package:user_app/features/onboarding/presentation/screens/onboard.screen.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/screens/email_code_confirmation.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/screens/email_form.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/screens/finish_sign_up.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/screens/survey/steps/step_2_lifestyle.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/screens/survey/steps/step_3_body_energy.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/screens/survey/steps/step_4_health_safety.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/screens/survey/survey_screen.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/screens/survey/steps/step_1_general_goals.dart';
import 'package:user_app/features/orders/presentation/screens/orders.screen.dart';
import 'package:user_app/features/profile/presentation/screens/profile.screen.dart';
import 'package:user_app/features/authenticate/presentation/screens/signin.screen.dart';

part 'routes.g.dart';

// --- HELPER FUNCTION ---
// Hàm này giúp tái sử dụng logic slide transition cho tất cả các trang
Page<void> _buildSlideTransitionPage({
  required LocalKey pageKey,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut)),
        ),
        child: child,
      );
    },
  );
}

// --- SHELL ROUTE (Bottom Navigation) ---
@TypedStatefulShellRoute<MobileWrapperRoutes>(
  branches: [
    TypedStatefulShellBranch(
      routes: [TypedGoRoute<HomeRoute>(path: "/home", name: HomeRoute.name)],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<OrderApprovedRoute>(
          path: "/orders",
          name: OrderApprovedRoute.name,
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<ConversationHistoryRoute>(
          path: "/conversation_history",
          name: ConversationHistoryRoute.name,
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<NotificationsRoute>(
          path: "/notifications",
          name: NotificationsRoute.name,
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<ProfileRoute>(path: "/profile", name: ProfileRoute.name),
      ],
    ),
  ],
)
class MobileWrapperRoutes extends StatefulShellRouteData {
  const MobileWrapperRoutes();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return AdaptiveRootScraffold(navigationShell: navigationShell);
  }
}

// --- TAB ROUTES ---

class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();
  static const name = "home";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    // Sử dụng helper function cho gọn
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const HomeUpdatePage(),
    );
  }
}

class OrderApprovedRoute extends GoRouteData with $OrderApprovedRoute {
  const OrderApprovedRoute();
  static const name = "order_approved";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const OrdersPage(),
    );
  }
}

class ConversationHistoryRoute extends GoRouteData
    with $ConversationHistoryRoute {
  const ConversationHistoryRoute();
  static const name = "conversation_history";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const ConversationHistoryPage(),
    );
  }
}

class NotificationsRoute extends GoRouteData with $NotificationsRoute {
  const NotificationsRoute();
  static const name = "notifications";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const NotificationsPage(),
    );
  }
}

class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();
  static const name = "profile";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const ProfilePage(),
    );
  }
}

// --- AUTH & ONBOARDING ROUTES ---

@TypedGoRoute<LottieSplashRoute>(
  path: '/',
  name: LottieSplashRoute.name,
  routes: [
    TypedGoRoute<OnboardingRoute>(
      path: '/onboarding',
      name: OnboardingRoute.name,
    ),
    // Đã sửa typo: SingIn -> SignIn
    TypedGoRoute<SignInRoute>(path: '/signin', name: SignInRoute.name),

    TypedGoRoute<EmailFormRoute>(
      path: '/email_form',
      name: EmailFormRoute.name,
      routes: [
        TypedGoRoute<EmailCodeConfirmationRoute>(
          name: EmailCodeConfirmationRoute.name,
          path: '/email_code_confirmation',
        ),
      ],
    ),
    TypedGoRoute<FinishSignUpRoute>(
      path: '/finish_sign_up',
      name: FinishSignUpRoute.name,
    ),
    TypedGoRoute<SurveyScreenRoute>(
      path: '/survey_screen',
      name: SurveyScreenRoute.name,
    ),
    TypedGoRoute<GeneralGoalsStepRoute>(
      path: '/general_goals_step',
      name: GeneralGoalsStepRoute.name,
    ),
    TypedGoRoute<LifestyleActivityStepRoute>(
      path: '/lifestyle_activity_step',
      name: LifestyleActivityStepRoute.name,
    ),
    TypedGoRoute<BodyEnergyStepRoute>(
      path: '/body_energy_step',
      name: BodyEnergyStepRoute.name,
    ),
    TypedGoRoute<HealthSafetyStepRoute>(
      path: '/health_safety_step',
      name: HealthSafetyStepRoute.name,
    ),
  ],
)
class LottieSplashRoute extends GoRouteData with $LottieSplashRoute {
  const LottieSplashRoute();
  static const name = "lottie_splash";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const LottieSplashScreen(),
    );
  }
}

class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  const OnboardingRoute();
  static const name = "onboarding";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const OnboardScreen(),
    );
  }
}

class SignInRoute extends GoRouteData with $SignInRoute {
  const SignInRoute();
  static const name = "signin";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const SingInScreen(),
    );
  }
}

class EmailFormRoute extends GoRouteData with $EmailFormRoute {
  const EmailFormRoute();
  static const name = "email_form";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const EmailFormScreen(),
    );
  }
}

class EmailCodeConfirmationRoute extends GoRouteData
    with $EmailCodeConfirmationRoute {
  const EmailCodeConfirmationRoute();
  static const name = "email_code_confirmation";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const EmailCodeConfirmationScreen(),
    );
  }
}

class FinishSignUpRoute extends GoRouteData with $FinishSignUpRoute {
  const FinishSignUpRoute();
  static const name = "finish_sign_up";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const FinishSignUpScreen(),
    );
  }
}

class SurveyScreenRoute extends GoRouteData with $SurveyScreenRoute {
  const SurveyScreenRoute();
  static const name = "survey_screen";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const SurveyScreen(),
    );
  }
}

class GeneralGoalsStepRoute extends GoRouteData with $GeneralGoalsStepRoute {
  const GeneralGoalsStepRoute();
  static const name = "general_goals_step";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const GeneralGoalsStep(),
    );
  }
}

class LifestyleActivityStepRoute extends GoRouteData
    with $LifestyleActivityStepRoute {
  const LifestyleActivityStepRoute();
  static const name = "lifestyle_activity_step";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const LifestyleActivityStep(),
    );
  }
}

class BodyEnergyStepRoute extends GoRouteData with $BodyEnergyStepRoute {
  const BodyEnergyStepRoute();
  static const name = "body_energy_step";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const BodyEnergyStep(),
    );
  }
}

class HealthSafetyStepRoute extends GoRouteData with $HealthSafetyStepRoute {
  const HealthSafetyStepRoute();
  static const name = "health_safety_step";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const HealthSafetyStep(),
    );
  }
}
