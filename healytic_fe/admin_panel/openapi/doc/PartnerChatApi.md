# admin_openapi.api.PartnerChatApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnerChatControllerCreateConversation**](PartnerChatApi.md#partnerchatcontrollercreateconversation) | **POST** /partner/chat/conversations | Create a new conversation with a user
[**partnerChatControllerGetConversations**](PartnerChatApi.md#partnerchatcontrollergetconversations) | **GET** /partner/chat/conversations | List all conversations for the current partner
[**partnerChatControllerGetMessages**](PartnerChatApi.md#partnerchatcontrollergetmessages) | **GET** /partner/chat/conversations/{id}/messages | Get message history for a conversation (cursor-paginated)
[**partnerChatControllerMarkRead**](PartnerChatApi.md#partnerchatcontrollermarkread) | **POST** /partner/chat/conversations/{id}/read | Mark all messages in a conversation as read


# **partnerChatControllerCreateConversation**
> ConversationResponseDto partnerChatControllerCreateConversation(createConversationDto)

Create a new conversation with a user

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerChatApi();
final createConversationDto = CreateConversationDto(); // CreateConversationDto | 

try {
    final result = api_instance.partnerChatControllerCreateConversation(createConversationDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerChatApi->partnerChatControllerCreateConversation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createConversationDto** | [**CreateConversationDto**](CreateConversationDto.md)|  | 

### Return type

[**ConversationResponseDto**](ConversationResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerChatControllerGetConversations**
> List<ConversationResponseDto> partnerChatControllerGetConversations()

List all conversations for the current partner

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerChatApi();

try {
    final result = api_instance.partnerChatControllerGetConversations();
    print(result);
} catch (e) {
    print('Exception when calling PartnerChatApi->partnerChatControllerGetConversations: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ConversationResponseDto>**](ConversationResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerChatControllerGetMessages**
> partnerChatControllerGetMessages(id, beforeId, limit)

Get message history for a conversation (cursor-paginated)

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerChatApi();
final id = id_example; // String | 
final beforeId = beforeId_example; // String | Fetch messages older than this message ID (cursor)
final limit = 8.14; // num | Number of messages to return (max 50)

try {
    api_instance.partnerChatControllerGetMessages(id, beforeId, limit);
} catch (e) {
    print('Exception when calling PartnerChatApi->partnerChatControllerGetMessages: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **beforeId** | **String**| Fetch messages older than this message ID (cursor) | [optional] 
 **limit** | **num**| Number of messages to return (max 50) | [optional] [default to 50]

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerChatControllerMarkRead**
> partnerChatControllerMarkRead(id)

Mark all messages in a conversation as read

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerChatApi();
final id = id_example; // String | 

try {
    api_instance.partnerChatControllerMarkRead(id);
} catch (e) {
    print('Exception when calling PartnerChatApi->partnerChatControllerMarkRead: $e\n');
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

