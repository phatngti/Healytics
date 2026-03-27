# user_openapi.api.HealthServicesApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**healthServiceControllerFindOne**](HealthServicesApi.md#healthservicecontrollerfindone) | **GET** /health-services/{id} | Get a service by id
[**healthServiceControllerGetHomeRecommend**](HealthServicesApi.md#healthservicecontrollergethomerecommend) | **GET** /health-services/home-recommend | Get home recommendations
[**healthServiceControllerGetPremiumTreatments**](HealthServicesApi.md#healthservicecontrollergetpremiumtreatments) | **GET** /health-services/premium-treatments | Get premium treatments
[**healthServiceControllerGetProductEmployees**](HealthServicesApi.md#healthservicecontrollergetproductemployees) | **GET** /health-services/{id}/employees | Get employees for a service
[**healthServiceControllerGetProductInfo**](HealthServicesApi.md#healthservicecontrollergetproductinfo) | **GET** /health-services/{id}/info | Get service info by ID
[**healthServiceControllerGetProductReviews**](HealthServicesApi.md#healthservicecontrollergetproductreviews) | **GET** /health-services/{id}/reviews | Get reviews for a service
[**healthServiceControllerGetRecommendedProducts**](HealthServicesApi.md#healthservicecontrollergetrecommendedproducts) | **GET** /health-services/{id}/recommended | Get recommended services


# **healthServiceControllerFindOne**
> PublicHealthServiceResponseDto healthServiceControllerFindOne(id)

Get a service by id

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = HealthServicesApi();
final id = id_example; // String | 

try {
    final result = api_instance.healthServiceControllerFindOne(id);
    print(result);
} catch (e) {
    print('Exception when calling HealthServicesApi->healthServiceControllerFindOne: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**PublicHealthServiceResponseDto**](PublicHealthServiceResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **healthServiceControllerGetHomeRecommend**
> List<PublicHealthServiceCardResponseDto> healthServiceControllerGetHomeRecommend()

Get home recommendations

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = HealthServicesApi();

try {
    final result = api_instance.healthServiceControllerGetHomeRecommend();
    print(result);
} catch (e) {
    print('Exception when calling HealthServicesApi->healthServiceControllerGetHomeRecommend: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<PublicHealthServiceCardResponseDto>**](PublicHealthServiceCardResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **healthServiceControllerGetPremiumTreatments**
> List<PublicHealthServiceCardResponseDto> healthServiceControllerGetPremiumTreatments()

Get premium treatments

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = HealthServicesApi();

try {
    final result = api_instance.healthServiceControllerGetPremiumTreatments();
    print(result);
} catch (e) {
    print('Exception when calling HealthServicesApi->healthServiceControllerGetPremiumTreatments: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<PublicHealthServiceCardResponseDto>**](PublicHealthServiceCardResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **healthServiceControllerGetProductEmployees**
> List<PublicHealthServiceEmployeeResponseDto> healthServiceControllerGetProductEmployees(id)

Get employees for a service

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = HealthServicesApi();
final id = id_example; // String | 

try {
    final result = api_instance.healthServiceControllerGetProductEmployees(id);
    print(result);
} catch (e) {
    print('Exception when calling HealthServicesApi->healthServiceControllerGetProductEmployees: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**List<PublicHealthServiceEmployeeResponseDto>**](PublicHealthServiceEmployeeResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **healthServiceControllerGetProductInfo**
> PublicHealthServiceInfoResponseDto healthServiceControllerGetProductInfo(id)

Get service info by ID

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = HealthServicesApi();
final id = id_example; // String | 

try {
    final result = api_instance.healthServiceControllerGetProductInfo(id);
    print(result);
} catch (e) {
    print('Exception when calling HealthServicesApi->healthServiceControllerGetProductInfo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**PublicHealthServiceInfoResponseDto**](PublicHealthServiceInfoResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **healthServiceControllerGetProductReviews**
> List<PublicHealthServiceReviewResponseDto> healthServiceControllerGetProductReviews(id)

Get reviews for a service

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = HealthServicesApi();
final id = id_example; // String | 

try {
    final result = api_instance.healthServiceControllerGetProductReviews(id);
    print(result);
} catch (e) {
    print('Exception when calling HealthServicesApi->healthServiceControllerGetProductReviews: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**List<PublicHealthServiceReviewResponseDto>**](PublicHealthServiceReviewResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **healthServiceControllerGetRecommendedProducts**
> List<PublicHealthServiceRecommendedResponseDto> healthServiceControllerGetRecommendedProducts(id)

Get recommended services

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = HealthServicesApi();
final id = id_example; // String | 

try {
    final result = api_instance.healthServiceControllerGetRecommendedProducts(id);
    print(result);
} catch (e) {
    print('Exception when calling HealthServicesApi->healthServiceControllerGetRecommendedProducts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**List<PublicHealthServiceRecommendedResponseDto>**](PublicHealthServiceRecommendedResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

