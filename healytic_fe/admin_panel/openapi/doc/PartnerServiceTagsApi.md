# admin_openapi.api.PartnerServiceTagsApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**serviceTagsControllerAttachToProduct**](PartnerServiceTagsApi.md#servicetagscontrollerattachtoproduct) | **POST** /partner/service-tags/{id}/products/{productId} | Attach a tag to a product
[**serviceTagsControllerCreate**](PartnerServiceTagsApi.md#servicetagscontrollercreate) | **POST** /partner/service-tags | Create a new service tag
[**serviceTagsControllerDetachFromProduct**](PartnerServiceTagsApi.md#servicetagscontrollerdetachfromproduct) | **DELETE** /partner/service-tags/{id}/products/{productId} | Detach a tag from a product
[**serviceTagsControllerFindActive**](PartnerServiceTagsApi.md#servicetagscontrollerfindactive) | **GET** /partner/service-tags/active | Get active service tags for current user
[**serviceTagsControllerFindAll**](PartnerServiceTagsApi.md#servicetagscontrollerfindall) | **GET** /partner/service-tags | Get all service tags for current user
[**serviceTagsControllerFindOne**](PartnerServiceTagsApi.md#servicetagscontrollerfindone) | **GET** /partner/service-tags/{id} | Get a service tag by ID
[**serviceTagsControllerGetTagsForProduct**](PartnerServiceTagsApi.md#servicetagscontrollergettagsforproduct) | **GET** /partner/service-tags/products/{productId} | Get all tags attached to a product
[**serviceTagsControllerRemove**](PartnerServiceTagsApi.md#servicetagscontrollerremove) | **DELETE** /partner/service-tags/{id} | Delete a service tag
[**serviceTagsControllerUpdate**](PartnerServiceTagsApi.md#servicetagscontrollerupdate) | **PATCH** /partner/service-tags/{id} | Update a service tag


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

final api_instance = PartnerServiceTagsApi();
final id = id_example; // String | 
final productId = productId_example; // String | 

try {
    final result = api_instance.serviceTagsControllerAttachToProduct(id, productId);
    print(result);
} catch (e) {
    print('Exception when calling PartnerServiceTagsApi->serviceTagsControllerAttachToProduct: $e\n');
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

final api_instance = PartnerServiceTagsApi();
final createServiceTagDto = CreateServiceTagDto(); // CreateServiceTagDto | 

try {
    final result = api_instance.serviceTagsControllerCreate(createServiceTagDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerServiceTagsApi->serviceTagsControllerCreate: $e\n');
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

final api_instance = PartnerServiceTagsApi();
final id = id_example; // String | 
final productId = productId_example; // String | 

try {
    api_instance.serviceTagsControllerDetachFromProduct(id, productId);
} catch (e) {
    print('Exception when calling PartnerServiceTagsApi->serviceTagsControllerDetachFromProduct: $e\n');
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

final api_instance = PartnerServiceTagsApi();

try {
    final result = api_instance.serviceTagsControllerFindActive();
    print(result);
} catch (e) {
    print('Exception when calling PartnerServiceTagsApi->serviceTagsControllerFindActive: $e\n');
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

final api_instance = PartnerServiceTagsApi();

try {
    final result = api_instance.serviceTagsControllerFindAll();
    print(result);
} catch (e) {
    print('Exception when calling PartnerServiceTagsApi->serviceTagsControllerFindAll: $e\n');
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

final api_instance = PartnerServiceTagsApi();
final id = id_example; // String | 

try {
    final result = api_instance.serviceTagsControllerFindOne(id);
    print(result);
} catch (e) {
    print('Exception when calling PartnerServiceTagsApi->serviceTagsControllerFindOne: $e\n');
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

final api_instance = PartnerServiceTagsApi();
final productId = productId_example; // String | 

try {
    final result = api_instance.serviceTagsControllerGetTagsForProduct(productId);
    print(result);
} catch (e) {
    print('Exception when calling PartnerServiceTagsApi->serviceTagsControllerGetTagsForProduct: $e\n');
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

final api_instance = PartnerServiceTagsApi();
final id = id_example; // String | 

try {
    api_instance.serviceTagsControllerRemove(id);
} catch (e) {
    print('Exception when calling PartnerServiceTagsApi->serviceTagsControllerRemove: $e\n');
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

final api_instance = PartnerServiceTagsApi();
final id = id_example; // String | 
final updateServiceTagDto = UpdateServiceTagDto(); // UpdateServiceTagDto | 

try {
    final result = api_instance.serviceTagsControllerUpdate(id, updateServiceTagDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerServiceTagsApi->serviceTagsControllerUpdate: $e\n');
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

