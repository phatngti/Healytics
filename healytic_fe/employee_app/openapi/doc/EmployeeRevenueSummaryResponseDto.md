# employee_openapi.model.EmployeeRevenueSummaryResponseDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**totalRevenue** | **num** | Total revenue from completed appointments | 
**totalCommission** | **num** | Total commission deducted | 
**netEarnings** | **num** | Net earnings after commission | 
**completedAppointments** | **num** | Number of completed appointments | 
**canceledAppointments** | **num** | Number of canceled appointments | 
**period** | [**EmployeeRevenuePeriod**](EmployeeRevenuePeriod.md) |  | 
**periodStart** | [**DateTime**](DateTime.md) | Start of the aggregation period | 
**periodEnd** | [**DateTime**](DateTime.md) | End of the aggregation period | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


