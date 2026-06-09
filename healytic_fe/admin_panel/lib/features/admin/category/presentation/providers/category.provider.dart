import 'package:admin_panel/features/admin/category/datasource/category_implement.repository.dart';
import 'package:admin_panel/features/admin/category/domain/category.entity.dart';
import 'package:admin_panel/features/admin/category/domain/create_category.request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category.provider.freezed.dart';
part 'category.provider.g.dart';

enum CategoryTableSort { name, serviceCount, status, createdAt }

enum CategoryVisibilityFilter { all, visible, hidden }

/// State for category management
@freezed
abstract class CategoryState with _$CategoryState {
  const factory CategoryState({
    @Default([]) List<CategoryEntity> categories,
    @Default(0) int totalCount,
    @Default('') String searchQuery,
    @Default(CategoryTableSort.name) CategoryTableSort sortBy,
    @Default(true) bool sortAscending,
    @Default(CategoryVisibilityFilter.all)
    CategoryVisibilityFilter visibilityFilter,
    @Default(<String>{}) Set<String> selectedIds,
    @Default(0) int reloadToken,
  }) = _CategoryState;
}

/// Notifier for category state management
@Riverpod(keepAlive: true)
class CategoryNotifier extends _$CategoryNotifier {
  int? _visibleCategoriesCacheKey;
  Future<List<CategoryEntity>>? _visibleCategoriesCache;

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

  Future<int> getVisibleTotalRows() async {
    return (await _getVisibleCategories()).length;
  }

  Future<List<CategoryEntity>> getVisiblePage({
    required int startingAt,
    required int count,
  }) async {
    final categories = await _getVisibleCategories();
    return _page(categories, startingAt, count);
  }

