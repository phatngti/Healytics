import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/widgets/adaptive_root_scaffold/adaptive_root_scraffold.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/ai_health_assistant/presentation/screens/chat.screen.dart';
import 'package:user_app/features/ai_health_assistant/presentation/screens/conversation_history.screen.dart';
import 'package:user_app/features/home/presentation/screens/home_page.screen.dart';
import 'package:user_app/features/service_details/presentation/screens/service_details.screen.dart';
import 'package:user_app/features/service_details/presentation/screens/reviews.screen.dart';
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
import 'package:user_app/features/profile/presentation/screens/edit_profile.screen.dart';
import 'package:user_app/features/checkout/presentation/screens/checkout.screen.dart';
import 'package:user_app/features/authenticate/presentation/screens/signin.screen.dart';
import 'package:user_app/features/employee/domain/entities/certificate.entity.dart';
import 'package:user_app/features/employee/presentation/screens/certificate_viewer.screen.dart';
import 'package:user_app/features/employee/presentation/screens/certificates_list.screen.dart';
import 'package:user_app/features/employee/presentation/screens/employee_detail.screen.dart';
import 'package:user_app/features/booking/presentation/screens/book_appointment.screen.dart';
import 'package:user_app/features/booking/presentation/screens/select_specialist.screen.dart';
import 'package:user_app/features/service_details/presentation/screens/service_specialist.screen.dart';
import 'package:user_app/features/booking/presentation/screens/booking_summary.screen.dart';
import 'package:user_app/features/ai_health_assistant/presentation/screens/ai_health_assistant.screen.dart';
import 'package:user_app/features/employee/presentation/screens/employee_booking.screen.dart';
import 'package:user_app/features/employee/presentation/screens/employee_booking_summary.screen.dart';
import 'package:user_app/features/review/presentation/screens/review_treatment.screen.dart';
import 'package:user_app/features/review/presentation/screens/review_specialist.screen.dart';
import 'package:user_app/features/review/presentation/screens/review_submitted.screen.dart';
import 'package:user_app/features/review/presentation/screens/review_facility.screen.dart';
import 'package:user_app/features/partner_chat/presentation/screens/partner_chat.screen.dart';
import 'package:user_app/features/clinic_info/presentation/screens/clinic_info.screen.dart';
import 'package:user_app/features/cart/presentation/screens/cart.screen.dart';
import 'package:user_app/features/notifications/'
    'presentation/providers/notification.provider.dart';

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
    return _MobileWrapperBody(navigationShell: navigationShell);
  }
}

/// Extracted to a ConsumerWidget so we can
/// watch the unread count provider.
class _MobileWrapperBody extends ConsumerWidget {
  const _MobileWrapperBody({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount =
        ref.watch(unreadCountProvider).value ?? 0;

    return AdaptiveRootScraffold(
      navigationShell: navigationShell,
      notificationBadgeCount: unreadCount,
      destinationKeys: [
        keys.bottomNav.homeTab,
        keys.bottomNav.ordersTab,
        keys.bottomNav.chatTab,
        keys.bottomNav.notificationsTab,
        keys.bottomNav.profileTab,
      ],
    );
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
      child: const ConversationHistoryScreen(),
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

// --- AI HEALTH ASSISTANT CHAT ROUTES ---

@TypedGoRoute<ChatRoute>(path: '/chat', name: ChatRoute.name)
class ChatRoute extends GoRouteData with $ChatRoute {
  final String? conversationId;
  const ChatRoute({this.conversationId});
  static const name = "chat";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: ChatScreen(conversationId: conversationId),
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

// --- BOOK APPOINTMENT ROUTE (No Navigation Bar) ---

@TypedGoRoute<BookAppointmentRoute>(
  path: '/book_appointment',
  name: BookAppointmentRoute.name,
)
class BookAppointmentRoute extends GoRouteData with $BookAppointmentRoute {
  const BookAppointmentRoute();
  static const name = 'book_appointment';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const BookAppointmentScreen(),
    );
  }
}

// --- SELECT SPECIALIST ROUTE (No Navigation Bar) ---

@TypedGoRoute<SelectSpecialistRoute>(
  path: '/select_specialist',
  name: SelectSpecialistRoute.name,
)
class SelectSpecialistRoute extends GoRouteData with $SelectSpecialistRoute {
  final String categoryId;
  const SelectSpecialistRoute({required this.categoryId});
  static const name = 'select_specialist';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: SelectSpecialistScreen(categoryId: categoryId),
    );
  }
}

// --- SERVICE SPECIALIST ROUTE (No Navigation Bar) ---

@TypedGoRoute<ServiceSpecialistRoute>(
  path: '/service_specialist',
  name: ServiceSpecialistRoute.name,
)
class ServiceSpecialistRoute extends GoRouteData with $ServiceSpecialistRoute {
  final String serviceId;
  const ServiceSpecialistRoute({required this.serviceId});
  static const name = 'service_specialist';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: ServiceSpecialistScreen(serviceId: serviceId),
    );
  }
}

