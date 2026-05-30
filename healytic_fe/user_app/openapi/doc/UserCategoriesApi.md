# user_openapi.api.UserCategoriesApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userCategoriesControllerFindServicesByCategory**](UserCategoriesApi.md#usercategoriescontrollerfindservicesbycategory) | **GET** /user/categories/{categoryId}/services | Get services for a category
[**userCategoriesControllerFindSpecialistsByCategory**](UserCategoriesApi.md#usercategoriescontrollerfindspecialistsbycategory) | **GET** /user/categories/{categoryId}/specialists | Get specialists for a category


# **userCategoriesControllerFindServicesByCategory**
> List<BookingServiceResponseDto> userCategoriesControllerFindServicesByCategory(categoryId, sort, minPrice, maxPrice, categoryId2, clinicId, provinceId, districtId, wardId, lat, lng)

Get services for a category

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserCategoriesApi();
final categoryId = categoryId_example; // String |
final sort = sort_example; // String |
final minPrice = 8.14; // num |
final maxPrice = 8.14; // num |
final categoryId2 = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final clinicId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final provinceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final districtId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final wardId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final lat = 8.14; // num | User latitude for distance calc
final lng = 8.14; // num | User longitude for distance calc

try {
    final result = api_instance.userCategoriesControllerFindServicesByCategory(categoryId, sort, minPrice, maxPrice, categoryId2, clinicId, provinceId, districtId, wardId, lat, lng);
    print(result);
} catch (e) {
    print('Exception when calling UserCategoriesApi->userCategoriesControllerFindServicesByCategory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **categoryId** | **String**|  |
 **sort** | **String**|  | [optional] [default to 'default']
 **minPrice** | **num**|  | [optional]
 **maxPrice** | **num**|  | [optional]
 **categoryId2** | **String**|  | [optional]
 **clinicId** | **String**|  | [optional]
 **provinceId** | **String**|  | [optional]
 **districtId** | **String**|  | [optional]
 **wardId** | **String**|  | [optional]
 **lat** | **num**| User latitude for distance calc | [optional]
 **lng** | **num**| User longitude for distance calc | [optional]

### Return type

[**List<BookingServiceResponseDto>**](BookingServiceResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userCategoriesControllerFindSpecialistsByCategory**
> List<BookingSpecialistResponseDto> userCategoriesControllerFindSpecialistsByCategory(categoryId)

Get specialists for a category

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserCategoriesApi();
final categoryId = categoryId_example; // String |

try {
    final result = api_instance.userCategoriesControllerFindSpecialistsByCategory(categoryId);
    print(result);
} catch (e) {
    print('Exception when calling UserCategoriesApi->userCategoriesControllerFindSpecialistsByCategory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **categoryId** | **String**|  |

### Return type

[**List<BookingSpecialistResponseDto>**](BookingSpecialistResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

