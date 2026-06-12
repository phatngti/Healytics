import 'package:admin_openapi/api.dart';
import 'package:admin_panel/features/partner/products/domain/category.entity.dart';
import 'package:admin_panel/features/partner/products/domain/create_product.request.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/product.repository.dart';
import 'package:admin_panel/features/partner/products/domain/update_product.request.dart';
import 'package:admin_panel/features/partner/products/data/product_impl.repository.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_organization_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('subcategory dropdown tolerates duplicated category ids', (
    tester,
  ) async {
    final repository = _ProductOrganizationRepository([
      const CategoryEntity(
        id: 'root-1',
        name: 'Root',
        slug: 'root',
        isRoot: true,
      ),
      const CategoryEntity(
        id: 'child-1',
        name: 'Child',
        slug: 'child',
        parentId: 'root-1',
        parentName: 'Root',
        isRoot: false,
      ),
      const CategoryEntity(
        id: 'child-1',
        name: 'Child duplicate',
        slug: 'child-duplicate',
        parentId: 'root-1',
        parentName: 'Root',
        isRoot: false,
      ),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [productRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: ProductOrganizationCard(initialCategory: 'child-1'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Child'), findsOneWidget);
  });
}

class _ProductOrganizationRepository implements ProductRepository {
  _ProductOrganizationRepository(this.categories);

  final List<CategoryEntity> categories;

  @override
  Future<Product> createProduct(CreateProductRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProduct(ProductId id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getAllProducts({String? sortedBy, bool? sortedAsc}) {
    throw UnimplementedError();
  }

  @override
  Future<List<CategoryEntity>> getCategories() async => categories;

  @override
  Future<Product> getProductById(ProductId id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProducts(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<List<ServiceTagResponseDto>> getServiceTags() async =>
      const <ServiceTagResponseDto>[];

  @override
  Future<int> getTotalRows() {
    throw UnimplementedError();
  }

  @override
  Future<void> updateProduct(UpdateProductRequest request) {
    throw UnimplementedError();
  }
}
