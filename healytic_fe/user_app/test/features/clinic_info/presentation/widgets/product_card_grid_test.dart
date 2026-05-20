import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_products/product_card.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_products/product_grid.widget.dart';

void main() {
  testWidgets('product grid keeps two columns on wide layouts', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 600,
            height: 500,
            child: ProductGrid(products: _products(3)),
          ),
        ),
      ),
    );

    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

    expect(delegate.crossAxisCount, 2);
  });

  testWidgets('product card fits dense discounted content', (tester) async {
    const width = 168.0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: width,
              height: width + ProductCard.contentHeight,
              child: ProductCard(
                product: _product(
                  1,
                  title: 'Nutrition consultation and body composition review',
                  discountLabel: '-7%',
                  originalPrice: '700.000d',
                  durationLabel: '60 min',
                  specialistLabel: 'Specialist',
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      find.text('NUTRITION CONSULTATION AND BODY COMPOSITION REVIEW'),
      findsOneWidget,
    );
    expect(find.text('650.000d'), findsOneWidget);
  });
}

List<ClinicProductEntity> _products(int count) {
  return List.generate(count, (index) => _product(index + 1));
}

ClinicProductEntity _product(
  int index, {
  String title = 'Nutrition consultation',
  String? discountLabel,
  String? originalPrice,
  String? durationLabel,
  String? specialistLabel,
}) {
  return ClinicProductEntity(
    id: 'service-$index',
    title: title,
    price: '650.000d',
    priceAmount: 650000,
    originalPrice: originalPrice,
    discountLabel: discountLabel,
    durationLabel: durationLabel,
    specialistLabel: specialistLabel,
    categoryId: 'all',
  );
}
