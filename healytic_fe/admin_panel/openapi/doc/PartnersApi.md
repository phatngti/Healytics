# admin_openapi.api.PartnersApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnersControllerGetBusinessTypes**](PartnersApi.md#partnerscontrollergetbusinesstypes) | **GET** /partners/business-types | Get all business types
[**partnersControllerGetMyProfile**](PartnersApi.md#partnerscontrollergetmyprofile) | **GET** /partners/me | Get own business profile
[**partnersControllerUpdateMyProfile**](PartnersApi.md#partnerscontrollerupdatemyprofile) | **PUT** /partners/me | Update own business profile


# **partnersControllerGetBusinessTypes**
> BusinessTypesResponseDto partnersControllerGetBusinessTypes()

Get all business types

Returns list of all business types with Vietnamese labels for dropdown selection

### Example
```dart
import 'package:admin_openapi/api.dart';

final api_instance = PartnersApi();

try {
    final result = api_instance.partnersControllerGetBusinessTypes();
    print(result);
} catch (e) {
    print('Exception when calling PartnersApi->partnersControllerGetBusinessTypes: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BusinessTypesResponseDto**](BusinessTypesResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnersControllerGetMyProfile**
> MyProfileResponseDto partnersControllerGetMyProfile()

Get own business profile

Partner gets their own business entity information

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnersApi();

try {
    final result = api_instance.partnersControllerGetMyProfile();
    print(result);
} catch (e) {
    print('Exception when calling PartnersApi->partnersControllerGetMyProfile: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MyProfileResponseDto**](MyProfileResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnersControllerUpdateMyProfile**
> MyProfileResponseDto partnersControllerUpdateMyProfile(updatePartnerDto)

Update own business profile

Partner updates their business information (limited fields)

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnersApi();
final updatePartnerDto = UpdatePartnerDto(); // UpdatePartnerDto | 

try {
    final result = api_instance.partnersControllerUpdateMyProfile(updatePartnerDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnersApi->partnersControllerUpdateMyProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updatePartnerDto** | [**UpdatePartnerDto**](UpdatePartnerDto.md)|  | 

### Return type

[**MyProfileResponseDto**](MyProfileResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

