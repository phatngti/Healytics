import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';
import 'package:admin_panel/features/partner/transactions/presentation/widgets/finance_trend_panel.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses compact spaced labels for dense finance trend data', (
    tester,
  ) async {
    final points = List.generate(30, (index) {
      final date = DateTime(2026, 3, 31).add(Duration(days: index));
      return FinanceTrendPoint(
        date: date,
        grossAmount: index % 5 == 0 ? 450000 : 0,
        netAmount: index % 5 == 0 ? 410000 : 0,
        refundAmount: index % 5 == 0 ? 35000 : 0,
      );
    });

    await tester.binding.setSurfaceSize(const Size(1200, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FinanceTrendPanel(
            data: points,
            selectedPeriod: FinancePeriod.thirtyDays,
            selectedMetric: FinanceMetric.gross,
            onPeriodChanged: (_) {},
            onMetricChanged: (_) {},
            currency: 'VND',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('31 Mar'), findsOneWidget);
    expect(find.text('05 Apr'), findsOneWidget);
    expect(find.text('29 Apr'), findsOneWidget);
    expect(find.text('01 Apr'), findsNothing);
    expect(find.textContaining('VND'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
