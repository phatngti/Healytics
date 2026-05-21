import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/checkout/presentation/screens/checkout.screen.dart';

import 'common.dart';
import 'helpers/auth_helper.dart';
import 'helpers/navigation_helper.dart';

Future<void> _openCheckout(PatrolIntegrationTester $) async {
  await signIn($);
  await navigateToTab($, TabKeys.home);

  await $(keys.homePage.cartButton).waitUntilVisible();
  await $(keys.homePage.cartButton).tap();
  await $.pump(const Duration(seconds: 2));

  await $(keys.cartPage.itemSelectionByService('Swedish Relax')).tap();
  await $.pump(const Duration(seconds: 1));

  await $(keys.cartPage.checkoutButton).waitUntilVisible();
  await $(keys.cartPage.checkoutButton).tap();
  await $.pump(const Duration(seconds: 2));
}

void main() {
  patrolTest('checkout renders selected cart item and confirms pay later', (
    $,
  ) async {
    await pumpApp($, scenario: 'cartCheckout');
    await _openCheckout($);

    expect($(CheckoutScreen), findsOneWidget);
    expect($('Swedish Relax'), findsOneWidget);
    expect($('Spa An Nhien'), findsOneWidget);
    expect($('Dr. Nguyen Van A'), findsOneWidget);
    expect($('500,000đ'), findsWidgets);

    await $(keys.checkoutPage.paymentMethodTile('payLater')).tap();
    await $.pump(const Duration(seconds: 1));

    await $(keys.checkoutPage.confirmButton).tap();
    await $.pump(const Duration(seconds: 5));

    expect($('Booking Confirmed!'), findsOneWidget);
    expect(
      $('Your booking has been confirmed. Payment is due at the clinic.'),
      findsOneWidget,
    );
  });
}
