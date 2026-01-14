import 'package:admin_panel/features/partner/products/domain/category.entity.dart';
import 'package:admin_panel/features/partner/employee/data/employee_impl.repository.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/products/data/product_impl.repository.dart';

import 'package:admin_panel/features/partner/products/domain/create_product.request.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/update_product.request.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product.provider.freezed.dart';
part 'product.provider.g.dart';

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

  Future<List<Product>> getProducts({
    required int startingAt,
    required int count,
    String? search,
    bool? sortAscending,
  }) async {
    final repo = ref.read(productRepositoryProvider);
    return repo.getProducts(startingAt, count, search, sortAscending);
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
  Future<List<EmployeeEntity>> getStaffForProduct({String? role}) async {
    final employeeRepo = ref.read(employeeRepositoryProvider);

    if (role != null) {
      return employeeRepo.getEmployeesByRole(role: role);
    }

    // Get all employees (using a reasonable count for selection)
    final totalRows = await employeeRepo.getTotalRows();
    final employees = await employeeRepo.getEmployeesList(
      startingAt: 0,
      count: totalRows,
    );
    return employees;
  }

  /// Get list of categories for product organization
  Future<List<CategoryEntity>> getCategoriesForProduct() async {
    final repo = ref.read(productRepositoryProvider);
    return repo.getCategories();
  }
}
