# user_openapi.api.RecommenderApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**recommendChatbotRecommenderChatbotPost**](RecommenderApi.md#recommendchatbotrecommenderchatbotpost) | **POST** /recommender/chatbot | Recommend Chatbot
[**recommendHomeRecommenderHomePost**](RecommenderApi.md#recommendhomerecommenderhomepost) | **POST** /recommender/home | Recommend Home


# **recommendChatbotRecommenderChatbotPost**
> ChatbotRecommendationResponse recommendChatbotRecommenderChatbotPost(chatbotRecommenderRequest)

Recommend Chatbot

Chatbot recommender (non-stream).

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = RecommenderApi();
final chatbotRecommenderRequest = ChatbotRecommenderRequest(); // ChatbotRecommenderRequest | 

try {
    final result = api_instance.recommendChatbotRecommenderChatbotPost(chatbotRecommenderRequest);
    print(result);
} catch (e) {
    print('Exception when calling RecommenderApi->recommendChatbotRecommenderChatbotPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **chatbotRecommenderRequest** | [**ChatbotRecommenderRequest**](ChatbotRecommenderRequest.md)|  | 

### Return type

[**ChatbotRecommendationResponse**](ChatbotRecommendationResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recommendHomeRecommenderHomePost**
> RecommendationResponse recommendHomeRecommenderHomePost(homeRecommenderRequest)

Recommend Home

Home recommender (non-stream).

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = RecommenderApi();
final homeRecommenderRequest = HomeRecommenderRequest(); // HomeRecommenderRequest | 

try {
    final result = api_instance.recommendHomeRecommenderHomePost(homeRecommenderRequest);
    print(result);
} catch (e) {
    print('Exception when calling RecommenderApi->recommendHomeRecommenderHomePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **homeRecommenderRequest** | [**HomeRecommenderRequest**](HomeRecommenderRequest.md)|  | 

### Return type

[**RecommendationResponse**](RecommendationResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

