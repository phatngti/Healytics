import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/orders/presentation/screens/order_details.screen.dart';
import 'package:user_app/features/orders/presentation/screens/orders.screen.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/calendar/appointment_calendar.widget.dart';
import 'package:user_app/features/partner_chat/presentation/screens/partner_chat.screen.dart';
import 'package:user_app/features/review/presentation/screens/review_facility.screen.dart';
import 'package:user_app/features/review/presentation/screens/review_specialist.screen.dart';
import 'package:user_app/features/review/presentation/screens/review_submitted.screen.dart';
import 'package:user_app/features/review/presentation/screens/review_treatment.screen.dart';

import 'common.dart';
import 'helpers/auth_helper.dart';
import 'helpers/navigation_helper.dart';

Future<void> _openOrders(PatrolIntegrationTester $) async {
  await pumpApp($, scenario: 'orders');
  await signIn($);
  await navigateToTab($, TabKeys.orders);
  expect($(OrdersPage), findsOneWidget);
}

Future<void> _returnToOrdersFromPartnerChat(PatrolIntegrationTester $) async {
  await $(find.byIcon(Icons.arrow_back_ios_new_rounded)).tap();
  await $.pump(const Duration(seconds: 1));
  await $(find.byTooltip('Back')).tap();
  await $.pump(const Duration(seconds: 2));
  expect($(OrdersPage), findsOneWidget);
}

void main() {
  patrolTest('orders status, details, chat, and review flows work', ($) async {
    await _openOrders($);

    await $('Pending').tap();
    await $.pump(const Duration(seconds: 2));
    expect($('Pending Payment'), findsWidgets);
    expect($('Complete Payment'), findsWidgets);
    expect($('Hot Stone Therapy'), findsWidgets);

    await $('Upcoming').tap();
    await $.pump(const Duration(seconds: 1));
    await $('Completed').tap();
    await $.pump(const Duration(seconds: 1));
    await $('Canceled').tap();
    await $.pump(const Duration(seconds: 1));

    await $(find.byTooltip('Change layout')).tap();
    await $.pump(const Duration(seconds: 1));
    await $('Calendar').tap();
    await $.pump(const Duration(seconds: 2));
    expect($(AppointmentCalendar), findsOneWidget);

    await _openOrders($);
    await $('Swedish Relax').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));
    expect($(OrderDetailsScreen), findsOneWidget);

    await $('Message your services').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));
    expect($(PartnerChatScreen), findsOneWidget);

    await _returnToOrdersFromPartnerChat($);
    await $('Completed').tap();
    await $.pump(const Duration(seconds: 2));
    await $('Posture Correction').scrollTo();
    await $('Write a Review').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));
    expect($(ReviewTreatmentScreen), findsOneWidget);

    await $(keys.reviewPage.star(5)).tap();
    await $(keys.reviewPage.submitButton).tap();
    await $.pump(const Duration(seconds: 2));
    expect($(ReviewSpecialistScreen), findsOneWidget);

    await $(keys.reviewPage.star(5)).tap();
    await $(keys.reviewPage.submitButton).tap();
    await $.pump(const Duration(seconds: 2));
    expect($(ReviewFacilityScreen), findsOneWidget);

    await $(keys.reviewPage.star(5)).tap();
    await $(keys.reviewPage.submitButton).tap();
    await $.pump(const Duration(seconds: 2));
    await $(ReviewSubmittedScreen).waitUntilVisible(
      timeout: const Duration(seconds: 10),
    );
    expect($(ReviewSubmittedScreen), findsOneWidget);
  });
}
