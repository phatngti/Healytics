# employee_openapi.model.AsyncCheckoutDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**userId** | **String** | User account UUID | 
**staffId** | **String** | Staff/employee UUID | 
**startTime** | **String** | Desired slot start time (ISO 8601) | 
**productId** | **String** | Product/service UUID | 
**idempotencyKey** | **String** | Idempotency key to prevent duplicate requests from AI retry | 
**webhookUrl** | **String** | Webhook URL to receive checkout result | [optional] 
**payLater** | **bool** | If true, booking is immediately CONFIRMED without requiring payment. The booking has no payment URL or expiry — suitable for in-person pay-later scenarios. | [optional] [default to false]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


