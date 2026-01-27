# user_openapi.api.AdminPartnersApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminPartnersControllerGetPartnerDetail**](AdminPartnersApi.md#adminpartnerscontrollergetpartnerdetail) | **GET** /admin/partners/{id} | Get partner details including documents
[**adminPartnersControllerGetPartners**](AdminPartnersApi.md#adminpartnerscontrollergetpartners) | **GET** /admin/partners | List all partners
[**adminPartnersControllerReviewPartner**](AdminPartnersApi.md#adminpartnerscontrollerreviewpartner) | **PUT** /admin/partners/{id}/review | Review partner profile


# **adminPartnersControllerGetPartnerDetail**
> AdminPartnerDetailResponseDto adminPartnersControllerGetPartnerDetail(id)

Get partner details including documents

### Example
```dart
import 'package:user_openapi/api.dart';
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
> adminPartnersControllerGetPartners(page, limit, verificationStatus, search)

List all partners

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminPartnersApi();
final page = 1; // num | Page number
final limit = 10; // num | Items per page
final verificationStatus = PENDING; // String | Filter by verification status (PENDING, APPROVED, REJECTED)
final search = spa; // String | Search by tax code, brand name, legal name, or email

try {
    api_instance.adminPartnersControllerGetPartners(page, limit, verificationStatus, search);
} catch (e) {
    print('Exception when calling AdminPartnersApi->adminPartnersControllerGetPartners: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **num**| Page number | [optional] [default to 1]
 **limit** | **num**| Items per page | [optional] [default to 10]
 **verificationStatus** | **String**| Filter by verification status (PENDING, APPROVED, REJECTED) | [optional] 
 **search** | **String**| Search by tax code, brand name, legal name, or email | [optional] 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminPartnersControllerReviewPartner**
> ReviewPartnerResponseDto adminPartnersControllerReviewPartner(id, reviewPartnerProfileDto)

Review partner profile

### Example
```dart
import 'package:user_openapi/api.dart';
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

