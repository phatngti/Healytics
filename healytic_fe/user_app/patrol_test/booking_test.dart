import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/booking/presentation/screens/book_appointment.screen.dart';
import 'package:user_app/features/booking/presentation/screens/select_specialist.screen.dart';

import 'common.dart';
import 'helpers/auth_helper.dart';
import 'helpers/navigation_helper.dart';

void main() {
  patrolTest('quick action opens booking and selects category service', (
    $,
  ) async {
    await pumpApp($, scenario: 'core');
    await signIn($);
    await navigateToTab($, TabKeys.home);

    await $(keys.homePage.bookAppointmentAction).scrollTo().tap();
    await $.pump(const Duration(seconds: 2));

    expect($(BookAppointmentScreen), findsOneWidget);

    await $('Spa').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));

    await $('Deep Tissue Massage').scrollTo().tap();
    await $.pump(const Duration(seconds: 1));

    await $(keys.bookingPage.continueButton).tap();
    await $.pump(const Duration(seconds: 2));

    expect($(SelectSpecialistScreen), findsOneWidget);
  });
}
