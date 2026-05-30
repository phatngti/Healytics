# user_openapi.api.BookingsApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**bookingStatusControllerUpdateStatus**](BookingsApi.md#bookingstatuscontrollerupdatestatus) | **PATCH** /bookings/{id}/status | Update booking status through the shared booking lifecycle


# **bookingStatusControllerUpdateStatus**
> BookingStatusChangeEventDto bookingStatusControllerUpdateStatus(id, updateBookingStatusDto)

Update booking status through the shared booking lifecycle

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = BookingsApi();
final id = id_example; // String |
final updateBookingStatusDto = UpdateBookingStatusDto(); // UpdateBookingStatusDto |

try {
    final result = api_instance.bookingStatusControllerUpdateStatus(id, updateBookingStatusDto);
    print(result);
} catch (e) {
    print('Exception when calling BookingsApi->bookingStatusControllerUpdateStatus: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **updateBookingStatusDto** | [**UpdateBookingStatusDto**](UpdateBookingStatusDto.md)|  |

### Return type

[**BookingStatusChangeEventDto**](BookingStatusChangeEventDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

