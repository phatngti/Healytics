# admin_openapi.model.WsSendMessagePayloadDto

## Load the model package
```dart
import 'package:admin_openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**conversationId** | **String** | Target conversation UUID | 
**content** | **String** | Message text content (max 5000 chars) | 
**messageType** | **String** | Message type | [optional] [default to 'text']
**clientMessageId** | **String** | Client-generated UUID for idempotent delivery (prevents duplicates on retry) | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


