# employee_openapi.api.AdminPartnersApi

## Load the API package
```dart
import 'package:employee_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminPartnersControllerGetPartnerDetail**](AdminPartnersApi.md#adminpartnerscontrollergetpartnerdetail) | **GET** /admin/partners/{id} | Get partner details including documents
[**adminPartnersControllerGetPartnerStats**](AdminPartnersApi.md#adminpartnerscontrollergetpartnerstats) | **GET** /admin/partners/stats | Get partner dashboard statistics
[**adminPartnersControllerGetPartners**](AdminPartnersApi.md#adminpartnerscontrollergetpartners) | **GET** /admin/partners | List all partners
[**adminPartnersControllerGetTotalPartners**](AdminPartnersApi.md#adminpartnerscontrollergettotalpartners) | **GET** /admin/partners/total | Get total number of partners
[**adminPartnersControllerReviewPartner**](AdminPartnersApi.md#adminpartnerscontrollerreviewpartner) | **PUT** /admin/partners/{id}/review | Review partner profile


# **adminPartnersControllerGetPartnerDetail**
> AdminPartnerDetailResponseDto adminPartnersControllerGetPartnerDetail(id)

Get partner details including documents

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminPartnersApi();
final id = id_example; // String | Partner ID

try {
    final result = api_instance.adminPartnersControllerGetPartnerDetail(id);
    print(result);
} catch (e) {
    print('Exception when calling AdminPartnersApi->adminPartnersControllerGetPartnerDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Partner ID | 

### Return type

[**AdminPartnerDetailResponseDto**](AdminPartnerDetailResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnersControllerGetPartnerStats**
> AdminPartnerStatsResponseDto adminPartnersControllerGetPartnerStats(page, limit, scope, verificationStatus, search, sortBy, sortDirection)

Get partner dashboard statistics

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminPartnersApi();
final page = 1; // num | Page number (1-indexed)
final limit = 10; // num | Items per page
final scope = ; // AdminPartnerScope | Tab scope: VERIFICATION_QUEUE or ALL_PROVIDERS
final verificationStatus = ; // PartnerVerificationStatus | Explicit status filter
final search = spa; // String | Search by tax code, brand name, legal name, or email
final sortBy = ; // AdminPartnerSortBy | Column to sort by
final sortDirection = ; // AdminPartnerSortDirection | Sort direction

try {
    final result = api_instance.adminPartnersControllerGetPartnerStats(page, limit, scope, verificationStatus, search, sortBy, sortDirection);
    print(result);
} catch (e) {
    print('Exception when calling AdminPartnersApi->adminPartnersControllerGetPartnerStats: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **num**| Page number (1-indexed) | [optional] [default to 1]
 **limit** | **num**| Items per page | [optional] [default to 10]
 **scope** | [**AdminPartnerScope**](.md)| Tab scope: VERIFICATION_QUEUE or ALL_PROVIDERS | [optional] 
 **verificationStatus** | [**PartnerVerificationStatus**](.md)| Explicit status filter | [optional] 
 **search** | **String**| Search by tax code, brand name, legal name, or email | [optional] 
 **sortBy** | [**AdminPartnerSortBy**](.md)| Column to sort by | [optional] 
 **sortDirection** | [**AdminPartnerSortDirection**](.md)| Sort direction | [optional] 

### Return type

[**AdminPartnerStatsResponseDto**](AdminPartnerStatsResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnersControllerGetPartners**
> AdminPartnersResponseDto adminPartnersControllerGetPartners(page, limit, scope, verificationStatus, search, sortBy, sortDirection)

List all partners

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminPartnersApi();
final page = 1; // num | Page number (1-indexed)
final limit = 10; // num | Items per page
final scope = ; // AdminPartnerScope | Tab scope: VERIFICATION_QUEUE or ALL_PROVIDERS
final verificationStatus = ; // PartnerVerificationStatus | Explicit status filter
final search = spa; // String | Search by tax code, brand name, legal name, or email
final sortBy = ; // AdminPartnerSortBy | Column to sort by
final sortDirection = ; // AdminPartnerSortDirection | Sort direction

try {
    final result = api_instance.adminPartnersControllerGetPartners(page, limit, scope, verificationStatus, search, sortBy, sortDirection);
    print(result);
} catch (e) {
    print('Exception when calling AdminPartnersApi->adminPartnersControllerGetPartners: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **num**| Page number (1-indexed) | [optional] [default to 1]
 **limit** | **num**| Items per page | [optional] [default to 10]
 **scope** | [**AdminPartnerScope**](.md)| Tab scope: VERIFICATION_QUEUE or ALL_PROVIDERS | [optional] 
 **verificationStatus** | [**PartnerVerificationStatus**](.md)| Explicit status filter | [optional] 
 **search** | **String**| Search by tax code, brand name, legal name, or email | [optional] 
 **sortBy** | [**AdminPartnerSortBy**](.md)| Column to sort by | [optional] 
 **sortDirection** | [**AdminPartnerSortDirection**](.md)| Sort direction | [optional] 

### Return type

[**AdminPartnersResponseDto**](AdminPartnersResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnersControllerGetTotalPartners**
> TotalPartnersResponseDto adminPartnersControllerGetTotalPartners(page, limit, scope, verificationStatus, search, sortBy, sortDirection)

Get total number of partners

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminPartnersApi();
final page = 1; // num | Page number (1-indexed)
final limit = 10; // num | Items per page
final scope = ; // AdminPartnerScope | Tab scope: VERIFICATION_QUEUE or ALL_PROVIDERS
final verificationStatus = ; // PartnerVerificationStatus | Explicit status filter
final search = spa; // String | Search by tax code, brand name, legal name, or email
final sortBy = ; // AdminPartnerSortBy | Column to sort by
final sortDirection = ; // AdminPartnerSortDirection | Sort direction

try {
    final result = api_instance.adminPartnersControllerGetTotalPartners(page, limit, scope, verificationStatus, search, sortBy, sortDirection);
    print(result);
} catch (e) {
    print('Exception when calling AdminPartnersApi->adminPartnersControllerGetTotalPartners: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **num**| Page number (1-indexed) | [optional] [default to 1]
 **limit** | **num**| Items per page | [optional] [default to 10]
 **scope** | [**AdminPartnerScope**](.md)| Tab scope: VERIFICATION_QUEUE or ALL_PROVIDERS | [optional] 
 **verificationStatus** | [**PartnerVerificationStatus**](.md)| Explicit status filter | [optional] 
 **search** | **String**| Search by tax code, brand name, legal name, or email | [optional] 
 **sortBy** | [**AdminPartnerSortBy**](.md)| Column to sort by | [optional] 
 **sortDirection** | [**AdminPartnerSortDirection**](.md)| Sort direction | [optional] 

### Return type

[**TotalPartnersResponseDto**](TotalPartnersResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnersControllerReviewPartner**
> ReviewPartnerResponseDto adminPartnersControllerReviewPartner(id, reviewPartnerProfileDto)

Review partner profile

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminPartnersApi();
final id = id_example; // String | Partner ID
final reviewPartnerProfileDto = ReviewPartnerProfileDto(); // ReviewPartnerProfileDto | 

try {
    final result = api_instance.adminPartnersControllerReviewPartner(id, reviewPartnerProfileDto);
    print(result);
} catch (e) {
    print('Exception when calling AdminPartnersApi->adminPartnersControllerReviewPartner: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Partner ID | 
 **reviewPartnerProfileDto** | [**ReviewPartnerProfileDto**](ReviewPartnerProfileDto.md)|  | 

### Return type

[**ReviewPartnerResponseDto**](ReviewPartnerResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

