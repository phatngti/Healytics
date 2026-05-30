import 'dart:math' as math;

import 'package:admin_panel/core/entities/analytics_status_tone.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/product_analytics.entity.dart';

// ─── Overview Analytics Builder ─────────────────

/// Builds a synthetic [ProductOverviewAnalytics]
/// from the mock product catalogue.
ProductOverviewAnalytics buildMockOverviewAnalytics(
  List<Product> products,
  DashboardTimePeriod period,
) {
  final scale = _periodScale(period);
  final activeProducts = products.where(_isActiveProduct).length;
  final averageRating = _averageRating(products);
  final reviewCount = products.fold<int>(
    0,
    (sum, product) => sum + _serviceReviewCount(product),
  );
  final topServices =
      products.map((product) => _servicePerformance(product, scale)).toList()
        ..sort((left, right) => right.revenue.compareTo(left.revenue));

  final bookings = topServices.fold<int>(0, (sum, item) => sum + item.bookings);
  final revenue = topServices.fold<double>(
    0,
    (sum, item) => sum + item.revenue,
  );
  final bookingMetrics = _buildBookingMetrics(
    products: products,
    totalBookings: bookings,
    scale: scale,
  );

  return ProductOverviewAnalytics(
    totalProducts: products.length,
    activeProducts: activeProducts,
    bookingMetrics: bookingMetrics,
    bookings: bookings,
    bookingsDelta: 6.2 + scale * 1.5,
    revenue: revenue,
    revenueDelta: 4.8 + scale * 1.2,
    averageRating: averageRating,
    ratingDelta: 1.3 + scale * 0.4,
    reviewCount: reviewCount,
    trendPoints: _buildTrendPoints(
      scale: scale,
      seed: products.length,
      baseBookings: bookings / _periodDivisor(period),
      baseRevenue: revenue / _periodDivisor(period),
      period: period,
    ),
    categoryPerformance: _buildCategoryPerformance(products, scale),
    topServices: topServices.take(5).toList(),
  );
}

// ─── Detail Analytics Builder ───────────────────

/// Builds a synthetic [ProductDetailAnalytics]
/// for a single product within the mock catalogue.
ProductDetailAnalytics buildMockDetailAnalytics({
  required Product product,
  required List<Product> products,
  required DashboardTimePeriod period,
}) {
  final scale = _periodScale(period);
  final detailPerformance = _servicePerformance(product, scale);
  final completionRate = math.min(
    98.0,
    78 + (product.duration ?? 60) / 6 - (product.buffer ?? 0) / 12,
  );
  final peerRanking =
      products.map((item) => _servicePerformance(item, scale)).toList()..sort(
        (left, right) => right.averageRating.compareTo(left.averageRating),
      );

  final alerts = <ProductAnalyticsAlert>[
    if (!product.onlineStore)
      const ProductAnalyticsAlert(
        title: 'Online visibility disabled',
        detail:
            'This service is hidden from the '
            'public booking experience.',
        tone: AnalyticsStatusTone.warning,
      ),
    if (product.serviceManual == null)
      const ProductAnalyticsAlert(
        title: 'Service manual is incomplete',
        detail:
            'Document treatment steps and '
            'contraindications for staff.',
        tone: AnalyticsStatusTone.critical,
      ),
    if (_requiresSpecificStaffWithoutAssignment(product))
      const ProductAnalyticsAlert(
        title: 'No assigned staff',
        detail:
            'Bookings may fail when a service '
            'requires named staff.',
        tone: AnalyticsStatusTone.critical,
      ),
  ];

  return ProductDetailAnalytics(
    productId: product.id,
    bookings: detailPerformance.bookings,
    bookingsDelta: 5.4 + scale,
    revenue: detailPerformance.revenue,
    revenueDelta: 4.2 + scale,
    completionRate: completionRate,
    completionRateDelta: 1.1 + scale * 0.3,
    averageRating: detailPerformance.averageRating,
    reviewCount: _serviceReviewCount(product),
    trendPoints: _buildTrendPoints(
      scale: scale,
      seed: product.name.length,
      baseBookings: detailPerformance.bookings / _periodDivisor(period),
      baseRevenue: detailPerformance.revenue / _periodDivisor(period),
      period: period,
    ),
    reviewDistribution: _buildReviewDistribution(product),
    operationalMetrics: _buildOperationalMetrics(product),
    peerRanking: peerRanking.take(4).toList(),
    alerts: alerts,
  );
}

