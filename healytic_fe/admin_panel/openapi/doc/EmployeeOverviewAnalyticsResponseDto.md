# admin_openapi.model.EmployeeOverviewAnalyticsResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**totalEmployees** | **num** |  |
**activeEmployees** | **num** |  |
**onLeaveEmployees** | **num** |  |
**inactiveEmployees** | **num** |  |
**utilizationRate** | **num** | Aggregate utilization rate percentage |
**utilizationDelta** | **num** | % change vs previous period |
**averageRating** | **num** |  |
**ratingDelta** | **num** |  |
**reviewCount** | **num** |  |
**trendPoints** | [**List<EmployeeTrendPointDto>**](EmployeeTrendPointDto.md) |  | [default to const []]
**roleDistribution** | [**List<EmployeeRoleDistributionDto>**](EmployeeRoleDistributionDto.md) |  | [default to const []]
**topPerformers** | [**List<EmployeePerformanceSummaryDto>**](EmployeePerformanceSummaryDto.md) |  | [default to const []]
**complianceItems** | [**List<EmployeeComplianceItemDto>**](EmployeeComplianceItemDto.md) |  | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


