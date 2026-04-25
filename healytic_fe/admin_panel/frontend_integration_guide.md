# Frontend Integration Guide: Product Analytics APIs

## Overview

Replace the **synthetic, formula-based analytics** in `ProductAnalyticsRemoteDataSourceImpl` with calls to two new backend endpoints. The frontend architecture (domain entities, repository interface, providers, widgets) requires **zero changes** — only the data layer needs updating.

> [!IMPORTANT]
> The OpenAPI client has already been regenerated. All generated DTOs are in [admin_panel/openapi/lib/model/](file:///Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/openapi/lib/model). The guide references the **exact generated class names**.

---

## Generated DTOs Reference

These files exist in `admin_panel/openapi/lib/model/`:

| Generated File | Generated Class | Dart Type Notes |
|---|---|---|
| [health_service_overview_analytics_response_dto.dart](file:///Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/openapi/lib/model/health_service_overview_analytics_response_dto.dart) | `HealthServiceOverviewAnalyticsResponseDto` | All KPIs are `num` |
| [health_service_detail_analytics_response_dto.dart](file:///Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/openapi/lib/model/health_service_detail_analytics_response_dto.dart) | `HealthServiceDetailAnalyticsResponseDto` | `productId` is `String` |
| [analytics_booking_metrics_dto.dart](file:///Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/openapi/lib/model/analytics_booking_metrics_dto.dart) | `AnalyticsBookingMetricsDto` | All counts are `num` |
| [booking_status_breakdown_dto.dart](file:///Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/openapi/lib/model/booking_status_breakdown_dto.dart) | `BookingStatusBreakdownDto` | `count` is `num`, no `tone` field |
| [analytics_trend_point_dto.dart](file:///Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/openapi/lib/model/analytics_trend_point_dto.dart) | `AnalyticsTrendPointDto` | `bookings` and `revenue` are `num` |
| [analytics_category_performance_dto.dart](file:///Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/openapi/lib/model/analytics_category_performance_dto.dart) | `AnalyticsCategoryPerformanceDto` | All numerics are `num` |
| [analytics_service_performance_dto.dart](file:///Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/openapi/lib/model/analytics_service_performance_dto.dart) | `AnalyticsServicePerformanceDto` | All numerics are `num` |
| [analytics_review_bucket_dto.dart](file:///Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/openapi/lib/model/analytics_review_bucket_dto.dart) | `AnalyticsReviewBucketDto` | `stars` and `count` are `num` |
| [analytics_operational_metric_dto.dart](file:///Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/openapi/lib/model/analytics_operational_metric_dto.dart) | `AnalyticsOperationalMetricDto` | `tone` → `AnalyticsOperationalMetricDtoToneEnum` |
| [analytics_alert_dto.dart](file:///Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/openapi/lib/model/analytics_alert_dto.dart) | `AnalyticsAlertDto` | `tone` → `AnalyticsAlertDtoToneEnum` |

### Generated API Methods

In [partner_health_services_api.dart](file:///Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/openapi/lib/api/partner_health_services_api.dart):

```dart
// Overview analytics
Future<HealthServiceOverviewAnalyticsResponseDto?>
    partnerHealthServiceControllerGetOverviewAnalytics({
  String? period,       // e.g. 'this_month'
});

// Detail analytics
Future<HealthServiceDetailAnalyticsResponseDto?>
    partnerHealthServiceControllerGetDetailAnalytics(
  String productId,     // UUID path param
  {
    String? period,     // e.g. 'this_month'
  },
);
```

### Generated Tone Enums

> [!WARNING]
> The `tone` field is **not** a plain `String`. The generator creates **separate enum classes** for each DTO that has an inline string enum. You must convert these to `AnalyticsStatusTone` in the mapper.

```dart
// For AnalyticsAlertDto.tone:
class AnalyticsAlertDtoToneEnum {
  static const critical  = AnalyticsAlertDtoToneEnum._('critical');
  static const warning   = AnalyticsAlertDtoToneEnum._('warning');
  static const positive  = AnalyticsAlertDtoToneEnum._('positive');
  static const neutral   = AnalyticsAlertDtoToneEnum._('neutral');
  final String value;  // ← use .value to get the string
}

// For AnalyticsOperationalMetricDto.tone:
class AnalyticsOperationalMetricDtoToneEnum {
  // Same four values, same .value accessor
}
```

---

## Step 1: Rewrite `ProductAnalyticsRemoteDataSourceImpl`

**File**: [product_analytics_remote.datasource.dart](file:///Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/admin_panel/lib/features/partner/products/data/product_analytics_remote.datasource.dart)

### Replace the Impl class (lines 27–61)

```dart
/// Real implementation using the Partner Health
/// Services Analytics API.
class ProductAnalyticsRemoteDataSourceImpl
    implements ProductAnalyticsRemoteDataSource {
  ProductAnalyticsRemoteDataSourceImpl({
    required this.apiService,
  });

  final ApiService apiService;

  PartnerHealthServicesApi get _api =>
      apiService.partnerHealthServicesApi;

  @override
  Future<ProductOverviewAnalytics> getOverviewAnalytics({
    required DashboardTimePeriod period,
  }) async {
    final response = await _api
        .partnerHealthServiceControllerGetOverviewAnalytics(
      period: period.value,
    );

    if (response == null) {
      throw Exception(
        'Failed to load overview analytics',
      );
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
      throw Exception(
        'Failed to load detail analytics',
      );
    }

    return _mapDetailResponse(response);
  }
}
```

---

## Step 2: Add DTO → Entity Mapping Functions

Place these **after the Mock class** (or as private top-level functions). Every `.toInt()` and `.toDouble()` call handles the `num` → `int`/`double` conversion required by the Freezed entities.

### Overview Mapping

```dart
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
    bookingMetrics: _mapBookingMetrics(
      dto.bookingMetrics,
    ),
    trendPoints: dto.trendPoints
        .map(_mapTrendPoint)
        .toList(),
    categoryPerformance: dto.categoryPerformance
        .map(_mapCategoryPerformance)
        .toList(),
    topServices: dto.topServices
        .map(_mapServicePerformance)
        .toList(),
  );
}
```

### Detail Mapping

```dart
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
    completionRateDelta:
        dto.completionRateDelta.toDouble(),
    averageRating: dto.averageRating.toDouble(),
    reviewCount: dto.reviewCount.toInt(),
    trendPoints: dto.trendPoints
        .map(_mapTrendPoint)
        .toList(),
    reviewDistribution: dto.reviewDistribution
        .map(_mapReviewBucket)
        .toList(),
    operationalMetrics: dto.operationalMetrics
        .map(_mapOperationalMetric)
        .toList(),
    peerRanking: dto.peerRanking
        .map(_mapServicePerformance)
        .toList(),
    alerts: dto.alerts
        .map(_mapAlert)
        .toList(),
  );
}
```

### Sub-Entity Mappers

```dart
ProductBookingMetricsSummary _mapBookingMetrics(
  AnalyticsBookingMetricsDto dto,
) {
  return ProductBookingMetricsSummary(
    totalBookings: dto.totalBookings.toInt(),
    delayedBookings: dto.delayedBookings.toInt(),
    delayThresholdMinutes:
        dto.delayThresholdMinutes.toInt(),
    pendingBookings: dto.pendingBookings.toInt(),
    completedBookings: dto.completedBookings.toInt(),
    statusBreakdown: dto.statusBreakdown
        .map(_mapStatusBreakdown)
        .toList(),
    alerts: dto.alerts.map(_mapAlert).toList(),
  );
}

ProductBookingStatusMetric _mapStatusBreakdown(
  BookingStatusBreakdownDto dto,
) {
  return ProductBookingStatusMetric(
    statusKey: dto.statusKey,
    label: dto.label,
    count: dto.count.toInt(),
    tone: _parseStatusTone(dto.statusKey),
  );
}

ProductTrendPoint _mapTrendPoint(
  AnalyticsTrendPointDto dto,
) {
  return ProductTrendPoint(
    label: dto.label,
    bookings: dto.bookings.toDouble(),
    revenue: dto.revenue.toDouble(),
  );
}

ProductCategoryPerformance _mapCategoryPerformance(
  AnalyticsCategoryPerformanceDto dto,
) {
  return ProductCategoryPerformance(
    categoryName: dto.categoryName,
    bookings: dto.bookings.toInt(),
    revenue: dto.revenue.toDouble(),
    averageRating: dto.averageRating.toDouble(),
  );
}

ProductServicePerformance _mapServicePerformance(
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

ProductReviewBucket _mapReviewBucket(
  AnalyticsReviewBucketDto dto,
) {
  return ProductReviewBucket(
    stars: dto.stars.toInt(),
    count: dto.count.toInt(),
  );
}

ProductOperationalMetric _mapOperationalMetric(
  AnalyticsOperationalMetricDto dto,
) {
  return ProductOperationalMetric(
    label: dto.label,
    value: dto.value,
    detail: dto.detail,
    // tone is AnalyticsOperationalMetricDtoToneEnum
    tone: _parseToneEnum(dto.tone.value),
  );
}

ProductAnalyticsAlert _mapAlert(
  AnalyticsAlertDto dto,
) {
  return ProductAnalyticsAlert(
    title: dto.title,
    detail: dto.detail,
    // tone is AnalyticsAlertDtoToneEnum
    tone: _parseToneEnum(dto.tone.value),
  );
}
```

### Tone Conversion Helpers

```dart
/// Converts the generated enum's .value string
/// to the domain AnalyticsStatusTone.
AnalyticsStatusTone _parseToneEnum(String value) {
  return switch (value) {
    'positive' => AnalyticsStatusTone.positive,
    'warning' => AnalyticsStatusTone.warning,
    'critical' => AnalyticsStatusTone.critical,
    _ => AnalyticsStatusTone.neutral,
  };
}

/// Derives tone from booking status key.
/// BookingStatusBreakdownDto has no tone field.
AnalyticsStatusTone _parseStatusTone(
  String statusKey,
) {
  return switch (statusKey) {
    'completed' => AnalyticsStatusTone.positive,
    'confirmed' => AnalyticsStatusTone.positive,
    'cancelled' => AnalyticsStatusTone.critical,
    'no_show' => AnalyticsStatusTone.warning,
    _ => AnalyticsStatusTone.neutral,
  };
}
```

---

## Step 3: Update the Provider Factory

Same file, bottom (~line 89). Change the constructor argument.

### Before

```dart
@riverpod
ProductAnalyticsRemoteDataSource
    productAnalyticsRemoteDataSource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  if (isMock) {
    return ProductAnalyticsRemoteDataSourceMock();
  }
  final repository = ref.read(productRepositoryProvider);
  return ProductAnalyticsRemoteDataSourceImpl(
    repository: repository,
  );
}
```

### After

```dart
@riverpod
ProductAnalyticsRemoteDataSource
    productAnalyticsRemoteDataSource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  if (isMock) {
    return ProductAnalyticsRemoteDataSourceMock();
  }
  final apiService = ref.read(apiServiceProvider);
  return ProductAnalyticsRemoteDataSourceImpl(
    apiService: apiService,
  );
}
```

---

## Step 4: Update Imports

### Remove these imports (no longer needed by Impl)

```dart
// Remove:
import 'dart:math' as math;
import '...product_impl.repository.dart';
import '...product.repository.dart';
```

### Add these imports

```dart
import 'package:admin_openapi/api.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
```

> [!NOTE]
> Keep the existing imports for `store.entity.dart`, `store.model.dart`, `product_mock_data.dart`, and `product.entity.dart` — they're still used by the Mock class and the provider factory.

---

## Step 5: Remove Dead Code

Delete all the synthetic computation helpers that the old Impl and Mock class used. These are the **top-level functions** after line ~100:

| Function | Purpose (now obsolete) |
|---|---|
| `_buildOverviewAnalytics()` | Computed overview from product list |
| `_buildDetailAnalytics()` | Computed detail from single product |
| `_buildBookingMetrics()` | Synthetic booking breakdown |
| `_buildTrendPoints()` | Deterministic chart data |
| `_buildCategoryPerformance()` | Category aggregation from products |
| `_servicePerformance()` | Per-service metric computation |
| `_averageRating()` | Average rating from product list |
| `_serviceReviewCount()` | Estimated review count |
| `_isActiveProduct()` | Active status check |
| `_periodScale()` / `_periodDivisor()` | Scale factors for synthetic data |
| `_requiresSpecificStaffWithoutAssignment()` | Staff allocation check |

> [!WARNING]
> **Before deleting**: Check if `ProductAnalyticsRemoteDataSourceMock` still calls any of these functions. If so, either keep them for mock use, or rewrite the mock to use hardcoded values.

---

## Step 6: Regenerate Providers

```bash
cd healytic_fe/admin_panel
dart run build_runner build --delete-conflicting-outputs
```

---

## Step 7: Verify

### Smoke Test Checklist

- [ ] App compiles (`make run-uat`)
- [ ] Products → Analytics tab → KPIs show real data
- [ ] Trend chart renders with correct time labels
- [ ] Category performance table is populated
- [ ] Top services list shows actual service names
- [ ] Click product → Detail analytics
- [ ] Review distribution shows 5-star histogram
- [ ] Operational metrics reflect product metadata
- [ ] Alerts appear only for relevant conditions
- [ ] Toggle mock mode → analytics still renders

---

## Type Conversion Quick Reference

> [!TIP]
> All OpenAPI `number` fields generate as Dart `num`. Use `.toInt()` for Freezed `int` fields and `.toDouble()` for `double` fields. This is the **#1 source of compile errors** during integration.

| Generated Type | Domain Type | Conversion |
|---|---|---|
| `num` | `int` | `.toInt()` |
| `num` | `double` | `.toDouble()` |
| `String` | `ProductId` | `ProductId(dto.productId)` |
| `AnalyticsAlertDtoToneEnum` | `AnalyticsStatusTone` | `_parseToneEnum(dto.tone.value)` |
| `AnalyticsOperationalMetricDtoToneEnum` | `AnalyticsStatusTone` | `_parseToneEnum(dto.tone.value)` |
| *(no tone on BookingStatusBreakdownDto)* | `AnalyticsStatusTone` | `_parseStatusTone(dto.statusKey)` |

---

## Files Changed Summary

```
ONLY THIS FILE CHANGES:
lib/features/partner/products/data/
  product_analytics_remote.datasource.dart

NO CHANGES NEEDED:
  domain/product_analytics.entity.dart
  domain/product_analytics.repository.dart
  data/product_analytics_impl.repository.dart
  presentation/providers/product_analytics.provider.dart
  presentation/widgets/product_analytics/*
```
