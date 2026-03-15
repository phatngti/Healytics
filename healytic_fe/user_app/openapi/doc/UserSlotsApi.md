# user_openapi.api.UserSlotsApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**slotsControllerMicroLock**](UserSlotsApi.md#slotscontrollermicrolock) | **POST** /user/slots/micro-lock | Acquire a micro-lock on a time slot (120s TTL)


# **slotsControllerMicroLock**
> MicroLockResponseDto slotsControllerMicroLock(microLockDto)

Acquire a micro-lock on a time slot (120s TTL)

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserSlotsApi();
final microLockDto = MicroLockDto(); // MicroLockDto | 

try {
    final result = api_instance.slotsControllerMicroLock(microLockDto);
    print(result);
} catch (e) {
    print('Exception when calling UserSlotsApi->slotsControllerMicroLock: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **microLockDto** | [**MicroLockDto**](MicroLockDto.md)|  | 

### Return type

[**MicroLockResponseDto**](MicroLockResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

