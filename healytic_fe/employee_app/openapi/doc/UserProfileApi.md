# employee_openapi.api.UserProfileApi

## Load the API package
```dart
import 'package:employee_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userProfileControllerGetSummary**](UserProfileApi.md#userprofilecontrollergetsummary) | **GET** /user/profile/summary | Get current user profile summary counters


# **userProfileControllerGetSummary**
> UserProfileSummaryResponseDto userProfileControllerGetSummary()

Get current user profile summary counters

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserProfileApi();

try {
    final result = api_instance.userProfileControllerGetSummary();
    print(result);
} catch (e) {
    print('Exception when calling UserProfileApi->userProfileControllerGetSummary: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserProfileSummaryResponseDto**](UserProfileSummaryResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

