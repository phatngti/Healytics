# user_openapi.api.PartnerProductsApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnerProductsControllerCreate**](PartnerProductsApi.md#partnerproductscontrollercreate) | **POST** /partner/products | Create a new product
[**partnerProductsControllerRemove**](PartnerProductsApi.md#partnerproductscontrollerremove) | **DELETE** /partner/products/{id} | Delete a product
[**partnerProductsControllerUpdate**](PartnerProductsApi.md#partnerproductscontrollerupdate) | **PATCH** /partner/products/{id} | Update a product


# **partnerProductsControllerCreate**
> ProductResponseDto partnerProductsControllerCreate(createProductDto)

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
final createProductDto = CreateProductDto(); // CreateProductDto | 

try {
    final result = api_instance.partnerProductsControllerCreate(createProductDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerProductsApi->partnerProductsControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createProductDto** | [**CreateProductDto**](CreateProductDto.md)|  | 

### Return type

[**ProductResponseDto**](ProductResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
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
> ProductResponseDto partnerProductsControllerUpdate(id, updateProductDto)

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
final updateProductDto = UpdateProductDto(); // UpdateProductDto | 

try {
    final result = api_instance.partnerProductsControllerUpdate(id, updateProductDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerProductsApi->partnerProductsControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateProductDto** | [**UpdateProductDto**](UpdateProductDto.md)|  | 

### Return type

[**ProductResponseDto**](ProductResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

