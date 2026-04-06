// Pure-Dart entities for the Product tab.
// Platform-agnostic — no Flutter or Riverpod imports.

/// Sort options for the clinic product list.
///
/// Maps to backend query parameter values via
/// [toApiValue].
enum ClinicProductSort {
  /// Default ordering (as returned by API).
  popular,

  /// Newest first by creation date.
  latest,

  /// Most sold first.
  topSales,

  /// Cheapest first.
  priceAsc,

  /// Most expensive first.
  priceDesc;

  /// Converts this enum to the API query string.
  String toApiValue() => switch (this) {
        popular => 'popular',
        latest => 'latest',
        topSales => 'top_sales',
        priceAsc => 'price_asc',
        priceDesc => 'price_desc',
      };
}

/// A product category chip (e.g. "All Services",
/// "Massage Therapy").
class ClinicProductCategory {
  const ClinicProductCategory({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;
}

/// A single clinic product/service in the grid.
class ClinicProductEntity {
  const ClinicProductEntity({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.price,
    required this.priceAmount,
    this.originalPrice,
    this.discountLabel,
    this.badgeLabel,
    this.durationLabel,
    this.specialistLabel,
    required this.categoryId,
    this.soldCount = 0,
    this.createdAtMs = 0,
  });

  final String id;

  /// Display title (uppercase in the UI).
  final String title;

  final String? imageUrl;

  /// Formatted current price, e.g. "990.000đ".
  final String price;

  /// Numeric price for client-side comparisons.
  final double priceAmount;

  /// Formatted original price shown with
  /// strikethrough when discounted.
  final String? originalPrice;

  /// Discount badge text, e.g. "-20%".
  /// Mutually exclusive with [badgeLabel].
  final String? discountLabel;

  /// Non-discount badge text, e.g. "HOT".
  /// Mutually exclusive with [discountLabel].
  final String? badgeLabel;

  /// Duration chip text, e.g. "60 min".
  final String? durationLabel;

  /// Specialist chip text, e.g. "Specialist".
  final String? specialistLabel;

  /// FK to [ClinicProductCategory.id].
  final String categoryId;

  /// Number of units sold — for "Top Sales" sort.
  final int soldCount;

  /// Creation epoch ms — for "Latest" sort.
  final int createdAtMs;

  /// Whether this product has a discount.
  bool get hasDiscount =>
      discountLabel != null && originalPrice != null;
}

/// Paginated bundle returned by the clinic products
/// endpoint.
class ClinicProductsData {
  const ClinicProductsData({
    required this.categories,
    required this.products,
    required this.totalCount,
    required this.hasMore,
  });

  final List<ClinicProductCategory> categories;
  final List<ClinicProductEntity> products;

  /// Total number of products matching the filter.
  final int totalCount;

  /// Whether more pages are available.
  final bool hasMore;
}
