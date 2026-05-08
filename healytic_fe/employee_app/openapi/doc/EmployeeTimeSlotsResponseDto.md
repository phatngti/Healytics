# employee_openapi.model.EmployeeTimeSlotsResponseDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**employeeId** | **String** | Employee ID | 
**employeeName** | **String** | Employee full name | 
**slotDurationMinutes** | **num** | Slot duration in minutes | 
**schedule** | [**List<DayScheduleDto>**](DayScheduleDto.md) | Day-by-day schedule with time slots | [default to const []]
**rangeStart** | **String** | Start of the schedule range | 
**rangeEnd** | **String** | End of the schedule range | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


