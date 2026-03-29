# user_openapi.api.UserAppointmentsApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userAppointmentControllerGetAppointment**](UserAppointmentsApi.md#userappointmentcontrollergetappointment) | **GET** /user/appointments/{id} | Get appointment details by ID
[**userAppointmentControllerGetServiceManual**](UserAppointmentsApi.md#userappointmentcontrollergetservicemanual) | **GET** /user/appointments/{appointmentId}/manual | Get service manual for an appointment
[**userAppointmentControllerListAppointments**](UserAppointmentsApi.md#userappointmentcontrollerlistappointments) | **GET** /user/appointments | List all user appointments with optional distance calculation
[**userAppointmentControllerListCategories**](UserAppointmentsApi.md#userappointmentcontrollerlistcategories) | **GET** /user/appointments/categories | Get appointment categories for filter chips
[**userAppointmentControllerListRecentActivity**](UserAppointmentsApi.md#userappointmentcontrollerlistrecentactivity) | **GET** /user/appointments/recent-activity | Get recent appointment activity for home dashboard
[**userAppointmentControllerListRecommendedServices**](UserAppointmentsApi.md#userappointmentcontrollerlistrecommendedservices) | **GET** /user/appointments/recommendations | Get recommended services


# **userAppointmentControllerGetAppointment**
> AppointmentResponseDto userAppointmentControllerGetAppointment(id)

Get appointment details by ID

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserAppointmentsApi();
final id = id_example; // String | 

try {
    final result = api_instance.userAppointmentControllerGetAppointment(id);
    print(result);
} catch (e) {
    print('Exception when calling UserAppointmentsApi->userAppointmentControllerGetAppointment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AppointmentResponseDto**](AppointmentResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userAppointmentControllerGetServiceManual**
> ServiceManualResponseDto userAppointmentControllerGetServiceManual(appointmentId)

Get service manual for an appointment

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserAppointmentsApi();
final appointmentId = appointmentId_example; // String | 

try {
    final result = api_instance.userAppointmentControllerGetServiceManual(appointmentId);
    print(result);
} catch (e) {
    print('Exception when calling UserAppointmentsApi->userAppointmentControllerGetServiceManual: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appointmentId** | **String**|  | 

### Return type

[**ServiceManualResponseDto**](ServiceManualResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userAppointmentControllerListAppointments**
> List<AppointmentResponseDto> userAppointmentControllerListAppointments(latitude, longitude)

List all user appointments with optional distance calculation

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserAppointmentsApi();
final latitude = 10.7769; // num | User latitude (-90 to 90)
final longitude = 106.7009; // num | User longitude (-180 to 180)

try {
    final result = api_instance.userAppointmentControllerListAppointments(latitude, longitude);
    print(result);
} catch (e) {
    print('Exception when calling UserAppointmentsApi->userAppointmentControllerListAppointments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **latitude** | **num**| User latitude (-90 to 90) | [optional] 
 **longitude** | **num**| User longitude (-180 to 180) | [optional] 

### Return type

[**List<AppointmentResponseDto>**](AppointmentResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userAppointmentControllerListCategories**
> List<AppointmentCategoryResponseDto> userAppointmentControllerListCategories()

Get appointment categories for filter chips

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserAppointmentsApi();

try {
    final result = api_instance.userAppointmentControllerListCategories();
    print(result);
} catch (e) {
    print('Exception when calling UserAppointmentsApi->userAppointmentControllerListCategories: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<AppointmentCategoryResponseDto>**](AppointmentCategoryResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userAppointmentControllerListRecentActivity**
> userAppointmentControllerListRecentActivity(limit, offset)

Get recent appointment activity for home dashboard

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserAppointmentsApi();
final limit = 5; // num | Maximum number of items to return (1–20)
final offset = 0; // num | Number of items to skip

try {
    api_instance.userAppointmentControllerListRecentActivity(limit, offset);
} catch (e) {
    print('Exception when calling UserAppointmentsApi->userAppointmentControllerListRecentActivity: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **num**| Maximum number of items to return (1–20) | [optional] [default to 5]
 **offset** | **num**| Number of items to skip | [optional] [default to 0]

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userAppointmentControllerListRecommendedServices**
> List<RecommendedServiceResponseDto> userAppointmentControllerListRecommendedServices()

Get recommended services

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserAppointmentsApi();

try {
    final result = api_instance.userAppointmentControllerListRecommendedServices();
    print(result);
} catch (e) {
    print('Exception when calling UserAppointmentsApi->userAppointmentControllerListRecommendedServices: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<RecommendedServiceResponseDto>**](RecommendedServiceResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

