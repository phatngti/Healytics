# admin_openapi.api.CartApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**cartControllerAddItem**](CartApi.md#cartcontrolleradditem) | **POST** /cart | Add service to cart
[**cartControllerApplyCoupon**](CartApi.md#cartcontrollerapplycoupon) | **POST** /cart/{cartItemId}/coupon | Apply coupon to cart item
[**cartControllerClearCart**](CartApi.md#cartcontrollerclearcart) | **DELETE** /cart | Clear all cart items
[**cartControllerGetItems**](CartApi.md#cartcontrollergetitems) | **GET** /cart | Get all cart items for current user
[**cartControllerRemoveCoupon**](CartApi.md#cartcontrollerremovecoupon) | **DELETE** /cart/{cartItemId}/coupon | Remove coupon from cart item
[**cartControllerRemoveItem**](CartApi.md#cartcontrollerremoveitem) | **DELETE** /cart/{cartItemId} | Remove an item from cart


# **cartControllerAddItem**
> CartItemResponseDto cartControllerAddItem(addToCartDto)

Add service to cart

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CartApi();
final addToCartDto = AddToCartDto(); // AddToCartDto | 

try {
    final result = api_instance.cartControllerAddItem(addToCartDto);
    print(result);
} catch (e) {
    print('Exception when calling CartApi->cartControllerAddItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **addToCartDto** | [**AddToCartDto**](AddToCartDto.md)|  | 

### Return type

[**CartItemResponseDto**](CartItemResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cartControllerApplyCoupon**
> CartItemResponseDto cartControllerApplyCoupon(cartItemId, applyCouponDto)

Apply coupon to cart item

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CartApi();
final cartItemId = cartItemId_example; // String | 
final applyCouponDto = ApplyCouponDto(); // ApplyCouponDto | 

try {
    final result = api_instance.cartControllerApplyCoupon(cartItemId, applyCouponDto);
    print(result);
} catch (e) {
    print('Exception when calling CartApi->cartControllerApplyCoupon: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cartItemId** | **String**|  | 
 **applyCouponDto** | [**ApplyCouponDto**](ApplyCouponDto.md)|  | 

### Return type

[**CartItemResponseDto**](CartItemResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cartControllerClearCart**
> cartControllerClearCart()

Clear all cart items

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CartApi();

try {
    api_instance.cartControllerClearCart();
} catch (e) {
    print('Exception when calling CartApi->cartControllerClearCart: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cartControllerGetItems**
> List<CartItemResponseDto> cartControllerGetItems()

Get all cart items for current user

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CartApi();

try {
    final result = api_instance.cartControllerGetItems();
    print(result);
} catch (e) {
    print('Exception when calling CartApi->cartControllerGetItems: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<CartItemResponseDto>**](CartItemResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cartControllerRemoveCoupon**
> CartItemResponseDto cartControllerRemoveCoupon(cartItemId)

Remove coupon from cart item

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CartApi();
final cartItemId = cartItemId_example; // String | 

try {
    final result = api_instance.cartControllerRemoveCoupon(cartItemId);
    print(result);
} catch (e) {
    print('Exception when calling CartApi->cartControllerRemoveCoupon: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cartItemId** | **String**|  | 

### Return type

[**CartItemResponseDto**](CartItemResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cartControllerRemoveItem**
> cartControllerRemoveItem(cartItemId)

Remove an item from cart

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = CartApi();
final cartItemId = cartItemId_example; // String | 

try {
    api_instance.cartControllerRemoveItem(cartItemId);
} catch (e) {
    print('Exception when calling CartApi->cartControllerRemoveItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cartItemId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

