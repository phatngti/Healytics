# user_openapi.api.S3Api

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**s3ControllerDeleteFile**](S3Api.md#s3controllerdeletefile) | **DELETE** /s3/{key} | Delete file
[**s3ControllerGetFileUrl**](S3Api.md#s3controllergetfileurl) | **GET** /s3/{key} | Get file url
[**s3ControllerPreSign**](S3Api.md#s3controllerpresign) | **POST** /s3/presign | Get presigned upload url


# **s3ControllerDeleteFile**
> S3ControllerDeleteFile200Response s3ControllerDeleteFile(key)

Delete file

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = S3Api();
final key = key_example; // String | File key

try {
    final result = api_instance.s3ControllerDeleteFile(key);
    print(result);
} catch (e) {
    print('Exception when calling S3Api->s3ControllerDeleteFile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **key** | **String**| File key | 

### Return type

[**S3ControllerDeleteFile200Response**](S3ControllerDeleteFile200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **s3ControllerGetFileUrl**
> S3ControllerGetFileUrl200Response s3ControllerGetFileUrl(key)

Get file url

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = S3Api();
final key = key_example; // String | File key

try {
    final result = api_instance.s3ControllerGetFileUrl(key);
    print(result);
} catch (e) {
    print('Exception when calling S3Api->s3ControllerGetFileUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **key** | **String**| File key | 

### Return type

[**S3ControllerGetFileUrl200Response**](S3ControllerGetFileUrl200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **s3ControllerPreSign**
> S3ControllerPreSign201Response s3ControllerPreSign(s3ControllerPreSignRequest)

Get presigned upload url

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = S3Api();
final s3ControllerPreSignRequest = S3ControllerPreSignRequest(); // S3ControllerPreSignRequest | 

try {
    final result = api_instance.s3ControllerPreSign(s3ControllerPreSignRequest);
    print(result);
} catch (e) {
    print('Exception when calling S3Api->s3ControllerPreSign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **s3ControllerPreSignRequest** | [**S3ControllerPreSignRequest**](S3ControllerPreSignRequest.md)|  | 

### Return type

[**S3ControllerPreSign201Response**](S3ControllerPreSign201Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

