import 'package:admin_panel/features/partner/products/domain/category.entity.dart';
import 'package:admin_panel/features/partner/employee/data/employee_impl.repository.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/products/data/product_impl.repository.dart';

import 'package:admin_panel/features/partner/products/domain/create_product.request.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/update_product.request.dart';
import 'package:admin_openapi/api.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product.provider.freezed.dart';
part 'product.provider.g.dart';

enum ProductTableSort { name, category, price, status }

enum ProductStatusFilter { all, active, draft, archived }

@freezed
abstract class ProductState with _$ProductState {
  const factory ProductState({
    @Default('') String searchQuery,
    @Default(ProductTableSort.name) ProductTableSort sortBy,
    @Default(true) bool sortAscending,
    String? categoryFilter,
    @Default(ProductStatusFilter.all) ProductStatusFilter statusFilter,
    @Default(<String>{}) Set<String> selectedIds,
    @Default(0) int reloadToken,
  }) = _ProductState;
}

@riverpod
class ProductNotifier extends _$ProductNotifier {
  int? _visibleProductsCacheKey;
  Future<List<Product>>? _visibleProductsCache;

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

  Future<int> getVisibleTotalRows() async {
    return (await _getVisibleProducts()).length;
  }

  Future<List<Product>> getVisiblePage({
    required int startingAt,
    required int count,
  }) async {
    final products = await _getVisibleProducts();
    return _page(products, startingAt, count);
  }

  Future<List<String>> getFilterCategories() async {
    final repo = ref.read(productRepositoryProvider);
    final products = await repo.getAllProducts();
    final categories =
        products
            .map((product) => product.category.name.trim())
            .where((name) => name.isNotEmpty)
            .toSet()
            .toList()
          ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return categories;
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

  void setSort(ProductTableSort sortBy) {
    final current = _currentState;
    final nextAscending = current.sortBy == sortBy
        ? !current.sortAscending
        : true;
    _setTableState(
      current.copyWith(
        sortBy: sortBy,
        sortAscending: nextAscending,
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  void setCategoryFilter(String? value) {
    final current = _currentState;
    final normalized = value?.trim();
    _setTableState(
      current.copyWith(
        categoryFilter: normalized == null || normalized.isEmpty
            ? null
            : normalized,
        selectedIds: const <String>{},
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  void setStatusFilter(ProductStatusFilter value) {
    final current = _currentState;
    _setTableState(
      current.copyWith(
        statusFilter: value,
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

  Future<void> deleteProduct(ProductId id) async {
    final repo = ref.read(productRepositoryProvider);
    await repo.deleteProduct(id);
  }

  Future<void> deleteOne(String id) async {
    final repo = ref.read(productRepositoryProvider);
    await repo.deleteProduct(ProductId(id));
    _afterDelete(idsToRemove: {id});
  }

  Future<void> deleteSelected() async {
    final ids = _currentState.selectedIds.toList(growable: false);
    if (ids.isEmpty) return;

    final repo = ref.read(productRepositoryProvider);
    await Future.wait(ids.map((id) => repo.deleteProduct(ProductId(id))));
    _afterDelete(idsToRemove: ids.toSet());
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

  /// Get list of staff/employees available for
  /// product assignment
  Future<List<EmployeeEntity>> getStaffForProduct({String? role}) async {
    final employeeRepo = ref.read(employeeRepositoryProvider);

    if (role != null) {
      return employeeRepo.getEmployeesByRole(role: role);
    }

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

  /// Get active service tags for product tagging
  Future<List<ServiceTagResponseDto>> getServiceTagsForProduct() async {
    final repo = ref.read(productRepositoryProvider);
    return repo.getServiceTags();
  }

  ProductState get _currentState => state.value ?? const ProductState();

  void _setTableState(ProductState value) {
    state = AsyncValue.data(value);
  }

  void _afterDelete({required Set<String> idsToRemove}) {
    final current = _currentState;
    _invalidateVisibleProductsCache();
    _setTableState(
      current.copyWith(
        selectedIds: current.selectedIds.difference(idsToRemove),
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  Future<List<Product>> _getVisibleProducts() async {
    final cacheKey = _visibleProductsKey(_currentState);
    final cached = _visibleProductsCache;
    if (_visibleProductsCacheKey == cacheKey && cached != null) {
      return cached;
    }

    final future = _loadVisibleProducts(cacheKey);
    _visibleProductsCacheKey = cacheKey;
    _visibleProductsCache = future;
    return future;
  }

  Future<List<Product>> _loadVisibleProducts(int cacheKey) async {
    try {
      return await _fetchVisibleProducts();
    } catch (_) {
      if (_visibleProductsCacheKey == cacheKey) {
        _invalidateVisibleProductsCache();
      }
      rethrow;
    }
  }

  Future<List<Product>> _fetchVisibleProducts() async {
    final repo = ref.read(productRepositoryProvider);
    final products = await repo.getAllProducts();
    final query = _currentState;
    final normalizedSearch = query.searchQuery.trim().toLowerCase();
    final categoryFilter = query.categoryFilter?.trim().toLowerCase();

    final filtered = products.where((product) {
      final matchesSearch =
          normalizedSearch.isEmpty ||
          product.id.value.toLowerCase().contains(normalizedSearch) ||
          product.name.toLowerCase().contains(normalizedSearch) ||
          product.description.toLowerCase().contains(normalizedSearch) ||
          product.category.name.toLowerCase().contains(normalizedSearch);

      final matchesCategory =
          categoryFilter == null ||
          product.category.name.toLowerCase() == categoryFilter;

      final matchesStatus = switch (query.statusFilter) {
        ProductStatusFilter.all => true,
        ProductStatusFilter.active => product.status.toLowerCase() == 'active',
        ProductStatusFilter.draft => product.status.toLowerCase() == 'draft',
        ProductStatusFilter.archived =>
          product.status.toLowerCase() == 'archived',
      };

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();

    filtered.sort((a, b) {
      final comparison = switch (query.sortBy) {
        ProductTableSort.name => _compareText(a.name, b.name),
        ProductTableSort.category => _compareText(
          a.category.name,
          b.category.name,
        ),
        ProductTableSort.price => a.basePrice.compareTo(b.basePrice),
        ProductTableSort.status => _compareText(a.status, b.status),
      };
      return query.sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  int _visibleProductsKey(ProductState state) {
    return Object.hash(
      state.searchQuery,
      state.sortBy,
      state.sortAscending,
      state.categoryFilter,
      state.statusFilter,
      state.reloadToken,
    );
  }

  void _invalidateVisibleProductsCache() {
    _visibleProductsCacheKey = null;
    _visibleProductsCache = null;
  }

  List<T> _page<T>(List<T> items, int startingAt, int count) {
    if (startingAt >= items.length) return [];
    final end = (startingAt + count).clamp(0, items.length);
    return items.sublist(startingAt.clamp(0, items.length), end);
  }

  int _compareText(String a, String b) {
    return a.toLowerCase().compareTo(b.toLowerCase());
  }
}
