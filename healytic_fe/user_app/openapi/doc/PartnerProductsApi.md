# user_openapi.api.PartnerProductsApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnerProductsControllerCreate**](PartnerProductsApi.md#partnerproductscontrollercreate) | **POST** /partner/products | Create a new product
[**partnerProductsControllerFindAll**](PartnerProductsApi.md#partnerproductscontrollerfindall) | **GET** /partner/products | Get all products
[**partnerProductsControllerFindBySlug**](PartnerProductsApi.md#partnerproductscontrollerfindbyslug) | **GET** /partner/products/slug/{slug} | Get a product by slug
[**partnerProductsControllerGetDetails**](PartnerProductsApi.md#partnerproductscontrollergetdetails) | **GET** /partner/products/slug/{slug}/details | Get full product details by slug
[**partnerProductsControllerRemove**](PartnerProductsApi.md#partnerproductscontrollerremove) | **DELETE** /partner/products/{id} | Delete a product
[**partnerProductsControllerUpdate**](PartnerProductsApi.md#partnerproductscontrollerupdate) | **PATCH** /partner/products/{id} | Update a product


# **partnerProductsControllerCreate**
> PartnerProductResponseDto partnerProductsControllerCreate(createPartnerProductDto)

Create a new product

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerProductsApi();
final createPartnerProductDto = CreatePartnerProductDto(); // CreatePartnerProductDto | 

try {
    final result = api_instance.partnerProductsControllerCreate(createPartnerProductDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerProductsApi->partnerProductsControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createPartnerProductDto** | [**CreatePartnerProductDto**](CreatePartnerProductDto.md)|  | 

### Return type

[**PartnerProductResponseDto**](PartnerProductResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerProductsControllerFindAll**
> List<PartnerProductResponseDto> partnerProductsControllerFindAll()

Get all products

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerProductsApi();

try {
    final result = api_instance.partnerProductsControllerFindAll();
    print(result);
} catch (e) {
    print('Exception when calling PartnerProductsApi->partnerProductsControllerFindAll: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<PartnerProductResponseDto>**](PartnerProductResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerProductsControllerFindBySlug**
> PartnerProductResponseDto partnerProductsControllerFindBySlug(slug)

Get a product by slug

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerProductsApi();
final slug = slug_example; // String | 

try {
    final result = api_instance.partnerProductsControllerFindBySlug(slug);
    print(result);
} catch (e) {
    print('Exception when calling PartnerProductsApi->partnerProductsControllerFindBySlug: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **slug** | **String**|  | 

### Return type

[**PartnerProductResponseDto**](PartnerProductResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerProductsControllerGetDetails**
> PartnerProductDetailResponseDto partnerProductsControllerGetDetails(slug)

Get full product details by slug

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerProductsApi();
final slug = slug_example; // String | 

try {
    final result = api_instance.partnerProductsControllerGetDetails(slug);
    print(result);
} catch (e) {
    print('Exception when calling PartnerProductsApi->partnerProductsControllerGetDetails: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **slug** | **String**|  | 

### Return type

[**PartnerProductDetailResponseDto**](PartnerProductDetailResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerProductsControllerRemove**
> partnerProductsControllerRemove(id)

Delete a product

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerProductsApi();
final id = id_example; // String | 

try {
    api_instance.partnerProductsControllerRemove(id);
} catch (e) {
    print('Exception when calling PartnerProductsApi->partnerProductsControllerRemove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerProductsControllerUpdate**
> PartnerProductResponseDto partnerProductsControllerUpdate(id, updatePartnerProductDto)

Update a product

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerProductsApi();
final id = id_example; // String | 
final updatePartnerProductDto = UpdatePartnerProductDto(); // UpdatePartnerProductDto | 

try {
    final result = api_instance.partnerProductsControllerUpdate(id, updatePartnerProductDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerProductsApi->partnerProductsControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updatePartnerProductDto** | [**UpdatePartnerProductDto**](UpdatePartnerProductDto.md)|  | 

### Return type

[**PartnerProductResponseDto**](PartnerProductResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

