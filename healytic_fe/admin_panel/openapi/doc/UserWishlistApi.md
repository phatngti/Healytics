# admin_openapi.api.UserWishlistApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userWishlistControllerAddItem**](UserWishlistApi.md#userwishlistcontrolleradditem) | **POST** /user/wishlist/{productId} | Add a product to the current user wishlist
[**userWishlistControllerListWishlist**](UserWishlistApi.md#userwishlistcontrollerlistwishlist) | **GET** /user/wishlist | List current user wishlist items
[**userWishlistControllerRemoveItem**](UserWishlistApi.md#userwishlistcontrollerremoveitem) | **DELETE** /user/wishlist/{productId} | Remove a product from the current user wishlist


# **userWishlistControllerAddItem**
> WishlistItemResponseDto userWishlistControllerAddItem(productId)

Add a product to the current user wishlist

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserWishlistApi();
final productId = productId_example; // String | 

try {
    final result = api_instance.userWishlistControllerAddItem(productId);
    print(result);
} catch (e) {
    print('Exception when calling UserWishlistApi->userWishlistControllerAddItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **String**|  | 

### Return type

[**WishlistItemResponseDto**](WishlistItemResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userWishlistControllerListWishlist**
> List<WishlistItemResponseDto> userWishlistControllerListWishlist()

List current user wishlist items

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserWishlistApi();

try {
    final result = api_instance.userWishlistControllerListWishlist();
    print(result);
} catch (e) {
    print('Exception when calling UserWishlistApi->userWishlistControllerListWishlist: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<WishlistItemResponseDto>**](WishlistItemResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userWishlistControllerRemoveItem**
> userWishlistControllerRemoveItem(productId)

Remove a product from the current user wishlist

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserWishlistApi();
final productId = productId_example; // String | 

try {
    api_instance.userWishlistControllerRemoveItem(productId);
} catch (e) {
    print('Exception when calling UserWishlistApi->userWishlistControllerRemoveItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

