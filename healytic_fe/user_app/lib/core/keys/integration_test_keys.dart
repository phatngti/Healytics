import 'package:flutter/foundation.dart';

/// Centralized test keys for Patrol integration tests.
///
/// Single source of truth — used both in widget code
/// and test code to avoid key duplication.
/// See: https://patrol.leancode.co/documentation/
/// write-your-first-test#writing-the-test

// --- Onboarding ---

class OnboardPageKeys {
  final signInButton = const Key('onboardSignInButton');
  final createAccountButton = const Key('onboardCreateAccountButton');
}

// --- Sign In ---

class SignInPageKeys {
  final emailTextField = const Key('signInEmailTextField');
  final passwordTextField = const Key('signInPasswordTextField');
  final signInButton = const Key('signInButton');
  final forgotPasswordButton = const Key('forgotPasswordButton');
  final googleButton = const Key('googleSignInButton');
  final facebookButton = const Key('facebookSignInButton');
}

class ForgotPasswordPageKeys {
  final emailTextField = const Key('forgotPasswordEmailTextField');
  final sendResetCodeButton = const Key('forgotPasswordSendResetCodeButton');
}

class PasswordResetCodePageKeys {
  final pinput = const Key('passwordResetCodePinput');
  final submitButton = const Key('passwordResetCodeSubmitButton');
  final resendButton = const Key('passwordResetCodeResendButton');
}

class ResetPasswordPageKeys {
  final passwordTextField = const Key('resetPasswordPasswordTextField');
  final confirmPasswordTextField = const Key(
    'resetPasswordConfirmPasswordTextField',
  );
  final submitButton = const Key('resetPasswordSubmitButton');
}

// --- Sign Up: Email Form ---

class EmailFormPageKeys {
  final emailTextField = const Key('emailFormEmailTextField');
  final continueButton = const Key('emailFormContinueButton');
}

// --- Sign Up: Code Confirmation ---

class CodeConfirmationPageKeys {
  final pinput = const Key('codeConfirmationPinput');
  final submitButton = const Key('codeConfirmationSubmitButton');
  final resendLink = const Key('codeConfirmationResendLink');
}

// --- Home ---

class HomePageKeys {
  final searchField = const Key('homeSearchField');
  final cartButton = const Key('homeCartButton');
  final recommendationsViewAll = const Key('homeRecommendationsViewAll');
  final recentActivityViewAll = const Key('homeRecentActivityViewAll');
  final specialistsViewAll = const Key('homeSpecialistsViewAll');
  final premiumTreatmentsViewAll = const Key('homePremiumTreatmentsViewAll');
  final bookAppointmentAction = const Key('homeBookAppointmentAction');
  final aiAssistantAction = const Key('homeAiAssistantAction');

  Key sectionCard(String section, String id) =>
      ValueKey('homeSectionCard-$section-$id');
}

// --- Clinic / Employee / Booking ---

class ClinicPageKeys {
  Key tab(String tab) => ValueKey('clinicTab-$tab');
  final followButton = const Key('clinicFollowButton');
  final searchField = const Key('clinicProductSearchField');
  final sortButton = const Key('clinicProductSortButton');
  final specialistsSection = const Key('clinicSpecialistsSection');

  Key sortOption(String label) => ValueKey('clinicProductSort-$label');
}

class EmployeePageKeys {
  final bookButton = const Key('employeeBookButton');
  final certificatesSection = const Key('employeeCertificatesSection');
  final reviewsSection = const Key('employeeReviewsSection');

  Key serviceBookButton(String serviceId) =>
      ValueKey('employeeBookButton-$serviceId');
}

class BookingPageKeys {
  final continueButton = const Key('bookingContinueButton');
  final addToCartButton = const Key('bookingAddToCartButton');
  final summaryConfirmButton = const Key('bookingSummaryConfirmButton');

  Key categoryTile(String categoryId) =>
      ValueKey('bookingCategoryTile-$categoryId');

