import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/features/home/presentation/screens/home_page.screen.dart';
import 'package:user_app/features/service_details/presentation/screens/reviews.screen.dart';
import 'package:user_app/features/service_details/presentation/screens/service_details.screen.dart';

import 'common.dart';
import 'helpers/auth_helper.dart';
import 'helpers/navigation_helper.dart';

void main() {
  patrolTest(
    'home screen renders after sign in',
    ($) async {
      await pumpApp($);
      await signIn($);
      await navigateToTab($, TabKeys.home);

      expect($(HomeUpdatePage), findsOneWidget);
    },
  );

  patrolTest(
    'tapping a service card navigates to '
    'service details',
    ($) async {
      await pumpApp($);
      await signIn($);
      await navigateToTab($, TabKeys.home);

      // "Deep Tissue Massage" = first product in
      // home_mock_data.dart (prod-1)
      await $('Deep Tissue Massage')
          .scrollTo()
          .tap();
      await $.pump(const Duration(seconds: 2));

      expect(
        $(ServiceDetailsScreen),
        findsOneWidget,
      );
    },
  );

  patrolTest(
    'navigating to reviews from '
    'service details',
    ($) async {
      await pumpApp($);
      await signIn($);
      await navigateToTab($, TabKeys.home);

      await $('Deep Tissue Massage')
          .scrollTo()
          .tap();
      await $.pump(const Duration(seconds: 2));

      // The "View More (N)" TextButton.icon in
      // _ViewMoreButton navigates to ReviewsScreen.
      final viewMore = $(find.textContaining('View More'));
      await viewMore.scrollTo().tap();
      await $.pump(const Duration(seconds: 2));

      expect(
        $(ReviewsScreen),
        findsOneWidget,
      );
    },
  );

  patrolTest(
    'tapping category chips filters results',
    ($) async {
      await pumpApp($);
      await signIn($);
      await navigateToTab($, TabKeys.home);

      // "Spa" = first category chip in
      // home_mock_data.dart (cat-1)
      await $('Spa').scrollTo().tap();
      await $.pump(const Duration(seconds: 2));

      // Spa category contains Deep Tissue Massage
      // and Hot Stone Therapy
      expect(
        $('Deep Tissue Massage'),
        findsWidgets,
      );
    },
  );
}
