import 'package:admin_panel/router/app_router.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('finance menu item points to provider transaction home route', () {
    final financeItem = providerSlideMenuItems.firstWhere(
      (item) => item['label'] == 'Finance',
    );

    expect(financeItem['route'], TransactionHomeRoute().location);
    expect(TransactionHomeRoute().location, '/provider/transactions');
  });
}
