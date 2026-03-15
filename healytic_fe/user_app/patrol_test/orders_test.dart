import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/features/orders/presentation/screens/orders.screen.dart';
import 'package:user_app/features/orders/presentation/screens/order_details.screen.dart';

import 'common.dart';
import 'helpers/auth_helper.dart';
import 'helpers/navigation_helper.dart';

void main() {
  patrolTest(
    'orders tab renders appointment cards',
    ($) async {
      await pumpApp($);
      await signIn($);
      await navigateToTab($, TabKeys.orders);

      expect($(OrdersPage), findsOneWidget);
    },
  );

  patrolTest(
    'filtering orders by status tabs',
    ($) async {
      await pumpApp($);
      await signIn($);
      await navigateToTab($, TabKeys.orders);

      await $('Upcoming').tap();
      await $.pump(const Duration(seconds: 1));

      await $('Completed').tap();
      await $.pump(const Duration(seconds: 1));

      await $('Canceled').tap();
      await $.pump(const Duration(seconds: 1));
    },
  );

  patrolTest(
    'tapping an order navigates to details',
    ($) async {
      await pumpApp($);
      await signIn($);
      await navigateToTab($, TabKeys.orders);

      // "Swedish Relax" = first appointment in
      // appointment_mock_data.dart (apt-1)
      await $('Swedish Relax')
          .scrollTo()
          .tap();
      await $.pump(const Duration(seconds: 2));

      expect(
        $(OrderDetailsScreen),
        findsOneWidget,
      );
    },
  );

  patrolTest(
    'opening service manual from details',
    ($) async {
      await pumpApp($);
      await signIn($);
      await navigateToTab($, TabKeys.orders);

      await $('Swedish Relax')
          .scrollTo()
          .tap();
      await $.pump(const Duration(seconds: 2));

      await $('Service manual')
          .scrollTo()
          .tap();
      await $.pump(const Duration(seconds: 2));
    },
  );

  patrolTest(
    'service details shows booking bar',
    ($) async {
      await pumpApp($);
      await signIn($);
      await navigateToTab($, TabKeys.home);

      // "Deep Tissue Massage" = first service
      // product in home_mock_data.dart
      await $('Deep Tissue Massage')
          .scrollTo()
          .tap();
      await $.pump(const Duration(seconds: 2));

      // Verify the booking bar renders with
      // the "Confirm Booking" button visible.
      // (Full checkout navigation requires
      // specialist + time-slot selection.)
      expect(
        $('Confirm Booking'),
        findsOneWidget,
      );
    },
  );
}
