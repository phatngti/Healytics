# employee_openapi.api.MomoApi

## Load the API package
```dart
import 'package:employee_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**moMoControllerHandleMoMoIPN**](MomoApi.md#momocontrollerhandlemomoipn) | **POST** /momo/ipn | MoMo IPN callback (server-to-server)


# **moMoControllerHandleMoMoIPN**
> moMoControllerHandleMoMoIPN(body)

MoMo IPN callback (server-to-server)

### Example
```dart
import 'package:employee_openapi/api.dart';

final api_instance = MomoApi();
final body = Object(); // Object | 

try {
    api_instance.moMoControllerHandleMoMoIPN(body);
} catch (e) {
    print('Exception when calling MomoApi->moMoControllerHandleMoMoIPN: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | **Object**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

