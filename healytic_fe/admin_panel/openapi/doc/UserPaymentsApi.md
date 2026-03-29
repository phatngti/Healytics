# admin_openapi.api.UserPaymentsApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userPaymentControllerCreateMoMoPayment**](UserPaymentsApi.md#userpaymentcontrollercreatemomopayment) | **POST** /user/payments/momo/{bookingId} | Create MoMo payment for booking
[**userPaymentControllerRefundMoMoPayment**](UserPaymentsApi.md#userpaymentcontrollerrefundmomopayment) | **POST** /user/payments/momo/{bookingId}/refund | Request MoMo refund for booking


# **userPaymentControllerCreateMoMoPayment**
> Object userPaymentControllerCreateMoMoPayment(bookingId, createMoMoPaymentDto)

Create MoMo payment for booking

### Example
```dart
import 'package:admin_openapi/api.dart';
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

# **userPaymentControllerRefundMoMoPayment**
> Object userPaymentControllerRefundMoMoPayment(bookingId, createMoMoRefundDto)

Request MoMo refund for booking

### Example
```dart
import 'package:admin_openapi/api.dart';
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

