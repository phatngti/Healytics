# user_openapi.api.ProductsApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**productsControllerFindAll**](ProductsApi.md#productscontrollerfindall) | **GET** /products | Get all products
[**productsControllerFindBySlug**](ProductsApi.md#productscontrollerfindbyslug) | **GET** /products/slug/{slug} | Get a product by slug
[**productsControllerFindOne**](ProductsApi.md#productscontrollerfindone) | **GET** /products/{id} | Get a product by id
[**productsControllerGetDetails**](ProductsApi.md#productscontrollergetdetails) | **GET** /products/slug/{slug}/details | Get full product details by slug


# **productsControllerFindAll**
> List<ProductResponseDto> productsControllerFindAll()

Get all products

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = ProductsApi();

try {
    final result = api_instance.productsControllerFindAll();
    print(result);
} catch (e) {
    print('Exception when calling ProductsApi->productsControllerFindAll: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ProductResponseDto>**](ProductResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **productsControllerFindBySlug**
> ProductResponseDto productsControllerFindBySlug(slug)

Get a product by slug

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = ProductsApi();
final slug = slug_example; // String | 

try {
    final result = api_instance.productsControllerFindBySlug(slug);
    print(result);
} catch (e) {
    print('Exception when calling ProductsApi->productsControllerFindBySlug: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **slug** | **String**|  | 

### Return type

[**ProductResponseDto**](ProductResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **productsControllerFindOne**
> ProductResponseDto productsControllerFindOne(id)

Get a product by id

### Example
```dart
import 'package:user_openapi/api.dart';

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

[**ProductResponseDto**](ProductResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **productsControllerGetDetails**
> ProductDetailResponseDto productsControllerGetDetails(slug)

Get full product details by slug

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = ProductsApi();
final slug = slug_example; // String | 

try {
    final result = api_instance.productsControllerGetDetails(slug);
    print(result);
} catch (e) {
    print('Exception when calling ProductsApi->productsControllerGetDetails: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **slug** | **String**|  | 

### Return type

[**ProductDetailResponseDto**](ProductDetailResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