// ─── Booking Metrics ────────────────────────────

ProductBookingMetricsSummary _buildBookingMetrics({
  required List<Product> products,
  required int totalBookings,
  required double scale,
}) {
  final draftCount = products
      .where((product) => product.status == 'draft')
      .length;
  final hiddenCount = products.where((product) => !product.onlineStore).length;
  final staffingGaps = products
      .where(_requiresSpecificStaffWithoutAssignment)
      .length;

  final pendingBookings = math.min(
    totalBookings,
    math.max(1, (totalBookings * (0.14 + scale * 0.03)).round()),
  );
  final completedBookings = math.min(
    totalBookings - pendingBookings,
    math.max(1, (totalBookings * 0.54).round()),
  );
  final confirmedBookings = math.min(
    totalBookings - pendingBookings - completedBookings,
    math.max(1, (totalBookings * 0.16).round()),
  );
  final cancelledBookings = math.min(
    totalBookings - pendingBookings - completedBookings - confirmedBookings,
    math.max(draftCount, (totalBookings * 0.06).round()),
  );
  final noShowBookings = math.min(
    totalBookings -
        pendingBookings -
        completedBookings -
        confirmedBookings -
        cancelledBookings,
    math.max(hiddenCount ~/ 2, (totalBookings * 0.03).round()),
  );
  final rescheduledBookings = math.max(
    0,
    totalBookings -
        pendingBookings -
        completedBookings -
        confirmedBookings -
        cancelledBookings -
        noShowBookings,
  );
  const delayThresholdMinutes = 15;
  final delayedBookings = math.min<int>(
    totalBookings,
    math.max<int>(
      staffingGaps,
      (totalBookings * 0.08).round() + math.max(0, pendingBookings ~/ 6),
    ),
  );

  final alerts = <ProductAnalyticsAlert>[
    if (delayedBookings > 0)
      ProductAnalyticsAlert(
        title: 'Delayed bookings need intervention',
        detail:
            '$delayedBookings bookings are running '
            'more than $delayThresholdMinutes '
            'minutes behind schedule.',
        tone: AnalyticsStatusTone.critical,
      ),
    if (pendingBookings > math.max(6, totalBookings ~/ 8))
      ProductAnalyticsAlert(
        title:
            'Pending bookings are awaiting '
            'confirmation',
        detail:
            '$pendingBookings bookings are still '
            'in the approval queue for this '
            'period.',
        tone: AnalyticsStatusTone.warning,
      ),
    if (cancelledBookings + noShowBookings > math.max(4, totalBookings ~/ 12))
      const ProductAnalyticsAlert(
        title:
            'Cancellation and no-show risk '
            'is elevated',
        detail:
            'Review reminder flows and staffing '
            'handoffs to protect the booking '
            'pipeline.',
        tone: AnalyticsStatusTone.warning,
      ),
  ];

  final rawStatusBreakdown = <ProductBookingStatusMetric>[
    ProductBookingStatusMetric(
      statusKey: 'confirmed',
      label: 'Confirmed',
      count: confirmedBookings,
      tone: AnalyticsStatusTone.positive,
    ),
    ProductBookingStatusMetric(
      statusKey: 'cancelled',
      label: 'Cancelled',
      count: cancelledBookings,
      tone: AnalyticsStatusTone.critical,
    ),
    ProductBookingStatusMetric(
      statusKey: 'no_show',
      label: 'No-show',
      count: noShowBookings,
      tone: AnalyticsStatusTone.critical,
    ),
    ProductBookingStatusMetric(
      statusKey: 'rescheduled',
      label: 'Rescheduled',
      count: rescheduledBookings,
      tone: AnalyticsStatusTone.warning,
    ),
  ];

  return ProductBookingMetricsSummary(
    totalBookings: totalBookings,
    delayedBookings: delayedBookings,
    delayThresholdMinutes: delayThresholdMinutes,
    pendingBookings: pendingBookings,
    completedBookings: completedBookings,
    statusBreakdown: _normalizeBookingStatusMetrics(rawStatusBreakdown),
    alerts: alerts,
  );
}

