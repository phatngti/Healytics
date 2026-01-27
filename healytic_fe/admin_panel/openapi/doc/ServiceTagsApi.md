# admin_openapi.api.ServiceTagsApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**serviceTagsControllerAttachToProduct**](ServiceTagsApi.md#servicetagscontrollerattachtoproduct) | **POST** /service-tags/{id}/products/{productId} | Attach a tag to a product
[**serviceTagsControllerCreate**](ServiceTagsApi.md#servicetagscontrollercreate) | **POST** /service-tags | Create a new service tag
[**serviceTagsControllerDetachFromProduct**](ServiceTagsApi.md#servicetagscontrollerdetachfromproduct) | **DELETE** /service-tags/{id}/products/{productId} | Detach a tag from a product
[**serviceTagsControllerFindActive**](ServiceTagsApi.md#servicetagscontrollerfindactive) | **GET** /service-tags/active | Get active service tags for current user
[**serviceTagsControllerFindAll**](ServiceTagsApi.md#servicetagscontrollerfindall) | **GET** /service-tags | Get all service tags for current user
[**serviceTagsControllerFindOne**](ServiceTagsApi.md#servicetagscontrollerfindone) | **GET** /service-tags/{id} | Get a service tag by ID
[**serviceTagsControllerGetTagsForProduct**](ServiceTagsApi.md#servicetagscontrollergettagsforproduct) | **GET** /service-tags/products/{productId} | Get all tags attached to a product
[**serviceTagsControllerRemove**](ServiceTagsApi.md#servicetagscontrollerremove) | **DELETE** /service-tags/{id} | Delete a service tag
[**serviceTagsControllerUpdate**](ServiceTagsApi.md#servicetagscontrollerupdate) | **PATCH** /service-tags/{id} | Update a service tag


# **serviceTagsControllerAttachToProduct**
> AttachTagResponseDto serviceTagsControllerAttachToProduct(id, productId)

Attach a tag to a product

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ServiceTagsApi();
final id = id_example; // String | 
final productId = productId_example; // String | 

try {
    final result = api_instance.serviceTagsControllerAttachToProduct(id, productId);
    print(result);
} catch (e) {
    print('Exception when calling ServiceTagsApi->serviceTagsControllerAttachToProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **productId** | **String**|  | 

### Return type

[**AttachTagResponseDto**](AttachTagResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **serviceTagsControllerCreate**
> ServiceTagResponseDto serviceTagsControllerCreate(createServiceTagDto)

Create a new service tag

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ServiceTagsApi();
final createServiceTagDto = CreateServiceTagDto(); // CreateServiceTagDto | 

try {
    final result = api_instance.serviceTagsControllerCreate(createServiceTagDto);
    print(result);
} catch (e) {
    print('Exception when calling ServiceTagsApi->serviceTagsControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createServiceTagDto** | [**CreateServiceTagDto**](CreateServiceTagDto.md)|  | 

### Return type

[**ServiceTagResponseDto**](ServiceTagResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **serviceTagsControllerDetachFromProduct**
> serviceTagsControllerDetachFromProduct(id, productId)

Detach a tag from a product

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ServiceTagsApi();
final id = id_example; // String | 
final productId = productId_example; // String | 

try {
    api_instance.serviceTagsControllerDetachFromProduct(id, productId);
} catch (e) {
    print('Exception when calling ServiceTagsApi->serviceTagsControllerDetachFromProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **productId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **serviceTagsControllerFindActive**
> List<ServiceTagResponseDto> serviceTagsControllerFindActive()

Get active service tags for current user

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ServiceTagsApi();

try {
    final result = api_instance.serviceTagsControllerFindActive();
    print(result);
} catch (e) {
    print('Exception when calling ServiceTagsApi->serviceTagsControllerFindActive: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ServiceTagResponseDto>**](ServiceTagResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **serviceTagsControllerFindAll**
> List<ServiceTagResponseDto> serviceTagsControllerFindAll()

Get all service tags for current user

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ServiceTagsApi();

try {
    final result = api_instance.serviceTagsControllerFindAll();
    print(result);
} catch (e) {
    print('Exception when calling ServiceTagsApi->serviceTagsControllerFindAll: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ServiceTagResponseDto>**](ServiceTagResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **serviceTagsControllerFindOne**
> ServiceTagResponseDto serviceTagsControllerFindOne(id)

Get a service tag by ID

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ServiceTagsApi();
final id = id_example; // String | 

try {
    final result = api_instance.serviceTagsControllerFindOne(id);
    print(result);
} catch (e) {
    print('Exception when calling ServiceTagsApi->serviceTagsControllerFindOne: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**ServiceTagResponseDto**](ServiceTagResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **serviceTagsControllerGetTagsForProduct**
> List<ServiceTagResponseDto> serviceTagsControllerGetTagsForProduct(productId)

Get all tags attached to a product

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ServiceTagsApi();
final productId = productId_example; // String | 

try {
    final result = api_instance.serviceTagsControllerGetTagsForProduct(productId);
    print(result);
} catch (e) {
    print('Exception when calling ServiceTagsApi->serviceTagsControllerGetTagsForProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **String**|  | 

### Return type

[**List<ServiceTagResponseDto>**](ServiceTagResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **serviceTagsControllerRemove**
> serviceTagsControllerRemove(id)

Delete a service tag

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ServiceTagsApi();
final id = id_example; // String | 

try {
    api_instance.serviceTagsControllerRemove(id);
} catch (e) {
    print('Exception when calling ServiceTagsApi->serviceTagsControllerRemove: $e\n');
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

# **serviceTagsControllerUpdate**
> ServiceTagResponseDto serviceTagsControllerUpdate(id, updateServiceTagDto)

Update a service tag

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = ServiceTagsApi();
final id = id_example; // String | 
final updateServiceTagDto = UpdateServiceTagDto(); // UpdateServiceTagDto | 

try {
    final result = api_instance.serviceTagsControllerUpdate(id, updateServiceTagDto);
    print(result);
} catch (e) {
    print('Exception when calling ServiceTagsApi->serviceTagsControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateServiceTagDto** | [**UpdateServiceTagDto**](UpdateServiceTagDto.md)|  | 

### Return type

[**ServiceTagResponseDto**](ServiceTagResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

