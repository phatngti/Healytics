# admin_openapi.api.AdminCategoriesApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminCategoriesControllerCreate**](AdminCategoriesApi.md#admincategoriescontrollercreate) | **POST** /admin/categories | Create a new category
[**adminCategoriesControllerFindAll**](AdminCategoriesApi.md#admincategoriescontrollerfindall) | **GET** /admin/categories | List all categories (admin view)
[**adminCategoriesControllerFindOne**](AdminCategoriesApi.md#admincategoriescontrollerfindone) | **GET** /admin/categories/{id} | Get a category by id (admin view)
[**adminCategoriesControllerRemove**](AdminCategoriesApi.md#admincategoriescontrollerremove) | **DELETE** /admin/categories/{id} | Delete a category
[**adminCategoriesControllerUpdate**](AdminCategoriesApi.md#admincategoriescontrollerupdate) | **PATCH** /admin/categories/{id} | Update a category


# **adminCategoriesControllerCreate**
> AdminCategoryResponseDto adminCategoriesControllerCreate(createCategoryDto)

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

final api_instance = AdminCategoriesApi();
final createCategoryDto = CreateCategoryDto(); // CreateCategoryDto |

try {
    final result = api_instance.adminCategoriesControllerCreate(createCategoryDto);
    print(result);
} catch (e) {
    print('Exception when calling AdminCategoriesApi->adminCategoriesControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createCategoryDto** | [**CreateCategoryDto**](CreateCategoryDto.md)|  |

### Return type

[**AdminCategoryResponseDto**](AdminCategoryResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCategoriesControllerFindAll**
> List<AdminCategoryResponseDto> adminCategoriesControllerFindAll()

List all categories (admin view)

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminCategoriesApi();

try {
    final result = api_instance.adminCategoriesControllerFindAll();
    print(result);
} catch (e) {
    print('Exception when calling AdminCategoriesApi->adminCategoriesControllerFindAll: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<AdminCategoryResponseDto>**](AdminCategoryResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCategoriesControllerFindOne**
> AdminCategoryResponseDto adminCategoriesControllerFindOne(id)

Get a category by id (admin view)

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminCategoriesApi();
final id = id_example; // String |

try {
    final result = api_instance.adminCategoriesControllerFindOne(id);
    print(result);
} catch (e) {
    print('Exception when calling AdminCategoriesApi->adminCategoriesControllerFindOne: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**AdminCategoryResponseDto**](AdminCategoryResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCategoriesControllerRemove**
> adminCategoriesControllerRemove(id)

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

final api_instance = AdminCategoriesApi();
final id = id_example; // String |

try {
    api_instance.adminCategoriesControllerRemove(id);
} catch (e) {
    print('Exception when calling AdminCategoriesApi->adminCategoriesControllerRemove: $e\n');
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

# **adminCategoriesControllerUpdate**
> AdminCategoryResponseDto adminCategoriesControllerUpdate(id, updateCategoryDto)

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

final api_instance = AdminCategoriesApi();
final id = id_example; // String |
final updateCategoryDto = UpdateCategoryDto(); // UpdateCategoryDto |

try {
    final result = api_instance.adminCategoriesControllerUpdate(id, updateCategoryDto);
    print(result);
} catch (e) {
    print('Exception when calling AdminCategoriesApi->adminCategoriesControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **updateCategoryDto** | [**UpdateCategoryDto**](UpdateCategoryDto.md)|  |

### Return type

[**AdminCategoryResponseDto**](AdminCategoryResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

