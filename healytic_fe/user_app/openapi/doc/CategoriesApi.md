# user_openapi.api.CategoriesApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**categoriesControllerFindAll**](CategoriesApi.md#categoriescontrollerfindall) | **GET** /categories | Get all categories
[**categoriesControllerFindBySlug**](CategoriesApi.md#categoriescontrollerfindbyslug) | **GET** /categories/slug/{slug} | Get a category by slug
[**categoriesControllerFindOne**](CategoriesApi.md#categoriescontrollerfindone) | **GET** /categories/{id} | Get a category by id


# **categoriesControllerFindAll**
> List<CategoryResponseDto> categoriesControllerFindAll(rootsOnly)

Get all categories

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = CategoriesApi();
final rootsOnly = true; // bool | Return only root categories (without parent)

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
 **rootsOnly** | **bool**| Return only root categories (without parent) | [optional]

### Return type

[**List<CategoryResponseDto>**](CategoryResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **categoriesControllerFindBySlug**
> CategoryResponseDto categoriesControllerFindBySlug(slug)

Get a category by slug

### Example
```dart
import 'package:user_openapi/api.dart';

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

[**CategoryResponseDto**](CategoryResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **categoriesControllerFindOne**
> CategoryResponseDto categoriesControllerFindOne(id)

Get a category by id

### Example
```dart
import 'package:user_openapi/api.dart';

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

[**CategoryResponseDto**](CategoryResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