/// Filters zero-count statuses and sorts by a
/// canonical display order.
List<ProductBookingStatusMetric> _normalizeBookingStatusMetrics(
  Iterable<ProductBookingStatusMetric> items,
) {
  const supportedOrder = <String, int>{
    'confirmed': 0,
    'cancelled': 1,
    'no_show': 2,
    'rescheduled': 3,
  };

  final filtered = items
      .where(
        (item) => supportedOrder.containsKey(item.statusKey) && item.count > 0,
      )
      .toList();

  filtered.sort(
    (left, right) => supportedOrder[left.statusKey]!.compareTo(
      supportedOrder[right.statusKey]!,
    ),
  );

  return filtered;
}

// ─── Trend Points ───────────────────────────────

List<ProductTrendPoint> _buildTrendPoints({
  required double scale,
  required int seed,
  required double baseBookings,
  required double baseRevenue,
  DashboardTimePeriod period = DashboardTimePeriod.thisMonth,
}) {
  final labels = _periodLabels(period);

  // Separate factor lists so the two lines
  // diverge visually and feel more realistic.
  const bookingFactors = [
    0.72,
    0.85,
    0.94,
    1.08,
    0.91,
    1.15,
    1.22,
    0.88,
    1.03,
    0.96,
    1.18,
    1.30,
  ];
  const revenueFactors = [
    0.80,
    0.78,
    1.02,
    1.12,
    0.97,
    1.05,
    1.28,
    0.93,
    1.10,
    1.00,
    1.24,
    1.35,
  ];

  return List<ProductTrendPoint>.generate(labels.length, (i) {
    final bMod = bookingFactors[(i + seed) % bookingFactors.length];
    final rMod = revenueFactors[(i + seed + 3) % revenueFactors.length];
    return ProductTrendPoint(
      label: labels[i],
      bookings: math.max(4, baseBookings * bMod * scale),
      revenue: math.max(300, baseRevenue * rMod * scale),
    );
  });
}

