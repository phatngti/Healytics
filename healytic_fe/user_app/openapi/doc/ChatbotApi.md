# user_openapi.api.ChatbotApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**generativeAiStreamGenerativeAiStreamPost**](ChatbotApi.md#generativeaistreamgenerativeaistreampost) | **POST** /generative_ai/stream | Generative Ai Stream


# **generativeAiStreamGenerativeAiStreamPost**
> Object generativeAiStreamGenerativeAiStreamPost(chatbotRequest)

Generative Ai Stream

### Example
```dart
import 'package:user_openapi/api.dart';

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

