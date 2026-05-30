# user_openapi.api.PartnerDashboardApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnerDashboardControllerGetEmployeeDistribution**](PartnerDashboardApi.md#partnerdashboardcontrollergetemployeedistribution) | **GET** /partner/dashboard/employees/distribution | Get employee role distribution
[**partnerDashboardControllerGetInventoryAlerts**](PartnerDashboardApi.md#partnerdashboardcontrollergetinventoryalerts) | **GET** /partner/dashboard/inventory/alerts | Get inventory alerts
[**partnerDashboardControllerGetNotifications**](PartnerDashboardApi.md#partnerdashboardcontrollergetnotifications) | **GET** /partner/dashboard/notifications | Get dashboard notifications
[**partnerDashboardControllerGetRecentReviews**](PartnerDashboardApi.md#partnerdashboardcontrollergetrecentreviews) | **GET** /partner/dashboard/reviews/recent | Get recent customer reviews
[**partnerDashboardControllerGetRevenue**](PartnerDashboardApi.md#partnerdashboardcontrollergetrevenue) | **GET** /partner/dashboard/revenue | Get revenue time-series data
[**partnerDashboardControllerGetServicePerformance**](PartnerDashboardApi.md#partnerdashboardcontrollergetserviceperformance) | **GET** /partner/dashboard/services/performance | Get service performance metrics
[**partnerDashboardControllerGetStaffSchedule**](PartnerDashboardApi.md#partnerdashboardcontrollergetstaffschedule) | **GET** /partner/dashboard/staff/schedule | Get staff schedule for a date
[**partnerDashboardControllerGetStats**](PartnerDashboardApi.md#partnerdashboardcontrollergetstats) | **GET** /partner/dashboard/stats | Get aggregated KPI statistics
[**partnerDashboardControllerGetUpcomingAppointments**](PartnerDashboardApi.md#partnerdashboardcontrollergetupcomingappointments) | **GET** /partner/dashboard/appointments/upcoming | Get upcoming appointments


# **partnerDashboardControllerGetEmployeeDistribution**
> List<EmployeeDistributionDto> partnerDashboardControllerGetEmployeeDistribution()

Get employee role distribution

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerDashboardApi();

try {
    final result = api_instance.partnerDashboardControllerGetEmployeeDistribution();
    print(result);
} catch (e) {
    print('Exception when calling PartnerDashboardApi->partnerDashboardControllerGetEmployeeDistribution: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<EmployeeDistributionDto>**](EmployeeDistributionDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerDashboardControllerGetInventoryAlerts**
> List<InventoryAlertDto> partnerDashboardControllerGetInventoryAlerts()

Get inventory alerts

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerDashboardApi();

try {
    final result = api_instance.partnerDashboardControllerGetInventoryAlerts();
    print(result);
} catch (e) {
    print('Exception when calling PartnerDashboardApi->partnerDashboardControllerGetInventoryAlerts: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<InventoryAlertDto>**](InventoryAlertDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerDashboardControllerGetNotifications**
> List<DashboardNotificationDto> partnerDashboardControllerGetNotifications(limit)

Get dashboard notifications

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerDashboardApi();
final limit = 8.14; // num | Maximum number of items to return

try {
    final result = api_instance.partnerDashboardControllerGetNotifications(limit);
    print(result);
} catch (e) {
    print('Exception when calling PartnerDashboardApi->partnerDashboardControllerGetNotifications: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **num**| Maximum number of items to return | [optional] [default to 5]

### Return type

[**List<DashboardNotificationDto>**](DashboardNotificationDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerDashboardControllerGetRecentReviews**
> List<DashboardReviewDto> partnerDashboardControllerGetRecentReviews(limit)

Get recent customer reviews

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerDashboardApi();
final limit = 8.14; // num | Maximum number of items to return

try {
    final result = api_instance.partnerDashboardControllerGetRecentReviews(limit);
    print(result);
} catch (e) {
    print('Exception when calling PartnerDashboardApi->partnerDashboardControllerGetRecentReviews: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **num**| Maximum number of items to return | [optional] [default to 5]

### Return type

[**List<DashboardReviewDto>**](DashboardReviewDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerDashboardControllerGetRevenue**
> List<RevenueDataPointDto> partnerDashboardControllerGetRevenue(period)

Get revenue time-series data

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerDashboardApi();
final period = period_example; // String | Time period filter for revenue and KPI aggregation

try {
    final result = api_instance.partnerDashboardControllerGetRevenue(period);
    print(result);
} catch (e) {
    print('Exception when calling PartnerDashboardApi->partnerDashboardControllerGetRevenue: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | **String**| Time period filter for revenue and KPI aggregation | [optional] [default to 'this_month']

### Return type

[**List<RevenueDataPointDto>**](RevenueDataPointDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerDashboardControllerGetServicePerformance**
> List<ServicePerformanceDto> partnerDashboardControllerGetServicePerformance()

Get service performance metrics

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerDashboardApi();

try {
    final result = api_instance.partnerDashboardControllerGetServicePerformance();
    print(result);
} catch (e) {
    print('Exception when calling PartnerDashboardApi->partnerDashboardControllerGetServicePerformance: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ServicePerformanceDto>**](ServicePerformanceDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerDashboardControllerGetStaffSchedule**
> List<StaffScheduleEntryDto> partnerDashboardControllerGetStaffSchedule(date)

Get staff schedule for a date

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerDashboardApi();
final date = 2026-04-09; // String | Target date for schedule lookup (ISO 8601 date)

try {
    final result = api_instance.partnerDashboardControllerGetStaffSchedule(date);
    print(result);
} catch (e) {
    print('Exception when calling PartnerDashboardApi->partnerDashboardControllerGetStaffSchedule: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **date** | **String**| Target date for schedule lookup (ISO 8601 date) |

### Return type

[**List<StaffScheduleEntryDto>**](StaffScheduleEntryDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerDashboardControllerGetStats**
> DashboardStatsResponseDto partnerDashboardControllerGetStats(period)

Get aggregated KPI statistics

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerDashboardApi();
final period = period_example; // String | Time period filter for revenue and KPI aggregation

try {
    final result = api_instance.partnerDashboardControllerGetStats(period);
    print(result);
} catch (e) {
    print('Exception when calling PartnerDashboardApi->partnerDashboardControllerGetStats: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | **String**| Time period filter for revenue and KPI aggregation | [optional] [default to 'this_month']

### Return type

[**DashboardStatsResponseDto**](DashboardStatsResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerDashboardControllerGetUpcomingAppointments**
> List<UpcomingAppointmentDto> partnerDashboardControllerGetUpcomingAppointments(limit)

Get upcoming appointments

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerDashboardApi();
final limit = 8.14; // num | Maximum number of items to return

try {
    final result = api_instance.partnerDashboardControllerGetUpcomingAppointments(limit);
    print(result);
} catch (e) {
    print('Exception when calling PartnerDashboardApi->partnerDashboardControllerGetUpcomingAppointments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **num**| Maximum number of items to return | [optional] [default to 5]

### Return type

[**List<UpcomingAppointmentDto>**](UpcomingAppointmentDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

