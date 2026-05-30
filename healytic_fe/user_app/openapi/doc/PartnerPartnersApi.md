# user_openapi.api.PartnerPartnersApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnerSelfControllerGetMyProfile**](PartnerPartnersApi.md#partnerselfcontrollergetmyprofile) | **GET** /partner/partners/me | Get own business profile
[**partnerSelfControllerGetMyProfileCompletion**](PartnerPartnersApi.md#partnerselfcontrollergetmyprofilecompletion) | **GET** /partner/partners/me/completion | Get partner clinic profile completion data
[**partnerSelfControllerGetPublicProfile**](PartnerPartnersApi.md#partnerselfcontrollergetpublicprofile) | **GET** /partner/partners/public-profile | Get partner public profile edit aggregate
[**partnerSelfControllerUpdateMyProfile**](PartnerPartnersApi.md#partnerselfcontrollerupdatemyprofile) | **PUT** /partner/partners/me | Update own business profile
[**partnerSelfControllerUpdateMyProfileCompletion**](PartnerPartnersApi.md#partnerselfcontrollerupdatemyprofilecompletion) | **PUT** /partner/partners/me/completion | Update partner clinic profile completion data
[**partnerSelfControllerUpdatePublicProfile**](PartnerPartnersApi.md#partnerselfcontrollerupdatepublicprofile) | **PUT** /partner/partners/public-profile | Update partner public profile (storefront only)


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

# **partnerSelfControllerGetMyProfileCompletion**
> MyProfileCompletionResponseDto partnerSelfControllerGetMyProfileCompletion()

Get partner clinic profile completion data

Returns verified clinic identity data and editable post-verification profile fields.

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
    final result = api_instance.partnerSelfControllerGetMyProfileCompletion();
    print(result);
} catch (e) {
    print('Exception when calling PartnerPartnersApi->partnerSelfControllerGetMyProfileCompletion: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MyProfileCompletionResponseDto**](MyProfileCompletionResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerSelfControllerGetPublicProfile**
> PartnerPublicProfileResponseDto partnerSelfControllerGetPublicProfile()

Get partner public profile edit aggregate

Returns the full partner profile with read-only business context and editable storefront fields. Only available after profile completion.

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
    final result = api_instance.partnerSelfControllerGetPublicProfile();
    print(result);
} catch (e) {
    print('Exception when calling PartnerPartnersApi->partnerSelfControllerGetPublicProfile: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PartnerPublicProfileResponseDto**](PartnerPublicProfileResponseDto.md)

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

# **partnerSelfControllerUpdateMyProfileCompletion**
> MyProfileCompletionResponseDto partnerSelfControllerUpdateMyProfileCompletion(updatePartnerProfileCompletionDto)

Update partner clinic profile completion data

Immediately publishes post-verification clinic profile fields without entering admin review again.

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
final updatePartnerProfileCompletionDto = UpdatePartnerProfileCompletionDto(); // UpdatePartnerProfileCompletionDto |

try {
    final result = api_instance.partnerSelfControllerUpdateMyProfileCompletion(updatePartnerProfileCompletionDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerPartnersApi->partnerSelfControllerUpdateMyProfileCompletion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updatePartnerProfileCompletionDto** | [**UpdatePartnerProfileCompletionDto**](UpdatePartnerProfileCompletionDto.md)|  |

### Return type

[**MyProfileCompletionResponseDto**](MyProfileCompletionResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerSelfControllerUpdatePublicProfile**
> PartnerPublicProfileResponseDto partnerSelfControllerUpdatePublicProfile(updatePartnerPublicProfileDto)

Update partner public profile (storefront only)

Updates public-facing clinic profile fields (cover image, logo, description, gallery, certifications). Does not affect admin-verified business data.

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
final updatePartnerPublicProfileDto = UpdatePartnerPublicProfileDto(); // UpdatePartnerPublicProfileDto |

try {
    final result = api_instance.partnerSelfControllerUpdatePublicProfile(updatePartnerPublicProfileDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerPartnersApi->partnerSelfControllerUpdatePublicProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updatePartnerPublicProfileDto** | [**UpdatePartnerPublicProfileDto**](UpdatePartnerPublicProfileDto.md)|  |

### Return type

[**PartnerPublicProfileResponseDto**](PartnerPublicProfileResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

