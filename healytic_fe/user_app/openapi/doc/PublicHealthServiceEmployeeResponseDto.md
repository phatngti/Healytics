# user_openapi.model.PublicHealthServiceEmployeeResponseDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Employee (specialist) ID | 
**eligibilityId** | **String** | product_employee_eligibility surrogate PK for this employee–service pair | 
**name** | **String** |  | 
**role** | **String** |  | 
**imageUrl** | [**Object**](.md) |  | [optional] 
**isSelected** | **bool** |  | 
**quote** | [**Object**](.md) |  | [optional] 
**degrees** | [**Object**](.md) |  | [optional] 
**languages** | [**Object**](.md) |  | [optional] 
**experience** | [**Object**](.md) |  | [optional] 
**specializations** | **List<String>** |  | [optional] [default to const []]
**bio** | [**Object**](.md) |  | [optional] 
**daySchedules** | [**List<PublicHealthServiceEmployeeDayScheduleDto>**](PublicHealthServiceEmployeeDayScheduleDto.md) |  | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


