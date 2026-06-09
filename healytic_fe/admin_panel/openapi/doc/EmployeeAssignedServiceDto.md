# admin_openapi.model.EmployeeAssignedServiceDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Assigned service/product ID | 
**name** | **String** | Service name | 
**status** | [**HealthServiceStatus**](HealthServiceStatus.md) |  | 
**basePrice** | **num** | Base price in service currency | 
**salePrice** | **num** | Sale price in service currency, when configured | [optional] 
**currency** | **String** | Currency code | 
**durationMinutes** | **num** | Service duration in minutes | [optional] 
**categoryName** | **String** | Service category name | [optional] 
**imageUrl** | **String** | Preferred service image URL | [optional] 
**isPrimary** | **bool** | Whether this employee is primary for this service | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


