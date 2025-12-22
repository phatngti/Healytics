# admin_openapi.api.EmployeesApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**employeesControllerCreateDoctor**](EmployeesApi.md#employeescontrollercreatedoctor) | **POST** /employees/doctors | Create a new doctor
[**employeesControllerCreateTherapist**](EmployeesApi.md#employeescontrollercreatetherapist) | **POST** /employees/therapists | Create a new therapist
[**employeesControllerFindAll**](EmployeesApi.md#employeescontrollerfindall) | **GET** /employees | Get all employees
[**employeesControllerFindOne**](EmployeesApi.md#employeescontrollerfindone) | **GET** /employees/{id} | Get an employee by id
[**employeesControllerRemove**](EmployeesApi.md#employeescontrollerremove) | **DELETE** /employees/{id} | Delete an employee
[**employeesControllerUpdate**](EmployeesApi.md#employeescontrollerupdate) | **PATCH** /employees/{id} | Update an employee


# **employeesControllerCreateDoctor**
> Object employeesControllerCreateDoctor(createDoctorDto)

Create a new doctor

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = EmployeesApi();
final createDoctorDto = CreateDoctorDto(); // CreateDoctorDto | 

try {
    final result = api_instance.employeesControllerCreateDoctor(createDoctorDto);
    print(result);
} catch (e) {
    print('Exception when calling EmployeesApi->employeesControllerCreateDoctor: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createDoctorDto** | [**CreateDoctorDto**](CreateDoctorDto.md)|  | 

### Return type

[**Object**](Object.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeesControllerCreateTherapist**
> Object employeesControllerCreateTherapist(createTherapistDto)

Create a new therapist

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = EmployeesApi();
final createTherapistDto = CreateTherapistDto(); // CreateTherapistDto | 

try {
    final result = api_instance.employeesControllerCreateTherapist(createTherapistDto);
    print(result);
} catch (e) {
    print('Exception when calling EmployeesApi->employeesControllerCreateTherapist: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createTherapistDto** | [**CreateTherapistDto**](CreateTherapistDto.md)|  | 

### Return type

[**Object**](Object.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeesControllerFindAll**
> List<Object> employeesControllerFindAll()

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

final api_instance = EmployeesApi();

try {
    final result = api_instance.employeesControllerFindAll();
    print(result);
} catch (e) {
    print('Exception when calling EmployeesApi->employeesControllerFindAll: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<Object>**](Object.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeesControllerFindOne**
> Object employeesControllerFindOne(id)

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

final api_instance = EmployeesApi();
final id = id_example; // String | 

try {
    final result = api_instance.employeesControllerFindOne(id);
    print(result);
} catch (e) {
    print('Exception when calling EmployeesApi->employeesControllerFindOne: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Object**](Object.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeesControllerRemove**
> employeesControllerRemove(id)

Delete an employee

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = EmployeesApi();
final id = id_example; // String | 

try {
    api_instance.employeesControllerRemove(id);
} catch (e) {
    print('Exception when calling EmployeesApi->employeesControllerRemove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeesControllerUpdate**
> Object employeesControllerUpdate(id, updateEmployeeDto)

Update an employee

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = EmployeesApi();
final id = id_example; // String | 
final updateEmployeeDto = UpdateEmployeeDto(); // UpdateEmployeeDto | 

try {
    final result = api_instance.employeesControllerUpdate(id, updateEmployeeDto);
    print(result);
} catch (e) {
    print('Exception when calling EmployeesApi->employeesControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateEmployeeDto** | [**UpdateEmployeeDto**](UpdateEmployeeDto.md)|  | 

### Return type

[**Object**](Object.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

