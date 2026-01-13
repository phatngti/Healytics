import 'package:admin_panel/features/admin/category/datasource/category_implement.repository.dart';
import 'package:admin_panel/features/admin/category/domain/category.entity.dart';
import 'package:admin_panel/features/admin/category/domain/create_category.request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category.provider.freezed.dart';
part 'category.provider.g.dart';

/// State for category management
@freezed
abstract class CategoryState with _$CategoryState {
  const factory CategoryState({
    @Default([]) List<CategoryEntity> categories,
    @Default(0) int totalCount,
  }) = _CategoryState;
}

/// Notifier for category state management
@riverpod
class CategoryNotifier extends _$CategoryNotifier {
  @override
  FutureOr<CategoryState> build() async {
    return const CategoryState();
  }

  /// Get total count of categories
  Future<int> getTotalRows() async {
    final repo = ref.read(categoryRepositoryProvider);
    return repo.getTotalRows();
  }

  /// Get paginated list of categories
  Future<List<CategoryEntity>> getCategories({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    final repo = ref.read(categoryRepositoryProvider);
    return repo.getCategories(
      startingAt: startingAt,
      count: count,
      sortedBy: sortedBy,
      sortedAsc: sortedAsc,
    );
  }

  /// Get a single category by ID
  Future<CategoryEntity> getCategoryById(CategoryId id) async {
    final repo = ref.read(categoryRepositoryProvider);
    return repo.getCategoryById(id);
  }

  /// Create a new category
  Future<CategoryEntity> createCategory(CreateCategoryRequest request) async {
    final repo = ref.read(categoryRepositoryProvider);
    final result = await repo.createCategory(request);

    // Refresh state after creation
    state = AsyncValue.data(state.value ?? const CategoryState());

    return result;
  }

  /// Update an existing category
  Future<void> updateCategory({
    required CategoryId id,
    String? name,
    String? description,
    String? iconName,
    int? colorValue,
    bool? isVisible,
    int? sortOrder,
  }) async {
    final repo = ref.read(categoryRepositoryProvider);
    await repo.updateCategory(
      id: id,
      name: name,
      description: description,
      iconName: iconName,
      colorValue: colorValue,
      isVisible: isVisible,
      sortOrder: sortOrder,
    );
  }

  /// Delete a category by ID
  Future<void> deleteCategory(CategoryId id) async {
    final repo = ref.read(categoryRepositoryProvider);
    await repo.deleteCategory(id);
  }

  /// Get visible categories for selection widgets
  Future<List<CategoryEntity>> getVisibleCategories() async {
    final repo = ref.read(categoryRepositoryProvider);
    return repo.getVisibleCategories();
  }
}