/// Returns context-appropriate x-axis labels for
/// each [DashboardTimePeriod].
List<String> _periodLabels(DashboardTimePeriod period) {
  switch (period) {
    case DashboardTimePeriod.today:
      return ['9AM', '11AM', '1PM', '3PM', '5PM', '7PM'];
    case DashboardTimePeriod.thisWeek:
      return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    case DashboardTimePeriod.thisMonth:
      return ['Wk 1', 'Wk 2', 'Wk 3', 'Wk 4'];
    case DashboardTimePeriod.thisQuarter:
      return ['Month 1', 'Month 2', 'Month 3'];
    case DashboardTimePeriod.thisYear:
      return [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
  }
}

// ─── Category & Service Performance ─────────────

List<ProductCategoryPerformance> _buildCategoryPerformance(
  List<Product> products,
  double scale,
) {
  final buckets = <String, List<Product>>{};
  for (final product in products) {
    buckets
        .putIfAbsent(_rootCategoryName(product), () => <Product>[])
        .add(product);
  }

  return buckets.entries.map((entry) {
    final services = entry.value;
    final performances = services
        .map((product) => _servicePerformance(product, scale))
        .toList();

    final bookings = performances.fold<int>(
      0,
      (sum, item) => sum + item.bookings,
    );
    final revenue = performances.fold<double>(
      0,
      (sum, item) => sum + item.revenue,
    );
    final avgRating =
        performances.fold<double>(0, (sum, item) => sum + item.averageRating) /
        math.max(1, performances.length);

    return ProductCategoryPerformance(
      categoryName: entry.key,
      bookings: bookings,
      revenue: revenue,
      averageRating: avgRating,
    );
  }).toList()..sort((left, right) => right.revenue.compareTo(left.revenue));
}

ProductServicePerformance _servicePerformance(Product product, double scale) {
  final bookingBase =
      ((product.duration ?? 60) / 4) +
      (product.onlineStore ? 18 : 9) +
      (product.status == 'active' ? 14 : 5) +
      (product.images.length * 2);
  final bookings = math.max(12, (bookingBase * scale).round());
  final revenue = bookings * (product.salePrice ?? product.basePrice);

  return ProductServicePerformance(
    name: product.name,
    categoryName: _rootCategoryName(product),
    bookings: bookings,
    revenue: revenue,
    averageRating: _serviceRating(product),
  );
}

String _rootCategoryName(Product product) {
  final parentName = product.category.parentName?.trim();
  if (parentName != null && parentName.isNotEmpty) {
    return parentName;
  }
  return product.category.name;
}

// ─── Review Distribution ────────────────────────

List<ProductReviewBucket> _buildReviewDistribution(Product product) {
  final reviewCount = _serviceReviewCount(product);
  final fiveStar = (reviewCount * 0.48).round();
  final fourStar = (reviewCount * 0.29).round();
  final threeStar = (reviewCount * 0.14).round();
  final twoStar = (reviewCount * 0.06).round();
  final oneStar = math.max(
    1,
    reviewCount - fiveStar - fourStar - threeStar - twoStar,
  );

  return [
    ProductReviewBucket(stars: 5, count: fiveStar),
    ProductReviewBucket(stars: 4, count: fourStar),
    ProductReviewBucket(stars: 3, count: threeStar),
    ProductReviewBucket(stars: 2, count: twoStar),
    ProductReviewBucket(stars: 1, count: oneStar),
  ];
}

// ─── Operational Metrics ────────────────────────

List<ProductOperationalMetric> _buildOperationalMetrics(Product product) {
  final completeness = [
    product.description.isNotEmpty,
    product.images.isNotEmpty,
    product.serviceManual != null,
  ].where((item) => item).length;

  return [
    ProductOperationalMetric(
      label: 'Visibility',
      value: product.onlineStore ? 'Public' : 'Internal',
      detail: product.onlineStore
          ? 'Eligible for online discovery'
          : 'Hidden from public booking',
      tone: product.onlineStore
          ? AnalyticsStatusTone.positive
          : AnalyticsStatusTone.warning,
    ),
    ProductOperationalMetric(
      label: 'Staff coverage',
      value: product.staffAllocation == 'specific'
          ? '${product.staffIds.length} assigned'
          : 'Flexible',
      detail: product.staffAllocation == 'specific'
          ? 'Named staff required for '
                'fulfillment'
          : 'Any qualified employee can '
                'deliver',
      tone: _requiresSpecificStaffWithoutAssignment(product)
          ? AnalyticsStatusTone.critical
          : AnalyticsStatusTone.positive,
    ),
    ProductOperationalMetric(
      label: 'Scheduling',
      value:
          '${product.duration ?? 0}m / '
          '${product.buffer ?? 0}m buffer',
      detail:
          'Capacity ${product.capacity ?? 1}, '
          'lead ${product.leadTime ?? 0}h',
      tone: (product.duration ?? 0) > 0
          ? AnalyticsStatusTone.neutral
          : AnalyticsStatusTone.warning,
    ),
    ProductOperationalMetric(
      label: 'Content completeness',
      value: '$completeness / 3',
      detail:
          'Description, gallery, and service '
          'manual readiness',
      tone: completeness == 3
          ? AnalyticsStatusTone.positive
          : completeness == 2
          ? AnalyticsStatusTone.warning
          : AnalyticsStatusTone.critical,
    ),
  ];
}

// ─── Private Helpers ────────────────────────────

bool _isActiveProduct(Product product) => product.status == 'active';

bool _requiresSpecificStaffWithoutAssignment(Product product) {
  return product.staffAllocation == 'specific' && product.staffIds.isEmpty;
}

double _averageRating(List<Product> products) {
  if (products.isEmpty) return 0;

  final total = products.fold<double>(
    0,
    (sum, product) => sum + _serviceRating(product),
  );
  return total / products.length;
}

double _serviceRating(Product product) {
  final seed =
      product.name.length + product.images.length + (product.duration ?? 0);
  final base = 3.7 + (seed % 11) / 10;
  return double.parse(math.min(4.9, base).toStringAsFixed(1));
}

int _serviceReviewCount(Product product) {
  return math.max(
    8,
    (product.images.length * 9) + (product.name.length % 21) + 22,
  );
}

double _periodScale(DashboardTimePeriod period) {
  switch (period) {
    case DashboardTimePeriod.today:
      return 0.32;
    case DashboardTimePeriod.thisWeek:
      return 0.72;
    case DashboardTimePeriod.thisMonth:
      return 1.0;
    case DashboardTimePeriod.thisQuarter:
      return 1.55;
    case DashboardTimePeriod.thisYear:
      return 2.35;
  }
}

double _periodDivisor(DashboardTimePeriod period) {
  switch (period) {
    case DashboardTimePeriod.today:
      return 6;
    case DashboardTimePeriod.thisWeek:
      return 7;
    case DashboardTimePeriod.thisMonth:
      return 4;
    case DashboardTimePeriod.thisQuarter:
      return 3;
    case DashboardTimePeriod.thisYear:
      return 12;
  }
}
