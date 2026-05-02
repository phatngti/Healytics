import 'package:admin_openapi/api.dart' hide DashboardTimePeriod;
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/core/entities/analytics_status_tone.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:admin_panel/features/partner/products/data/data/product_analytics_mock_data.dart';
import 'package:admin_panel/features/partner/products/data/data/product_mock_data.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/product_analytics.entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_analytics_remote.datasource.g.dart';

// ============================================================
// 1. ABSTRACT INTERFACE
// ============================================================

/// Contract for product analytics remote data
/// operations.
abstract class ProductAnalyticsRemoteDataSource {
  /// Fetches aggregated overview analytics for
  /// the given [period].
  Future<ProductOverviewAnalytics> getOverviewAnalytics({
    required DashboardTimePeriod period,
  });

  /// Fetches detailed analytics for a single
  /// product within the given [period].
  Future<ProductDetailAnalytics> getDetailAnalytics({
    required ProductId productId,
    required DashboardTimePeriod period,
  });
}

// ============================================================
// 2. REAL API IMPLEMENTATION
// ============================================================

/// Real implementation using the Partner Health
/// Services Analytics API.
class ProductAnalyticsRemoteDataSourceImpl
    implements ProductAnalyticsRemoteDataSource {
  ProductAnalyticsRemoteDataSourceImpl({required this.apiService});

  final ApiService apiService;

  PartnerHealthServicesApi get _api => apiService.partnerHealthServicesApi;

  @override
  Future<ProductOverviewAnalytics> getOverviewAnalytics({
    required DashboardTimePeriod period,
  }) async {
    final response = await _api
        .partnerHealthServiceControllerGetOverviewAnalytics(
          period: period.value,
        );

    if (response == null) {
      throw ProductAnalyticsDataException('Failed to load overview analytics');
    }

    return _mapOverviewResponse(response);
  }

  @override
  Future<ProductDetailAnalytics> getDetailAnalytics({
    required ProductId productId,
    required DashboardTimePeriod period,
  }) async {
    final response = await _api
        .partnerHealthServiceControllerGetDetailAnalytics(
          productId.value.toString(),
          period: period.value,
        );

    if (response == null) {
      throw ProductAnalyticsDataException('Failed to load detail analytics');
    }

    return _mapDetailResponse(response);
  }

  // ── Private DTO → Entity Mappers ──────────────

  ProductOverviewAnalytics _mapOverviewResponse(
    HealthServiceOverviewAnalyticsResponseDto dto,
  ) {
    return ProductOverviewAnalytics(
      totalProducts: dto.totalProducts.toInt(),
      activeProducts: dto.activeProducts.toInt(),
      bookings: dto.bookings.toInt(),
      bookingsDelta: dto.bookingsDelta.toDouble(),
      revenue: dto.revenue.toDouble(),
      revenueDelta: dto.revenueDelta.toDouble(),
      averageRating: dto.averageRating.toDouble(),
      ratingDelta: dto.ratingDelta.toDouble(),
      reviewCount: dto.reviewCount.toInt(),
      bookingMetrics: _mapBookingMetricsDto(dto.bookingMetrics),
      trendPoints: dto.trendPoints.map(_mapTrendPointDto).toList(),
      categoryPerformance: dto.categoryPerformance
          .map(_mapCategoryPerformanceDto)
          .toList(),
      topServices: dto.topServices.map(_mapServicePerformanceDto).toList(),
    );
  }

  ProductDetailAnalytics _mapDetailResponse(
    HealthServiceDetailAnalyticsResponseDto dto,
  ) {
    return ProductDetailAnalytics(
      productId: ProductId(dto.productId),
      bookings: dto.bookings.toInt(),
      bookingsDelta: dto.bookingsDelta.toDouble(),
      revenue: dto.revenue.toDouble(),
      revenueDelta: dto.revenueDelta.toDouble(),
      completionRate: dto.completionRate.toDouble(),
      completionRateDelta: dto.completionRateDelta.toDouble(),
      averageRating: dto.averageRating.toDouble(),
      reviewCount: dto.reviewCount.toInt(),
      trendPoints: dto.trendPoints.map(_mapTrendPointDto).toList(),
      reviewDistribution: dto.reviewDistribution
          .map(_mapReviewBucketDto)
          .toList(),
      operationalMetrics: dto.operationalMetrics
          .map(_mapOperationalMetricDto)
          .toList(),
      peerRanking: dto.peerRanking.map(_mapServicePerformanceDto).toList(),
      alerts: dto.alerts.map(_mapAlertDto).toList(),
    );
  }

  ProductBookingMetricsSummary _mapBookingMetricsDto(
    AnalyticsBookingMetricsDto dto,
  ) {
    return ProductBookingMetricsSummary(
      totalBookings: dto.totalBookings.toInt(),
      delayedBookings: dto.delayedBookings.toInt(),
      delayThresholdMinutes: dto.delayThresholdMinutes.toInt(),
      pendingBookings: dto.pendingBookings.toInt(),
      completedBookings: dto.completedBookings.toInt(),
      statusBreakdown: dto.statusBreakdown.map(_mapStatusBreakdownDto).toList(),
      alerts: dto.alerts.map(_mapAlertDto).toList(),
    );
  }

  ProductBookingStatusMetric _mapStatusBreakdownDto(
    BookingStatusBreakdownDto dto,
  ) {
    return ProductBookingStatusMetric(
      statusKey: dto.statusKey,
      label: dto.label,
      count: dto.count.toInt(),
      tone: _parseStatusTone(dto.statusKey),
    );
  }

  ProductTrendPoint _mapTrendPointDto(AnalyticsTrendPointDto dto) {
    return ProductTrendPoint(
      label: dto.label,
      bookings: dto.bookings.toDouble(),
      revenue: dto.revenue.toDouble(),
    );
  }

  ProductCategoryPerformance _mapCategoryPerformanceDto(
    AnalyticsCategoryPerformanceDto dto,
  ) {
    return ProductCategoryPerformance(
      categoryName: dto.categoryName,
      bookings: dto.bookings.toInt(),
      revenue: dto.revenue.toDouble(),
      averageRating: dto.averageRating.toDouble(),
    );
  }

  ProductServicePerformance _mapServicePerformanceDto(
    AnalyticsServicePerformanceDto dto,
  ) {
    return ProductServicePerformance(
      name: dto.name,
      categoryName: dto.categoryName,
      bookings: dto.bookings.toInt(),
      revenue: dto.revenue.toDouble(),
      averageRating: dto.averageRating.toDouble(),
    );
  }

  ProductReviewBucket _mapReviewBucketDto(AnalyticsReviewBucketDto dto) {
    return ProductReviewBucket(
      stars: dto.stars.toInt(),
      count: dto.count.toInt(),
    );
  }

  ProductOperationalMetric _mapOperationalMetricDto(
    AnalyticsOperationalMetricDto dto,
  ) {
    return ProductOperationalMetric(
      label: dto.label,
      value: dto.value,
      detail: dto.detail,
      tone: _parseToneEnum(dto.tone.value),
    );
  }

  ProductAnalyticsAlert _mapAlertDto(AnalyticsAlertDto dto) {
    return ProductAnalyticsAlert(
      title: dto.title,
      detail: dto.detail,
      tone: _parseToneEnum(dto.tone.value),
    );
  }

  /// Converts the generated enum's .value string
  /// to the domain [AnalyticsStatusTone].
  AnalyticsStatusTone _parseToneEnum(String value) {
    return switch (value) {
      'positive' => AnalyticsStatusTone.positive,
      'warning' => AnalyticsStatusTone.warning,
      'critical' => AnalyticsStatusTone.critical,
      _ => AnalyticsStatusTone.neutral,
    };
  }

  /// Derives tone from booking status key.
  /// [BookingStatusBreakdownDto] has no tone
  /// field.
  AnalyticsStatusTone _parseStatusTone(String statusKey) {
    return switch (statusKey) {
      'completed' => AnalyticsStatusTone.positive,
      'confirmed' => AnalyticsStatusTone.positive,
      'cancelled' => AnalyticsStatusTone.critical,
      'no_show' => AnalyticsStatusTone.warning,
      _ => AnalyticsStatusTone.neutral,
    };
  }
}

