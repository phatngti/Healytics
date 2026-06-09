# user_openapi.model.SeedNotificationDto

## Load the model package
```dart
import 'package:user_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**key** | **String** | Unique lookup key | [optional] 
**userKey** | **String** | Key of a previously seeded user | [optional] 
**userEmail** | **String** | Email to look up the recipient user | [optional] 
**senderKey** | **String** | Key of a previously seeded sender account | [optional] 
**senderEmail** | **String** | Email to look up the sender account | [optional] 
**type** | **String** |  | 
**title** | **String** |  | 
**body** | **String** |  | 
**data** | [**Object**](.md) |  | [optional] 
**isRead** | **bool** |  | [optional] [default to false]
**isBroadcast** | **bool** |  | [optional] [default to false]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


