# employee_openapi.model.AddToCartDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**serviceId** | **String** | UUID of the health service | 
**employeeId** | **String** | UUID of the assigned employee (doctor or therapist) | [optional] 
**timeSlot** | **String** | Desired time slot in ISO 8601 datetime format | 
**autoAssignStaff** | **bool** | If true, backend selects the best eligible available specialist for this service and time slot. | [optional] [default to false]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


