# user_openapi.api.AccountApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**accountControllerGetMe**](AccountApi.md#accountcontrollergetme) | **GET** /account/me | Get current user account details
[**accountControllerGetSurvey**](AccountApi.md#accountcontrollergetsurvey) | **GET** /account/survey | Get current user survey
[**accountControllerPostSurvey**](AccountApi.md#accountcontrollerpostsurvey) | **POST** /account/survey | Create one-shot survey for current user
[**accountControllerUpdateAddress**](AccountApi.md#accountcontrollerupdateaddress) | **PATCH** /account/me/address | Update current user address
[**accountControllerUpdateAvatar**](AccountApi.md#accountcontrollerupdateavatar) | **PATCH** /account/me/avatar | Update current user avatar
[**accountControllerUpdateProfile**](AccountApi.md#accountcontrollerupdateprofile) | **PATCH** /account/me/profile | Update current user profile identity


# **accountControllerGetMe**
> AccountMeResponseDto accountControllerGetMe()

Get current user account details

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
    final result = api_instance.accountControllerGetMe();
    print(result);
} catch (e) {
    print('Exception when calling AccountApi->accountControllerGetMe: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AccountMeResponseDto**](AccountMeResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

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

# **accountControllerUpdateAddress**
> AccountMeResponseDto accountControllerUpdateAddress(updateAccountAddressDto)

Update current user address

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
final updateAccountAddressDto = UpdateAccountAddressDto(); // UpdateAccountAddressDto | 

try {
    final result = api_instance.accountControllerUpdateAddress(updateAccountAddressDto);
    print(result);
} catch (e) {
    print('Exception when calling AccountApi->accountControllerUpdateAddress: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateAccountAddressDto** | [**UpdateAccountAddressDto**](UpdateAccountAddressDto.md)|  | 

### Return type

[**AccountMeResponseDto**](AccountMeResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **accountControllerUpdateAvatar**
> AccountMeResponseDto accountControllerUpdateAvatar(updateAvatarDto)

Update current user avatar

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
final updateAvatarDto = UpdateAvatarDto(); // UpdateAvatarDto | 

try {
    final result = api_instance.accountControllerUpdateAvatar(updateAvatarDto);
    print(result);
} catch (e) {
    print('Exception when calling AccountApi->accountControllerUpdateAvatar: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateAvatarDto** | [**UpdateAvatarDto**](UpdateAvatarDto.md)|  | 

### Return type

[**AccountMeResponseDto**](AccountMeResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **accountControllerUpdateProfile**
> AccountMeResponseDto accountControllerUpdateProfile(updateAccountProfileDto)

Update current user profile identity

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
final updateAccountProfileDto = UpdateAccountProfileDto(); // UpdateAccountProfileDto | 

try {
    final result = api_instance.accountControllerUpdateProfile(updateAccountProfileDto);
    print(result);
} catch (e) {
    print('Exception when calling AccountApi->accountControllerUpdateProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateAccountProfileDto** | [**UpdateAccountProfileDto**](UpdateAccountProfileDto.md)|  | 

### Return type

[**AccountMeResponseDto**](AccountMeResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

