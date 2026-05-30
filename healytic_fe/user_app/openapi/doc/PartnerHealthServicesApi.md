# user_openapi.api.PartnerHealthServicesApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnerHealthServiceControllerCreate**](PartnerHealthServicesApi.md#partnerhealthservicecontrollercreate) | **POST** /partner/health-services | Create a new health service
[**partnerHealthServiceControllerFindAll**](PartnerHealthServicesApi.md#partnerhealthservicecontrollerfindall) | **GET** /partner/health-services | Get all health services
[**partnerHealthServiceControllerFindBySlug**](PartnerHealthServicesApi.md#partnerhealthservicecontrollerfindbyslug) | **GET** /partner/health-services/slug/{slug} | Get a health service by slug
[**partnerHealthServiceControllerGetDetailAnalytics**](PartnerHealthServicesApi.md#partnerhealthservicecontrollergetdetailanalytics) | **GET** /partner/health-services/analytics/{productId} | Get per-service detail analytics
[**partnerHealthServiceControllerGetDetails**](PartnerHealthServicesApi.md#partnerhealthservicecontrollergetdetails) | **GET** /partner/health-services/slug/{slug}/details | Get full health service details by slug
[**partnerHealthServiceControllerGetOverviewAnalytics**](PartnerHealthServicesApi.md#partnerhealthservicecontrollergetoverviewanalytics) | **GET** /partner/health-services/analytics/overview | Get health service overview analytics
[**partnerHealthServiceControllerRemove**](PartnerHealthServicesApi.md#partnerhealthservicecontrollerremove) | **DELETE** /partner/health-services/{id} | Delete a health service
[**partnerHealthServiceControllerUpdate**](PartnerHealthServicesApi.md#partnerhealthservicecontrollerupdate) | **PATCH** /partner/health-services/{id} | Update a health service


# **partnerHealthServiceControllerCreate**
> PartnerHealthServiceResponseDto partnerHealthServiceControllerCreate(createPartnerHealthServiceDto)

Create a new health service

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerHealthServicesApi();
final createPartnerHealthServiceDto = CreatePartnerHealthServiceDto(); // CreatePartnerHealthServiceDto |

try {
    final result = api_instance.partnerHealthServiceControllerCreate(createPartnerHealthServiceDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerHealthServicesApi->partnerHealthServiceControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createPartnerHealthServiceDto** | [**CreatePartnerHealthServiceDto**](CreatePartnerHealthServiceDto.md)|  |

### Return type

[**PartnerHealthServiceResponseDto**](PartnerHealthServiceResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerHealthServiceControllerFindAll**
> List<PartnerHealthServiceResponseDto> partnerHealthServiceControllerFindAll()

Get all health services

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerHealthServicesApi();

try {
    final result = api_instance.partnerHealthServiceControllerFindAll();
    print(result);
} catch (e) {
    print('Exception when calling PartnerHealthServicesApi->partnerHealthServiceControllerFindAll: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<PartnerHealthServiceResponseDto>**](PartnerHealthServiceResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerHealthServiceControllerFindBySlug**
> PartnerHealthServiceResponseDto partnerHealthServiceControllerFindBySlug(slug)

Get a health service by slug

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerHealthServicesApi();
final slug = slug_example; // String |

try {
    final result = api_instance.partnerHealthServiceControllerFindBySlug(slug);
    print(result);
} catch (e) {
    print('Exception when calling PartnerHealthServicesApi->partnerHealthServiceControllerFindBySlug: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **slug** | **String**|  |

### Return type

[**PartnerHealthServiceResponseDto**](PartnerHealthServiceResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerHealthServiceControllerGetDetailAnalytics**
> HealthServiceDetailAnalyticsResponseDto partnerHealthServiceControllerGetDetailAnalytics(productId, period)

Get per-service detail analytics

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerHealthServicesApi();
final productId = productId_example; // String |
final period = period_example; // String | Time period for analytics aggregation

try {
    final result = api_instance.partnerHealthServiceControllerGetDetailAnalytics(productId, period);
    print(result);
} catch (e) {
    print('Exception when calling PartnerHealthServicesApi->partnerHealthServiceControllerGetDetailAnalytics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **productId** | **String**|  |
 **period** | **String**| Time period for analytics aggregation | [optional] [default to 'this_month']

### Return type

[**HealthServiceDetailAnalyticsResponseDto**](HealthServiceDetailAnalyticsResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerHealthServiceControllerGetDetails**
> PartnerHealthServiceDetailResponseDto partnerHealthServiceControllerGetDetails(slug)

Get full health service details by slug

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerHealthServicesApi();
final slug = slug_example; // String |

try {
    final result = api_instance.partnerHealthServiceControllerGetDetails(slug);
    print(result);
} catch (e) {
    print('Exception when calling PartnerHealthServicesApi->partnerHealthServiceControllerGetDetails: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **slug** | **String**|  |

### Return type

[**PartnerHealthServiceDetailResponseDto**](PartnerHealthServiceDetailResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerHealthServiceControllerGetOverviewAnalytics**
> HealthServiceOverviewAnalyticsResponseDto partnerHealthServiceControllerGetOverviewAnalytics(period)

Get health service overview analytics

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerHealthServicesApi();
final period = period_example; // String | Time period for analytics aggregation

try {
    final result = api_instance.partnerHealthServiceControllerGetOverviewAnalytics(period);
    print(result);
} catch (e) {
    print('Exception when calling PartnerHealthServicesApi->partnerHealthServiceControllerGetOverviewAnalytics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | **String**| Time period for analytics aggregation | [optional] [default to 'this_month']

### Return type

[**HealthServiceOverviewAnalyticsResponseDto**](HealthServiceOverviewAnalyticsResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerHealthServiceControllerRemove**
> partnerHealthServiceControllerRemove(id)

Delete a health service

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerHealthServicesApi();
final id = id_example; // String |

try {
    api_instance.partnerHealthServiceControllerRemove(id);
} catch (e) {
    print('Exception when calling PartnerHealthServicesApi->partnerHealthServiceControllerRemove: $e\n');
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

# **partnerHealthServiceControllerUpdate**
> PartnerHealthServiceResponseDto partnerHealthServiceControllerUpdate(id, updatePartnerHealthServiceDto)

Update a health service

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerHealthServicesApi();
final id = id_example; // String |
final updatePartnerHealthServiceDto = UpdatePartnerHealthServiceDto(); // UpdatePartnerHealthServiceDto |

try {
    final result = api_instance.partnerHealthServiceControllerUpdate(id, updatePartnerHealthServiceDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerHealthServicesApi->partnerHealthServiceControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **updatePartnerHealthServiceDto** | [**UpdatePartnerHealthServiceDto**](UpdatePartnerHealthServiceDto.md)|  |

### Return type

[**PartnerHealthServiceResponseDto**](PartnerHealthServiceResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

