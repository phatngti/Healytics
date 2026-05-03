# user_openapi.model.AsyncCheckoutDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
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

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


