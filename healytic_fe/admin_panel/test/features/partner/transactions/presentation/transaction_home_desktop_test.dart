import 'package:admin_panel/features/partner/transactions/data/transactions_impl.repository.dart';
import 'package:admin_panel/features/partner/transactions/data/transactions_remote.datasource.dart';
import 'package:admin_panel/features/partner/transactions/presentation/layouts/transaction_home_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        transactionsRepositoryProvider.overrideWithValue(
          TransactionsImplRepository(
            remoteDataSource: TransactionsRemoteDataSourceMock(),
          ),
        ),
      ],
      child: const MaterialApp(home: Scaffold(body: TransactionHomeDesktop())),
    );
  }

  testWidgets('renders finance summary and switches workspace tabs', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Transaction Manager'), findsOneWidget);
    expect(find.text('Gross Volume'), findsOneWidget);
    expect(find.text('Transactions'), findsOneWidget);

    await tester.tap(find.text('Payouts'));
    await tester.pumpAndSettle();
    expect(find.text('Payout ID'), findsOneWidget);

    await tester.tap(find.text('Refunds & Disputes'));
    await tester.pumpAndSettle();
    expect(find.text('Case ID'), findsOneWidget);
  });

  testWidgets('search filters transaction rows', (tester) async {
    tester.view.physicalSize = const Size(1800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final searchField = find.byType(TextField).first;
    await tester.enterText(searchField, 'BK-240408-001');
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'BK-240408-001',
      ),
      findsOneWidget,
    );
    expect(find.text('OD-240408-013'), findsNothing);

    await tester.pump(const Duration(milliseconds: 600));
  });
}
