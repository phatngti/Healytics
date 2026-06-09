# admin_openapi.model.BookingStatusChangeEventDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**eventId** | **String** |  | 
**bookingId** | **String** |  | 
**status** | [**PublicBookingStatus**](PublicBookingStatus.md) |  | 
**persistedStatus** | [**BookingStatus**](BookingStatus.md) |  | 
**previousStatus** | [**BookingStatus**](BookingStatus.md) |  | 
**userId** | **String** |  | 
**partnerId** | **String** |  | [optional] 
**specialistId** | **String** |  | 
**changedBy** | [**BookingStatusChangedByDto**](BookingStatusChangedByDto.md) |  | 
**occurredAt** | [**DateTime**](DateTime.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


