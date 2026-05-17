// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $mobileWrapperRoutes,
  $homeRecommendationsRoute,
  $homeRecentActivityRoute,
  $homeSpecialistsRoute,
  $homePremiumTreatmentsRoute,
  $chatRoute,
  $serviceDetailsRoute,
  $reviewsRoute,
  $checkoutRoute,
  $bookAppointmentRoute,
  $selectSpecialistRoute,
  $serviceSpecialistRoute,
  $employeeBookingRoute,
  $employeeBookingSummaryRoute,
  $bookingSummaryRoute,
  $aiHealthAssistantRoute,
  $orderDetailsRoute,
  $serviceManualRoute,
  $employeeDetailRoute,
  $certificatesListRoute,
  $employeeReviewsRoute,
  $certificateViewerRoute,
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
  $editProfileRoute,
  $reviewTreatmentRoute,
  $reviewSpecialistRoute,
  $reviewFacilityRoute,
  $reviewSubmittedRoute,
  $partnerChatRoute,
  $clinicInfoRoute,
  $cartRoute,
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

RouteBase get $homeRecommendationsRoute => GoRouteData.$route(
  path: '/home/recommendations',
  name: 'home_recommendations',
  factory: $HomeRecommendationsRoute._fromState,
);

mixin $HomeRecommendationsRoute on GoRouteData {
  static HomeRecommendationsRoute _fromState(GoRouterState state) =>
      const HomeRecommendationsRoute();

  @override
  String get location => GoRouteData.$location('/home/recommendations');

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

RouteBase get $homeRecentActivityRoute => GoRouteData.$route(
  path: '/home/recent-activity',
  name: 'home_recent_activity',
  factory: $HomeRecentActivityRoute._fromState,
);

mixin $HomeRecentActivityRoute on GoRouteData {
  static HomeRecentActivityRoute _fromState(GoRouterState state) =>
      const HomeRecentActivityRoute();

  @override
  String get location => GoRouteData.$location('/home/recent-activity');

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

RouteBase get $homeSpecialistsRoute => GoRouteData.$route(
  path: '/home/specialists',
  name: 'home_specialists',
  factory: $HomeSpecialistsRoute._fromState,
);

mixin $HomeSpecialistsRoute on GoRouteData {
  static HomeSpecialistsRoute _fromState(GoRouterState state) =>
      const HomeSpecialistsRoute();

  @override
  String get location => GoRouteData.$location('/home/specialists');

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

RouteBase get $homePremiumTreatmentsRoute => GoRouteData.$route(
  path: '/home/premium-treatments',
  name: 'home_premium_treatments',
  factory: $HomePremiumTreatmentsRoute._fromState,
);

mixin $HomePremiumTreatmentsRoute on GoRouteData {
  static HomePremiumTreatmentsRoute _fromState(GoRouterState state) =>
      const HomePremiumTreatmentsRoute();

  @override
  String get location => GoRouteData.$location('/home/premium-treatments');

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

RouteBase get $bookAppointmentRoute => GoRouteData.$route(
  path: '/book_appointment',
  name: 'book_appointment',
  factory: $BookAppointmentRoute._fromState,
);

mixin $BookAppointmentRoute on GoRouteData {
  static BookAppointmentRoute _fromState(GoRouterState state) =>
      const BookAppointmentRoute();

  @override
  String get location => GoRouteData.$location('/book_appointment');

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

RouteBase get $selectSpecialistRoute => GoRouteData.$route(
  path: '/select_specialist',
  name: 'select_specialist',
  factory: $SelectSpecialistRoute._fromState,
);

mixin $SelectSpecialistRoute on GoRouteData {
  static SelectSpecialistRoute _fromState(GoRouterState state) =>
      SelectSpecialistRoute(
        categoryId: state.uri.queryParameters['category-id']!,
      );

  SelectSpecialistRoute get _self => this as SelectSpecialistRoute;

  @override
  String get location => GoRouteData.$location(
    '/select_specialist',
    queryParams: {'category-id': _self.categoryId},
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

RouteBase get $serviceSpecialistRoute => GoRouteData.$route(
  path: '/service_specialist',
  name: 'service_specialist',
  factory: $ServiceSpecialistRoute._fromState,
);

mixin $ServiceSpecialistRoute on GoRouteData {
  static ServiceSpecialistRoute _fromState(GoRouterState state) =>
      ServiceSpecialistRoute(
        serviceId: state.uri.queryParameters['service-id']!,
      );

  ServiceSpecialistRoute get _self => this as ServiceSpecialistRoute;

  @override
  String get location => GoRouteData.$location(
    '/service_specialist',
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

RouteBase get $employeeBookingRoute => GoRouteData.$route(
  path: '/employee_booking',
  name: 'employee_booking',
  factory: $EmployeeBookingRoute._fromState,
);

mixin $EmployeeBookingRoute on GoRouteData {
  static EmployeeBookingRoute _fromState(GoRouterState state) =>
      EmployeeBookingRoute(
        employeeId: state.uri.queryParameters['employee-id']!,
        serviceId: state.uri.queryParameters['service-id']!,
      );

  EmployeeBookingRoute get _self => this as EmployeeBookingRoute;

  @override
  String get location => GoRouteData.$location(
    '/employee_booking',
    queryParams: {
      'employee-id': _self.employeeId,
      'service-id': _self.serviceId,
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

RouteBase get $employeeBookingSummaryRoute => GoRouteData.$route(
  path: '/employee_booking_summary',
  name: 'employee_booking_summary',
  factory: $EmployeeBookingSummaryRoute._fromState,
);

mixin $EmployeeBookingSummaryRoute on GoRouteData {
  static EmployeeBookingSummaryRoute _fromState(GoRouterState state) =>
      const EmployeeBookingSummaryRoute();

  @override
  String get location => GoRouteData.$location('/employee_booking_summary');

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

RouteBase get $bookingSummaryRoute => GoRouteData.$route(
  path: '/booking_summary',
  name: 'booking_summary',
  factory: $BookingSummaryRoute._fromState,
);

mixin $BookingSummaryRoute on GoRouteData {
  static BookingSummaryRoute _fromState(GoRouterState state) =>
      const BookingSummaryRoute();

  @override
  String get location => GoRouteData.$location('/booking_summary');

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

RouteBase get $aiHealthAssistantRoute => GoRouteData.$route(
  path: '/ai_health_assistant',
  name: 'ai_health_assistant',
  factory: $AiHealthAssistantRoute._fromState,
);

mixin $AiHealthAssistantRoute on GoRouteData {
  static AiHealthAssistantRoute _fromState(GoRouterState state) =>
      const AiHealthAssistantRoute();

  @override
  String get location => GoRouteData.$location('/ai_health_assistant');

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

RouteBase get $orderDetailsRoute => GoRouteData.$route(
  path: '/order_details',
  name: 'order_details',
  factory: $OrderDetailsRoute._fromState,
);

mixin $OrderDetailsRoute on GoRouteData {
  static OrderDetailsRoute _fromState(GoRouterState state) => OrderDetailsRoute(
    appointmentId: state.uri.queryParameters['appointment-id']!,
  );

  OrderDetailsRoute get _self => this as OrderDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/order_details',
    queryParams: {'appointment-id': _self.appointmentId},
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

RouteBase get $serviceManualRoute => GoRouteData.$route(
  path: '/service_manual',
  name: 'service_manual',
  factory: $ServiceManualRoute._fromState,
);

mixin $ServiceManualRoute on GoRouteData {
  static ServiceManualRoute _fromState(GoRouterState state) =>
      ServiceManualRoute(
        appointmentId: state.uri.queryParameters['appointment-id']!,
      );

  ServiceManualRoute get _self => this as ServiceManualRoute;

  @override
  String get location => GoRouteData.$location(
    '/service_manual',
    queryParams: {'appointment-id': _self.appointmentId},
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

RouteBase get $employeeDetailRoute => GoRouteData.$route(
  path: '/employee_detail',
  name: 'employee_detail',
  factory: $EmployeeDetailRoute._fromState,
);

mixin $EmployeeDetailRoute on GoRouteData {
  static EmployeeDetailRoute _fromState(GoRouterState state) =>
      EmployeeDetailRoute(
        employeeId: state.uri.queryParameters['employee-id']!,
      );

  EmployeeDetailRoute get _self => this as EmployeeDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/employee_detail',
    queryParams: {'employee-id': _self.employeeId},
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

RouteBase get $certificatesListRoute => GoRouteData.$route(
  path: '/certificates_list',
  name: 'certificates_list',
  factory: $CertificatesListRoute._fromState,
);

mixin $CertificatesListRoute on GoRouteData {
  static CertificatesListRoute _fromState(GoRouterState state) =>
      CertificatesListRoute(
        employeeName: state.uri.queryParameters['employee-name']!,
        employeeId: state.uri.queryParameters['employee-id']!,
      );

  CertificatesListRoute get _self => this as CertificatesListRoute;

  @override
  String get location => GoRouteData.$location(
    '/certificates_list',
    queryParams: {
      'employee-name': _self.employeeName,
      'employee-id': _self.employeeId,
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

RouteBase get $employeeReviewsRoute => GoRouteData.$route(
  path: '/employee_reviews',
  name: 'employee_reviews',
  factory: $EmployeeReviewsRoute._fromState,
);

mixin $EmployeeReviewsRoute on GoRouteData {
  static EmployeeReviewsRoute _fromState(GoRouterState state) =>
      EmployeeReviewsRoute(
        employeeId: state.uri.queryParameters['employee-id']!,
        employeeName: state.uri.queryParameters['employee-name']!,
      );

  EmployeeReviewsRoute get _self => this as EmployeeReviewsRoute;

  @override
  String get location => GoRouteData.$location(
    '/employee_reviews',
    queryParams: {
      'employee-id': _self.employeeId,
      'employee-name': _self.employeeName,
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

RouteBase get $certificateViewerRoute => GoRouteData.$route(
  path: '/certificate_viewer',
  name: 'certificate_viewer',
  factory: $CertificateViewerRoute._fromState,
);

mixin $CertificateViewerRoute on GoRouteData {
  static CertificateViewerRoute _fromState(GoRouterState state) =>
      CertificateViewerRoute(
        certificateName: state.uri.queryParameters['certificate-name']!,
        url: state.uri.queryParameters['url']!,
        type: state.uri.queryParameters['type']!,
      );

  CertificateViewerRoute get _self => this as CertificateViewerRoute;

  @override
  String get location => GoRouteData.$location(
    '/certificate_viewer',
    queryParams: {
      'certificate-name': _self.certificateName,
      'url': _self.url,
      'type': _self.type,
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

RouteBase get $editProfileRoute => GoRouteData.$route(
  path: '/edit_profile',
  name: 'edit_profile',
  factory: $EditProfileRoute._fromState,
);

mixin $EditProfileRoute on GoRouteData {
  static EditProfileRoute _fromState(GoRouterState state) =>
      const EditProfileRoute();

  @override
  String get location => GoRouteData.$location('/edit_profile');

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

RouteBase get $reviewTreatmentRoute => GoRouteData.$route(
  path: '/review_treatment',
  name: 'review_treatment',
  factory: $ReviewTreatmentRoute._fromState,
);

mixin $ReviewTreatmentRoute on GoRouteData {
  static ReviewTreatmentRoute _fromState(GoRouterState state) =>
      ReviewTreatmentRoute(
        appointmentId: state.uri.queryParameters['appointment-id']!,
        serviceName: state.uri.queryParameters['service-name']!,
        vendorName: state.uri.queryParameters['vendor-name']!,
      );

  ReviewTreatmentRoute get _self => this as ReviewTreatmentRoute;

  @override
  String get location => GoRouteData.$location(
    '/review_treatment',
    queryParams: {
      'appointment-id': _self.appointmentId,
      'service-name': _self.serviceName,
      'vendor-name': _self.vendorName,
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

RouteBase get $reviewSpecialistRoute => GoRouteData.$route(
  path: '/review_specialist',
  name: 'review_specialist',
  factory: $ReviewSpecialistRoute._fromState,
);

mixin $ReviewSpecialistRoute on GoRouteData {
  static ReviewSpecialistRoute _fromState(GoRouterState state) =>
      ReviewSpecialistRoute(
        appointmentId: state.uri.queryParameters['appointment-id']!,
        specialistId: state.uri.queryParameters['specialist-id']!,
        specialistName: state.uri.queryParameters['specialist-name']!,
        specialistRole: state.uri.queryParameters['specialist-role']!,
        specialistAvatarUrl: state.uri.queryParameters['specialist-avatar-url'],
        facilityId: state.uri.queryParameters['facility-id']!,
        facilityName: state.uri.queryParameters['facility-name']!,
        facilityAddress: state.uri.queryParameters['facility-address'],
      );

  ReviewSpecialistRoute get _self => this as ReviewSpecialistRoute;

  @override
  String get location => GoRouteData.$location(
    '/review_specialist',
    queryParams: {
      'appointment-id': _self.appointmentId,
      'specialist-id': _self.specialistId,
      'specialist-name': _self.specialistName,
      'specialist-role': _self.specialistRole,
      if (_self.specialistAvatarUrl != null)
        'specialist-avatar-url': _self.specialistAvatarUrl,
      'facility-id': _self.facilityId,
      'facility-name': _self.facilityName,
      if (_self.facilityAddress != null)
        'facility-address': _self.facilityAddress,
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

RouteBase get $reviewFacilityRoute => GoRouteData.$route(
  path: '/review_facility',
  name: 'review_facility',
  factory: $ReviewFacilityRoute._fromState,
);

mixin $ReviewFacilityRoute on GoRouteData {
  static ReviewFacilityRoute _fromState(GoRouterState state) =>
      ReviewFacilityRoute(
        appointmentId: state.uri.queryParameters['appointment-id']!,
        facilityId: state.uri.queryParameters['facility-id']!,
        facilityName: state.uri.queryParameters['facility-name']!,
        facilityAddress: state.uri.queryParameters['facility-address'],
        specialistName: state.uri.queryParameters['specialist-name']!,
        specialistAvatarUrl: state.uri.queryParameters['specialist-avatar-url'],
        specialistRating: int.parse(
          state.uri.queryParameters['specialist-rating']!,
        ),
      );

  ReviewFacilityRoute get _self => this as ReviewFacilityRoute;

  @override
  String get location => GoRouteData.$location(
    '/review_facility',
    queryParams: {
      'appointment-id': _self.appointmentId,
      'facility-id': _self.facilityId,
      'facility-name': _self.facilityName,
      if (_self.facilityAddress != null)
        'facility-address': _self.facilityAddress,
      'specialist-name': _self.specialistName,
      if (_self.specialistAvatarUrl != null)
        'specialist-avatar-url': _self.specialistAvatarUrl,
      'specialist-rating': _self.specialistRating.toString(),
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

RouteBase get $reviewSubmittedRoute => GoRouteData.$route(
  path: '/review_submitted',
  name: 'review_submitted',
  factory: $ReviewSubmittedRoute._fromState,
);

mixin $ReviewSubmittedRoute on GoRouteData {
  static ReviewSubmittedRoute _fromState(GoRouterState state) =>
      ReviewSubmittedRoute(
        specialistName: state.uri.queryParameters['specialist-name']!,
        specialistAvatarUrl: state.uri.queryParameters['specialist-avatar-url'],
        rating: int.parse(state.uri.queryParameters['rating']!),
      );

  ReviewSubmittedRoute get _self => this as ReviewSubmittedRoute;

  @override
  String get location => GoRouteData.$location(
    '/review_submitted',
    queryParams: {
      'specialist-name': _self.specialistName,
      if (_self.specialistAvatarUrl != null)
        'specialist-avatar-url': _self.specialistAvatarUrl,
      'rating': _self.rating.toString(),
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

RouteBase get $partnerChatRoute => GoRouteData.$route(
  path: '/partner_chat',
  name: 'partner_chat',
  factory: $PartnerChatRoute._fromState,
);

mixin $PartnerChatRoute on GoRouteData {
  static PartnerChatRoute _fromState(GoRouterState state) => PartnerChatRoute(
    partnerAccountId: state.uri.queryParameters['partner-account-id']!,
    partnerName: state.uri.queryParameters['partner-name']!,
    partnerAvatar: state.uri.queryParameters['partner-avatar'],
  );

  PartnerChatRoute get _self => this as PartnerChatRoute;

  @override
  String get location => GoRouteData.$location(
    '/partner_chat',
    queryParams: {
      'partner-account-id': _self.partnerAccountId,
      'partner-name': _self.partnerName,
      if (_self.partnerAvatar != null) 'partner-avatar': _self.partnerAvatar,
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

RouteBase get $clinicInfoRoute => GoRouteData.$route(
  path: '/clinic_info',
  name: 'clinic_info',
  factory: $ClinicInfoRoute._fromState,
);

mixin $ClinicInfoRoute on GoRouteData {
  static ClinicInfoRoute _fromState(GoRouterState state) =>
      ClinicInfoRoute(clinicId: state.uri.queryParameters['clinic-id']!);

  ClinicInfoRoute get _self => this as ClinicInfoRoute;

  @override
  String get location => GoRouteData.$location(
    '/clinic_info',
    queryParams: {'clinic-id': _self.clinicId},
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

RouteBase get $cartRoute => GoRouteData.$route(
  path: '/cart',
  name: 'cart',
  factory: $CartRoute._fromState,
);

mixin $CartRoute on GoRouteData {
  static CartRoute _fromState(GoRouterState state) => const CartRoute();

  @override
  String get location => GoRouteData.$location('/cart');

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
