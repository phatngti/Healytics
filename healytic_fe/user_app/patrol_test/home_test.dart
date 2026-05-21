import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/home/presentation/screens/home_page.screen.dart';
import 'package:user_app/features/home/presentation/screens/home_premium_treatments.screen.dart';
import 'package:user_app/features/home/presentation/screens/home_recent_activity.screen.dart';
import 'package:user_app/features/home/presentation/screens/home_recommendations.screen.dart';
import 'package:user_app/features/home/presentation/screens/home_specialists.screen.dart';
import 'package:user_app/features/service_details/presentation/screens/reviews.screen.dart';
import 'package:user_app/features/service_details/presentation/screens/service_details.screen.dart';
import 'package:user_app/router/routes.dart';

import 'common.dart';
import 'helpers/auth_helper.dart';
import 'helpers/navigation_helper.dart';

void main() {
  patrolTest('home discovery and view-all routes work', ($) async {
    await pumpApp($, scenario: 'home');
    await signIn($);
    await navigateToTab($, TabKeys.home);

    expect($(HomeUpdatePage), findsOneWidget);

    await $('Spa').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));
    expect($('Deep Tissue Massage'), findsWidgets);

    await $('Deep Tissue Massage').scrollTo().tap();
    await $.pump(const Duration(seconds: 2));
    expect($(ServiceDetailsScreen), findsOneWidget);

    final detailsElement = $(ServiceDetailsScreen).evaluate().single;
    final detailsWidget = detailsElement.widget as ServiceDetailsScreen;
    ReviewsRoute(serviceId: detailsWidget.serviceId).push(detailsElement);
    await $.pump(const Duration(seconds: 2));
    expect($(ReviewsScreen), findsOneWidget);

    await pumpApp($, scenario: 'home');
    await signIn($);
    await navigateToTab($, TabKeys.home);

    await $(keys.homePage.recommendationsViewAll).scrollTo().tap();
    await $.pump(const Duration(seconds: 1));
    expect($(HomeRecommendationsScreen), findsOneWidget);
    await $(find.byTooltip('Back')).tap();
    await $.pump(const Duration(seconds: 1));

    await $(keys.homePage.recentActivityViewAll).scrollTo().tap();
    await $.pump(const Duration(seconds: 1));
    expect($(HomeRecentActivityScreen), findsOneWidget);
    await $(find.byTooltip('Back')).tap();
    await $.pump(const Duration(seconds: 1));

    await $(keys.homePage.specialistsViewAll).scrollTo().tap();
    await $.pump(const Duration(seconds: 1));
    expect($(HomeSpecialistsScreen), findsOneWidget);
    await $(find.byTooltip('Back')).tap();
    await $.pump(const Duration(seconds: 1));

    await $(keys.homePage.premiumTreatmentsViewAll).scrollTo().tap();
    await $.pump(const Duration(seconds: 1));
    expect($(HomePremiumTreatmentsScreen), findsOneWidget);
  });
}
