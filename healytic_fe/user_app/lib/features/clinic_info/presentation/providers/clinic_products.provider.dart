import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:user_app/features/clinic_info/data/provider/clinic_info.provider.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';

part 'clinic_products.provider.g.dart';

// ── 1. Raw Data Fetch (family by clinicId) ──────────

/// Fetches all products and categories for a clinic.
///
/// Family provider — each [clinicId] gets its own
/// cached async state with auto-dispose.
@riverpod
Future<ClinicProductsData> clinicProducts(
  Ref ref, {
  required String clinicId,
}) async {
  final repo = ref.read(clinicInfoRepositoryProvider);
  return repo.getClinicProducts(clinicId);
}

// ── 2. Sort State ───────────────────────────────────

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

// ── 3. Category Filter State ────────────────────────

/// Tracks the selected category chip ID.
/// Defaults to `'all'` (show everything).
@riverpod
class ClinicProductCategoryNotifier extends _$ClinicProductCategoryNotifier {
  @override
  String build() => 'all';

  /// Selects a category by its ID.
  void select(String categoryId) => state = categoryId;
}

// ── 4. Search State ─────────────────────────────────

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

// ── 5. Computed Filtered + Sorted Products ──────────

/// Reactively combines raw product data with sort,
/// category, and search state to produce the final
/// list displayed in the grid.
@riverpod
Future<List<ClinicProductEntity>> filteredClinicProducts(
  Ref ref, {
  required String clinicId,
}) async {
  final data = await ref.watch(
    clinicProductsProvider(clinicId: clinicId).future,
  );
  final sort = ref.watch(clinicProductSortProvider);
  final categoryId = ref.watch(clinicProductCategoryProvider);
  final searchQuery = ref.watch(clinicProductSearchProvider);

  var items = data.products;

  // ── Category filter ──
  if (categoryId != 'all') {
    items = items.where((p) => p.categoryId == categoryId).toList();
  }

  // ── Search filter ──
  if (searchQuery.isNotEmpty) {
    final q = searchQuery.toLowerCase();
    items = items.where((p) => p.title.toLowerCase().contains(q)).toList();
  }

  // ── Sort ──
  switch (sort) {
    case ClinicProductSort.popular:
      break; // default API order
    case ClinicProductSort.latest:
      items = [...items]
        ..sort((a, b) => b.createdAtMs.compareTo(a.createdAtMs));
    case ClinicProductSort.topSales:
      items = [...items]..sort((a, b) => b.soldCount.compareTo(a.soldCount));
    case ClinicProductSort.priceAsc:
      items = [...items]
        ..sort((a, b) => _parsePrice(a.price).compareTo(_parsePrice(b.price)));
    case ClinicProductSort.priceDesc:
      items = [...items]
        ..sort((a, b) => _parsePrice(b.price).compareTo(_parsePrice(a.price)));
  }

  return items;
}

/// Extracts numeric value from a formatted price
/// string, e.g. "990.000đ" → 990000.
int _parsePrice(String formatted) {
  return int.tryParse(formatted.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
}
