# admin_openapi.model.NotificationResponseDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Notification UUID |
**type** | **String** | The type of notification |
**title** | **String** | Notification title |
**body** | **String** | Notification body text |
**data** | [**Object**](.md) | Deep-link data for frontend routing | [optional]
**isRead** | **bool** | Whether the notification has been read |
**readAt** | [**Object**](.md) | When the notification was read | [optional]
**isBroadcast** | **bool** | Whether this is a system-wide broadcast |
**createdAt** | [**DateTime**](DateTime.md) | When the notification was created |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