  void setSearchQuery(String value) {
    final current = _currentState;
    _setTableState(
      current.copyWith(
        searchQuery: value,
        selectedIds: const <String>{},
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  void setSort(CategoryTableSort sortBy) {
    final current = _currentState;
    final nextAscending = current.sortBy == sortBy
        ? !current.sortAscending
        : _defaultSortAscending(sortBy);
    _setTableState(
      current.copyWith(
        sortBy: sortBy,
        sortAscending: nextAscending,
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  void setVisibilityFilter(CategoryVisibilityFilter value) {
    final current = _currentState;
    _setTableState(
      current.copyWith(
        visibilityFilter: value,
        selectedIds: const <String>{},
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  void toggleSelection(String id, bool selected) {
    final current = _currentState;
    final selectedIds = {...current.selectedIds};
    if (selected) {
      selectedIds.add(id);
    } else {
      selectedIds.remove(id);
    }
    _setTableState(current.copyWith(selectedIds: selectedIds));
  }

  void clearSelection() {
    final current = _currentState;
    if (current.selectedIds.isEmpty) return;
    _setTableState(current.copyWith(selectedIds: const <String>{}));
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

    final current = _currentState;
    _invalidateVisibleCategoriesCache();
    _setTableState(current.copyWith(reloadToken: current.reloadToken + 1));

    return result;
  }

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
  }) async {
    final repo = ref.read(categoryRepositoryProvider);
    await repo.updateCategory(
      id: id,
      parentId: parentId,
      name: name,
      description: description,
      iconName: iconName,
      colorValue: colorValue,
      isVisible: isVisible,
      sortOrder: sortOrder,
    );

    final current = _currentState;
    _invalidateVisibleCategoriesCache();
    _setTableState(current.copyWith(reloadToken: current.reloadToken + 1));
  }

  /// Delete a category by ID
  Future<void> deleteCategory(CategoryId id) async {
    final repo = ref.read(categoryRepositoryProvider);
    await repo.deleteCategory(id);
  }

  Future<void> deleteOne(String id) async {
    final repo = ref.read(categoryRepositoryProvider);
    await repo.deleteCategory(CategoryId(id));
    _afterDelete(idsToRemove: {id});
  }

  Future<void> deleteSelected() async {
    final ids = _currentState.selectedIds.toList(growable: false);
    if (ids.isEmpty) return;

    final repo = ref.read(categoryRepositoryProvider);
    await Future.wait(ids.map((id) => repo.deleteCategory(CategoryId(id))));
    _afterDelete(idsToRemove: ids.toSet());
  }

  /// Get visible categories for selection widgets
  Future<List<CategoryEntity>> getVisibleCategories() async {
    final repo = ref.read(categoryRepositoryProvider);
    return repo.getVisibleCategories();
  }

  CategoryState get _currentState => state.value ?? const CategoryState();

  void _setTableState(CategoryState value) {
    state = AsyncValue.data(value);
  }

  void _afterDelete({required Set<String> idsToRemove}) {
    final current = _currentState;
    _invalidateVisibleCategoriesCache();
    _setTableState(
      current.copyWith(
        selectedIds: current.selectedIds.difference(idsToRemove),
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  Future<List<CategoryEntity>> _getVisibleCategories() async {
    final cacheKey = _visibleCategoriesKey(_currentState);
    final cached = _visibleCategoriesCache;
    if (_visibleCategoriesCacheKey == cacheKey && cached != null) {
      return cached;
    }

    final future = _loadVisibleCategories(cacheKey);
    _visibleCategoriesCacheKey = cacheKey;
    _visibleCategoriesCache = future;
    return future;
  }

  Future<List<CategoryEntity>> _loadVisibleCategories(int cacheKey) async {
    try {
      return await _fetchVisibleCategories();
    } catch (_) {
      if (_visibleCategoriesCacheKey == cacheKey) {
        _invalidateVisibleCategoriesCache();
      }
      rethrow;
    }
  }

  Future<List<CategoryEntity>> _fetchVisibleCategories() async {
    final repo = ref.read(categoryRepositoryProvider);
    final categories = await repo.getAllCategories();
    final query = _currentState;
    final normalizedSearch = query.searchQuery.trim().toLowerCase();

    final filtered = categories.where((category) {
      final matchesSearch =
          normalizedSearch.isEmpty ||
          category.name.toLowerCase().contains(normalizedSearch) ||
          category.description.toLowerCase().contains(normalizedSearch) ||
          (category.parentName?.toLowerCase().contains(normalizedSearch) ??
              false);

      final matchesVisibility = switch (query.visibilityFilter) {
        CategoryVisibilityFilter.all => true,
        CategoryVisibilityFilter.visible => category.isVisible,
        CategoryVisibilityFilter.hidden => !category.isVisible,
      };

      return matchesSearch && matchesVisibility;
    }).toList();

    filtered.sort((a, b) {
      final comparison = switch (query.sortBy) {
        CategoryTableSort.name => _compareText(a.name, b.name),
        CategoryTableSort.serviceCount => a.serviceCount.compareTo(
          b.serviceCount,
        ),
        CategoryTableSort.status => (a.isVisible ? 1 : 0).compareTo(
          b.isVisible ? 1 : 0,
        ),
        CategoryTableSort.createdAt => _compareNullableDateString(
          a.createdAt,
          b.createdAt,
        ),
      };
      return query.sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  int _visibleCategoriesKey(CategoryState state) {
    return Object.hash(
      state.searchQuery,
      state.sortBy,
      state.sortAscending,
      state.visibilityFilter,
      state.reloadToken,
    );
  }

  void _invalidateVisibleCategoriesCache() {
    _visibleCategoriesCacheKey = null;
    _visibleCategoriesCache = null;
  }

  List<T> _page<T>(List<T> items, int startingAt, int count) {
    if (startingAt >= items.length) return [];
    final end = (startingAt + count).clamp(0, items.length);
    return items.sublist(startingAt.clamp(0, items.length), end);
  }

  int _compareText(String a, String b) {
    return a.toLowerCase().compareTo(b.toLowerCase());
  }

  bool _defaultSortAscending(CategoryTableSort sortBy) {
    return switch (sortBy) {
      CategoryTableSort.createdAt => false,
      _ => true,
    };
  }

  int _compareNullableDateString(String? a, String? b) {
    final left = a == null ? null : DateTime.tryParse(a);
    final right = b == null ? null : DateTime.tryParse(b);
    if (left != null || right != null) {
      if (left == null) return -1;
      if (right == null) return 1;
      return left.compareTo(right);
    }
    return (a ?? '').compareTo(b ?? '');
  }
}
