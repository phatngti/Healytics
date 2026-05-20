import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/features/partner_chat/presentation/screens/partner_chat.screen.dart';
import 'package:user_app/features/orders/presentation/widgets/orders/calendar/appointment_calendar.widget.dart';
import 'package:user_app/features/orders/presentation/screens/orders.screen.dart';
import 'package:user_app/features/orders/presentation/screens/order_details.screen.dart';
import 'package:user_app/features/review/presentation/screens/review_treatment.screen.dart';

import 'common.dart';
import 'config/test_config.dart';
import 'helpers/auth_helper.dart';
import 'helpers/navigation_helper.dart';

void main() {
  patrolTest('orders tab renders appointment cards', ($) async {
    await pumpApp($, scenario: 'orders');
    await signIn($);
    await navigateToTab($, TabKeys.orders);

    expect($(OrdersPage), findsOneWidget);
  });

  patrolTest('filtering orders by status tabs', ($) async {
    await pumpApp($, scenario: 'orders');
    await signIn($);
    await navigateToTab($, TabKeys.orders);

    await $('Pending').tap();
    await $.pump(const Duration(seconds: 1));

    await $('Upcoming').tap();
    await $.pump(const Duration(seconds: 1));

    await $('Completed').tap();
    await $.pump(const Duration(seconds: 1));

    await $('Canceled').tap();
    await $.pump(const Duration(seconds: 1));
  });

  patrolTest('pending orders show payment recovery action', ($) async {
    await pumpApp($, scenario: 'orders');
    final config = TestConfig.instance;

    if (!config.useMock) {
      await $.pump(const Duration(seconds: 1));
      return;
    }

    await signIn($);
    await navigateToTab($, TabKeys.orders);

    await $('Pending').tap();
    await $.pump(const Duration(seconds: 2));

    expect($('Pending Payment'), findsWidgets);
    expect($('Complete Payment'), findsWidgets);
    expect($('Hot Stone Therapy'), findsOneWidget);
  });

  patrolTest('orders can switch to calendar layout', ($) async {
    await pumpApp($, scenario: 'orders');
    await signIn($);
    await navigateToTab($, TabKeys.orders);

    await $(find.byTooltip('Change layout')).tap();
    await $.pumpAndSettle();

    await $('Calendar').tap();
    await $.pump(const Duration(seconds: 2));

    expect($(AppointmentCalendar), findsOneWidget);
  });

  patrolTest('tapping an order navigates to details', ($) async {
    await pumpApp($, scenario: 'orders');
    await signIn($);
    await navigateToTab($, TabKeys.orders);

    // "Swedish Relax" = first appointment in
    // appointment_mock_data.dart (apt-1)
    await $('Swedish Relax').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));

    expect($(OrderDetailsScreen), findsOneWidget);
  });

  patrolTest('opening service manual from details', ($) async {
    await pumpApp($, scenario: 'orders');
    await signIn($);
    await navigateToTab($, TabKeys.orders);

    await $('Swedish Relax').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));

    await $('Service manual').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));
  });

  patrolTest('opening partner chat from order details', ($) async {
    await pumpApp($, scenario: 'orders');
    await signIn($);
    await navigateToTab($, TabKeys.orders);

    await $('Swedish Relax').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));

    await $('Message your services').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));

    expect($(PartnerChatScreen), findsOneWidget);
  });

  patrolTest('completed order can open treatment review', ($) async {
    await pumpApp($, scenario: 'orders');
    final config = TestConfig.instance;

    if (!config.useMock) {
      await $.pump(const Duration(seconds: 1));
      return;
    }

    await signIn($);
    await navigateToTab($, TabKeys.orders);

    await $('Completed').tap();
    await $.pump(const Duration(seconds: 2));

    await $('Posture Correction').scrollTo();
    await $('Write a Review').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));

    expect($(ReviewTreatmentScreen), findsOneWidget);
  });

  patrolTest('service details shows booking bar', ($) async {
    await pumpApp($, scenario: 'orders');
    await signIn($);
    await navigateToTab($, TabKeys.home);

    // "Deep Tissue Massage" = first service
    // product in home_mock_data.dart
    await $('Deep Tissue Massage').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));

    // Verify the booking bar renders with
    // the "Confirm Booking" button visible.
    // (Full checkout navigation requires
    // specialist + time-slot selection.)
    expect($('Confirm Booking'), findsOneWidget);
  });
}
