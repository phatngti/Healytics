# user_openapi.api.ChatbotApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**chatbotControllerSendMessage**](ChatbotApi.md#chatbotcontrollersendmessage) | **POST** /chatbot/send | Send a message to the chatbot
[**chatbotControllerStreamChat**](ChatbotApi.md#chatbotcontrollerstreamchat) | **GET** /chatbot/stream/{conversationId} | Stream chatbot response via SSE


# **chatbotControllerSendMessage**
> SendMessageResponseDto chatbotControllerSendMessage(sendMessageDto)

Send a message to the chatbot

### Example
```dart
import 'package:user_openapi/api.dart';
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
> ChatMessageResponseDto chatbotControllerStreamChat(conversationId)

Stream chatbot response via SSE

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ChatbotApi();
final conversationId = conversationId_example; // String | 

try {
    final result = api_instance.chatbotControllerStreamChat(conversationId);
    print(result);
} catch (e) {
    print('Exception when calling ChatbotApi->chatbotControllerStreamChat: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **conversationId** | **String**|  | 

### Return type

[**ChatMessageResponseDto**](ChatMessageResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

