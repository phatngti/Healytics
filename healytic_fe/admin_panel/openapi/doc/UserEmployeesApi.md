# admin_openapi.api.UserEmployeesApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userEmployeesControllerFindAll**](UserEmployeesApi.md#useremployeescontrollerfindall) | **GET** /user/employees | Get all employees
[**userEmployeesControllerFindOne**](UserEmployeesApi.md#useremployeescontrollerfindone) | **GET** /user/employees/{id} | Get an employee by id
[**userEmployeesControllerFindServices**](UserEmployeesApi.md#useremployeescontrollerfindservices) | **GET** /user/employees/{id}/services | Get services for a specialist
[**userEmployeesControllerGetFeaturedSpecialists**](UserEmployeesApi.md#useremployeescontrollergetfeaturedspecialists) | **GET** /user/employees/featured-specialists | Get featured specialists for home page
[**userEmployeesControllerGetTimeSlots**](UserEmployeesApi.md#useremployeescontrollergettimeslots) | **GET** /user/employees/{id}/time-slots | Get time slots with availability for an employee


# **userEmployeesControllerFindAll**
> List<EmployeeResponseDto> userEmployeesControllerFindAll(role)

Get all employees

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserEmployeesApi();
final role = role_example; // String | 

try {
    final result = api_instance.userEmployeesControllerFindAll(role);
    print(result);
} catch (e) {
    print('Exception when calling UserEmployeesApi->userEmployeesControllerFindAll: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **role** | **String**|  | [optional] 

### Return type

[**List<EmployeeResponseDto>**](EmployeeResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userEmployeesControllerFindOne**
> EmployeeResponseDto userEmployeesControllerFindOne(id)

Get an employee by id

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserEmployeesApi();
final id = id_example; // String | 

try {
    final result = api_instance.userEmployeesControllerFindOne(id);
    print(result);
} catch (e) {
    print('Exception when calling UserEmployeesApi->userEmployeesControllerFindOne: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**EmployeeResponseDto**](EmployeeResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userEmployeesControllerFindServices**
> List<BookingServiceResponseDto> userEmployeesControllerFindServices(id)

Get services for a specialist

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserEmployeesApi();
final id = id_example; // String | 

try {
    final result = api_instance.userEmployeesControllerFindServices(id);
    print(result);
} catch (e) {
    print('Exception when calling UserEmployeesApi->userEmployeesControllerFindServices: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**List<BookingServiceResponseDto>**](BookingServiceResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userEmployeesControllerGetFeaturedSpecialists**
> List<FeaturedSpecialistResponseDto> userEmployeesControllerGetFeaturedSpecialists(limit)

Get featured specialists for home page

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserEmployeesApi();
final limit = 8.14; // num | Max specialists to return (default 10)

try {
    final result = api_instance.userEmployeesControllerGetFeaturedSpecialists(limit);
    print(result);
} catch (e) {
    print('Exception when calling UserEmployeesApi->userEmployeesControllerGetFeaturedSpecialists: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **num**| Max specialists to return (default 10) | [optional] 

### Return type

[**List<FeaturedSpecialistResponseDto>**](FeaturedSpecialistResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userEmployeesControllerGetTimeSlots**
> EmployeeTimeSlotsResponseDto userEmployeesControllerGetTimeSlots(id, date, days)

Get time slots with availability for an employee

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserEmployeesApi();
final id = id_example; // String | 
final date = 2026-03-26; // String | Start date for the schedule range (YYYY-MM-DD). Defaults to today.
final days = 7; // num | Number of days to return from the start date. Default 7, max 30.

try {
    final result = api_instance.userEmployeesControllerGetTimeSlots(id, date, days);
    print(result);
} catch (e) {
    print('Exception when calling UserEmployeesApi->userEmployeesControllerGetTimeSlots: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **date** | **String**| Start date for the schedule range (YYYY-MM-DD). Defaults to today. | [optional] 
 **days** | **num**| Number of days to return from the start date. Default 7, max 30. | [optional] 

### Return type

[**EmployeeTimeSlotsResponseDto**](EmployeeTimeSlotsResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

