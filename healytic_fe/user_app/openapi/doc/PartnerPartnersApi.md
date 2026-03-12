# user_openapi.api.PartnerPartnersApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnerSelfControllerGetMyProfile**](PartnerPartnersApi.md#partnerselfcontrollergetmyprofile) | **GET** /partner/partners/me | Get own business profile
[**partnerSelfControllerUpdateMyProfile**](PartnerPartnersApi.md#partnerselfcontrollerupdatemyprofile) | **PUT** /partner/partners/me | Update own business profile


# **partnerSelfControllerGetMyProfile**
> MyProfileResponseDto partnerSelfControllerGetMyProfile()

Get own business profile

Partner gets their own business entity information

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerPartnersApi();

try {
    final result = api_instance.partnerSelfControllerGetMyProfile();
    print(result);
} catch (e) {
    print('Exception when calling PartnerPartnersApi->partnerSelfControllerGetMyProfile: $e\n');
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

# **partnerSelfControllerUpdateMyProfile**
> MyProfileResponseDto partnerSelfControllerUpdateMyProfile(updatePartnerDto)

Update own business profile

Partner updates their business information (limited fields)

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerPartnersApi();
final updatePartnerDto = UpdatePartnerDto(); // UpdatePartnerDto | 

try {
    final result = api_instance.partnerSelfControllerUpdateMyProfile(updatePartnerDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerPartnersApi->partnerSelfControllerUpdateMyProfile: $e\n');
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

