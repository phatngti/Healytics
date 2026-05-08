# employee_openapi.api.HealthApi

## Load the API package
```dart
import 'package:employee_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**healthHealthGet**](HealthApi.md#healthhealthget) | **GET** /health | Health


# **healthHealthGet**
> Object healthHealthGet()

Health

### Example
```dart
import 'package:employee_openapi/api.dart';

final api_instance = HealthApi();

try {
    final result = api_instance.healthHealthGet();
    print(result);
} catch (e) {
    print('Exception when calling HealthApi->healthHealthGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Object**](Object.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