  Key serviceTile(String serviceId) =>
      ValueKey('bookingServiceTile-$serviceId');

  Key specialistTile(String employeeId) =>
      ValueKey('bookingSpecialistTile-$employeeId');

  Key timeSlot(String label) => ValueKey('bookingTimeSlot-$label');
}

class ReviewPageKeys {
  final submitButton = const Key('reviewSubmitButton');
  final treatmentRating = const Key('reviewTreatmentRating');
  final specialistRating = const Key('reviewSpecialistRating');
  final facilityRating = const Key('reviewFacilityRating');

  Key star(int value) => ValueKey('reviewStar-$value');
}

// --- AI Health Assistant Chat ---

class ChatScreenKeys {
  final messageInput = const Key('chatMessageInput');
  final sendButton = const Key('chatSendButton');
  final newChatButton = const Key('chatNewButton');
}

// --- Checkout ---

class CheckoutPageKeys {
  final confirmButton = const Key('checkoutConfirmButton');

  Key paymentMethodTile(String method) =>
      ValueKey('checkoutPaymentMethod-$method');
}

// --- Cart ---

class CartPageKeys {
  final searchField = const Key('cartSearchField');
  final checkoutButton = const Key('cartCheckoutButton');
  final voucherApplyButton = const Key('cartVoucherApplyButton');

  Key itemSelection(String itemId) => ValueKey('cartItemSelection-$itemId');

  Key itemSelectionByService(String serviceName) =>
      ValueKey('cartItemSelectionService-$serviceName');

  Key voucherSelector(String itemId) => ValueKey('cartVoucherSelector-$itemId');

  Key voucherSelectorByService(String serviceName) =>
      ValueKey('cartVoucherSelectorService-$serviceName');

  Key voucherTile(String code) => ValueKey('cartVoucherTile-$code');
}

// --- Profile ---

class ProfilePageKeys {
  final editButton = const Key('profileEditButton');
  final saveButton = const Key('profileSaveButton');
  final displayNameField = const Key('profileDisplayNameField');
  final logoutButton = const Key('profileLogoutButton');
}

// --- Logout Confirmation Dialog ---

class LogoutDialogKeys {
  final confirmButton = const Key('logoutDialogConfirmButton');
  final cancelButton = const Key('logoutDialogCancelButton');
}

// --- Notifications ---

class NotificationsPageKeys {
  final notificationsList = const Key('notificationsList');
  final markAllReadButton = const Key('notificationsMarkAllReadButton');

  Key card(String id) => ValueKey('notificationCard-$id');
}

// --- Bottom Navigation ---

class BottomNavKeys {
  final homeTab = const Key('bottomNavHome');
  final ordersTab = const Key('bottomNavOrders');
  final chatTab = const Key('bottomNavChat');
  final notificationsTab = const Key('bottomNavNotifications');
  final profileTab = const Key('bottomNavProfile');
}

// --- Root Accessor ---

class Keys {
  final onboardPage = OnboardPageKeys();
  final signInPage = SignInPageKeys();
  final forgotPasswordPage = ForgotPasswordPageKeys();
  final passwordResetCodePage = PasswordResetCodePageKeys();
  final resetPasswordPage = ResetPasswordPageKeys();
  final emailFormPage = EmailFormPageKeys();
  final codeConfirmationPage = CodeConfirmationPageKeys();
  final homePage = HomePageKeys();
  final clinicPage = ClinicPageKeys();
  final employeePage = EmployeePageKeys();
  final bookingPage = BookingPageKeys();
  final reviewPage = ReviewPageKeys();
  final chatScreen = ChatScreenKeys();
  final checkoutPage = CheckoutPageKeys();
  final cartPage = CartPageKeys();
  final profilePage = ProfilePageKeys();
  final logoutDialog = LogoutDialogKeys();
  final notificationsPage = NotificationsPageKeys();
  final bottomNav = BottomNavKeys();
}

/// Global key accessor — import this in both widgets
/// and tests.
final keys = Keys();
