# user_openapi.api.AccountApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**accountControllerGetSurvey**](AccountApi.md#accountcontrollergetsurvey) | **GET** /account/survey | Get current user survey
[**accountControllerPostSurvey**](AccountApi.md#accountcontrollerpostsurvey) | **POST** /account/survey | Create one-shot survey for current user


# **accountControllerGetSurvey**
> SurveyResponseDto accountControllerGetSurvey()

Get current user survey

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AccountApi();

try {
    final result = api_instance.accountControllerGetSurvey();
    print(result);
} catch (e) {
    print('Exception when calling AccountApi->accountControllerGetSurvey: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SurveyResponseDto**](SurveyResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **accountControllerPostSurvey**
> SurveyResponseDto accountControllerPostSurvey(surveyDto)

Create one-shot survey for current user

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AccountApi();
final surveyDto = SurveyDto(); // SurveyDto | 

try {
    final result = api_instance.accountControllerPostSurvey(surveyDto);
    print(result);
} catch (e) {
    print('Exception when calling AccountApi->accountControllerPostSurvey: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **surveyDto** | [**SurveyDto**](SurveyDto.md)|  | 

### Return type

[**SurveyResponseDto**](SurveyResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

