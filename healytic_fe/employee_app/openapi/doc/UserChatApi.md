# employee_openapi.api.UserChatApi

## Load the API package
```dart
import 'package:employee_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userChatControllerCreateConversation**](UserChatApi.md#userchatcontrollercreateconversation) | **POST** /user/chat/conversations | Create a new conversation with a health partner
[**userChatControllerGetConversations**](UserChatApi.md#userchatcontrollergetconversations) | **GET** /user/chat/conversations | List all conversations for the current user
[**userChatControllerGetMessages**](UserChatApi.md#userchatcontrollergetmessages) | **GET** /user/chat/conversations/{id}/messages | Get message history for a conversation (cursor-paginated)
[**userChatControllerMarkRead**](UserChatApi.md#userchatcontrollermarkread) | **POST** /user/chat/conversations/{id}/read | Mark all messages in a conversation as read


# **userChatControllerCreateConversation**
> ConversationResponseDto userChatControllerCreateConversation(createConversationDto)

Create a new conversation with a health partner

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserChatApi();
final createConversationDto = CreateConversationDto(); // CreateConversationDto | 

try {
    final result = api_instance.userChatControllerCreateConversation(createConversationDto);
    print(result);
} catch (e) {
    print('Exception when calling UserChatApi->userChatControllerCreateConversation: $e\n');
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

# **userChatControllerGetConversations**
> List<ConversationResponseDto> userChatControllerGetConversations()

List all conversations for the current user

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserChatApi();

try {
    final result = api_instance.userChatControllerGetConversations();
    print(result);
} catch (e) {
    print('Exception when calling UserChatApi->userChatControllerGetConversations: $e\n');
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

# **userChatControllerGetMessages**
> userChatControllerGetMessages(id, beforeId, limit)

Get message history for a conversation (cursor-paginated)

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserChatApi();
final id = id_example; // String | 
final beforeId = beforeId_example; // String | Fetch messages older than this message ID (cursor)
final limit = 8.14; // num | Number of messages to return (max 50)

try {
    api_instance.userChatControllerGetMessages(id, beforeId, limit);
} catch (e) {
    print('Exception when calling UserChatApi->userChatControllerGetMessages: $e\n');
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

# **userChatControllerMarkRead**
> userChatControllerMarkRead(id)

Mark all messages in a conversation as read

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserChatApi();
final id = id_example; // String | 

try {
    api_instance.userChatControllerMarkRead(id);
} catch (e) {
    print('Exception when calling UserChatApi->userChatControllerMarkRead: $e\n');
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

