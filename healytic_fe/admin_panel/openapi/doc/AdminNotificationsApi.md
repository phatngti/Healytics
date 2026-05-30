# admin_openapi.api.AdminNotificationsApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminNotificationControllerCreateBroadcast**](AdminNotificationsApi.md#adminnotificationcontrollercreatebroadcast) | **POST** /admin/notifications/broadcast | Create and send a system-wide broadcast notification
[**adminNotificationControllerGetBroadcasts**](AdminNotificationsApi.md#adminnotificationcontrollergetbroadcasts) | **GET** /admin/notifications/broadcasts | List sent broadcast notifications (audit)


# **adminNotificationControllerCreateBroadcast**
> NotificationResponseDto adminNotificationControllerCreateBroadcast(createBroadcastDto)

Create and send a system-wide broadcast notification

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminNotificationsApi();
final createBroadcastDto = CreateBroadcastDto(); // CreateBroadcastDto |

try {
    final result = api_instance.adminNotificationControllerCreateBroadcast(createBroadcastDto);
    print(result);
} catch (e) {
    print('Exception when calling AdminNotificationsApi->adminNotificationControllerCreateBroadcast: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createBroadcastDto** | [**CreateBroadcastDto**](CreateBroadcastDto.md)|  |

### Return type

[**NotificationResponseDto**](NotificationResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminNotificationControllerGetBroadcasts**
> List<NotificationResponseDto> adminNotificationControllerGetBroadcasts()

List sent broadcast notifications (audit)

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminNotificationsApi();

try {
    final result = api_instance.adminNotificationControllerGetBroadcasts();
    print(result);
} catch (e) {
    print('Exception when calling AdminNotificationsApi->adminNotificationControllerGetBroadcasts: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<NotificationResponseDto>**](NotificationResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

