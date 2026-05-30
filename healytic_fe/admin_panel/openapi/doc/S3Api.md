# admin_openapi.api.S3Api

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**s3ControllerDeleteFile**](S3Api.md#s3controllerdeletefile) | **DELETE** /s3/{key} | Delete file
[**s3ControllerGetFileUrl**](S3Api.md#s3controllergetfileurl) | **GET** /s3/{key} | Get file URL
[**s3ControllerPreSign**](S3Api.md#s3controllerpresign) | **POST** /s3/presign | Get presigned upload URL


# **s3ControllerDeleteFile**
> DeleteFileResponseDto s3ControllerDeleteFile(key)

Delete file

### Example
```dart
import 'package:admin_openapi/api.dart';

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

[**DeleteFileResponseDto**](DeleteFileResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **s3ControllerGetFileUrl**
> FileUrlResponseDto s3ControllerGetFileUrl(key)

Get file URL

### Example
```dart
import 'package:admin_openapi/api.dart';

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

[**FileUrlResponseDto**](FileUrlResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **s3ControllerPreSign**
> PresignResponseDto s3ControllerPreSign(presignRequestDto)

Get presigned upload URL

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = S3Api();
final presignRequestDto = PresignRequestDto(); // PresignRequestDto |

try {
    final result = api_instance.s3ControllerPreSign(presignRequestDto);
    print(result);
} catch (e) {
    print('Exception when calling S3Api->s3ControllerPreSign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **presignRequestDto** | [**PresignRequestDto**](PresignRequestDto.md)|  |

### Return type

[**PresignResponseDto**](PresignResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

