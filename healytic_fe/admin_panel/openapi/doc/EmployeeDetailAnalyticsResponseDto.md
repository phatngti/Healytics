# admin_openapi.model.EmployeeDetailAnalyticsResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**employeeId** | **String** |  | 
**completedSessions** | **num** |  | 
**sessionsDelta** | **num** | % change vs previous period | 
**contributionValue** | **num** | Contribution value in VND | 
**contributionDelta** | **num** |  | 
**utilizationRate** | **num** |  | 
**utilizationDelta** | **num** |  | 
**averageRating** | **num** |  | 
**reviewCount** | **num** |  | 
**trendPoints** | [**List<EmployeeTrendPointDto>**](EmployeeTrendPointDto.md) |  | [default to const []]
**mixMetrics** | [**List<EmployeeMixMetricDto>**](EmployeeMixMetricDto.md) |  | [default to const []]
**scheduleLoad** | [**List<EmployeeScheduleLoadDto>**](EmployeeScheduleLoadDto.md) |  | [default to const []]
**qualityMetrics** | [**List<EmployeeQualityMetricDto>**](EmployeeQualityMetricDto.md) |  | [default to const []]
**complianceItems** | [**List<EmployeeComplianceItemDto>**](EmployeeComplianceItemDto.md) |  | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


