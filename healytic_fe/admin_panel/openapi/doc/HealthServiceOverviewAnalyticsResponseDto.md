# admin_openapi.model.HealthServiceOverviewAnalyticsResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**totalProducts** | **num** |  | 
**activeProducts** | **num** |  | 
**bookings** | **num** | Completed bookings in the selected period | 
**bookingsDelta** | **num** | % change vs previous period | 
**revenue** | **num** | Revenue in VND | 
**revenueDelta** | **num** |  | 
**averageRating** | **num** |  | 
**ratingDelta** | **num** |  | 
**reviewCount** | **num** |  | 
**bookingMetrics** | [**AnalyticsBookingMetricsDto**](AnalyticsBookingMetricsDto.md) |  | 
**trendPoints** | [**List<AnalyticsTrendPointDto>**](AnalyticsTrendPointDto.md) |  | [default to const []]
**categoryPerformance** | [**List<AnalyticsCategoryPerformanceDto>**](AnalyticsCategoryPerformanceDto.md) |  | [default to const []]
**topServices** | [**List<AnalyticsServicePerformanceDto>**](AnalyticsServicePerformanceDto.md) |  | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