// --- EMPLOYEE BOOKING ROUTE (No Navigation Bar) ---

@TypedGoRoute<EmployeeBookingRoute>(
  path: '/employee_booking',
  name: EmployeeBookingRoute.name,
)
class EmployeeBookingRoute extends GoRouteData with $EmployeeBookingRoute {
  final String employeeId;
  final String serviceId;
  const EmployeeBookingRoute({
    required this.employeeId,
    required this.serviceId,
  });
  static const name = 'employee_booking';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: EmployeeBookingScreen(
        employeeId: employeeId,
        serviceId: serviceId,
      ),
    );
  }
}

// --- EMPLOYEE BOOKING SUMMARY ROUTE (No Nav Bar) ---

@TypedGoRoute<EmployeeBookingSummaryRoute>(
  path: '/employee_booking_summary',
  name: EmployeeBookingSummaryRoute.name,
)
class EmployeeBookingSummaryRoute extends GoRouteData
    with $EmployeeBookingSummaryRoute {
  const EmployeeBookingSummaryRoute();
  static const name = 'employee_booking_summary';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const EmployeeBookingSummaryScreen(),
    );
  }
}

// --- BOOKING SUMMARY ROUTE (No Navigation Bar) ---

@TypedGoRoute<BookingSummaryRoute>(
  path: '/booking_summary',
  name: BookingSummaryRoute.name,
)
class BookingSummaryRoute extends GoRouteData with $BookingSummaryRoute {
  const BookingSummaryRoute();
  static const name = 'booking_summary';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const BookingSummaryScreen(),
    );
  }
}

// --- AI HEALTH ASSISTANT ROUTE (No Navigation Bar) ---

@TypedGoRoute<AiHealthAssistantRoute>(
  path: '/ai_health_assistant',
  name: AiHealthAssistantRoute.name,
)
class AiHealthAssistantRoute extends GoRouteData with $AiHealthAssistantRoute {
  const AiHealthAssistantRoute();
  static const name = 'ai_health_assistant';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const AiHealthAssistantScreen(),
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

// --- EMPLOYEE DETAIL ROUTE (No Navigation Bar) ---

@TypedGoRoute<EmployeeDetailRoute>(
  path: '/employee_detail',
  name: EmployeeDetailRoute.name,
)
class EmployeeDetailRoute extends GoRouteData with $EmployeeDetailRoute {
  final String employeeId;
  const EmployeeDetailRoute({required this.employeeId});
  static const name = 'employee_detail';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: EmployeeDetailScreen(employeeId: employeeId),
    );
  }
}

// --- CERTIFICATES ROUTES (No Navigation Bar) ---

@TypedGoRoute<CertificatesListRoute>(
  path: '/certificates_list',
  name: CertificatesListRoute.name,
)
class CertificatesListRoute extends GoRouteData with $CertificatesListRoute {
  final String employeeName;
  final String employeeId;
  const CertificatesListRoute({
    required this.employeeName,
    required this.employeeId,
  });
  static const name = 'certificates_list';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: CertificatesListScreen(
        employeeId: employeeId,
        employeeName: employeeName,
      ),
    );
  }
}

@TypedGoRoute<CertificateViewerRoute>(
  path: '/certificate_viewer',
  name: CertificateViewerRoute.routeName,
)
class CertificateViewerRoute extends GoRouteData with $CertificateViewerRoute {
  final String certificateName;
  final String url;
  final String type;
  const CertificateViewerRoute({
    required this.certificateName,
    required this.url,
    required this.type,
  });
  static const routeName = 'certificate_viewer';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: CertificateViewerScreen(
        name: certificateName,
        url: url,
        type: CertificateType.values.firstWhere(
          (e) => e.name == type,
          orElse: () => CertificateType.unknown,
        ),
      ),
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

// --- EDIT PROFILE ROUTE (No Navigation Bar) ---

@TypedGoRoute<EditProfileRoute>(
  path: '/edit_profile',
  name: EditProfileRoute.name,
)
class EditProfileRoute extends GoRouteData with $EditProfileRoute {
  const EditProfileRoute();
  static const name = 'edit_profile';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const EditProfileScreen(),
    );
  }
}

// --- REVIEW TREATMENT ROUTE (No Navigation Bar) ---

@TypedGoRoute<ReviewTreatmentRoute>(
  path: '/review_treatment',
  name: ReviewTreatmentRoute.name,
)
class ReviewTreatmentRoute extends GoRouteData with $ReviewTreatmentRoute {
  final String appointmentId;
  final String serviceName;
  final String vendorName;

  const ReviewTreatmentRoute({
    required this.appointmentId,
    required this.serviceName,
    required this.vendorName,
  });

