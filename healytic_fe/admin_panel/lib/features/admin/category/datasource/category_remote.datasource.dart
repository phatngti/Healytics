import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/admin/category/domain/category.entity.dart';
import 'package:admin_panel/features/admin/category/domain/create_category.request.dart';
import 'package:admin_panel/features/admin/category/datasource/data/category_mock_data.dart';
import 'package:admin_openapi/api.dart';
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

  AdminCategoriesApi get _api => apiService.adminCategoriesApi;

  @override
  Future<List<CategoryEntity>> getCategories({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    final dtos = await _api.adminCategoriesControllerFindAll();
    if (dtos == null) return [];

    final all = dtos.map(_mapDtoToEntity).toList();

    final end = (startingAt + count).clamp(0, all.length);
    return all.sublist(startingAt.clamp(0, all.length), end);
  }

  @override
  Future<int> getTotalRows() async {
    final dtos = await _api.adminCategoriesControllerFindAll();
    return dtos?.length ?? 0;
  }

  @override
  Future<CategoryEntity> getCategoryById(CategoryId id) async {
    final dto = await _api.adminCategoriesControllerFindOne(id);
    if (dto == null) {
      throw Exception('Category not found: $id');
    }
    return _mapDtoToEntity(dto);
  }

  @override
  Future<CategoryEntity> createCategory(CreateCategoryRequest request) async {
    final dto = await _api.adminCategoriesControllerCreate(
      CreateCategoryDto(
        name: request.name,
        slug: _slugify(request.name),
        description: request.description,
        isActive: request.isVisible,
        iconName: request.iconName,
        colorValue: '#${request.colorValue.toRadixString(16).padLeft(8, '0')}',
        sortOrder: request.sortOrder,
      ),
    );
    if (dto == null) {
      throw Exception('Failed to create category');
    }
    return _mapDtoToEntity(dto);
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
    await _api.adminCategoriesControllerUpdate(
      id,
      UpdateCategoryDto(
        name: name,
        slug: name != null ? _slugify(name) : null,
        description: description,
        isActive: isVisible,
        iconName: iconName,
        colorValue: colorValue != null
            ? '#${colorValue.toRadixString(16).padLeft(8, '0')}'
            : null,
        sortOrder: sortOrder,
      ),
    );
  }

  @override
  Future<void> deleteCategory(CategoryId id) async {
    await _api.adminCategoriesControllerRemove(id);
  }

  @override
  Future<List<CategoryEntity>> getVisibleCategories() async {
    final dtos = await _api.adminCategoriesControllerFindAll();
    if (dtos == null) return [];

    return dtos.where((dto) => dto.isActive).map(_mapDtoToEntity).toList();
  }
}

// ── Mapping helpers ─────────────────────────────────

/// Maps [AdminCategoryResponseDto] → [CategoryEntity]
CategoryEntity _mapDtoToEntity(AdminCategoryResponseDto dto) {
  return CategoryEntity(
    id: CategoryId(dto.id),
    name: dto.name,
    description: dto.description?.toString() ?? '',
    iconName: dto.iconName?.toString() ?? 'category',
    colorValue: _parseColorValue(dto.colorValue),
    serviceCount: dto.serviceCount.toInt(),
    isVisible: dto.isActive,
    sortOrder: dto.sortOrder.toInt(),
    createdAt: dto.createdAt.toIso8601String(),
    updatedAt: dto.updatedAt.toIso8601String(),
  );
}

/// Parses a hex color string like `#FF6366F1` to int.
/// Falls back to default indigo if parsing fails.
int _parseColorValue(Object? value) {
  if (value == null) return 0xFF6366F1;
  final str = value.toString().replaceFirst('#', '');
  return int.tryParse(str, radix: 16) ?? 0xFF6366F1;
}

/// Generates a URL-friendly slug from [name].
String _slugify(String name) {
  return name
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[^\w\s-]'), '')
      .replaceAll(RegExp(r'\s+'), '-');
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
