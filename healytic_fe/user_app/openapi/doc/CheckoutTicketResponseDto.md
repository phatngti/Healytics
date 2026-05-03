# user_openapi.model.CheckoutTicketResponseDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Ticket ID (same as ticket_id in webhook) | 
**userId** | **String** |  | 
**staffId** | **String** |  | 
**startTime** | [**DateTime**](DateTime.md) |  | 
**status** | **String** |  | 
**idempotencyKey** | **String** |  | 
**bookingId** | **String** | Booking ID when checkout succeeds | [optional] 
**errorMessage** | **String** | Error message when checkout fails | [optional] 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**updatedAt** | [**DateTime**](DateTime.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


