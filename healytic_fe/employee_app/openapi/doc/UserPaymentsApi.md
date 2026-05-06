# employee_openapi.api.UserPaymentsApi

## Load the API package
```dart
import 'package:employee_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userPaymentControllerCreateMoMoPayment**](UserPaymentsApi.md#userpaymentcontrollercreatemomopayment) | **POST** /user/payments/momo/{bookingId} | Create MoMo payment for booking
[**userPaymentControllerCreateStripePayment**](UserPaymentsApi.md#userpaymentcontrollercreatestripepayment) | **POST** /user/payments/stripe/{bookingId} | Create Stripe payment for booking (card)
[**userPaymentControllerRefundMoMoPayment**](UserPaymentsApi.md#userpaymentcontrollerrefundmomopayment) | **POST** /user/payments/momo/{bookingId}/refund | Request MoMo refund for booking
[**userPaymentControllerRefundStripePayment**](UserPaymentsApi.md#userpaymentcontrollerrefundstripepayment) | **POST** /user/payments/stripe/{bookingId}/refund | Request Stripe refund for booking


# **userPaymentControllerCreateMoMoPayment**
> Object userPaymentControllerCreateMoMoPayment(bookingId, createMoMoPaymentDto)

Create MoMo payment for booking

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserPaymentsApi();
final bookingId = bookingId_example; // String | 
final createMoMoPaymentDto = CreateMoMoPaymentDto(); // CreateMoMoPaymentDto | 

try {
    final result = api_instance.userPaymentControllerCreateMoMoPayment(bookingId, createMoMoPaymentDto);
    print(result);
} catch (e) {
    print('Exception when calling UserPaymentsApi->userPaymentControllerCreateMoMoPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **createMoMoPaymentDto** | [**CreateMoMoPaymentDto**](CreateMoMoPaymentDto.md)|  | 

### Return type

[**Object**](Object.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPaymentControllerCreateStripePayment**
> StripePaymentResponseDto userPaymentControllerCreateStripePayment(bookingId, body)

Create Stripe payment for booking (card)

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserPaymentsApi();
final bookingId = bookingId_example; // String | 
final body = Object(); // Object | 

try {
    final result = api_instance.userPaymentControllerCreateStripePayment(bookingId, body);
    print(result);
} catch (e) {
    print('Exception when calling UserPaymentsApi->userPaymentControllerCreateStripePayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **body** | **Object**|  | 

### Return type

[**StripePaymentResponseDto**](StripePaymentResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPaymentControllerRefundMoMoPayment**
> Object userPaymentControllerRefundMoMoPayment(bookingId, createMoMoRefundDto)

Request MoMo refund for booking

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserPaymentsApi();
final bookingId = bookingId_example; // String | 
final createMoMoRefundDto = CreateMoMoRefundDto(); // CreateMoMoRefundDto | 

try {
    final result = api_instance.userPaymentControllerRefundMoMoPayment(bookingId, createMoMoRefundDto);
    print(result);
} catch (e) {
    print('Exception when calling UserPaymentsApi->userPaymentControllerRefundMoMoPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 
 **createMoMoRefundDto** | [**CreateMoMoRefundDto**](CreateMoMoRefundDto.md)|  | 

### Return type

[**Object**](Object.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPaymentControllerRefundStripePayment**
> StripeRefundResponseDto userPaymentControllerRefundStripePayment(bookingId)

Request Stripe refund for booking

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserPaymentsApi();
final bookingId = bookingId_example; // String | 

try {
    final result = api_instance.userPaymentControllerRefundStripePayment(bookingId);
    print(result);
} catch (e) {
    print('Exception when calling UserPaymentsApi->userPaymentControllerRefundStripePayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  | 

### Return type

[**StripeRefundResponseDto**](StripeRefundResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

