# employee_openapi.api.EmployeeProfileApi

## Load the API package
```dart
import 'package:employee_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**employeeProfileControllerGetMyProfile**](EmployeeProfileApi.md#employeeprofilecontrollergetmyprofile) | **GET** /employee/profile | Get my employee profile
[**employeeProfileControllerUpdateMyProfile**](EmployeeProfileApi.md#employeeprofilecontrollerupdatemyprofile) | **PATCH** /employee/profile | Update my employee profile


# **employeeProfileControllerGetMyProfile**
> EmployeeResponseDto employeeProfileControllerGetMyProfile()

Get my employee profile

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = EmployeeProfileApi();

try {
    final result = api_instance.employeeProfileControllerGetMyProfile();
    print(result);
} catch (e) {
    print('Exception when calling EmployeeProfileApi->employeeProfileControllerGetMyProfile: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**EmployeeResponseDto**](EmployeeResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeProfileControllerUpdateMyProfile**
> EmployeeResponseDto employeeProfileControllerUpdateMyProfile(updateEmployeeProfileDto)

Update my employee profile

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = EmployeeProfileApi();
final updateEmployeeProfileDto = UpdateEmployeeProfileDto(); // UpdateEmployeeProfileDto | 

try {
    final result = api_instance.employeeProfileControllerUpdateMyProfile(updateEmployeeProfileDto);
    print(result);
} catch (e) {
    print('Exception when calling EmployeeProfileApi->employeeProfileControllerUpdateMyProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateEmployeeProfileDto** | [**UpdateEmployeeProfileDto**](UpdateEmployeeProfileDto.md)|  | 

### Return type

[**EmployeeResponseDto**](EmployeeResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

