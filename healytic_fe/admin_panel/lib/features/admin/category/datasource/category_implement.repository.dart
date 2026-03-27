import 'package:admin_panel/features/admin/category/datasource/category_remote.datasource.dart';
import 'package:admin_panel/features/admin/category/domain/category.entity.dart';
import 'package:admin_panel/features/admin/category/domain/category.repository.dart';
import 'package:admin_panel/features/admin/category/domain/create_category.request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_implement.repository.g.dart';

/// Repository implementation that delegates to the data source
class CategoryImplementRepository implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryImplementRepository({required this.remoteDataSource});

  @override
  Future<List<CategoryEntity>> getCategories({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  }) {
    return remoteDataSource.getCategories(
      startingAt: startingAt,
      count: count,
      sortedBy: sortedBy,
      sortedAsc: sortedAsc,
    );
  }

  @override
  Future<int> getTotalRows() {
    return remoteDataSource.getTotalRows();
  }

  @override
  Future<CategoryEntity> getCategoryById(CategoryId id) {
    return remoteDataSource.getCategoryById(id);
  }

  @override
  Future<CategoryEntity> createCategory(CreateCategoryRequest request) {
    return remoteDataSource.createCategory(request);
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
  }) {
    return remoteDataSource.updateCategory(
      id: id,
      name: name,
      description: description,
      iconName: iconName,
      colorValue: colorValue,
      isVisible: isVisible,
      sortOrder: sortOrder,
    );
  }

  @override
  Future<void> deleteCategory(CategoryId id) {
    return remoteDataSource.deleteCategory(id);
  }

  @override
  Future<List<CategoryEntity>> getVisibleCategories() {
    return remoteDataSource.getVisibleCategories();
  }
}

/// Provider for the category repository
@riverpod
CategoryRepository categoryRepository(Ref ref) {
  final remoteDataSource = ref.read(categoryRemoteDataSourceProvider);
  return CategoryImplementRepository(remoteDataSource: remoteDataSource);
}
