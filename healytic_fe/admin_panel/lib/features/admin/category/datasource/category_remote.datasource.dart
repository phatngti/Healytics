import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/admin/category/domain/category.entity.dart';
import 'package:admin_panel/features/admin/category/domain/create_category.request.dart';
import 'package:admin_panel/features/admin/category/datasource/data/category_mock_data.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_remote.datasource.g.dart';

// ============================================================================
// 1. ABSTRACT INTERFACE
// ============================================================================

/// Abstract interface for category data operations
abstract class CategoryRemoteDataSource {
  Future<List<CategoryEntity>> getCategories({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  });

  Future<int> getTotalRows();

  Future<CategoryEntity> getCategoryById(CategoryId id);

  Future<CategoryEntity> createCategory(CreateCategoryRequest request);

  Future<void> updateCategory({
    required CategoryId id,
    String? name,
    String? description,
    String? iconName,
    int? colorValue,
    bool? isVisible,
    int? sortOrder,
  });

  Future<void> deleteCategory(CategoryId id);

  Future<List<CategoryEntity>> getVisibleCategories();
}

// ============================================================================
// 2. IMPLEMENTATION (Real API)
// ============================================================================

/// Real implementation using API service
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiService apiService;

  CategoryRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<CategoryEntity>> getCategories({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    // TODO: Implement real API call when endpoint is available
    // final response = await apiService.categoriesApi.findAll();
    debugPrint(
      'CategoryRemoteDataSourceImpl.getCategories called - API not implemented yet',
    );
    return [];
  }

  @override
  Future<int> getTotalRows() async {
    // TODO: Implement real API call
    debugPrint(
      'CategoryRemoteDataSourceImpl.getTotalRows called - API not implemented yet',
    );
    return 0;
  }

  @override
  Future<CategoryEntity> getCategoryById(CategoryId id) async {
    // TODO: Implement real API call
    throw UnimplementedError('Category API not implemented yet');
  }

  @override
  Future<CategoryEntity> createCategory(CreateCategoryRequest request) async {
    // TODO: Implement real API call
    throw UnimplementedError('Category API not implemented yet');
  }

  @override
  Future<void> updateCategory({
    required CategoryId id,
    String? name,
    String? description,
    String? iconName,
    int? colorValue,
    bool? isVisible,
    int? sortOrder,
  }) async {
    // TODO: Implement real API call
    throw UnimplementedError('Category API not implemented yet');
  }

  @override
  Future<void> deleteCategory(CategoryId id) async {
    // TODO: Implement real API call
    throw UnimplementedError('Category API not implemented yet');
  }

  @override
  Future<List<CategoryEntity>> getVisibleCategories() async {
    final all = await getCategories(startingAt: 0, count: 1000);
    return all.where((c) => c.isVisible).toList();
  }
}

// ============================================================================
// 3. MOCK IMPLEMENTATION
// ============================================================================

/// Mock implementation with rich static data for UI testing
class CategoryRemoteDataSourceMock implements CategoryRemoteDataSource {
  // Mock data matching the existing UI
  final List<CategoryEntity> _mockCategories = categoryMockData;

  @override
  Future<List<CategoryEntity>> getCategories({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final endIndex = (startingAt + count).clamp(0, _mockCategories.length);
    return _mockCategories.sublist(
      startingAt.clamp(0, _mockCategories.length),
      endIndex,
    );
  }

  @override
  Future<int> getTotalRows() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockCategories.length;
  }

  @override
  Future<CategoryEntity> getCategoryById(CategoryId id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCategories.firstWhere(
      (c) => c.id == id,
      orElse: () => throw Exception('Category not found: $id'),
    );
  }

  @override
  Future<CategoryEntity> createCategory(CreateCategoryRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    final newCategory = CategoryEntity(
      id: CategoryId('new-${DateTime.now().millisecondsSinceEpoch}'),
      name: request.name,
      description: request.description,
      iconName: request.iconName,
      colorValue: request.colorValue,
      serviceCount: 0,
      isVisible: request.isVisible,
      sortOrder: request.sortOrder,
      createdAt: DateTime.now().toIso8601String(),
    );

    // In a real app, this would persist to the server
    // For mock, we could add to local list if needed
    return newCategory;
  }

  @override
  Future<void> updateCategory({
    required CategoryId id,
    String? name,
    String? description,
    String? iconName,
    int? colorValue,
    bool? isVisible,
    int? sortOrder,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock update - in real implementation, this would update the server
    debugPrint('Mock: Updated category $id');
  }

  @override
  Future<void> deleteCategory(CategoryId id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock delete - in real implementation, this would delete from server
    debugPrint('Mock: Deleted category $id');
  }

  @override
  Future<List<CategoryEntity>> getVisibleCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockCategories.where((c) => c.isVisible).toList();
  }
}

// ============================================================================
// 4. PROVIDER WITH MOCK SWITCHING
// ============================================================================

@riverpod
CategoryRemoteDataSource categoryRemoteDataSource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);

  if (isMock) {
    return CategoryRemoteDataSourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return CategoryRemoteDataSourceImpl(apiService: apiService);
}
