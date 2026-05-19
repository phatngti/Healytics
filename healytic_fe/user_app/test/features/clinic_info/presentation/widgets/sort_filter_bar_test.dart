import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/clinic_info/presentation/providers/clinic_products.provider.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_products/sort_filter_bar.widget.dart';

void main() {
  testWidgets('filter button opens sheet and applies filters', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: SortFilterBar())),
      ),
    );

    await tester.tap(find.text('Filter'));
    await tester.pumpAndSettle();

    expect(find.text('Filter services'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), '100000');
    await tester.enterText(find.byType(TextField).at(3), '90');
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Apply'));
    await tester.pumpAndSettle();

    final filters = container.read(clinicProductFilterProvider);
    expect(filters.minPrice, 100000);
    expect(filters.maxDuration, 90);
    expect(filters.discountOnly, isTrue);
  });
}
