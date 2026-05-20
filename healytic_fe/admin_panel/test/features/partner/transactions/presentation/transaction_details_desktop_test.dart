import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';
import 'package:admin_panel/features/partner/transactions/presentation/layouts/transaction_details_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders amount breakdown and payout metadata', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: TransactionDetailsDesktop(
              transactionId: TransactionRecordId('txn_240401_001'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Amount Breakdown'), findsOneWidget);
    expect(find.text('Source Summary'), findsOneWidget);
    expect(find.text('Settlement & Payout'), findsOneWidget);
    expect(find.textContaining('Payout ID'), findsOneWidget);
    expect(find.text('Timeline & Notes'), findsOneWidget);
  });
}
