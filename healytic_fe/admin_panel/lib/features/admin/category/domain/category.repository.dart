import 'package:admin_panel/features/admin/category/domain/category.entity.dart';
import 'package:admin_panel/features/admin/category/domain/create_category.request.dart';

/// Abstract repository interface for Category operations
/// Domain layer - no dependencies on Flutter UI, Riverpod, or HTTP clients
abstract class CategoryRepository {
  /// Get paginated list of categories for table display
  Future<List<CategoryEntity>> getCategories({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  });

  /// Get all categories for client-side filtering/sorting.
  Future<List<CategoryEntity>> getAllCategories({
    String? sortedBy,
    bool? sortedAsc,
  });

  /// Get total count of categories
  Future<int> getTotalRows();

  /// Get a single category by ID
  Future<CategoryEntity> getCategoryById(CategoryId id);

  /// Create a new category
  Future<CategoryEntity> createCategory(CreateCategoryRequest request);

  /// Update an existing category
  Future<void> updateCategory({
    required CategoryId id,
    String? parentId,
    String? name,
    String? description,
    String? iconName,
    int? colorValue,
    bool? isVisible,
    int? sortOrder,
  });

  /// Delete a category by ID
  Future<void> deleteCategory(CategoryId id);

  /// Get all visible categories (for selection widgets)
  Future<List<CategoryEntity>> getVisibleCategories();
}
