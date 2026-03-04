# admin_openapi.api.PartnerEmployeesApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnerEmployeesControllerCreateDoctor**](PartnerEmployeesApi.md#partneremployeescontrollercreatedoctor) | **POST** /partner/employees/doctors | Create a new doctor
[**partnerEmployeesControllerCreateTherapist**](PartnerEmployeesApi.md#partneremployeescontrollercreatetherapist) | **POST** /partner/employees/therapists | Create a new therapist
[**partnerEmployeesControllerFindAll**](PartnerEmployeesApi.md#partneremployeescontrollerfindall) | **GET** /partner/employees | Get all employees for this partner
[**partnerEmployeesControllerFindOne**](PartnerEmployeesApi.md#partneremployeescontrollerfindone) | **GET** /partner/employees/{id} | Get an employee by id
[**partnerEmployeesControllerRemove**](PartnerEmployeesApi.md#partneremployeescontrollerremove) | **DELETE** /partner/employees/{id} | Delete an employee
[**partnerEmployeesControllerUpdate**](PartnerEmployeesApi.md#partneremployeescontrollerupdate) | **PATCH** /partner/employees/{id} | Update an employee


# **partnerEmployeesControllerCreateDoctor**
> EmployeeResponseDto partnerEmployeesControllerCreateDoctor(createDoctorDto)

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

final api_instance = PartnerEmployeesApi();
final createDoctorDto = CreateDoctorDto(); // CreateDoctorDto | 

try {
    final result = api_instance.partnerEmployeesControllerCreateDoctor(createDoctorDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerEmployeesApi->partnerEmployeesControllerCreateDoctor: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createDoctorDto** | [**CreateDoctorDto**](CreateDoctorDto.md)|  | 

### Return type

[**EmployeeResponseDto**](EmployeeResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerEmployeesControllerCreateTherapist**
> EmployeeResponseDto partnerEmployeesControllerCreateTherapist(createTherapistDto)

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

final api_instance = PartnerEmployeesApi();
final createTherapistDto = CreateTherapistDto(); // CreateTherapistDto | 

try {
    final result = api_instance.partnerEmployeesControllerCreateTherapist(createTherapistDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerEmployeesApi->partnerEmployeesControllerCreateTherapist: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createTherapistDto** | [**CreateTherapistDto**](CreateTherapistDto.md)|  | 

### Return type

[**EmployeeResponseDto**](EmployeeResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerEmployeesControllerFindAll**
> List<EmployeeResponseDto> partnerEmployeesControllerFindAll(role)

Get all employees for this partner

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerEmployeesApi();
final role = role_example; // String | 

try {
    final result = api_instance.partnerEmployeesControllerFindAll(role);
    print(result);
} catch (e) {
    print('Exception when calling PartnerEmployeesApi->partnerEmployeesControllerFindAll: $e\n');
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

# **partnerEmployeesControllerFindOne**
> EmployeeResponseDto partnerEmployeesControllerFindOne(id)

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

final api_instance = PartnerEmployeesApi();
final id = id_example; // String | 

try {
    final result = api_instance.partnerEmployeesControllerFindOne(id);
    print(result);
} catch (e) {
    print('Exception when calling PartnerEmployeesApi->partnerEmployeesControllerFindOne: $e\n');
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

# **partnerEmployeesControllerRemove**
> partnerEmployeesControllerRemove(id)

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

final api_instance = PartnerEmployeesApi();
final id = id_example; // String | 

try {
    api_instance.partnerEmployeesControllerRemove(id);
} catch (e) {
    print('Exception when calling PartnerEmployeesApi->partnerEmployeesControllerRemove: $e\n');
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

# **partnerEmployeesControllerUpdate**
> EmployeeResponseDto partnerEmployeesControllerUpdate(id, updateEmployeeDto)

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

final api_instance = PartnerEmployeesApi();
final id = id_example; // String | 
final updateEmployeeDto = UpdateEmployeeDto(); // UpdateEmployeeDto | 

try {
    final result = api_instance.partnerEmployeesControllerUpdate(id, updateEmployeeDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerEmployeesApi->partnerEmployeesControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateEmployeeDto** | [**UpdateEmployeeDto**](UpdateEmployeeDto.md)|  | 

### Return type

[**EmployeeResponseDto**](EmployeeResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

