# admin_openapi.model.CartItemResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**serviceId** | **String** |  |
**serviceName** | **String** |  |
**serviceImageUrl** | **String** |  |
**price** | **String** |  |
**priceAmount** | **num** |  |
**clinicId** | **String** |  |
**clinicName** | **String** |  |
**clinicAddress** | **String** |  |
**clinicImageUrl** | [**Object**](.md) |  | [optional]
**employeeId** | **String** |  |
**employeeName** | **String** |  |
**employeeRole** | **String** |  |
**employeeAvatarUrl** | [**Object**](.md) |  | [optional]
**timeSlot** | [**DateTime**](DateTime.md) | Selected time slot for the appointment |
**isTimeSlotAvailable** | **bool** | Whether the selected time slot is still available in the employee schedule. |
**status** | **String** | Cart item status: ACTIVE, BOOKED, or DELETED |
**createdAt** | [**DateTime**](DateTime.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


