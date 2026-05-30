# admin_openapi.api.UserBookingSearchApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**bookingSearchControllerSearch**](UserBookingSearchApi.md#bookingsearchcontrollersearch) | **GET** /user/booking-search | Search booking services and specialists


# **bookingSearchControllerSearch**
> BookingSearchResponseDto bookingSearchControllerSearch(q, limit)

Search booking services and specialists

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserBookingSearchApi();
final q = massage; // String | Search text. Minimum 2 characters.
final limit = 5; // String | Maximum results per group. Default 5, max 20.

try {
    final result = api_instance.bookingSearchControllerSearch(q, limit);
    print(result);
} catch (e) {
    print('Exception when calling UserBookingSearchApi->bookingSearchControllerSearch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**| Search text. Minimum 2 characters. |
 **limit** | **String**| Maximum results per group. Default 5, max 20. | [optional]

### Return type

[**BookingSearchResponseDto**](BookingSearchResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

