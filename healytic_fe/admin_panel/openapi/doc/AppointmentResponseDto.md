# admin_openapi.model.AppointmentResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | 
**serviceName** | **String** |  | 
**healthPartnerName** | **String** |  | 
**imageUrl** | **String** |  | 
**status** | **String** |  | 
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
**healthPartnerId** | [**Object**](.md) | Account ID of the health partner (vendor). Used for chat. | 
**serviceId** | [**Object**](.md) | Product/service ID for navigation to service details. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


