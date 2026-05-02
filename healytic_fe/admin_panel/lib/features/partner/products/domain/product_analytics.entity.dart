import 'package:admin_panel/core/entities/analytics_status_tone.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_analytics.entity.freezed.dart';

@freezed
abstract class ProductOverviewAnalytics with _$ProductOverviewAnalytics {
  const factory ProductOverviewAnalytics({
    required int totalProducts,
    required int activeProducts,
    required ProductBookingMetricsSummary bookingMetrics,
    required int bookings,
    required double bookingsDelta,
    required double revenue,
    required double revenueDelta,
    required double averageRating,
    required double ratingDelta,
    required int reviewCount,
    required List<ProductTrendPoint> trendPoints,
    required List<ProductCategoryPerformance> categoryPerformance,
    required List<ProductServicePerformance> topServices,
  }) = _ProductOverviewAnalytics;
}

@freezed
abstract class ProductBookingMetricsSummary
    with _$ProductBookingMetricsSummary {
  const factory ProductBookingMetricsSummary({
    required int totalBookings,
    required int delayedBookings,
    required int delayThresholdMinutes,
    required int pendingBookings,
    required int completedBookings,
    required List<ProductBookingStatusMetric> statusBreakdown,
    required List<ProductAnalyticsAlert> alerts,
  }) = _ProductBookingMetricsSummary;
}

@freezed
abstract class ProductBookingStatusMetric with _$ProductBookingStatusMetric {
  const factory ProductBookingStatusMetric({
    required String statusKey,
    required String label,
    required int count,
    required AnalyticsStatusTone tone,
  }) = _ProductBookingStatusMetric;
}

@freezed
abstract class ProductDetailAnalytics with _$ProductDetailAnalytics {
  const factory ProductDetailAnalytics({
    required ProductId productId,
    required int bookings,
    required double bookingsDelta,
    required double revenue,
    required double revenueDelta,
    required double completionRate,
    required double completionRateDelta,
    required double averageRating,
    required int reviewCount,
    required List<ProductTrendPoint> trendPoints,
    required List<ProductReviewBucket> reviewDistribution,
    required List<ProductOperationalMetric> operationalMetrics,
    required List<ProductServicePerformance> peerRanking,
    required List<ProductAnalyticsAlert> alerts,
  }) = _ProductDetailAnalytics;
}

@freezed
abstract class ProductTrendPoint with _$ProductTrendPoint {
  const factory ProductTrendPoint({
    required String label,
    required double bookings,
    required double revenue,
  }) = _ProductTrendPoint;
}

@freezed
abstract class ProductCategoryPerformance with _$ProductCategoryPerformance {
  const factory ProductCategoryPerformance({
    required String categoryName,
    required int bookings,
    required double revenue,
    required double averageRating,
  }) = _ProductCategoryPerformance;
}

@freezed
abstract class ProductServicePerformance with _$ProductServicePerformance {
  const factory ProductServicePerformance({
    required String name,
    required String categoryName,
    required int bookings,
    required double revenue,
    required double averageRating,
  }) = _ProductServicePerformance;
}

@freezed
abstract class ProductOperationalMetric with _$ProductOperationalMetric {
  const factory ProductOperationalMetric({
    required String label,
    required String value,
    required String detail,
    required AnalyticsStatusTone tone,
  }) = _ProductOperationalMetric;
}

@freezed
abstract class ProductReviewBucket with _$ProductReviewBucket {
  const factory ProductReviewBucket({required int stars, required int count}) =
      _ProductReviewBucket;
}

@freezed
abstract class ProductAnalyticsAlert with _$ProductAnalyticsAlert {
  const factory ProductAnalyticsAlert({
    required String title,
    required String detail,
    required AnalyticsStatusTone tone,
  }) = _ProductAnalyticsAlert;
}
