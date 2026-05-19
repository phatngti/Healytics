import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:user_app/features/clinic_info/data/provider/clinic_info.provider.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';

part 'clinic_products.provider.g.dart';

// ── 1. Sort State ───────────────────────────────────

/// Tracks the active sort option for the product
/// grid. Defaults to [ClinicProductSort.popular].
@riverpod
class ClinicProductSortNotifier extends _$ClinicProductSortNotifier {
  @override
  ClinicProductSort build() => ClinicProductSort.popular;

  /// Selects a specific sort option.
  void select(ClinicProductSort sort) => state = sort;

  /// Toggles between ascending/descending price when
  /// the "Price" button is tapped repeatedly.
  void togglePrice() {
    state = state == ClinicProductSort.priceAsc
        ? ClinicProductSort.priceDesc
        : ClinicProductSort.priceAsc;
  }
}

// ── 2. Category Filter State ────────────────────────

/// Tracks the selected category chip ID.
/// Defaults to `'all'` (show everything).
@riverpod
class ClinicProductCategoryNotifier extends _$ClinicProductCategoryNotifier {
  @override
  String build() => 'all';

  /// Selects a category by its ID.
  void select(String categoryId) => state = categoryId;
}

// ── 3. Search State ─────────────────────────────────

/// Tracks the search query for title-based filtering.
/// Defaults to an empty string (no search).
@riverpod
class ClinicProductSearchNotifier extends _$ClinicProductSearchNotifier {
  @override
  String build() => '';

  /// Updates the search query.
  void updateQuery(String query) => state = query;

  /// Clears the search query.
  void clear() => state = '';
}

// ── 4. Filter State ─────────────────────────────────

/// Tracks additional filter-sheet criteria.
@riverpod
class ClinicProductFilterNotifier extends _$ClinicProductFilterNotifier {
  @override
  ClinicProductFilters build() => const ClinicProductFilters();

  /// Applies a complete filter set from the bottom sheet.
  void apply(ClinicProductFilters filters) => state = filters;

  /// Clears only the extra filter-sheet criteria.
  void reset() => state = const ClinicProductFilters();
}

// ── 5. Accumulated Products State ───────────────────

/// Holds the accumulated products list across
/// all loaded pages, plus pagination metadata
/// and the categories from the first response.
class ClinicProductsAccumulated {
  const ClinicProductsAccumulated({
    required this.categories,
    required this.products,
    required this.totalCount,
    required this.hasMore,
    required this.currentPage,
    this.isLoadingMore = false,
  });

  final List<ClinicProductCategory> categories;
  final List<ClinicProductEntity> products;
  final int totalCount;
  final bool hasMore;
  final int currentPage;
  final bool isLoadingMore;

  /// Creates a copy with updated fields.
  ClinicProductsAccumulated copyWith({
    List<ClinicProductCategory>? categories,
    List<ClinicProductEntity>? products,
    int? totalCount,
    bool? hasMore,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return ClinicProductsAccumulated(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

// ── 6. Paginated Products Provider ──────────────────

/// Manages server-side paginated product loading.
///
/// Watches sort, category, and search state.
/// When any of them change, fetches fresh data
/// from page 1. Supports "load more" pagination.
@riverpod
class ClinicProductsPaginated extends _$ClinicProductsPaginated {
  @override
  Future<ClinicProductsAccumulated> build({required String clinicId}) async {
    final sort = ref.watch(clinicProductSortProvider);
    final categoryId = ref.watch(clinicProductCategoryProvider);
    final searchQuery = ref.watch(clinicProductSearchProvider);
    final filters = ref.watch(clinicProductFilterProvider);

    final repo = ref.read(clinicInfoRepositoryProvider);
    final data = await repo.getClinicProducts(
      clinicId,
      categoryId: categoryId == 'all' ? null : categoryId,
      sort: sort,
      search: searchQuery.isEmpty ? null : searchQuery,
      filters: filters,
    );

    return ClinicProductsAccumulated(
      categories: data.categories,
      products: data.products,
      totalCount: data.totalCount,
      hasMore: data.hasMore,
      currentPage: 1,
    );
  }

  /// Loads the next page and appends to the list.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) {
      return;
    }

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final sort = ref.read(clinicProductSortProvider);
    final categoryId = ref.read(clinicProductCategoryProvider);
    final searchQuery = ref.read(clinicProductSearchProvider);
    final filters = ref.read(clinicProductFilterProvider);

    final nextPage = current.currentPage + 1;
    final repo = ref.read(clinicInfoRepositoryProvider);
    final data = await repo.getClinicProducts(
      clinicId,
      categoryId: categoryId == 'all' ? null : categoryId,
      sort: sort,
      search: searchQuery.isEmpty ? null : searchQuery,
      filters: filters,
      page: nextPage,
    );

    state = AsyncData(
      current.copyWith(
        products: [...current.products, ...data.products],
        totalCount: data.totalCount,
        hasMore: data.hasMore,
        currentPage: nextPage,
        isLoadingMore: false,
      ),
    );
  }
}
