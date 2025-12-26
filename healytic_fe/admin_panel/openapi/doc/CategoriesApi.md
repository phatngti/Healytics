# admin_openapi.api.CategoriesApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**categoriesControllerCreate**](CategoriesApi.md#categoriescontrollercreate) | **POST** /categories | Create a new category
[**categoriesControllerFindAll**](CategoriesApi.md#categoriescontrollerfindall) | **GET** /categories | Get all categories
[**categoriesControllerFindBySlug**](CategoriesApi.md#categoriescontrollerfindbyslug) | **GET** /categories/slug/{slug} | Get a category by slug
[**categoriesControllerFindOne**](CategoriesApi.md#categoriescontrollerfindone) | **GET** /categories/{id} | Get a category by id
[**categoriesControllerRemove**](CategoriesApi.md#categoriescontrollerremove) | **DELETE** /categories/{id} | Delete a category
[**categoriesControllerUpdate**](CategoriesApi.md#categoriescontrollerupdate) | **PATCH** /categories/{id} | Update a category


# **categoriesControllerCreate**
> Object categoriesControllerCreate(createCategoryDto)

Create a new category

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CategoriesApi();
final createCategoryDto = CreateCategoryDto(); // CreateCategoryDto | 

try {
    final result = api_instance.categoriesControllerCreate(createCategoryDto);
    print(result);
} catch (e) {
    print('Exception when calling CategoriesApi->categoriesControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createCategoryDto** | [**CreateCategoryDto**](CreateCategoryDto.md)|  | 

### Return type

[**Object**](Object.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **categoriesControllerFindAll**
> List<Object> categoriesControllerFindAll(rootsOnly)

Get all categories

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CategoriesApi();
final rootsOnly = true; // bool | Return only root categories

try {
    final result = api_instance.categoriesControllerFindAll(rootsOnly);
    print(result);
} catch (e) {
    print('Exception when calling CategoriesApi->categoriesControllerFindAll: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **rootsOnly** | **bool**| Return only root categories | [optional] 

### Return type

[**List<Object>**](Object.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **categoriesControllerFindBySlug**
> Object categoriesControllerFindBySlug(slug)

Get a category by slug

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CategoriesApi();
final slug = slug_example; // String | 

try {
    final result = api_instance.categoriesControllerFindBySlug(slug);
    print(result);
} catch (e) {
    print('Exception when calling CategoriesApi->categoriesControllerFindBySlug: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **slug** | **String**|  | 

### Return type

[**Object**](Object.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **categoriesControllerFindOne**
> Object categoriesControllerFindOne(id)

Get a category by id

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CategoriesApi();
final id = id_example; // String | 

try {
    final result = api_instance.categoriesControllerFindOne(id);
    print(result);
} catch (e) {
    print('Exception when calling CategoriesApi->categoriesControllerFindOne: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Object**](Object.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **categoriesControllerRemove**
> categoriesControllerRemove(id)

Delete a category

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CategoriesApi();
final id = id_example; // String | 

try {
    api_instance.categoriesControllerRemove(id);
} catch (e) {
    print('Exception when calling CategoriesApi->categoriesControllerRemove: $e\n');
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

# **categoriesControllerUpdate**
> Object categoriesControllerUpdate(id, updateCategoryDto)

Update a category

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CategoriesApi();
final id = id_example; // String | 
final updateCategoryDto = UpdateCategoryDto(); // UpdateCategoryDto | 

try {
    final result = api_instance.categoriesControllerUpdate(id, updateCategoryDto);
    print(result);
} catch (e) {
    print('Exception when calling CategoriesApi->categoriesControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateCategoryDto** | [**UpdateCategoryDto**](UpdateCategoryDto.md)|  | 

### Return type

[**Object**](Object.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

