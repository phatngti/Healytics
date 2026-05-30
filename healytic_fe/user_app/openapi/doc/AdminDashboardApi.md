# user_openapi.api.AdminDashboardApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminDashboardControllerGetBookingOutcomeSummary**](AdminDashboardApi.md#admindashboardcontrollergetbookingoutcomesummary) | **GET** /admin/dashboard/booking-outcomes | Get booking outcome summary
[**adminDashboardControllerGetCategoryHealth**](AdminDashboardApi.md#admindashboardcontrollergetcategoryhealth) | **GET** /admin/dashboard/category-health | Get service category health overview
[**adminDashboardControllerGetNotifications**](AdminDashboardApi.md#admindashboardcontrollergetnotifications) | **GET** /admin/dashboard/notifications | Get admin dashboard notifications
[**adminDashboardControllerGetOverview**](AdminDashboardApi.md#admindashboardcontrollergetoverview) | **GET** /admin/dashboard/overview | Get admin dashboard overview metrics
[**adminDashboardControllerGetRevenueTrend**](AdminDashboardApi.md#admindashboardcontrollergetrevenuetrend) | **GET** /admin/dashboard/revenue-trend | Get admin revenue trend data points
[**adminDashboardControllerGetTopPartners**](AdminDashboardApi.md#admindashboardcontrollergettoppartners) | **GET** /admin/dashboard/top-partners | Get top performing partners by revenue
[**adminDashboardControllerGetTopServices**](AdminDashboardApi.md#admindashboardcontrollergettopservices) | **GET** /admin/dashboard/top-services | Get top performing services by revenue
[**adminDashboardControllerGetTransactionHealth**](AdminDashboardApi.md#admindashboardcontrollergettransactionhealth) | **GET** /admin/dashboard/transaction-health | Get transaction health breakdown


# **adminDashboardControllerGetBookingOutcomeSummary**
> AdminDashboardBookingOutcomeSummaryDto adminDashboardControllerGetBookingOutcomeSummary(period)

Get booking outcome summary

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminDashboardApi();
final period = period_example; // String |

try {
    final result = api_instance.adminDashboardControllerGetBookingOutcomeSummary(period);
    print(result);
} catch (e) {
    print('Exception when calling AdminDashboardApi->adminDashboardControllerGetBookingOutcomeSummary: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | **String**|  | [optional] [default to '30d']

### Return type

[**AdminDashboardBookingOutcomeSummaryDto**](AdminDashboardBookingOutcomeSummaryDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDashboardControllerGetCategoryHealth**
> AdminCategoryHealthDto adminDashboardControllerGetCategoryHealth()

Get service category health overview

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminDashboardApi();

try {
    final result = api_instance.adminDashboardControllerGetCategoryHealth();
    print(result);
} catch (e) {
    print('Exception when calling AdminDashboardApi->adminDashboardControllerGetCategoryHealth: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AdminCategoryHealthDto**](AdminCategoryHealthDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDashboardControllerGetNotifications**
> List<AdminDashboardNotificationItemDto> adminDashboardControllerGetNotifications(limit)

Get admin dashboard notifications

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminDashboardApi();
final limit = 8.14; // num |

try {
    final result = api_instance.adminDashboardControllerGetNotifications(limit);
    print(result);
} catch (e) {
    print('Exception when calling AdminDashboardApi->adminDashboardControllerGetNotifications: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **num**|  | [optional] [default to 5]

### Return type

[**List<AdminDashboardNotificationItemDto>**](AdminDashboardNotificationItemDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDashboardControllerGetOverview**
> AdminDashboardOverviewDto adminDashboardControllerGetOverview(period)

Get admin dashboard overview metrics

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminDashboardApi();
final period = period_example; // String |

try {
    final result = api_instance.adminDashboardControllerGetOverview(period);
    print(result);
} catch (e) {
    print('Exception when calling AdminDashboardApi->adminDashboardControllerGetOverview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | **String**|  | [optional] [default to '30d']

### Return type

[**AdminDashboardOverviewDto**](AdminDashboardOverviewDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDashboardControllerGetRevenueTrend**
> List<AdminDashboardRevenueTrendPointDto> adminDashboardControllerGetRevenueTrend(period)

Get admin revenue trend data points

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminDashboardApi();
final period = period_example; // String |

try {
    final result = api_instance.adminDashboardControllerGetRevenueTrend(period);
    print(result);
} catch (e) {
    print('Exception when calling AdminDashboardApi->adminDashboardControllerGetRevenueTrend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | **String**|  | [optional] [default to '30d']

### Return type

[**List<AdminDashboardRevenueTrendPointDto>**](AdminDashboardRevenueTrendPointDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDashboardControllerGetTopPartners**
> List<AdminPartnerRankingItemDto> adminDashboardControllerGetTopPartners(period, limit)

Get top performing partners by revenue

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminDashboardApi();
final period = period_example; // String |
final limit = 8.14; // num |

try {
    final result = api_instance.adminDashboardControllerGetTopPartners(period, limit);
    print(result);
} catch (e) {
    print('Exception when calling AdminDashboardApi->adminDashboardControllerGetTopPartners: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | **String**|  | [optional] [default to '30d']
 **limit** | **num**|  | [optional] [default to 5]

### Return type

[**List<AdminPartnerRankingItemDto>**](AdminPartnerRankingItemDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDashboardControllerGetTopServices**
> List<AdminServiceRankingItemDto> adminDashboardControllerGetTopServices(period, limit)

Get top performing services by revenue

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminDashboardApi();
final period = period_example; // String |
final limit = 8.14; // num |

try {
    final result = api_instance.adminDashboardControllerGetTopServices(period, limit);
    print(result);
} catch (e) {
    print('Exception when calling AdminDashboardApi->adminDashboardControllerGetTopServices: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | **String**|  | [optional] [default to '30d']
 **limit** | **num**|  | [optional] [default to 5]

### Return type

[**List<AdminServiceRankingItemDto>**](AdminServiceRankingItemDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminDashboardControllerGetTransactionHealth**
> AdminDashboardTransactionHealthDto adminDashboardControllerGetTransactionHealth(period)

Get transaction health breakdown

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminDashboardApi();
final period = period_example; // String |

try {
    final result = api_instance.adminDashboardControllerGetTransactionHealth(period);
    print(result);
} catch (e) {
    print('Exception when calling AdminDashboardApi->adminDashboardControllerGetTransactionHealth: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | **String**|  | [optional] [default to '30d']

### Return type

[**AdminDashboardTransactionHealthDto**](AdminDashboardTransactionHealthDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

