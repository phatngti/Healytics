# admin_openapi.api.UserDevicesApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userDeviceControllerRegisterDevice**](UserDevicesApi.md#userdevicecontrollerregisterdevice) | **POST** /user/devices | Register a device token for push notifications
[**userDeviceControllerUnregisterDevice**](UserDevicesApi.md#userdevicecontrollerunregisterdevice) | **DELETE** /user/devices/{token} | Unregister a device token (e.g. on logout)


# **userDeviceControllerRegisterDevice**
> userDeviceControllerRegisterDevice(registerDeviceDto)

Register a device token for push notifications

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserDevicesApi();
final registerDeviceDto = RegisterDeviceDto(); // RegisterDeviceDto |

try {
    api_instance.userDeviceControllerRegisterDevice(registerDeviceDto);
} catch (e) {
    print('Exception when calling UserDevicesApi->userDeviceControllerRegisterDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerDeviceDto** | [**RegisterDeviceDto**](RegisterDeviceDto.md)|  |

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userDeviceControllerUnregisterDevice**
> userDeviceControllerUnregisterDevice(token)

Unregister a device token (e.g. on logout)

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserDevicesApi();
final token = token_example; // String |

try {
    api_instance.userDeviceControllerUnregisterDevice(token);
} catch (e) {
    print('Exception when calling UserDevicesApi->userDeviceControllerUnregisterDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **token** | **String**|  |

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

