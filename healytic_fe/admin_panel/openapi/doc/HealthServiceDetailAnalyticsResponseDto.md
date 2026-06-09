# admin_openapi.model.HealthServiceDetailAnalyticsResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**productId** | **String** |  | 
**bookings** | **num** |  | 
**bookingsDelta** | **num** |  | 
**revenue** | **num** | Revenue in VND | 
**revenueDelta** | **num** |  | 
**completionRate** | **num** | % of bookings that completed | 
**completionRateDelta** | **num** |  | 
**averageRating** | **num** |  | 
**reviewCount** | **num** |  | 
**trendPoints** | [**List<AnalyticsTrendPointDto>**](AnalyticsTrendPointDto.md) |  | [default to const []]
**reviewDistribution** | [**List<AnalyticsReviewBucketDto>**](AnalyticsReviewBucketDto.md) |  | [default to const []]
**operationalMetrics** | [**List<AnalyticsOperationalMetricDto>**](AnalyticsOperationalMetricDto.md) |  | [default to const []]
**peerRanking** | [**List<AnalyticsServicePerformanceDto>**](AnalyticsServicePerformanceDto.md) |  | [default to const []]
**alerts** | [**List<AnalyticsAlertDto>**](AnalyticsAlertDto.md) |  | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


