import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_products/product_filter_sheet.widget.dart';

void main() {
  testWidgets('product filter sheet applies entered values', (tester) async {
    ClinicProductFilters? applied;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductFilterSheet(
            initialFilters: const ClinicProductFilters(),
            onApply: (filters) => applied = filters,
            onReset: () {},
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), '100000');
    await tester.enterText(find.byType(TextField).at(1), '500000');
    await tester.enterText(find.byType(TextField).at(2), '30');
    await tester.enterText(find.byType(TextField).at(3), '90');
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Apply'));

    expect(applied?.minPrice, 100000);
    expect(applied?.maxPrice, 500000);
    expect(applied?.minDuration, 30);
    expect(applied?.maxDuration, 90);
    expect(applied?.discountOnly, isTrue);
  });
}
