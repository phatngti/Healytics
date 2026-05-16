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
  patrolTest('cart screen renders seeded items from home header', ($) async {
    await pumpApp($, scenario: 'cartCheckout');
    final config = TestConfig.instance;

    if (!config.useMock) {
      await $.pump(const Duration(seconds: 1));
      return;
    }

    await _openCart($);

    expect($(CartScreen), findsOneWidget);
    expect($('Swedish Relax'), findsOneWidget);
    expect($('Herbal Hot Stone'), findsOneWidget);
  });

  patrolTest('searching cart filters visible items', ($) async {
    await pumpApp($, scenario: 'cartCheckout');
    final config = TestConfig.instance;

    if (!config.useMock) {
      await $.pump(const Duration(seconds: 1));
      return;
    }

    await _openCart($);

    await $(keys.cartPage.searchField).enterText('Swedish');
    await $.pump(const Duration(seconds: 1));

    expect($('Swedish Relax'), findsOneWidget);
    expect($('Herbal Hot Stone'), findsNothing);
  });

  patrolTest('selecting an item exposes voucher actions and applies coupon', (
    $,
  ) async {
    await pumpApp($, scenario: 'cartCheckout');
    final config = TestConfig.instance;

    if (!config.useMock) {
      await $.pump(const Duration(seconds: 1));
      return;
    }

    await _openCart($);

    await $(keys.cartPage.itemSelection('cart-001')).tap();
    await $.pump(const Duration(seconds: 1));

    expect($(keys.cartPage.voucherSelector('cart-001')), findsOneWidget);
    expect($(keys.cartPage.checkoutButton), findsOneWidget);

    await $(keys.cartPage.voucherSelector('cart-001')).tap();
    await $.pump(const Duration(seconds: 1));

    await $(keys.cartPage.voucherTile('RELAX10')).tap();
    await $(keys.cartPage.voucherApplyButton).tap();
    await $.pump(const Duration(seconds: 2));

    expect($('RELAX10'), findsOneWidget);
    expect($('Discount'), findsOneWidget);
  });
}
