# user_openapi.api.StripeApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**stripeWebhookControllerHandleStripeWebhook**](StripeApi.md#stripewebhookcontrollerhandlestripewebhook) | **POST** /stripe/webhook | Stripe webhook callback (server-to-server)


# **stripeWebhookControllerHandleStripeWebhook**
> stripeWebhookControllerHandleStripeWebhook(stripeSignature)

Stripe webhook callback (server-to-server)

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = StripeApi();
final stripeSignature = stripeSignature_example; // String |

try {
    api_instance.stripeWebhookControllerHandleStripeWebhook(stripeSignature);
} catch (e) {
    print('Exception when calling StripeApi->stripeWebhookControllerHandleStripeWebhook: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **stripeSignature** | **String**|  |

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

