# admin_openapi.api.PartnerBookingsApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnerBookingsControllerGetBooking**](PartnerBookingsApi.md#partnerbookingscontrollergetbooking) | **GET** /partner/bookings/{id} | Get partner booking detail
[**partnerBookingsControllerListBookings**](PartnerBookingsApi.md#partnerbookingscontrollerlistbookings) | **GET** /partner/bookings | List bookings for the authenticated partner


# **partnerBookingsControllerGetBooking**
> PartnerBookingResponseDto partnerBookingsControllerGetBooking(id)

Get partner booking detail

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerBookingsApi();
final id = id_example; // String | 

try {
    final result = api_instance.partnerBookingsControllerGetBooking(id);
    print(result);
} catch (e) {
    print('Exception when calling PartnerBookingsApi->partnerBookingsControllerGetBooking: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**PartnerBookingResponseDto**](PartnerBookingResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerBookingsControllerListBookings**
> List<PartnerBookingResponseDto> partnerBookingsControllerListBookings()

List bookings for the authenticated partner

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerBookingsApi();

try {
    final result = api_instance.partnerBookingsControllerListBookings();
    print(result);
} catch (e) {
    print('Exception when calling PartnerBookingsApi->partnerBookingsControllerListBookings: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<PartnerBookingResponseDto>**](PartnerBookingResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

