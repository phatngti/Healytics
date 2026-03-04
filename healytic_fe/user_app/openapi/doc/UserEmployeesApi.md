# user_openapi.api.UserEmployeesApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userEmployeesControllerFindAll**](UserEmployeesApi.md#useremployeescontrollerfindall) | **GET** /user/employees | Get all employees
[**userEmployeesControllerFindOne**](UserEmployeesApi.md#useremployeescontrollerfindone) | **GET** /user/employees/{id} | Get an employee by id


# **userEmployeesControllerFindAll**
> List<EmployeeResponseDto> userEmployeesControllerFindAll(role)

Get all employees

### Example
```dart
import 'package:user_openapi/api.dart';
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
import 'package:user_openapi/api.dart';
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