  static const name = 'review_treatment';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: ReviewTreatmentScreen(
        appointmentId: appointmentId,
        serviceName: serviceName,
        vendorName: vendorName,
      ),
    );
  }
}

// --- REVIEW SPECIALIST ROUTE (No Navigation Bar) ---

@TypedGoRoute<ReviewSpecialistRoute>(
  path: '/review_specialist',
  name: ReviewSpecialistRoute.name,
)
class ReviewSpecialistRoute extends GoRouteData with $ReviewSpecialistRoute {
  final String appointmentId;
  final String specialistId;
  final String specialistName;
  final String specialistRole;
  final String? specialistAvatarUrl;
  final String facilityId;
  final String facilityName;
  final String? facilityAddress;

  const ReviewSpecialistRoute({
    required this.appointmentId,
    required this.specialistId,
    required this.specialistName,
    required this.specialistRole,
    this.specialistAvatarUrl,
    required this.facilityId,
    required this.facilityName,
    this.facilityAddress,
  });

  static const name = 'review_specialist';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: ReviewSpecialistScreen(
        appointmentId: appointmentId,
        specialistId: specialistId,
        specialistName: specialistName,
        specialistRole: specialistRole,
        specialistAvatarUrl: specialistAvatarUrl,
        facilityId: facilityId,
        facilityName: facilityName,
        facilityAddress: facilityAddress,
      ),
    );
  }
}

// --- REVIEW FACILITY ROUTE (No Navigation Bar) ---

@TypedGoRoute<ReviewFacilityRoute>(
  path: '/review_facility',
  name: ReviewFacilityRoute.name,
)
class ReviewFacilityRoute extends GoRouteData
    with $ReviewFacilityRoute {
  final String appointmentId;
  final String facilityId;
  final String facilityName;
  final String? facilityAddress;
  final String specialistName;
  final String? specialistAvatarUrl;
  final int specialistRating;

  const ReviewFacilityRoute({
    required this.appointmentId,
    required this.facilityId,
    required this.facilityName,
    this.facilityAddress,
    required this.specialistName,
    this.specialistAvatarUrl,
    required this.specialistRating,
  });

  static const name = 'review_facility';

  @override
  Page<void> buildPage(
    BuildContext context,
    GoRouterState state,
  ) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: ReviewFacilityScreen(
        appointmentId: appointmentId,
        facilityId: facilityId,
        facilityName: facilityName,
        facilityAddress: facilityAddress,
        specialistName: specialistName,
        specialistAvatarUrl:
            specialistAvatarUrl,
        specialistRating: specialistRating,
      ),
    );
  }
}

// --- REVIEW SUBMITTED ROUTE (No Navigation Bar) ---

@TypedGoRoute<ReviewSubmittedRoute>(
  path: '/review_submitted',
  name: ReviewSubmittedRoute.name,
)
class ReviewSubmittedRoute extends GoRouteData with $ReviewSubmittedRoute {
  final String specialistName;
  final String? specialistAvatarUrl;
  final int rating;

  const ReviewSubmittedRoute({
    required this.specialistName,
    this.specialistAvatarUrl,
    required this.rating,
  });

  static const name = 'review_submitted';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: ReviewSubmittedScreen(
        specialistName: specialistName,
        specialistAvatarUrl: specialistAvatarUrl,
        rating: rating,
      ),
    );
  }
}

// --- PARTNER CHAT ROUTE (No Navigation Bar) ---

@TypedGoRoute<PartnerChatRoute>(
  path: '/partner_chat',
  name: PartnerChatRoute.name,
)
class PartnerChatRoute extends GoRouteData with $PartnerChatRoute {
  final String partnerAccountId;
  final String partnerName;
  final String? partnerAvatar;

  const PartnerChatRoute({
    required this.partnerAccountId,
    required this.partnerName,
    this.partnerAvatar,
  });

  static const name = 'partner_chat';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: PartnerChatScreen(
        partnerAccountId: partnerAccountId,
        partnerName: partnerName,
        partnerAvatar: partnerAvatar,
      ),
    );
  }
}

// --- CLINIC INFO ROUTE (No Navigation Bar) ---

@TypedGoRoute<ClinicInfoRoute>(path: '/clinic_info', name: ClinicInfoRoute.name)
class ClinicInfoRoute extends GoRouteData with $ClinicInfoRoute {
  final String clinicId;

  const ClinicInfoRoute({required this.clinicId});

  static const name = 'clinic_info';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: ClinicInfoScreen(clinicId: clinicId),
    );
  }
}

// --- CART ROUTE (No Navigation Bar) ---

@TypedGoRoute<CartRoute>(
  path: '/cart',
  name: CartRoute.name,
)
class CartRoute extends GoRouteData
    with $CartRoute {
  const CartRoute();
  static const name = 'cart';

  @override
  Page<void> buildPage(
    BuildContext context,
    GoRouterState state,
  ) {
    return _buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const CartScreen(),
    );
  }
}
