import 'package:flutter/foundation.dart';

/// Centralized test keys for integration tests.

class SignInPageKeys {
  final emailTextField = const Key('signInEmailTextField');
  final passwordTextField = const Key('signInPasswordTextField');
  final signInButton = const Key('signInButton');
  final forgotPasswordButton = const Key('forgotPasswordButton');
}

class AppointmentsPageKeys {
  final upcomingTab = const Key('appointmentsUpcomingTab');
  final completedTab = const Key('appointmentsCompletedTab');
  final canceledTab = const Key('appointmentsCanceledTab');
  final appointmentsList = const Key('appointmentsList');
}

class AppointmentDetailKeys {
  final startServiceButton = const Key('startServiceButton');
  final completeServiceButton = const Key('completeServiceButton');
  final cancelButton = const Key('cancelAppointmentButton');
}

class RevenuePageKeys {
  final dayChip = const Key('revenueDayChip');
  final monthChip = const Key('revenueMonthChip');
  final yearChip = const Key('revenueYearChip');
  final previousButton = const Key('revenuePreviousButton');
  final nextButton = const Key('revenueNextButton');
}

class ProfilePageKeys {
  final logoutButton = const Key('profileLogoutButton');
}

class BottomNavKeys {
  final appointmentsTab = const Key('bottomNavAppointments');
  final revenueTab = const Key('bottomNavRevenue');
  final profileTab = const Key('bottomNavProfile');
}

class Keys {
  final signInPage = SignInPageKeys();
  final appointmentsPage = AppointmentsPageKeys();
  final appointmentDetail = AppointmentDetailKeys();
  final revenuePage = RevenuePageKeys();
  final profilePage = ProfilePageKeys();
  final bottomNav = BottomNavKeys();
}

/// Global key accessor.
final keys = Keys();
