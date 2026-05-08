# employee_openapi.model.AppointmentResponseDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**serviceName** | **String** |  | 
**healthPartnerName** | **String** |  | 
**imageUrl** | **String** |  | 
**status** | [**AppointmentStatus**](AppointmentStatus.md) |  | 
**category** | **String** |  | 
**specialistName** | **String** |  | 
**specialistId** | **String** |  | 
**address** | **String** |  | 
**date** | **String** |  | 
**checkInTime** | **String** |  | 
**checkOutTime** | **String** |  | 
**duration** | **String** |  | 
**isReviewed** | **bool** | Whether the user has reviewed this appointment | 
**distanceKm** | **num** | Distance from user to clinic in kilometers (null if coordinates not provided) | 
**healthPartnerId** | **String** | Account ID of the health partner (vendor). Used for chat. | 
**serviceId** | **String** | Product/service ID for navigation to service details. | 
**paymentUrl** | **String** | Payment gateway checkout URL. Only present when status is pending_payment. | 
**paymentDeeplink** | **String** | Deep link to open payment app directly (mobile). Only present when status is pending_payment. | 
**paymentExpiresAt** | **String** | ISO 8601 timestamp when the payment link expires. Only present when status is pending_payment. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


