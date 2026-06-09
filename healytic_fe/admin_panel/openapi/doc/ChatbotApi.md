# admin_openapi.api.ChatbotApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**generativeAiStreamGenerativeAiStreamPost**](ChatbotApi.md#generativeaistreamgenerativeaistreampost) | **POST** /generative_ai/stream | Generative Ai Stream
[**getConversationsChatbotConversationsGet**](ChatbotApi.md#getconversationschatbotconversationsget) | **GET** /chatbot/conversations | Get Conversations
[**getMessagesChatbotConversationsConversationIdMessagesGet**](ChatbotApi.md#getmessageschatbotconversationsconversationidmessagesget) | **GET** /chatbot/conversations/{conversation_id}/messages | Get Messages


# **generativeAiStreamGenerativeAiStreamPost**
> Object generativeAiStreamGenerativeAiStreamPost(chatbotRequest)

Generative Ai Stream

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = ChatbotApi();
final chatbotRequest = ChatbotRequest(); // ChatbotRequest | 

try {
    final result = api_instance.generativeAiStreamGenerativeAiStreamPost(chatbotRequest);
    print(result);
} catch (e) {
    print('Exception when calling ChatbotApi->generativeAiStreamGenerativeAiStreamPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **chatbotRequest** | [**ChatbotRequest**](ChatbotRequest.md)|  | 

### Return type

[**Object**](Object.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getConversationsChatbotConversationsGet**
> ConversationsPageResponse getConversationsChatbotConversationsGet(userId, page, limit)

Get Conversations

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = ChatbotApi();
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Account / user UUID
final page = 56; // int | 
final limit = 56; // int | 

try {
    final result = api_instance.getConversationsChatbotConversationsGet(userId, page, limit);
    print(result);
} catch (e) {
    print('Exception when calling ChatbotApi->getConversationsChatbotConversationsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**| Account / user UUID | 
 **page** | **int**|  | [optional] [default to 1]
 **limit** | **int**|  | [optional] [default to 10]

### Return type

[**ConversationsPageResponse**](ConversationsPageResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMessagesChatbotConversationsConversationIdMessagesGet**
> MessagesPageResponse getMessagesChatbotConversationsConversationIdMessagesGet(conversationId, userId, page, limit)

Get Messages

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = ChatbotApi();
final conversationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Must match conversation owner
final page = 56; // int | 
final limit = 56; // int | 

try {
    final result = api_instance.getMessagesChatbotConversationsConversationIdMessagesGet(conversationId, userId, page, limit);
    print(result);
} catch (e) {
    print('Exception when calling ChatbotApi->getMessagesChatbotConversationsConversationIdMessagesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **conversationId** | **String**|  | 
 **userId** | **String**| Must match conversation owner | [optional] 
 **page** | **int**|  | [optional] [default to 1]
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**MessagesPageResponse**](MessagesPageResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

