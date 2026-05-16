# user_openapi.api.UserClinicsApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userClinicControllerFollowClinic**](UserClinicsApi.md#usercliniccontrollerfollowclinic) | **POST** /user/clinics/{id}/follow | Follow a clinic
[**userClinicControllerGetClinicInfo**](UserClinicsApi.md#usercliniccontrollergetclinicinfo) | **GET** /user/clinics/{id}/info | Get public clinic profile
[**userClinicControllerGetClinicProducts**](UserClinicsApi.md#usercliniccontrollergetclinicproducts) | **GET** /user/clinics/{id}/products | Get clinic products/services catalog
[**userClinicControllerGetClinicReviews**](UserClinicsApi.md#usercliniccontrollergetclinicreviews) | **GET** /user/clinics/{id}/reviews | Get paginated clinic reviews
[**userClinicControllerUnfollowClinic**](UserClinicsApi.md#usercliniccontrollerunfollowclinic) | **DELETE** /user/clinics/{id}/follow | Unfollow a clinic


# **userClinicControllerFollowClinic**
> ClinicInfoResponseDto userClinicControllerFollowClinic(id)

Follow a clinic

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserClinicsApi();
final id = id_example; // String | 

try {
    final result = api_instance.userClinicControllerFollowClinic(id);
    print(result);
} catch (e) {
    print('Exception when calling UserClinicsApi->userClinicControllerFollowClinic: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**ClinicInfoResponseDto**](ClinicInfoResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userClinicControllerGetClinicInfo**
> ClinicInfoResponseDto userClinicControllerGetClinicInfo(id)

Get public clinic profile

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserClinicsApi();
final id = id_example; // String | 

try {
    final result = api_instance.userClinicControllerGetClinicInfo(id);
    print(result);
} catch (e) {
    print('Exception when calling UserClinicsApi->userClinicControllerGetClinicInfo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**ClinicInfoResponseDto**](ClinicInfoResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userClinicControllerGetClinicProducts**
> ClinicProductsResponseDto userClinicControllerGetClinicProducts(id, categoryId, sort, search, page, limit)

Get clinic products/services catalog

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserClinicsApi();
final id = id_example; // String | 
final categoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | Filter products by category ID
final sort = sort_example; // String | Sort order for products
final search = search_example; // String | Case-insensitive service name search
final page = 8.14; // num | 
final limit = 8.14; // num | 

try {
    final result = api_instance.userClinicControllerGetClinicProducts(id, categoryId, sort, search, page, limit);
    print(result);
} catch (e) {
    print('Exception when calling UserClinicsApi->userClinicControllerGetClinicProducts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **categoryId** | **String**| Filter products by category ID | [optional] 
 **sort** | **String**| Sort order for products | [optional] [default to 'popular']
 **search** | **String**| Case-insensitive service name search | [optional] 
 **page** | **num**|  | [optional] [default to 1]
 **limit** | **num**|  | [optional] [default to 20]

### Return type

[**ClinicProductsResponseDto**](ClinicProductsResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userClinicControllerGetClinicReviews**
> ClinicReviewsResponseDto userClinicControllerGetClinicReviews(id, page, limit, starCount, hasMedia)

Get paginated clinic reviews

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserClinicsApi();
final id = id_example; // String | 
final page = 8.14; // num | 
final limit = 8.14; // num | 
final starCount = 8.14; // num | Filter: only reviews with this rating (1–5)
final hasMedia = true; // bool | Filter: only reviews with photos

try {
    final result = api_instance.userClinicControllerGetClinicReviews(id, page, limit, starCount, hasMedia);
    print(result);
} catch (e) {
    print('Exception when calling UserClinicsApi->userClinicControllerGetClinicReviews: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **page** | **num**|  | [optional] [default to 1]
 **limit** | **num**|  | [optional] [default to 10]
 **starCount** | **num**| Filter: only reviews with this rating (1–5) | [optional] 
 **hasMedia** | **bool**| Filter: only reviews with photos | [optional] 

### Return type

[**ClinicReviewsResponseDto**](ClinicReviewsResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userClinicControllerUnfollowClinic**
> ClinicInfoResponseDto userClinicControllerUnfollowClinic(id)

Unfollow a clinic

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserClinicsApi();
final id = id_example; // String | 

try {
    final result = api_instance.userClinicControllerUnfollowClinic(id);
    print(result);
} catch (e) {
    print('Exception when calling UserClinicsApi->userClinicControllerUnfollowClinic: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**ClinicInfoResponseDto**](ClinicInfoResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

