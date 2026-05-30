# admin_openapi.api.UserNotificationsApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userNotificationControllerGetNotifications**](UserNotificationsApi.md#usernotificationcontrollergetnotifications) | **GET** /user/notifications | Get user notifications (paginated, cursor-based)
[**userNotificationControllerGetUnreadCount**](UserNotificationsApi.md#usernotificationcontrollergetunreadcount) | **GET** /user/notifications/unread-count | Get unread notification count
[**userNotificationControllerMarkAllRead**](UserNotificationsApi.md#usernotificationcontrollermarkallread) | **PATCH** /user/notifications/read-all | Mark all notifications as read
[**userNotificationControllerMarkRead**](UserNotificationsApi.md#usernotificationcontrollermarkread) | **PATCH** /user/notifications/{id}/read | Mark a specific notification as read


# **userNotificationControllerGetNotifications**
> userNotificationControllerGetNotifications(limit, cursor, type, isRead)

Get user notifications (paginated, cursor-based)

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserNotificationsApi();
final limit = 8.14; // num | Number of notifications to return
final cursor = cursor_example; // String | Cursor: fetch notifications before this ID (for pagination)
final type = type_example; // String | Filter by notification type
final isRead = true; // bool | Filter by read status

try {
    api_instance.userNotificationControllerGetNotifications(limit, cursor, type, isRead);
} catch (e) {
    print('Exception when calling UserNotificationsApi->userNotificationControllerGetNotifications: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **num**| Number of notifications to return | [optional] [default to 20]
 **cursor** | **String**| Cursor: fetch notifications before this ID (for pagination) | [optional]
 **type** | **String**| Filter by notification type | [optional]
 **isRead** | **bool**| Filter by read status | [optional]

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userNotificationControllerGetUnreadCount**
> userNotificationControllerGetUnreadCount()

Get unread notification count

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserNotificationsApi();

try {
    api_instance.userNotificationControllerGetUnreadCount();
} catch (e) {
    print('Exception when calling UserNotificationsApi->userNotificationControllerGetUnreadCount: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userNotificationControllerMarkAllRead**
> userNotificationControllerMarkAllRead()

Mark all notifications as read

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserNotificationsApi();

try {
    api_instance.userNotificationControllerMarkAllRead();
} catch (e) {
    print('Exception when calling UserNotificationsApi->userNotificationControllerMarkAllRead: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userNotificationControllerMarkRead**
> userNotificationControllerMarkRead(id)

Mark a specific notification as read

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserNotificationsApi();
final id = id_example; // String |

try {
    api_instance.userNotificationControllerMarkRead(id);
} catch (e) {
    print('Exception when calling UserNotificationsApi->userNotificationControllerMarkRead: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

