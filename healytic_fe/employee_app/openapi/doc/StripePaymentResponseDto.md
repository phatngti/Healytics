# employee_openapi.model.StripePaymentResponseDto

## Load the model package
```dart
import 'package:employee_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**paymentIntentId** | **String** | Stripe PaymentIntent ID | 
**clientSecret** | **String** | Client secret for on-device payment confirmation | 
**amount** | **num** | Payment amount in smallest currency unit (VND) | 
**currency** | **String** | ISO currency code (e.g., vnd) | 
**status** | **String** | Stripe PaymentIntent status | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


