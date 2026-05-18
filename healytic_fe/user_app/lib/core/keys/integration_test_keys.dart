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
  final sendResetLinkButton = const Key('forgotPasswordSendResetLinkButton');
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

  Key voucherSelector(String itemId) => ValueKey('cartVoucherSelector-$itemId');

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
  final emailFormPage = EmailFormPageKeys();
  final codeConfirmationPage = CodeConfirmationPageKeys();
  final homePage = HomePageKeys();
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
