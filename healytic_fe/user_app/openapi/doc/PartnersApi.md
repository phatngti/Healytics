# user_openapi.api.PartnersApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnersControllerGetBusinessServices**](PartnersApi.md#partnerscontrollergetbusinessservices) | **GET** /partners/business-services | Get all business services


# **partnersControllerGetBusinessServices**
> BusinessServicesResponseDto partnersControllerGetBusinessServices()

Get all business services

Returns list of all business services with Vietnamese labels for dropdown selection

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = PartnersApi();

try {
    final result = api_instance.partnersControllerGetBusinessServices();
    print(result);
} catch (e) {
    print('Exception when calling PartnersApi->partnersControllerGetBusinessServices: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BusinessServicesResponseDto**](BusinessServicesResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

