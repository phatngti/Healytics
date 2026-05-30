# user_openapi.api.UserPaymentsApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userPaymentControllerConfirmMoMoReturn**](UserPaymentsApi.md#userpaymentcontrollerconfirmmomoreturn) | **POST** /user/payments/momo/{bookingId}/return | Confirm signed MoMo return payload for booking
[**userPaymentControllerConfirmStripeSetupIntent**](UserPaymentsApi.md#userpaymentcontrollerconfirmstripesetupintent) | **POST** /user/payments/stripe/setup-intents/{setupIntentId}/confirm | Confirm and persist a saved Stripe card
[**userPaymentControllerCreateMoMoPayment**](UserPaymentsApi.md#userpaymentcontrollercreatemomopayment) | **POST** /user/payments/momo/{bookingId} | Create MoMo payment for booking
[**userPaymentControllerCreateStripePayment**](UserPaymentsApi.md#userpaymentcontrollercreatestripepayment) | **POST** /user/payments/stripe/{bookingId} | Create Stripe payment for booking (card)
[**userPaymentControllerCreateStripeSetupIntent**](UserPaymentsApi.md#userpaymentcontrollercreatestripesetupintent) | **POST** /user/payments/stripe/setup-intents | Create Stripe SetupIntent for adding a card
[**userPaymentControllerDeleteCard**](UserPaymentsApi.md#userpaymentcontrollerdeletecard) | **DELETE** /user/payments/cards/{cardId} | Delete a saved payment card
[**userPaymentControllerListCards**](UserPaymentsApi.md#userpaymentcontrollerlistcards) | **GET** /user/payments/cards | List saved payment cards
[**userPaymentControllerRefundMoMoPayment**](UserPaymentsApi.md#userpaymentcontrollerrefundmomopayment) | **POST** /user/payments/momo/{bookingId}/refund | Request MoMo refund for booking
[**userPaymentControllerRefundStripePayment**](UserPaymentsApi.md#userpaymentcontrollerrefundstripepayment) | **POST** /user/payments/stripe/{bookingId}/refund | Request Stripe refund for booking
[**userPaymentControllerSetDefaultCard**](UserPaymentsApi.md#userpaymentcontrollersetdefaultcard) | **PATCH** /user/payments/cards/{cardId}/default | Set a saved card as the default card


# **userPaymentControllerConfirmMoMoReturn**
> userPaymentControllerConfirmMoMoReturn(bookingId, body)

Confirm signed MoMo return payload for booking

### Example
```dart
import 'package:user_openapi/api.dart';
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
    api_instance.userPaymentControllerConfirmMoMoReturn(bookingId, body);
} catch (e) {
    print('Exception when calling UserPaymentsApi->userPaymentControllerConfirmMoMoReturn: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  |
 **body** | **Object**|  |

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPaymentControllerConfirmStripeSetupIntent**
> SavedPaymentCardDto userPaymentControllerConfirmStripeSetupIntent(setupIntentId, confirmStripeSetupIntentDto)

Confirm and persist a saved Stripe card

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserPaymentsApi();
final setupIntentId = setupIntentId_example; // String |
final confirmStripeSetupIntentDto = ConfirmStripeSetupIntentDto(); // ConfirmStripeSetupIntentDto |

try {
    final result = api_instance.userPaymentControllerConfirmStripeSetupIntent(setupIntentId, confirmStripeSetupIntentDto);
    print(result);
} catch (e) {
    print('Exception when calling UserPaymentsApi->userPaymentControllerConfirmStripeSetupIntent: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **setupIntentId** | **String**|  |
 **confirmStripeSetupIntentDto** | [**ConfirmStripeSetupIntentDto**](ConfirmStripeSetupIntentDto.md)|  |

### Return type

[**SavedPaymentCardDto**](SavedPaymentCardDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPaymentControllerCreateMoMoPayment**
> Object userPaymentControllerCreateMoMoPayment(bookingId, createMoMoPaymentDto)

Create MoMo payment for booking

### Example
```dart
import 'package:user_openapi/api.dart';
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
> StripePaymentResponseDto userPaymentControllerCreateStripePayment(bookingId, createStripePaymentDto)

Create Stripe payment for booking (card)

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserPaymentsApi();
final bookingId = bookingId_example; // String |
final createStripePaymentDto = CreateStripePaymentDto(); // CreateStripePaymentDto |

try {
    final result = api_instance.userPaymentControllerCreateStripePayment(bookingId, createStripePaymentDto);
    print(result);
} catch (e) {
    print('Exception when calling UserPaymentsApi->userPaymentControllerCreateStripePayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**|  |
 **createStripePaymentDto** | [**CreateStripePaymentDto**](CreateStripePaymentDto.md)|  |

### Return type

[**StripePaymentResponseDto**](StripePaymentResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPaymentControllerCreateStripeSetupIntent**
> CreateStripeSetupIntentResponseDto userPaymentControllerCreateStripeSetupIntent()

Create Stripe SetupIntent for adding a card

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserPaymentsApi();

try {
    final result = api_instance.userPaymentControllerCreateStripeSetupIntent();
    print(result);
} catch (e) {
    print('Exception when calling UserPaymentsApi->userPaymentControllerCreateStripeSetupIntent: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CreateStripeSetupIntentResponseDto**](CreateStripeSetupIntentResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPaymentControllerDeleteCard**
> List<SavedPaymentCardDto> userPaymentControllerDeleteCard(cardId)

Delete a saved payment card

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserPaymentsApi();
final cardId = cardId_example; // String |

try {
    final result = api_instance.userPaymentControllerDeleteCard(cardId);
    print(result);
} catch (e) {
    print('Exception when calling UserPaymentsApi->userPaymentControllerDeleteCard: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cardId** | **String**|  |

### Return type

[**List<SavedPaymentCardDto>**](SavedPaymentCardDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPaymentControllerListCards**
> List<SavedPaymentCardDto> userPaymentControllerListCards()

List saved payment cards

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserPaymentsApi();

try {
    final result = api_instance.userPaymentControllerListCards();
    print(result);
} catch (e) {
    print('Exception when calling UserPaymentsApi->userPaymentControllerListCards: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<SavedPaymentCardDto>**](SavedPaymentCardDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userPaymentControllerRefundMoMoPayment**
> Object userPaymentControllerRefundMoMoPayment(bookingId, createMoMoRefundDto)

Request MoMo refund for booking

### Example
```dart
import 'package:user_openapi/api.dart';
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
import 'package:user_openapi/api.dart';
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

# **userPaymentControllerSetDefaultCard**
> SavedPaymentCardDto userPaymentControllerSetDefaultCard(cardId)

Set a saved card as the default card

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserPaymentsApi();
final cardId = cardId_example; // String |

try {
    final result = api_instance.userPaymentControllerSetDefaultCard(cardId);
    print(result);
} catch (e) {
    print('Exception when calling UserPaymentsApi->userPaymentControllerSetDefaultCard: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cardId** | **String**|  |

### Return type

[**SavedPaymentCardDto**](SavedPaymentCardDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

