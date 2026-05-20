# employee_openapi.api.EmployeeRevenueApi

## Load the API package
```dart
import 'package:employee_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**employeeRevenueControllerGetBreakdown**](EmployeeRevenueApi.md#employeerevenuecontrollergetbreakdown) | **GET** /employee/revenue/breakdown | Get revenue breakdown by service
[**employeeRevenueControllerGetSummary**](EmployeeRevenueApi.md#employeerevenuecontrollergetsummary) | **GET** /employee/revenue/summary | Get revenue summary
[**employeeRevenueControllerGetTrend**](EmployeeRevenueApi.md#employeerevenuecontrollergettrend) | **GET** /employee/revenue/trend | Get revenue trend data


# **employeeRevenueControllerGetBreakdown**
> List<EmployeeRevenueBreakdownItemDto> employeeRevenueControllerGetBreakdown(period, date)

Get revenue breakdown by service

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = EmployeeRevenueApi();
final period = ; // EmployeeRevenuePeriod | Time period for revenue aggregation
final date = 2026-05-01; // String | Reference date for the period (defaults to today)

try {
    final result = api_instance.employeeRevenueControllerGetBreakdown(period, date);
    print(result);
} catch (e) {
    print('Exception when calling EmployeeRevenueApi->employeeRevenueControllerGetBreakdown: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | [**EmployeeRevenuePeriod**](.md)| Time period for revenue aggregation | [optional] 
 **date** | **String**| Reference date for the period (defaults to today) | [optional] 

### Return type

[**List<EmployeeRevenueBreakdownItemDto>**](EmployeeRevenueBreakdownItemDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeRevenueControllerGetSummary**
> EmployeeRevenueSummaryResponseDto employeeRevenueControllerGetSummary(period, date)

Get revenue summary

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = EmployeeRevenueApi();
final period = ; // EmployeeRevenuePeriod | Time period for revenue aggregation
final date = 2026-05-01; // String | Reference date for the period (defaults to today)

try {
    final result = api_instance.employeeRevenueControllerGetSummary(period, date);
    print(result);
} catch (e) {
    print('Exception when calling EmployeeRevenueApi->employeeRevenueControllerGetSummary: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | [**EmployeeRevenuePeriod**](.md)| Time period for revenue aggregation | [optional] 
 **date** | **String**| Reference date for the period (defaults to today) | [optional] 

### Return type

[**EmployeeRevenueSummaryResponseDto**](EmployeeRevenueSummaryResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeeRevenueControllerGetTrend**
> List<EmployeeRevenueTrendPointDto> employeeRevenueControllerGetTrend(period, date)

Get revenue trend data

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = EmployeeRevenueApi();
final period = ; // EmployeeRevenuePeriod | Time period for revenue aggregation
final date = 2026-05-01; // String | Reference date for the period (defaults to today)

try {
    final result = api_instance.employeeRevenueControllerGetTrend(period, date);
    print(result);
} catch (e) {
    print('Exception when calling EmployeeRevenueApi->employeeRevenueControllerGetTrend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | [**EmployeeRevenuePeriod**](.md)| Time period for revenue aggregation | [optional] 
 **date** | **String**| Reference date for the period (defaults to today) | [optional] 

### Return type

[**List<EmployeeRevenueTrendPointDto>**](EmployeeRevenueTrendPointDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

