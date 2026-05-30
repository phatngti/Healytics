# admin_openapi.api.UserSlotsApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**slotsControllerCheckDuplicateSlot**](UserSlotsApi.md#slotscontrollercheckduplicateslot) | **POST** /user/slots/check-duplicate | Check if the user already has a booking at the same datetime
[**slotsControllerMicroLock**](UserSlotsApi.md#slotscontrollermicrolock) | **POST** /user/slots/micro-lock | Acquire a micro-lock on a time slot (120s TTL)


# **slotsControllerCheckDuplicateSlot**
> CheckDuplicateSlotResponseDto slotsControllerCheckDuplicateSlot(checkDuplicateSlotDto)

Check if the user already has a booking at the same datetime

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserSlotsApi();
final checkDuplicateSlotDto = CheckDuplicateSlotDto(); // CheckDuplicateSlotDto |

try {
    final result = api_instance.slotsControllerCheckDuplicateSlot(checkDuplicateSlotDto);
    print(result);
} catch (e) {
    print('Exception when calling UserSlotsApi->slotsControllerCheckDuplicateSlot: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **checkDuplicateSlotDto** | [**CheckDuplicateSlotDto**](CheckDuplicateSlotDto.md)|  |

### Return type

[**CheckDuplicateSlotResponseDto**](CheckDuplicateSlotResponseDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **slotsControllerMicroLock**
> MicroLockResponseDto slotsControllerMicroLock(microLockDto)

Acquire a micro-lock on a time slot (120s TTL)

### Example
```dart
import 'package:admin_openapi/api.dart';
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

