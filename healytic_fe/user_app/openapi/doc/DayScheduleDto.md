# user_openapi.model.DayScheduleDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**date** | **String** | Date in YYYY-MM-DD format | 
**dayOfWeek** | **String** | Day of the week | 
**isWorkingDay** | **bool** | Whether the employee works on this day | 
**slots** | [**List<TimeSlotDto>**](TimeSlotDto.md) | Time slots for this day (empty if not working) | [default to const []]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


