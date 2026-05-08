# employee_openapi.api.AdminPartnersApi

## Load the API package
```dart
import 'package:employee_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminPartnersControllerGetPartnerDetail**](AdminPartnersApi.md#adminpartnerscontrollergetpartnerdetail) | **GET** /admin/partners/{id} | Get partner details including documents
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

# **adminPartnersControllerGetPartners**
> PartnersResponseDto adminPartnersControllerGetPartners(page, limit, verificationStatus, search)

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
final page = 1; // num | Page number
final limit = 10; // num | Items per page
final verificationStatus = PENDING; // String | Filter by verification status (PENDING, REQUIRED_RESUBMIT, APPROVED, REJECTED)
final search = spa; // String | Search by tax code, brand name, legal name, or email

try {
    final result = api_instance.adminPartnersControllerGetPartners(page, limit, verificationStatus, search);
    print(result);
} catch (e) {
    print('Exception when calling AdminPartnersApi->adminPartnersControllerGetPartners: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **num**| Page number | [optional] [default to 1]
 **limit** | **num**| Items per page | [optional] [default to 10]
 **verificationStatus** | **String**| Filter by verification status (PENDING, REQUIRED_RESUBMIT, APPROVED, REJECTED) | [optional] 
 **search** | **String**| Search by tax code, brand name, legal name, or email | [optional] 

### Return type

[**PartnersResponseDto**](PartnersResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnersControllerGetTotalPartners**
> TotalPartnersResponseDto adminPartnersControllerGetTotalPartners()

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

try {
    final result = api_instance.adminPartnersControllerGetTotalPartners();
    print(result);
} catch (e) {
    print('Exception when calling AdminPartnersApi->adminPartnersControllerGetTotalPartners: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

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

