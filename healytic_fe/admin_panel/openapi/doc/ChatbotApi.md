# admin_openapi.api.ChatbotApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**chatbotControllerListConversations**](ChatbotApi.md#chatbotcontrollerlistconversations) | **GET** /chatbot/conversations | Get paginated list of conversations
[**chatbotControllerSendMessage**](ChatbotApi.md#chatbotcontrollersendmessage) | **POST** /chatbot/send | Send a message to the chatbot
[**chatbotControllerStreamChat**](ChatbotApi.md#chatbotcontrollerstreamchat) | **GET** /chatbot/stream/{conversationId} | Stream chatbot response via SSE


# **chatbotControllerListConversations**
> ConversationListResponseDto chatbotControllerListConversations(page, limit)

Get paginated list of conversations

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ChatbotApi();
final page = 1; // num | Page number (1-indexed)
final limit = 10; // num | Number of items per page

try {
    final result = api_instance.chatbotControllerListConversations(page, limit);
    print(result);
} catch (e) {
    print('Exception when calling ChatbotApi->chatbotControllerListConversations: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **num**| Page number (1-indexed) | [optional] [default to 1]
 **limit** | **num**| Number of items per page | [optional] [default to 10]

### Return type

[**ConversationListResponseDto**](ConversationListResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **chatbotControllerSendMessage**
> SendMessageResponseDto chatbotControllerSendMessage(sendMessageDto)

Send a message to the chatbot

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ChatbotApi();
final sendMessageDto = SendMessageDto(); // SendMessageDto | 

try {
    final result = api_instance.chatbotControllerSendMessage(sendMessageDto);
    print(result);
} catch (e) {
    print('Exception when calling ChatbotApi->chatbotControllerSendMessage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sendMessageDto** | [**SendMessageDto**](SendMessageDto.md)|  | 

### Return type

[**SendMessageResponseDto**](SendMessageResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **chatbotControllerStreamChat**
> chatbotControllerStreamChat(conversationId)

Stream chatbot response via SSE

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ChatbotApi();
final conversationId = conversationId_example; // String | 

try {
    api_instance.chatbotControllerStreamChat(conversationId);
} catch (e) {
    print('Exception when calling ChatbotApi->chatbotControllerStreamChat: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **conversationId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

