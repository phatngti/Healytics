# admin_openapi.api.AIRecommendationsApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**aiServiceControllerGetRecommendations**](AIRecommendationsApi.md#aiservicecontrollergetrecommendations) | **POST** /ai/recommendations | Get service recommendations by IDs


# **aiServiceControllerGetRecommendations**
> AiRecommendationsResponseDto aiServiceControllerGetRecommendations(aiRecommendationsRequestDto)

Get service recommendations by IDs

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure API key authorization: X-AI-API-Key
//defaultApiClient.getAuthentication<ApiKeyAuth>('X-AI-API-Key').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('X-AI-API-Key').apiKeyPrefix = 'Bearer';

final api_instance = AIRecommendationsApi();
final aiRecommendationsRequestDto = AiRecommendationsRequestDto(); // AiRecommendationsRequestDto | 

try {
    final result = api_instance.aiServiceControllerGetRecommendations(aiRecommendationsRequestDto);
    print(result);
} catch (e) {
    print('Exception when calling AIRecommendationsApi->aiServiceControllerGetRecommendations: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **aiRecommendationsRequestDto** | [**AiRecommendationsRequestDto**](AiRecommendationsRequestDto.md)|  | 

### Return type

[**AiRecommendationsResponseDto**](AiRecommendationsResponseDto.md)

### Authorization

[X-AI-API-Key](../README.md#X-AI-API-Key)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

