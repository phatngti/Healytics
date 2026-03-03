# admin_openapi.api.ProductsApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**productsControllerFindOne**](ProductsApi.md#productscontrollerfindone) | **GET** /products/{id} | Get a product by id
[**productsControllerGetHomeRecommend**](ProductsApi.md#productscontrollergethomerecommend) | **GET** /products/home-recommend | Get home recommendations
[**productsControllerGetPremiumTreatments**](ProductsApi.md#productscontrollergetpremiumtreatments) | **GET** /products/premium-treatments | Get premium treatments
[**productsControllerGetProductEmployees**](ProductsApi.md#productscontrollergetproductemployees) | **GET** /products/{id}/employees | Get employees for a product
[**productsControllerGetProductInfo**](ProductsApi.md#productscontrollergetproductinfo) | **GET** /products/{id}/info | Get product info by ID
[**productsControllerGetProductReviews**](ProductsApi.md#productscontrollergetproductreviews) | **GET** /products/{id}/reviews | Get reviews for a product
[**productsControllerGetRecommendedProducts**](ProductsApi.md#productscontrollergetrecommendedproducts) | **GET** /products/{id}/recommended | Get recommended products


# **productsControllerFindOne**
> PublicProductResponseDto productsControllerFindOne(id)

Get a product by id

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = ProductsApi();
final id = id_example; // String | 

try {
    final result = api_instance.productsControllerFindOne(id);
    print(result);
} catch (e) {
    print('Exception when calling ProductsApi->productsControllerFindOne: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**PublicProductResponseDto**](PublicProductResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **productsControllerGetHomeRecommend**
> List<PublicProductCardResponseDto> productsControllerGetHomeRecommend()

Get home recommendations

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = ProductsApi();

try {
    final result = api_instance.productsControllerGetHomeRecommend();
    print(result);
} catch (e) {
    print('Exception when calling ProductsApi->productsControllerGetHomeRecommend: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<PublicProductCardResponseDto>**](PublicProductCardResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **productsControllerGetPremiumTreatments**
> List<PublicProductCardResponseDto> productsControllerGetPremiumTreatments()

Get premium treatments

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = ProductsApi();

try {
    final result = api_instance.productsControllerGetPremiumTreatments();
    print(result);
} catch (e) {
    print('Exception when calling ProductsApi->productsControllerGetPremiumTreatments: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<PublicProductCardResponseDto>**](PublicProductCardResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **productsControllerGetProductEmployees**
> List<PublicProductEmployeeResponseDto> productsControllerGetProductEmployees(id)

Get employees for a product

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = ProductsApi();
final id = id_example; // String | 

try {
    final result = api_instance.productsControllerGetProductEmployees(id);
    print(result);
} catch (e) {
    print('Exception when calling ProductsApi->productsControllerGetProductEmployees: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**List<PublicProductEmployeeResponseDto>**](PublicProductEmployeeResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **productsControllerGetProductInfo**
> PublicProductInfoResponseDto productsControllerGetProductInfo(id)

Get product info by ID

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = ProductsApi();
final id = id_example; // String | 

try {
    final result = api_instance.productsControllerGetProductInfo(id);
    print(result);
} catch (e) {
    print('Exception when calling ProductsApi->productsControllerGetProductInfo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**PublicProductInfoResponseDto**](PublicProductInfoResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **productsControllerGetProductReviews**
> List<PublicProductReviewResponseDto> productsControllerGetProductReviews(id)

Get reviews for a product

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = ProductsApi();
final id = id_example; // String | 

try {
    final result = api_instance.productsControllerGetProductReviews(id);
    print(result);
} catch (e) {
    print('Exception when calling ProductsApi->productsControllerGetProductReviews: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**List<PublicProductReviewResponseDto>**](PublicProductReviewResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **productsControllerGetRecommendedProducts**
> List<PublicProductRecommendedResponseDto> productsControllerGetRecommendedProducts(id)

Get recommended products

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = ProductsApi();
final id = id_example; // String | 

try {
    final result = api_instance.productsControllerGetRecommendedProducts(id);
    print(result);
} catch (e) {
    print('Exception when calling ProductsApi->productsControllerGetRecommendedProducts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**List<PublicProductRecommendedResponseDto>**](PublicProductRecommendedResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