// ============================================================
// 3. MOCK IMPLEMENTATION
// ============================================================

/// Mock data source for development and testing.
/// All synthetic data is built from
/// [product_analytics_mock_data.dart].
class ProductAnalyticsRemoteDataSourceMock
    implements ProductAnalyticsRemoteDataSource {
  @override
  Future<ProductOverviewAnalytics> getOverviewAnalytics({
    required DashboardTimePeriod period,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return buildMockOverviewAnalytics(productMockData.values.toList(), period);
  }

  @override
  Future<ProductDetailAnalytics> getDetailAnalytics({
    required ProductId productId,
    required DashboardTimePeriod period,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final products = productMockData.values.toList();
    final product = productMockData[productId.value] ?? productMockDefault;
    return buildMockDetailAnalytics(
      product: product.copyWith(id: productId),
      products: products,
      period: period,
    );
  }
}

// ============================================================
// 4. PROVIDER WITH MOCK SWITCHING
// ============================================================

/// Provides the correct data source based on the
/// mock flag in persistent storage.
@riverpod
ProductAnalyticsRemoteDataSource productAnalyticsRemoteDataSource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  if (isMock) {
    return ProductAnalyticsRemoteDataSourceMock();
  }
  final apiService = ref.read(apiServiceProvider);
  return ProductAnalyticsRemoteDataSourceImpl(apiService: apiService);
}

// ============================================================
// 5. CUSTOM EXCEPTIONS
// ============================================================

/// Exception for product analytics data fetch
/// failures.
class ProductAnalyticsDataException implements Exception {
  const ProductAnalyticsDataException(this.message);

  final String message;

  @override
  String toString() => 'ProductAnalyticsDataException: $message';
}
