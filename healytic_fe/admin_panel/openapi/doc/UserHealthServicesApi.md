# admin_openapi.api.UserHealthServicesApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userHealthServiceControllerFindOne**](UserHealthServicesApi.md#userhealthservicecontrollerfindone) | **GET** /user/health-services/{id} | Get a service by ID
[**userHealthServiceControllerGetClinicInfo**](UserHealthServicesApi.md#userhealthservicecontrollergetclinicinfo) | **GET** /user/health-services/clinics/{id}/info | Get public clinic info by ID
[**userHealthServiceControllerGetEligibilityDetail**](UserHealthServicesApi.md#userhealthservicecontrollergeteligibilitydetail) | **GET** /user/health-services/eligibilities/{id} | Get eligibility detail by ID
[**userHealthServiceControllerGetHomeRecommend**](UserHealthServicesApi.md#userhealthservicecontrollergethomerecommend) | **GET** /user/health-services/home-recommend | Get home recommendations
[**userHealthServiceControllerGetPremiumTreatments**](UserHealthServicesApi.md#userhealthservicecontrollergetpremiumtreatments) | **GET** /user/health-services/premium-treatments | Get premium treatments
[**userHealthServiceControllerGetProductEmployees**](UserHealthServicesApi.md#userhealthservicecontrollergetproductemployees) | **GET** /user/health-services/{id}/employees | Get employees for a service
[**userHealthServiceControllerGetProductInfo**](UserHealthServicesApi.md#userhealthservicecontrollergetproductinfo) | **GET** /user/health-services/{id}/info | Get service info by ID
[**userHealthServiceControllerGetProductReviews**](UserHealthServicesApi.md#userhealthservicecontrollergetproductreviews) | **GET** /user/health-services/{id}/reviews | Get reviews for a service
[**userHealthServiceControllerGetRecommendedProducts**](UserHealthServicesApi.md#userhealthservicecontrollergetrecommendedproducts) | **GET** /user/health-services/{id}/recommended | Get recommended services


# **userHealthServiceControllerFindOne**
> PublicHealthServiceResponseDto userHealthServiceControllerFindOne(id)

Get a service by ID

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserHealthServicesApi();
final id = id_example; // String |

try {
    final result = api_instance.userHealthServiceControllerFindOne(id);
    print(result);
} catch (e) {
    print('Exception when calling UserHealthServicesApi->userHealthServiceControllerFindOne: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**PublicHealthServiceResponseDto**](PublicHealthServiceResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userHealthServiceControllerGetClinicInfo**
> PublicClinicInfoResponseDto userHealthServiceControllerGetClinicInfo(id)

Get public clinic info by ID

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserHealthServicesApi();
final id = id_example; // String |

try {
    final result = api_instance.userHealthServiceControllerGetClinicInfo(id);
    print(result);
} catch (e) {
    print('Exception when calling UserHealthServicesApi->userHealthServiceControllerGetClinicInfo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**PublicClinicInfoResponseDto**](PublicClinicInfoResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userHealthServiceControllerGetEligibilityDetail**
> UserEligibilityDetailResponseDto userHealthServiceControllerGetEligibilityDetail(id)

Get eligibility detail by ID

Returns the full eligibility record enriched with category, service, and employee information, looked up by the surrogate primary key on the product_employee_eligibility table.

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserHealthServicesApi();
final id = id_example; // String |

try {
    final result = api_instance.userHealthServiceControllerGetEligibilityDetail(id);
    print(result);
} catch (e) {
    print('Exception when calling UserHealthServicesApi->userHealthServiceControllerGetEligibilityDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**UserEligibilityDetailResponseDto**](UserEligibilityDetailResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userHealthServiceControllerGetHomeRecommend**
> List<PublicHealthServiceCardResponseDto> userHealthServiceControllerGetHomeRecommend()

Get home recommendations

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserHealthServicesApi();

try {
    final result = api_instance.userHealthServiceControllerGetHomeRecommend();
    print(result);
} catch (e) {
    print('Exception when calling UserHealthServicesApi->userHealthServiceControllerGetHomeRecommend: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<PublicHealthServiceCardResponseDto>**](PublicHealthServiceCardResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userHealthServiceControllerGetPremiumTreatments**
> List<PublicHealthServiceCardResponseDto> userHealthServiceControllerGetPremiumTreatments(sort, minPrice, maxPrice, categoryId, clinicId, provinceId, districtId, wardId, lat, lng)

Get premium treatments

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserHealthServicesApi();
final sort = sort_example; // String |
final minPrice = 8.14; // num |
final maxPrice = 8.14; // num |
final categoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final clinicId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final provinceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final districtId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final wardId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final lat = 8.14; // num | User latitude
final lng = 8.14; // num | User longitude

try {
    final result = api_instance.userHealthServiceControllerGetPremiumTreatments(sort, minPrice, maxPrice, categoryId, clinicId, provinceId, districtId, wardId, lat, lng);
    print(result);
} catch (e) {
    print('Exception when calling UserHealthServicesApi->userHealthServiceControllerGetPremiumTreatments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sort** | **String**|  | [optional] [default to 'default']
 **minPrice** | **num**|  | [optional]
 **maxPrice** | **num**|  | [optional]
 **categoryId** | **String**|  | [optional]
 **clinicId** | **String**|  | [optional]
 **provinceId** | **String**|  | [optional]
 **districtId** | **String**|  | [optional]
 **wardId** | **String**|  | [optional]
 **lat** | **num**| User latitude | [optional]
 **lng** | **num**| User longitude | [optional]

### Return type

[**List<PublicHealthServiceCardResponseDto>**](PublicHealthServiceCardResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userHealthServiceControllerGetProductEmployees**
> List<PublicHealthServiceEmployeeResponseDto> userHealthServiceControllerGetProductEmployees(id)

Get employees for a service

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserHealthServicesApi();
final id = id_example; // String |

try {
    final result = api_instance.userHealthServiceControllerGetProductEmployees(id);
    print(result);
} catch (e) {
    print('Exception when calling UserHealthServicesApi->userHealthServiceControllerGetProductEmployees: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**List<PublicHealthServiceEmployeeResponseDto>**](PublicHealthServiceEmployeeResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userHealthServiceControllerGetProductInfo**
> PublicHealthServiceInfoResponseDto userHealthServiceControllerGetProductInfo(id)

Get service info by ID

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserHealthServicesApi();
final id = id_example; // String |

try {
    final result = api_instance.userHealthServiceControllerGetProductInfo(id);
    print(result);
} catch (e) {
    print('Exception when calling UserHealthServicesApi->userHealthServiceControllerGetProductInfo: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**PublicHealthServiceInfoResponseDto**](PublicHealthServiceInfoResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userHealthServiceControllerGetProductReviews**
> List<PublicHealthServiceReviewResponseDto> userHealthServiceControllerGetProductReviews(id)

Get reviews for a service

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserHealthServicesApi();
final id = id_example; // String |

try {
    final result = api_instance.userHealthServiceControllerGetProductReviews(id);
    print(result);
} catch (e) {
    print('Exception when calling UserHealthServicesApi->userHealthServiceControllerGetProductReviews: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**List<PublicHealthServiceReviewResponseDto>**](PublicHealthServiceReviewResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userHealthServiceControllerGetRecommendedProducts**
> List<PublicHealthServiceRecommendedResponseDto> userHealthServiceControllerGetRecommendedProducts(id)

Get recommended services

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserHealthServicesApi();
final id = id_example; // String |

try {
    final result = api_instance.userHealthServiceControllerGetRecommendedProducts(id);
    print(result);
} catch (e) {
    print('Exception when calling UserHealthServicesApi->userHealthServiceControllerGetRecommendedProducts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**List<PublicHealthServiceRecommendedResponseDto>**](PublicHealthServiceRecommendedResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

