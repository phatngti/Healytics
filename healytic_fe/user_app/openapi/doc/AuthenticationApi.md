# user_openapi.api.AuthenticationApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authControllerLoginAdmin**](AuthenticationApi.md#authcontrollerloginadmin) | **POST** /auth/admin/login | 
[**authControllerLoginPartner**](AuthenticationApi.md#authcontrollerloginpartner) | **POST** /auth/partner/login | 
[**authControllerLoginUser**](AuthenticationApi.md#authcontrollerloginuser) | **POST** /auth/user/login | 
[**authControllerLogout**](AuthenticationApi.md#authcontrollerlogout) | **POST** /auth/logout | 
[**authControllerRefresh**](AuthenticationApi.md#authcontrollerrefresh) | **POST** /auth/refresh | 
[**authControllerRegisterPartner**](AuthenticationApi.md#authcontrollerregisterpartner) | **POST** /auth/partner/register | Register a new business partner
[**authControllerRegisterUser**](AuthenticationApi.md#authcontrollerregisteruser) | **POST** /auth/user/register | 


# **authControllerLoginAdmin**
> AuthTokensDto authControllerLoginAdmin(adminLoginDto)



### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = AuthenticationApi();
final adminLoginDto = AdminLoginDto(); // AdminLoginDto | 

try {
    final result = api_instance.authControllerLoginAdmin(adminLoginDto);
    print(result);
} catch (e) {
    print('Exception when calling AuthenticationApi->authControllerLoginAdmin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminLoginDto** | [**AdminLoginDto**](AdminLoginDto.md)|  | 

### Return type

[**AuthTokensDto**](AuthTokensDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerLoginPartner**
> AuthTokensDto authControllerLoginPartner(partnerLoginDto)



### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = AuthenticationApi();
final partnerLoginDto = PartnerLoginDto(); // PartnerLoginDto | 

try {
    final result = api_instance.authControllerLoginPartner(partnerLoginDto);
    print(result);
} catch (e) {
    print('Exception when calling AuthenticationApi->authControllerLoginPartner: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **partnerLoginDto** | [**PartnerLoginDto**](PartnerLoginDto.md)|  | 

### Return type

[**AuthTokensDto**](AuthTokensDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerLoginUser**
> AuthTokensDto authControllerLoginUser(loginDto)



### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = AuthenticationApi();
final loginDto = LoginDto(); // LoginDto | 

try {
    final result = api_instance.authControllerLoginUser(loginDto);
    print(result);
} catch (e) {
    print('Exception when calling AuthenticationApi->authControllerLoginUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginDto** | [**LoginDto**](LoginDto.md)|  | 

### Return type

[**AuthTokensDto**](AuthTokensDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerLogout**
> LogoutResponseDto authControllerLogout()



### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = AuthenticationApi();

try {
    final result = api_instance.authControllerLogout();
    print(result);
} catch (e) {
    print('Exception when calling AuthenticationApi->authControllerLogout: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**LogoutResponseDto**](LogoutResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRefresh**
> AuthTokensDto authControllerRefresh(refreshTokenRequestDto)



### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = AuthenticationApi();
final refreshTokenRequestDto = RefreshTokenRequestDto(); // RefreshTokenRequestDto | 

try {
    final result = api_instance.authControllerRefresh(refreshTokenRequestDto);
    print(result);
} catch (e) {
    print('Exception when calling AuthenticationApi->authControllerRefresh: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshTokenRequestDto** | [**RefreshTokenRequestDto**](RefreshTokenRequestDto.md)|  | 

### Return type

[**AuthTokensDto**](AuthTokensDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRegisterPartner**
> RegisterPartnerResponseDto authControllerRegisterPartner(registerPartnerDto)

Register a new business partner

Creates business entity, legal representative, and returns auth tokens immediately

### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = AuthenticationApi();
final registerPartnerDto = RegisterPartnerDto(); // RegisterPartnerDto | 

try {
    final result = api_instance.authControllerRegisterPartner(registerPartnerDto);
    print(result);
} catch (e) {
    print('Exception when calling AuthenticationApi->authControllerRegisterPartner: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerPartnerDto** | [**RegisterPartnerDto**](RegisterPartnerDto.md)|  | 

### Return type

[**RegisterPartnerResponseDto**](RegisterPartnerResponseDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRegisterUser**
> AuthTokensDto authControllerRegisterUser(registerDto)



### Example
```dart
import 'package:user_openapi/api.dart';

final api_instance = AuthenticationApi();
final registerDto = RegisterDto(); // RegisterDto | 

try {
    final result = api_instance.authControllerRegisterUser(registerDto);
    print(result);
} catch (e) {
    print('Exception when calling AuthenticationApi->authControllerRegisterUser: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerDto** | [**RegisterDto**](RegisterDto.md)|  | 

### Return type

[**AuthTokensDto**](AuthTokensDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

