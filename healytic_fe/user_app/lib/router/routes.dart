import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:common/widgets/adaptive_root_scaffold/adaptive_root_scraffold.dart';
import 'package:user_app/features/bot_chat/presentation/screens/chat_page.dart';
import 'package:user_app/features/bot_chat/presentation/screens/conversation_history_page.dart';
import 'package:user_app/features/home/presentation/screens/home_page.screen.dart';
import 'package:user_app/features/home/presentation/screens/service_details.screen.dart';
import 'package:user_app/features/home/presentation/screens/reviews.screen.dart';
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
import 'package:user_app/features/orders/presentation/screens/order_details.screen.dart';
import 'package:user_app/features/orders/presentation/screens/orders.screen.dart';
import 'package:user_app/features/orders/presentation/screens/service_manual.screen.dart';
import 'package:user_app/features/profile/presentation/screens/profile.screen.dart';
import 'package:user_app/features/checkout/presentation/screens/checkout.screen.dart';
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

// --- BOT CHAT ROUTES ---

@TypedGoRoute<ChatRoute>(path: '/chat', name: ChatRoute.name)
class ChatRoute extends GoRouteData with $ChatRoute {
  final String? conversationId;
  const ChatRoute({this.conversationId});
  static const name = "chat";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: ChatPage(conversationId: conversationId),
    );
  }
}

// --- SERVICE DETAILS ROUTE (No Navigation Bar) ---

@TypedGoRoute<ServiceDetailsRoute>(
  path: '/service_details',
  name: ServiceDetailsRoute.name,
)
class ServiceDetailsRoute extends GoRouteData with $ServiceDetailsRoute {
  final String serviceId;
  const ServiceDetailsRoute({required this.serviceId});
  static const name = 'service_details';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: ServiceDetailsScreen(serviceId: serviceId),
    );
  }
}

// --- REVIEWS ROUTE (No Navigation Bar) ---

@TypedGoRoute<ReviewsRoute>(path: '/reviews', name: ReviewsRoute.name)
class ReviewsRoute extends GoRouteData with $ReviewsRoute {
  final String serviceId;
  const ReviewsRoute({required this.serviceId});
  static const name = 'reviews';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: ReviewsScreen(serviceId: serviceId),
    );
  }
}

// --- CHECKOUT ROUTE (No Navigation Bar) ---

@TypedGoRoute<CheckoutRoute>(path: '/checkout', name: CheckoutRoute.name)
class CheckoutRoute extends GoRouteData with $CheckoutRoute {
  const CheckoutRoute();
  static const name = 'checkout';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const CheckoutScreen(),
    );
  }
}

// --- ORDER DETAILS ROUTE (No Navigation Bar) ---

@TypedGoRoute<OrderDetailsRoute>(
  path: '/order_details',
  name: OrderDetailsRoute.name,
)
class OrderDetailsRoute extends GoRouteData with $OrderDetailsRoute {
  final String appointmentId;
  const OrderDetailsRoute({required this.appointmentId});
  static const name = 'order_details';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: OrderDetailsScreen(appointmentId: appointmentId),
    );
  }
}

// --- SERVICE MANUAL ROUTE (No Navigation Bar) ---

@TypedGoRoute<ServiceManualRoute>(
  path: '/service_manual',
  name: ServiceManualRoute.name,
)
class ServiceManualRoute extends GoRouteData with $ServiceManualRoute {
  final String appointmentId;
  const ServiceManualRoute({required this.appointmentId});
  static const name = 'service_manual';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: ServiceManualScreen(appointmentId: appointmentId),
    );
  }
}

@TypedGoRoute<LottieSplashRoute>(path: '/', name: LottieSplashRoute.name)
class LottieSplashRoute extends GoRouteData with $LottieSplashRoute {
  static const String pathPattern = '/';
  static const bool isPublic = true;

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

@TypedGoRoute<OnboardingRoute>(path: '/onboarding', name: OnboardingRoute.name)
class OnboardingRoute extends GoRouteData with $OnboardingRoute {
  static const String pathPattern = '/onboarding';
  static const bool isPublic = true;

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

@TypedGoRoute<SignInRoute>(path: '/signin', name: SignInRoute.name)
class SignInRoute extends GoRouteData with $SignInRoute {
  static const String pathPattern = '/signin';
  static const bool isPublic = true;

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

@TypedGoRoute<EmailFormRoute>(path: '/email_form', name: EmailFormRoute.name)
class EmailFormRoute extends GoRouteData with $EmailFormRoute {
  static const String pathPattern = '/email_form';
  static const bool isPublic = true;

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

@TypedGoRoute<EmailCodeConfirmationRoute>(
  path: '/email_code_confirmation',
  name: EmailCodeConfirmationRoute.name,
)
class EmailCodeConfirmationRoute extends GoRouteData
    with $EmailCodeConfirmationRoute {
  static const String pathPattern = '/email_code_confirmation';
  static const bool isPublic = true;

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

@TypedGoRoute<FinishSignUpRoute>(
  path: '/finish_sign_up',
  name: FinishSignUpRoute.name,
)
class FinishSignUpRoute extends GoRouteData with $FinishSignUpRoute {
  static const String pathPattern = '/finish_sign_up';
  static const bool isPublic = true;

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

// --- SURVEY ROUTES (No Navigation Bar) ---

@TypedGoRoute<SurveyScreenRoute>(
  path: '/survey_screen',
  name: SurveyScreenRoute.name,
)
class SurveyScreenRoute extends GoRouteData with $SurveyScreenRoute {
  static const String pathPattern = '/survey_screen';
  static const bool isPublic = true;

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

@TypedGoRoute<GeneralGoalsStepRoute>(
  path: '/general_goals_step',
  name: GeneralGoalsStepRoute.name,
)
class GeneralGoalsStepRoute extends GoRouteData with $GeneralGoalsStepRoute {
  static const String pathPattern = '/general_goals_step';
  static const bool isPublic = true;

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

@TypedGoRoute<LifestyleActivityStepRoute>(
  path: '/lifestyle_activity_step',
  name: LifestyleActivityStepRoute.name,
)
class LifestyleActivityStepRoute extends GoRouteData
    with $LifestyleActivityStepRoute {
  static const String pathPattern = '/lifestyle_activity_step';
  static const bool isPublic = true;

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

@TypedGoRoute<BodyEnergyStepRoute>(
  path: '/body_energy_step',
  name: BodyEnergyStepRoute.name,
)
class BodyEnergyStepRoute extends GoRouteData with $BodyEnergyStepRoute {
  static const String pathPattern = '/body_energy_step';
  static const bool isPublic = true;

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

@TypedGoRoute<HealthSafetyStepRoute>(
  path: '/health_safety_step',
  name: HealthSafetyStepRoute.name,
)
class HealthSafetyStepRoute extends GoRouteData with $HealthSafetyStepRoute {
  static const String pathPattern = '/health_safety_step';
  static const bool isPublic = true;

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
