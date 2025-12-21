import 'package:admin_panel/features/common/widgets/table/helper.dart';
import 'package:admin_panel/features/partner/employee/datasource/employee_implement.repository.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/products/datasource/product_implement.repository.dart';
import 'package:admin_panel/features/partner/products/domain/create_product.request.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/update_product.request.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product.provider.freezed.dart';
part 'product.provider.g.dart';

/// Model for category items used in product organization
class CategoryItem {
  final String id;
  final String name;

  const CategoryItem({required this.id, required this.name});
}

@freezed
abstract class ProductState with _$ProductState {
  const factory ProductState() = _ProductState;
}

@riverpod
class ProductNotifier extends _$ProductNotifier {
  @override
  FutureOr<ProductState> build() async {
    return ProductState();
  }

  Future<int> getTotalRows() async {
    final repo = ref.read(productRepositoryProvider);
    return repo.getTotalRows();
  }

  Future<List<DataRow>> getProducts({
    required SetRowSelectionCallback setRowSelection,
    required int startingAt,
    required int count,
    String? search,
    bool? sortAscending,
  }) async {
    final repo = ref.read(productRepositoryProvider);
    return repo.getProducts(
      setRowSelection,
      startingAt,
      count,
      search,
      sortAscending,
    );
  }

  Future<void> deleteProduct(ProductId id) async {
    final repo = ref.read(productRepositoryProvider);
    await repo.deleteProduct(id);
  }

  Future<void> updateProduct(UpdateProductRequest request) async {
    final repo = ref.read(productRepositoryProvider);
    await repo.updateProduct(request);
  }

  /// Add a new product
  Future<Product> addProduct(CreateProductRequest request) async {
    final repo = ref.read(productRepositoryProvider);
    return repo.createProduct(request);
  }

  Future<Product> getProductById(ProductId id) async {
    final repo = ref.read(productRepositoryProvider);
    return repo.getProductById(id);
  }

  /// Get list of staff/employees available for product assignment
  Future<List<EmployeeEntity>> getStaffForProduct() async {
    final employeeRepo = ref.read(employeeRepositoryProvider);
    // Get all employees (using a reasonable count for selection)
    final totalRows = await employeeRepo.getTotalRows();
    final employees = await employeeRepo.getEmployeesList(
      startingAt: 0,
      count: totalRows,
    );
    return employees;
  }

  /// Get list of categories for product organization
  Future<List<CategoryItem>> getCategoriesForProduct() async {
    // TODO: Replace with actual API call when available
    return Future.delayed(
      const Duration(milliseconds: 300),
      () => const [
        CategoryItem(id: 'skincare', name: 'Skincare'),
        CategoryItem(id: 'massage', name: 'Massage'),
        CategoryItem(id: 'facial_therapy', name: 'Facial Therapy'),
        CategoryItem(id: 'hair_care', name: 'Hair Care'),
        CategoryItem(id: 'supplements', name: 'Supplements'),
        CategoryItem(id: 'body_treatment', name: 'Body Treatment'),
        CategoryItem(id: 'wellness', name: 'Wellness'),
      ],
    );
  }
}
