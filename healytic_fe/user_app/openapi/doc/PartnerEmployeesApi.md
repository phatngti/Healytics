# user_openapi.api.PartnerEmployeesApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnerEmployeesControllerCreateDoctor**](PartnerEmployeesApi.md#partneremployeescontrollercreatedoctor) | **POST** /partner/employees/doctors | Create a new doctor
[**partnerEmployeesControllerCreateMassageSkill**](PartnerEmployeesApi.md#partneremployeescontrollercreatemassageskill) | **POST** /partner/employees/massage-skills | Create a massage skill
[**partnerEmployeesControllerCreateMassageTherapist**](PartnerEmployeesApi.md#partneremployeescontrollercreatemassagetherapist) | **POST** /partner/employees/massage-therapists | Create a new massage therapist
[**partnerEmployeesControllerCreateSpaSkill**](PartnerEmployeesApi.md#partneremployeescontrollercreatespaskill) | **POST** /partner/employees/spa-skills | Create a spa skill
[**partnerEmployeesControllerCreateSpaTherapist**](PartnerEmployeesApi.md#partneremployeescontrollercreatespatherapist) | **POST** /partner/employees/spa-therapists | Create a new spa therapist
[**partnerEmployeesControllerFindAll**](PartnerEmployeesApi.md#partneremployeescontrollerfindall) | **GET** /partner/employees | Get all employees for this partner
[**partnerEmployeesControllerFindAssignedServices**](PartnerEmployeesApi.md#partneremployeescontrollerfindassignedservices) | **GET** /partner/employees/{id}/services | Get services assigned to an employee
[**partnerEmployeesControllerFindOne**](PartnerEmployeesApi.md#partneremployeescontrollerfindone) | **GET** /partner/employees/{id} | Get an employee by id
[**partnerEmployeesControllerGetDetailAnalytics**](PartnerEmployeesApi.md#partneremployeescontrollergetdetailanalytics) | **GET** /partner/employees/analytics/{employeeId} | Get per-employee detail analytics
[**partnerEmployeesControllerGetMassageSkills**](PartnerEmployeesApi.md#partneremployeescontrollergetmassageskills) | **GET** /partner/employees/massage-skills | Get massage skill catalog
[**partnerEmployeesControllerGetOverviewAnalytics**](PartnerEmployeesApi.md#partneremployeescontrollergetoverviewanalytics) | **GET** /partner/employees/analytics/overview | Get employee overview analytics
[**partnerEmployeesControllerGetSpaSkills**](PartnerEmployeesApi.md#partneremployeescontrollergetspaskills) | **GET** /partner/employees/spa-skills | Get spa skill catalog
[**partnerEmployeesControllerRemove**](PartnerEmployeesApi.md#partneremployeescontrollerremove) | **DELETE** /partner/employees/{id} | Delete an employee
[**partnerEmployeesControllerUpdate**](PartnerEmployeesApi.md#partneremployeescontrollerupdate) | **PATCH** /partner/employees/{id} | Update an employee


# **partnerEmployeesControllerCreateDoctor**
> EmployeeResponseDto partnerEmployeesControllerCreateDoctor(createDoctorDto)

Create a new doctor

### Example
```dart
import 'package:user_openapi/api.dart';
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

# **partnerEmployeesControllerCreateMassageSkill**
> SkillCatalogResponseDto partnerEmployeesControllerCreateMassageSkill(createSkillDto)

Create a massage skill

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerEmployeesApi();
final createSkillDto = CreateSkillDto(); // CreateSkillDto | 

try {
    final result = api_instance.partnerEmployeesControllerCreateMassageSkill(createSkillDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerEmployeesApi->partnerEmployeesControllerCreateMassageSkill: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createSkillDto** | [**CreateSkillDto**](CreateSkillDto.md)|  | 

### Return type

[**SkillCatalogResponseDto**](SkillCatalogResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerEmployeesControllerCreateMassageTherapist**
> EmployeeResponseDto partnerEmployeesControllerCreateMassageTherapist(createMassageTherapistDto)

Create a new massage therapist

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerEmployeesApi();
final createMassageTherapistDto = CreateMassageTherapistDto(); // CreateMassageTherapistDto | 

try {
    final result = api_instance.partnerEmployeesControllerCreateMassageTherapist(createMassageTherapistDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerEmployeesApi->partnerEmployeesControllerCreateMassageTherapist: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createMassageTherapistDto** | [**CreateMassageTherapistDto**](CreateMassageTherapistDto.md)|  | 

### Return type

[**EmployeeResponseDto**](EmployeeResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerEmployeesControllerCreateSpaSkill**
> SkillCatalogResponseDto partnerEmployeesControllerCreateSpaSkill(createSkillDto)

Create a spa skill

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerEmployeesApi();
final createSkillDto = CreateSkillDto(); // CreateSkillDto | 

try {
    final result = api_instance.partnerEmployeesControllerCreateSpaSkill(createSkillDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerEmployeesApi->partnerEmployeesControllerCreateSpaSkill: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createSkillDto** | [**CreateSkillDto**](CreateSkillDto.md)|  | 

### Return type

[**SkillCatalogResponseDto**](SkillCatalogResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerEmployeesControllerCreateSpaTherapist**
> EmployeeResponseDto partnerEmployeesControllerCreateSpaTherapist(createSpaTherapistDto)

Create a new spa therapist

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerEmployeesApi();
final createSpaTherapistDto = CreateSpaTherapistDto(); // CreateSpaTherapistDto | 

try {
    final result = api_instance.partnerEmployeesControllerCreateSpaTherapist(createSpaTherapistDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerEmployeesApi->partnerEmployeesControllerCreateSpaTherapist: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createSpaTherapistDto** | [**CreateSpaTherapistDto**](CreateSpaTherapistDto.md)|  | 

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
import 'package:user_openapi/api.dart';
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

# **partnerEmployeesControllerFindAssignedServices**
> List<EmployeeAssignedServiceDto> partnerEmployeesControllerFindAssignedServices(id)

Get services assigned to an employee

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerEmployeesApi();
final id = id_example; // String | 

try {
    final result = api_instance.partnerEmployeesControllerFindAssignedServices(id);
    print(result);
} catch (e) {
    print('Exception when calling PartnerEmployeesApi->partnerEmployeesControllerFindAssignedServices: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**List<EmployeeAssignedServiceDto>**](EmployeeAssignedServiceDto.md)

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
import 'package:user_openapi/api.dart';
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

# **partnerEmployeesControllerGetDetailAnalytics**
> EmployeeDetailAnalyticsResponseDto partnerEmployeesControllerGetDetailAnalytics(employeeId, period)

Get per-employee detail analytics

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerEmployeesApi();
final employeeId = employeeId_example; // String | 
final period = ; // DashboardTimePeriod | Time period for employee analytics aggregation

try {
    final result = api_instance.partnerEmployeesControllerGetDetailAnalytics(employeeId, period);
    print(result);
} catch (e) {
    print('Exception when calling PartnerEmployeesApi->partnerEmployeesControllerGetDetailAnalytics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **employeeId** | **String**|  | 
 **period** | [**DashboardTimePeriod**](.md)| Time period for employee analytics aggregation | [optional] 

### Return type

[**EmployeeDetailAnalyticsResponseDto**](EmployeeDetailAnalyticsResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerEmployeesControllerGetMassageSkills**
> List<SkillCatalogResponseDto> partnerEmployeesControllerGetMassageSkills()

Get massage skill catalog

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerEmployeesApi();

try {
    final result = api_instance.partnerEmployeesControllerGetMassageSkills();
    print(result);
} catch (e) {
    print('Exception when calling PartnerEmployeesApi->partnerEmployeesControllerGetMassageSkills: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<SkillCatalogResponseDto>**](SkillCatalogResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerEmployeesControllerGetOverviewAnalytics**
> EmployeeOverviewAnalyticsResponseDto partnerEmployeesControllerGetOverviewAnalytics(period)

Get employee overview analytics

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerEmployeesApi();
final period = ; // DashboardTimePeriod | Time period for employee analytics aggregation

try {
    final result = api_instance.partnerEmployeesControllerGetOverviewAnalytics(period);
    print(result);
} catch (e) {
    print('Exception when calling PartnerEmployeesApi->partnerEmployeesControllerGetOverviewAnalytics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | [**DashboardTimePeriod**](.md)| Time period for employee analytics aggregation | [optional] 

### Return type

[**EmployeeOverviewAnalyticsResponseDto**](EmployeeOverviewAnalyticsResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerEmployeesControllerGetSpaSkills**
> List<SkillCatalogResponseDto> partnerEmployeesControllerGetSpaSkills()

Get spa skill catalog

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerEmployeesApi();

try {
    final result = api_instance.partnerEmployeesControllerGetSpaSkills();
    print(result);
} catch (e) {
    print('Exception when calling PartnerEmployeesApi->partnerEmployeesControllerGetSpaSkills: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<SkillCatalogResponseDto>**](SkillCatalogResponseDto.md)

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
import 'package:user_openapi/api.dart';
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
import 'package:user_openapi/api.dart';
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

