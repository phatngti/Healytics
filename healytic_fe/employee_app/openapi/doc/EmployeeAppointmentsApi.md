# employee_openapi.api.EmployeeAppointmentsApi

## Load the API package
```dart
import 'package:employee_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**employeeAppointmentsControllerCancelAppointment**](EmployeeAppointmentsApi.md#employeeappointmentscontrollercancelappointment) | **PATCH** /employee/appointments/{id}/cancel | Cancel an appointment
[**employeeAppointmentsControllerCompleteService**](EmployeeAppointmentsApi.md#employeeappointmentscontrollercompleteservice) | **PATCH** /employee/appointments/{id}/complete | Complete service for an appointment
[**employeeAppointmentsControllerGetAppointment**](EmployeeAppointmentsApi.md#employeeappointmentscontrollergetappointment) | **GET** /employee/appointments/{id} | Get appointment detail
[**employeeAppointmentsControllerListMyAppointments**](EmployeeAppointmentsApi.md#employeeappointmentscontrollerlistmyappointments) | **GET** /employee/appointments | List my appointments
[**employeeAppointmentsControllerStartService**](EmployeeAppointmentsApi.md#employeeappointmentscontrollerstartservice) | **PATCH** /employee/appointments/{id}/start | Start service for an appointment


# **employeeAppointmentsControllerCancelAppointment**
> EmployeeAppointmentResponseDto employeeAppointmentsControllerCancelAppointment(id, cancelEmployeeAppointmentDto)

Cancel an appointment

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = EmployeeAppointmentsApi();
final id = id_example; // String | 
final cancelEmployeeAppointmentDto = CancelEmployeeAppointmentDto(); // CancelEmployeeAppointmentDto | 

try {
    final result = api_instance.employeeAppointmentsControllerCancelAppointment(id, cancelEmployeeAppointmentDto);
    print(result);
} catch (e) {
    print('Exception when calling EmployeeAppointmentsApi->employeeAppointmentsControllerCancelAppointment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **cancelEmployeeAppointmentDto** | [**CancelEmployeeAppointmentDto**](CancelEmployeeAppointmentDto.md)|  | 

### Return type

[**EmployeeAppointmentResponseDto**](EmployeeAppointmentResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeAppointmentsControllerCompleteService**
> EmployeeAppointmentResponseDto employeeAppointmentsControllerCompleteService(id)

Complete service for an appointment

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = EmployeeAppointmentsApi();
final id = id_example; // String | 

try {
    final result = api_instance.employeeAppointmentsControllerCompleteService(id);
    print(result);
} catch (e) {
    print('Exception when calling EmployeeAppointmentsApi->employeeAppointmentsControllerCompleteService: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**EmployeeAppointmentResponseDto**](EmployeeAppointmentResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeAppointmentsControllerGetAppointment**
> EmployeeAppointmentResponseDto employeeAppointmentsControllerGetAppointment(id)

Get appointment detail

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = EmployeeAppointmentsApi();
final id = id_example; // String | 

try {
    final result = api_instance.employeeAppointmentsControllerGetAppointment(id);
    print(result);
} catch (e) {
    print('Exception when calling EmployeeAppointmentsApi->employeeAppointmentsControllerGetAppointment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**EmployeeAppointmentResponseDto**](EmployeeAppointmentResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeAppointmentsControllerListMyAppointments**
> PaginatedEmployeeAppointmentsResponseDto employeeAppointmentsControllerListMyAppointments(status, page, limit)

List my appointments

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = EmployeeAppointmentsApi();
final status = ; // EmployeeBookingStatusFilter | Filter appointments by status
final page = 8.14; // num | Page number
final limit = 8.14; // num | Items per page

try {
    final result = api_instance.employeeAppointmentsControllerListMyAppointments(status, page, limit);
    print(result);
} catch (e) {
    print('Exception when calling EmployeeAppointmentsApi->employeeAppointmentsControllerListMyAppointments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | [**EmployeeBookingStatusFilter**](.md)| Filter appointments by status | [optional] 
 **page** | **num**| Page number | [optional] [default to 1]
 **limit** | **num**| Items per page | [optional] [default to 20]

### Return type

[**PaginatedEmployeeAppointmentsResponseDto**](PaginatedEmployeeAppointmentsResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeAppointmentsControllerStartService**
> EmployeeAppointmentResponseDto employeeAppointmentsControllerStartService(id)

Start service for an appointment

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = EmployeeAppointmentsApi();
final id = id_example; // String | 

try {
    final result = api_instance.employeeAppointmentsControllerStartService(id);
    print(result);
} catch (e) {
    print('Exception when calling EmployeeAppointmentsApi->employeeAppointmentsControllerStartService: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**EmployeeAppointmentResponseDto**](EmployeeAppointmentResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

