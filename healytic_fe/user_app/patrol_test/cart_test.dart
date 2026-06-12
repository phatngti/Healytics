import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/cart/presentation/screens/cart.screen.dart';

import 'common.dart';
import 'config/test_config.dart';
import 'helpers/auth_helper.dart';
import 'helpers/navigation_helper.dart';

Future<void> _openCart(PatrolIntegrationTester $) async {
  await signIn($);
  await navigateToTab($, TabKeys.home);

  await $(keys.homePage.cartButton).waitUntilVisible();
  await $(keys.homePage.cartButton).tap();
  await $.pump(const Duration(seconds: 2));
}

void main() {
  patrolTest('cart screen renders seeded items and applies coupon', ($) async {
    await pumpApp($, scenario: 'cartCheckout');
    await _openCart($);

    expect($(CartScreen), findsOneWidget);
    expect($('Swedish Relax'), findsOneWidget);
    expect($('Herbal Hot Stone'), findsOneWidget);

    await $(keys.cartPage.searchField).enterText('Swedish');
    await $.pump(const Duration(seconds: 1));

    expect($('Swedish Relax'), findsOneWidget);
    expect($('Herbal Hot Stone'), findsNothing);

    await $(keys.cartPage.itemSelectionByService('Swedish Relax')).tap();
    await $.pump(const Duration(seconds: 1));

    expect(
      $(keys.cartPage.voucherSelectorByService('Swedish Relax')),
      findsOneWidget,
    );
    expect($(keys.cartPage.checkoutButton), findsOneWidget);

    await $(keys.cartPage.voucherSelectorByService('Swedish Relax')).tap();
    await $.pump(const Duration(seconds: 1));

    if (!TestConfig.instance.useMock) {
      expect($('No vouchers available'), findsOneWidget);
      return;
    }

    await $(keys.cartPage.voucherTile('RELAX10')).tap();
    await $(keys.cartPage.voucherApplyButton).tap();
    await $.pump(const Duration(seconds: 2));

    expect($('RELAX10'), findsOneWidget);
    expect($('Discount'), findsOneWidget);
  });
}
