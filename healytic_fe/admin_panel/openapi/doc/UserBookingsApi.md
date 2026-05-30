# admin_openapi.api.UserBookingsApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**bookingControllerAsyncCheckout**](UserBookingsApi.md#bookingcontrollerasynccheckout) | **POST** /user/bookings/async-checkout | Start async checkout (returns 202 with ticket ID)
[**bookingControllerGetBooking**](UserBookingsApi.md#bookingcontrollergetbooking) | **GET** /user/bookings/{id} | Get booking by ID
[**bookingControllerGetTicketStatus**](UserBookingsApi.md#bookingcontrollergetticketstatus) | **GET** /user/bookings/tickets/{id} | Get checkout ticket status
[**bookingControllerListMyBookings**](UserBookingsApi.md#bookingcontrollerlistmybookings) | **GET** /user/bookings | List my bookings


# **bookingControllerAsyncCheckout**
> AsyncCheckoutResponseDto bookingControllerAsyncCheckout(asyncCheckoutDto)

Start async checkout (returns 202 with ticket ID)

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserBookingsApi();
final asyncCheckoutDto = AsyncCheckoutDto(); // AsyncCheckoutDto |

try {
    final result = api_instance.bookingControllerAsyncCheckout(asyncCheckoutDto);
    print(result);
} catch (e) {
    print('Exception when calling UserBookingsApi->bookingControllerAsyncCheckout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **asyncCheckoutDto** | [**AsyncCheckoutDto**](AsyncCheckoutDto.md)|  |

### Return type

[**AsyncCheckoutResponseDto**](AsyncCheckoutResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **bookingControllerGetBooking**
> BookingResponseDto bookingControllerGetBooking(id)

Get booking by ID

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserBookingsApi();
final id = id_example; // String |

try {
    final result = api_instance.bookingControllerGetBooking(id);
    print(result);
} catch (e) {
    print('Exception when calling UserBookingsApi->bookingControllerGetBooking: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**BookingResponseDto**](BookingResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **bookingControllerGetTicketStatus**
> CheckoutTicketResponseDto bookingControllerGetTicketStatus(id)

Get checkout ticket status

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserBookingsApi();
final id = id_example; // String |

try {
    final result = api_instance.bookingControllerGetTicketStatus(id);
    print(result);
} catch (e) {
    print('Exception when calling UserBookingsApi->bookingControllerGetTicketStatus: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**CheckoutTicketResponseDto**](CheckoutTicketResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **bookingControllerListMyBookings**
> List<BookingResponseDto> bookingControllerListMyBookings()

List my bookings

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserBookingsApi();

try {
    final result = api_instance.bookingControllerListMyBookings();
    print(result);
} catch (e) {
    print('Exception when calling UserBookingsApi->bookingControllerListMyBookings: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<BookingResponseDto>**](BookingResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

