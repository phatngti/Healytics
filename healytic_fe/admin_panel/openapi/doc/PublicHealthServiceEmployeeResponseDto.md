# admin_openapi.model.PublicHealthServiceEmployeeResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Employee (specialist) ID | 
**eligibilityId** | **String** | product_employee_eligibility surrogate PK for this employee–service pair | 
**name** | **String** |  | 
**role** | **String** |  | 
**imageUrl** | **String** |  | [optional] 
**isSelected** | **bool** |  | 
**quote** | **String** |  | [optional] 
**degrees** | **String** |  | [optional] 
**languages** | **String** |  | [optional] 
**experience** | **String** |  | [optional] 
**specializations** | **List<String>** |  | [optional] [default to const []]
**bio** | **String** |  | [optional] 
**daySchedules** | [**List<PublicHealthServiceEmployeeDayScheduleDto>**](PublicHealthServiceEmployeeDayScheduleDto.md) |  | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


